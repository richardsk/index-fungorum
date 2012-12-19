using System;
using System.Data;
using System.Data.OleDb;
using System.IO;

namespace TapirDotNET 
{

	public class TpXmlGenerator:TpSchemaVisitor
	{
		public TpOutputModel mOutputModel;
		public TpResponseStructure mResponseStructure;
		public string mIndexingElement;
		public TpSqlBuilder mSqlBuilder;
		public string mDbEncoding;
		public int mMaxRepetitions = -1;
		public int mLimit = -1;
		public DataSet mrResultSet;
		public TpResource mrResource;
		public int mRecordIndex = 0;
		public int mTotalReturned = 0;
		public bool mAbort;
		public Utility.OrderedMap mIgnorePaths;
		public Utility.OrderedMap mNoContentSummary = new Utility.OrderedMap();
		public Utility.OrderedMap mNamespaceStack = new Utility.OrderedMap();
		public bool mOmitNamespaces;
		
		public TpXmlGenerator(TpOutputModel outputModel, Utility.OrderedMap ignorePaths, TpSqlBuilder sqlBuilder, string dbEncoding, int maxRepetitions, int limit, bool omitNamespaces)
		{
			this.mOutputModel = outputModel;
			this.mResponseStructure = outputModel.GetResponseStructure();
			this.mIndexingElement = Utility.TypeSupport.ToString(outputModel.GetIndexingElement());
			this.mIgnorePaths = ignorePaths;
			this.mSqlBuilder = sqlBuilder;
			this.mDbEncoding = dbEncoding;
			this.mMaxRepetitions = maxRepetitions;
			this.mLimit = limit;
			this.mOmitNamespaces = omitNamespaces;
		}
		
		
		public virtual string Render(DataSet rResultSet, TpResource rResource)
		{
			//global $g_dlog
			string content;
			string msg;
			
			TpLog.debug("[Generating XML]");
			
			// Make sure you call $output_model->IsValid() before calling this method!
			
			this.mrResultSet = rResultSet;
			this.mRecordIndex = 0;
			
			this.mrResource = rResource;
			
			Utility.OrderedMap global_elements = this.mResponseStructure.GetElementDecls(null);
			
			string path = "";
			
			// Get the first non abstract global element declaration and render it
			foreach ( string el_name in global_elements.Keys ) 
			{
				XsElementDecl xs_element_decl = (XsElementDecl)global_elements[el_name];
				if (!xs_element_decl.IsAbstract())
				{
					content = xs_element_decl.Accept(this, path).ToString();
					
					if (Utility.OrderedMap.CountElements(this.mNoContentSummary) > 0)
					{
						foreach ( string t_path in this.mNoContentSummary.Keys ) 
						{
							object times = this.mNoContentSummary[t_path];
							msg = "Node \"" + t_path + "\" was dropped " + Utility.TypeSupport.ToString(times) + " times for having incomplete or no content";
							new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_WARN);
						}
						
					}
					
					return content;
				}
			}
			
			
			return "";
		}// end of member function Render
		
		public override object VisitElementDecl(object rXsElementDecl, object path) //path = string
		{
			//global $g_dlog
			bool is_root;
			string name;
			int min_occurs;
			object r_type;
			int limit;
			int max_occurs;
			int num_instances;
			int num_attempts;
			string xml;
			bool is_complex;
			string prefix;
			string xmlns;
			string target_namespace;
			string element_namespace;
			Utility.OrderedMap imported_namespaces;
			string open_tag;
			string attributes_xml;
			string base_subcontent_xml;
			string sub_content_xml;
			string content;
			Utility.OrderedMap r_declared_attribute_uses;
			bool has_attributes;
			int i;
			string attribute_xml;
			object r_content_type;
			string val;
			
			is_root = (path.ToString() == "");
			
			name = ((XsElementDecl)rXsElementDecl).GetName();
			
			element_namespace = ((XsElementDecl)rXsElementDecl).GetTargetNamespace();

			string path_token_prefix = this.mOutputModel.GetPrefix( element_namespace );

			if ( path_token_prefix != "" )
			{
				path_token_prefix += ":";
			}

			path += "/" + path_token_prefix + name;
			
			TpLog.debug("Visiting element declaration at " + path);
			
			if (this.mIgnorePaths.Search(path) != null)
			{
				TpLog.debug("Ignoring element");
				
				return "";
			}
			
			// Note: We are assuming that the if the element exceeds the maximum level
			//       then it will be in mIgnorePaths. This is checked previously 
			//       by TpSchemaInspector.
			
			min_occurs = ((XsElementDecl)rXsElementDecl).GetMinOccurs();
			
			// Note: We are assuming that $type is always a valid object, since 
			//       there was a previous checking done by TpSchemaInspector.
			r_type = ((XsElementDecl)rXsElementDecl).GetType();
			
			// Element cardinality
			
			limit = min_occurs;
			
			limit = Math.Max(limit, 1);
			
			if (path.ToString() == this.mIndexingElement)
			{
				max_occurs = ((XsElementDecl)rXsElementDecl).GetMaxOccurs();
				
				if (max_occurs == -1)
				{
					limit = Math.Min(this.mLimit, this.mMaxRepetitions);
				}
				else
				{
					limit = Math.Min(this.mLimit, Math.Min(this.mMaxRepetitions, max_occurs));
				}
			}
			
			limit = Math.Min(limit, this.mMaxRepetitions);
			
			num_instances = num_attempts = 0;
			
			xml = "";
			
			is_complex = false;
			
			TpLog.debug("Element instances limit is " + Utility.TypeSupport.ToString(limit));
			
			// Namespaces & prefixes declaration
			
			prefix = "";
			
			xmlns = "";
			
			if (!this.mOmitNamespaces)
			{
				target_namespace = this.mResponseStructure.GetTargetNamespace();
				string target_ns_prefix = this.mOutputModel.GetPrefix( target_namespace );

				element_namespace = ((XsElementDecl)rXsElementDecl).GetTargetNamespace();
				
				if (is_root)
				{
					if ( target_ns_prefix == "" )
					{
						// Only declare a default namespace if there is no prefix
						// associated with the target namespace
						xmlns = " xmlns=\"" + target_namespace + "\"";
					}
					else
					{
						xmlns = " xmlns:" + target_ns_prefix + "=\"" + target_namespace + "\"";
						prefix = target_ns_prefix + ":";
					}

					xmlns += " xmlns:" + TpConfigManager.TP_XSI_PREFIX + "=\"" + TpConfigManager.XMLSCHEMAINST + "\"";

	                Utility.OrderedMap ns_to_declare = this.mOutputModel.GetDeclaredNamespaces();

					for ( int x = 0; x < ns_to_declare.Count; ++x )
					{
						string uri = ((TpNamespace)ns_to_declare.Values[x]).GetUri();

						string pref = ((TpNamespace)ns_to_declare.Values[x]).GetPrefix();

						if ( uri != target_namespace &&
							pref != TpConfigManager.TP_XSI_PREFIX &&
							pref != "default" &&
							uri != TpConfigManager.XMLSCHEMANS )
						{
							xmlns += " xmlns:" + pref + "=\"" + uri + "\"";
						}
					}					
				}
				else
				{
					if ( element_namespace != target_namespace )
					{
						prefix = this.mOutputModel.GetPrefix( element_namespace );

						if ( prefix == "" )
						{
							string msg = "Could not find prefix for namespace " + element_namespace;
							new TpDiagnostics().Append( TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_ERROR );

							this.mAbort = true;

							return "";
						}

						prefix += ":";
					}
					else if ( target_ns_prefix != "" )
					{
						prefix = target_ns_prefix + ":";
					}
				}
				
				this.mNamespaceStack.Push(element_namespace);
			}
			
			object r_basetype = ((XsType)r_type).BaseType;

			// Main loop for element instances
			
			while (num_attempts < limit)
			{
				this.mAbort = false;
				
				if (path.ToString() == this.mIndexingElement)
				{
					if (mRecordIndex >= mrResultSet.Tables[0].Rows.Count)
					{
						break;
					}
				}
				
				open_tag = "<";
				
				if (is_root)
				{
					open_tag += name + xmlns;
				}
				else
				{
					open_tag += prefix + name;
				}
				
				attributes_xml = "";
				base_subcontent_xml = "";
				sub_content_xml = "";
				
				content = "";
				
				if (((XsType)r_type).IsComplexType())
				{
					TpLog.debug("Has Complex type");
					
					is_complex = true;
					
					string derivation_method = ((XsType)r_type).DerivationMethod;

					// Add attributes
					
					if ( derivation_method == "extension" &&
						r_basetype != null && ((XsType)r_basetype).IsComplexType() )
					{
						TpLog.debug( "Base attributes" );

						// Base attributes, in case of extension
						Utility.OrderedMap r_basetype_declared_attribute_uses = ((XsComplexType)r_basetype).GetDeclaredAttributeUses();

						attributes_xml += this._GetAttributesXml( r_basetype_declared_attribute_uses, (string)path );
					}

					// Current attributes (real extended attributes or attributes from 
					// non extended types)
					
					TpLog.debug( "Current attributes" );

					r_declared_attribute_uses = ((XsComplexType)r_type).GetDeclaredAttributeUses();
					
					has_attributes = false;
					
					attributes_xml = _GetAttributesXml(r_declared_attribute_uses, (string)path);
					
					if (this.mAbort)
					{
						++num_attempts;
						
						if ( this._CheckLoop( path.ToString() ) )
						{
							break;
						}

						continue;
					}
					else
					{
						open_tag += attributes_xml + ">";
						
						if ( derivation_method == "extension" && r_basetype != null )
						{
							// Base content

							if ( ((XsType)r_basetype).IsSimpleType() )
							{
								val = this._GetSimpleContent( rXsElementDecl, (string)path );

								base_subcontent_xml = (val == null ? "" : val);

								content += base_subcontent_xml;
							}
							else
							{
								object r_base_content_type = ((XsComplexType)r_basetype).GetContentType();

								TpLog.debug( "Base content type: " + r_base_content_type.ToString() );

								if ( r_base_content_type.GetType().ToString().ToLower() == "tapirdotnet.xsmodelgroup" )
								{
									base_subcontent_xml = (string)((XsModelGroup)r_base_content_type).Accept( this, path );

									if ( this.mAbort )
									{
										++num_attempts;

										if ( this._CheckLoop( (string)path ) )
										{
											break;
										}

										continue;
									}

									content += base_subcontent_xml;
								}
								else
								{
									// Should not fall here now (schema inspector should have 
									// rejected)
								}
							}
						}

						r_content_type = ((XsComplexType)r_type).GetContentType();
						string current_subcontent_xml = "";

						if ( derivation_method == "" || 
							( ( ! this.mAbort ) &&
							( ! ((XsComplexType)r_type).HasSimpleContent() ) &&
							r_content_type != null ) )
						{
							TpLog.debug( "Current content type: " + r_content_type.GetType().ToString() );

							// Extended content or content from non extended types
							if ( r_content_type.GetType().ToString().ToLower() == "tapirdotnet.xsmodelgroup" )
							{
								current_subcontent_xml = (string)((XsModelGroup)r_content_type).Accept( this, path );

								if ( this.mAbort )
								{
									++num_attempts;

									if ( this._CheckLoop( (string)path ) )
									{
										break;
									}

									continue;
								}

								content += current_subcontent_xml;
							}
							else
							{
								// Should not fall here now (schema inspector should have 
								// rejected)
							}
						}

						// Don't render complex elements without content
						if ( attributes_xml == "" &&
							base_subcontent_xml  == "" &&
							current_subcontent_xml == "" )
						{
							++num_attempts;

							if ( this._CheckLoop( (string)path ) )
							{
								break;
							}

							continue;
						}

					}
				}
				else
				{
					// Simple type
					
					TpLog.debug("Has Simple type");
					
					val = this._GetSimpleContent(rXsElementDecl, path.ToString());
					
					if (val == "")
					{
						if (Utility.TypeSupport.ToBoolean(((XsElementDecl)rXsElementDecl).IsNillable()) && !this.mOmitNamespaces)
						{
							open_tag += " " + TpConfigManager.TP_XSI_PREFIX + ":nil=\"true\">";
						}
						else
						{
							if (this.mNoContentSummary[path] != null)
							{
								mNoContentSummary[path] = (int)mNoContentSummary[path] + 1;
							}
							else
							{
								this.mNoContentSummary[path] = 1;
							}
							
							TpLog.debug("Element " + path + " has no content (rec index=" + this.mRecordIndex.ToString() + ")");
							
							this.mAbort = true;
						}
					}
					else
					{
						open_tag += ">";
						
						content = val;
					}
				}
				
				if (!this.mAbort)
				{
					++num_instances;

					if (name != "any")
					{
						xml += open_tag + content + "</" + prefix + name + ">";
					}
					else
					{
						xml += content; //any elements are replaced by their content
					}
					
				}
								            
				if ( this._CheckLoop( (string)path ) )
				{
					break;
				}
				
				++num_attempts;
			}// end while
			
			if (!this.mOmitNamespaces)
			{
				this.mNamespaceStack.Pop();
			}
			
			if (num_instances < min_occurs)
			{
				if (this.mNoContentSummary[path] != null)
				{
					if (is_complex)
					{
						mNoContentSummary[path] = (int)mNoContentSummary[path] + 1;
					}
				}
				else
				{
					this.mNoContentSummary[path] = 1;
				}
				
				TpLog.debug("Element " + path + " did not reach the minimum number " + "of occurrences (rec index=" + this.mRecordIndex.ToString() + ")");
				
				this.mAbort = true;
				
				xml = "";
			}
			else
			{
				this.mAbort = false;
				
				if (path.ToString() == this.mIndexingElement)
				{
					this.mTotalReturned = num_instances;
				}
			}
			
			return xml;
		}// end of member function VisitElementDecl
		
		public bool _CheckLoop( string path )
		{
			// Jump to next record if this is the indexing element and in
			// this case returns true if reached the end of the result set
			if ( path == this.mIndexingElement )
			{
				this.mRecordIndex += 1;

				//$this->mrResultSet->MoveNext();

				if ( mRecordIndex >= mrResultSet.Tables[0].Rows.Count )
				{
					return true;
				}
			}

			return false;

		} // end of member function _CheckLoop

		public override object VisitAttributeUse(object rXsAttributeUse, object path) //path = string
		{
			//global $g_dlog
			XsAttributeDecl attribute_decl;
			string prefix;
			object attribute_namespace = null;
			int ns_depth;
			object contextual_namespace;
			string name;
			string val;
			
			attribute_decl = ((XsAttributeUse)rXsAttributeUse).GetDecl();
			
			prefix = "";
			
			if (!this.mOmitNamespaces)
			{
				attribute_namespace = attribute_decl.GetTargetNamespace();
				
				ns_depth = Utility.OrderedMap.CountElements(this.mNamespaceStack);
				
				if (ns_depth > 0)
				{
					contextual_namespace = this.mNamespaceStack[ns_depth - 1];
					
					if (attribute_namespace != contextual_namespace)
					{
						prefix = this.mOutputModel.GetPrefix( (string)attribute_namespace );

						if ( prefix == "" )
						{
							prefix = this.mResponseStructure.GetPrefix(attribute_namespace.ToString());
						
							prefix += ":";
						}
					}
				}
			}
			
			name = attribute_decl.GetName();
			
			string path_token_prefix = this.mOutputModel.GetPrefix( (string)attribute_namespace );

			if ( path_token_prefix != "" )
			{
				path_token_prefix += ":";
			}

			path += "/@" + path_token_prefix + name;
			
			TpLog.debug("Visiting attribute declaration at " + path);
			
			val = this._GetSimpleContent(rXsAttributeUse, path.ToString());
			
			if (val != "")
			{
				return " " + prefix + name + "=\"" + TpUtils.EscapeXmlSpecialChars(val) + "\"";
			}
			else
			{
				if (((XsAttributeUse)rXsAttributeUse).IsRequired())
				{
					if (this.mNoContentSummary[path] != null)
					{
						mNoContentSummary[path] = (int)mNoContentSummary[path] + 1;
					}
					else
					{
						this.mNoContentSummary[path] = 1;
					}
					
					TpLog.debug("Attribute " + path + " has no content (rec index=" + this.mRecordIndex.ToString() + ")");
					
					this.mAbort = true;
				}
			}
			
			return "";
		}// end of member function VisitAttributeUse
		
		public override object VisitModelGroup(object rXsModelGroup, object path) //path = int
		{
			string compositor;
			string xml;
			Utility.OrderedMap r_particles;
			int i;
			
			// Note: no need to check depth since this was already checked by 
			//       the schema inspector.
			
			compositor = ((XsModelGroup)rXsModelGroup).GetCompositor().ToString();
			
			xml = "";
			
			r_particles = ((XsModelGroup)rXsModelGroup).GetParticles();
			
			for (i = 0; i < Utility.OrderedMap.CountElements(r_particles); ++i)
			{
				TpLog.debug("Calling particle " + r_particles[i].GetType().Name);
				
				if (r_particles[i] is XsElementDecl)
				{
					xml = xml + ((XsElementDecl)r_particles[i]).Accept(this, path).ToString();
				}
				else
				{
					xml = xml + ((XsModelGroup)r_particles[i]).Accept(this, path).ToString();
				}
				
				if (this.mAbort && compositor != "choice")
				{
					break;
				}
				
				if (!Utility.VariableSupport.Empty(xml) && compositor == "choice")
				{
					break;
				}
			}
			
			if (Utility.VariableSupport.Empty(xml) && compositor == "choice" && ((XsModelGroup)rXsModelGroup).GetMinOccurs() > 0)
			{
				if (this.mNoContentSummary[path] != null)
				{
					mNoContentSummary[path] = (int)mNoContentSummary[path] + 1;
				}
				else
				{
					this.mNoContentSummary[path] = 1;
				}
				
				TpLog.debug("No valid choice for node " + path.ToString() + " (rec index=" + this.mRecordIndex.ToString() + ")");
				
				this.mAbort = true;
			}
			
			return xml;
		}// end of member function VisitModelGroup
		
		public string _GetAttributesXml( Utility.OrderedMap rDeclaredAttributeUses, string path )
		{
			string xml = "";

			for ( int i = 0; i < rDeclaredAttributeUses.Count; ++i )
			{
				string attribute_xml = (string)((XsAttributeUse)rDeclaredAttributeUses[i]).Accept( this, path );

				if ( attribute_xml != "" )
				{
					xml += attribute_xml;
				}

				if ( this.mAbort )
				{
					// No need to continue if a mandatory attribute was not rendered
					break;
				}
			}

			return xml;
		} // end of member function _GetAttributesXml

		public virtual string _GetSimpleContent(object obj, string path)
		{
			//global $g_dlog
			string val;
			Utility.OrderedMap mapping;
			
			TpLog.debug("Getting simple content");
			
			val = "";
			
			bool hasFV = false;
			bool hasDV = false;
			object fv = null;
			object dv = null;

			if (obj is XsAttributeUse) 
			{
				hasFV = ((XsAttributeUse)obj).HasFixedValue();
				hasDV = ((XsAttributeUse)obj).HasDefaultValue();				
				if (hasFV) fv = ((XsAttributeUse)obj).GetFixedValue();
				if (hasDV) dv = ((XsAttributeUse)obj).GetDefaultValue();
			}
			else
			{
				hasFV = ((XsElementDecl)obj).HasFixedValue();	
				hasDV = ((XsElementDecl)obj).HasDefaultValue();
				if (hasFV) fv = ((XsElementDecl)obj).GetFixedValue();
				if (hasDV) dv = ((XsElementDecl)obj).GetDefaultValue();
			}

			if (hasFV)
			{
				val = fv.ToString();
			}
			else
			{
				mapping = Utility.TypeSupport.ToArray(this.mOutputModel.GetMappingForNode(path));
				
				if (mapping != null)
				{
					val = this._GetMappedData(mapping, path);
				}
				
				if (val == "" && hasDV)
				{
					val = dv.ToString();
				}
			}
			
			return val;
		}// end of _GetValue
		
		public virtual string _GetMappedData(Utility.OrderedMap mapping, string path)
		{
			//global $g_dlog
			string data = "";
			int i;
			TpExpression expression;
			object reference;
			int column_index;
			
			TpLog.debug("Getting mapped data");
						
			if (this.mIgnorePaths.Search(path) != null)
			{
				TpLog.debug("Ignoring");
				
				return "";
			}
			
			for (i = 0; i < Utility.OrderedMap.CountElements(mapping); ++i)
			{
				expression = (TpExpression)mapping[i];
				
				reference = expression.GetReference();
				
				if ( ((TpExpression)expression).GetType() == TpFilter.EXP_LITERAL)
				{
					string c = reference.ToString();
					if (expression.XmlEncode) data += TpUtils.EscapeXmlSpecialChars(c);
					else data += c;
				}
				else
				{
					if (((TpExpression)expression).GetType() == TpFilter.EXP_VARIABLE)
					{
						string c = expression.GetValue(this.mrResource, null, false, false);
						if (expression.XmlEncode) data += TpUtils.EscapeXmlSpecialChars(c);
						else data += c;
					}
					else
					{
						if (((TpExpression)expression).GetType() == TpFilter.EXP_CONCEPT)
						{
							// Note: Here we are assuming that if this node is outside the
							//       indexingElement, then it does not have a mapping type
							//       bound to the local database (eg. SingleColumnMapping).
							//       This is checked previously with the TpSchemaInspector
							
							column_index = this.mSqlBuilder.GetTargetIndex(reference.ToString());
							
							if (column_index >= 0 && column_index < this.mrResultSet.Tables[0].Columns.Count)
							{
								
								string c = this.mrResultSet.Tables[0].Rows[mRecordIndex][column_index].ToString();
								if (expression.XmlEncode) data += TpServiceUtils.EncodeData(c, this.mDbEncoding);
								else data += c;

								//lsid data?
								if (mrResource.GetLocalMapping().GetConcept(reference).GetMappingType() == "LSIDDataMapping")
								{
									try
									{
										TpLog.debug("Resolving LSID : " + data);

										LSIDClient.LSIDResolver lsidRes = new LSIDClient.LSIDResolver(new LSIDClient.LSID(data));
										LSIDClient.MetadataResponse resp = lsidRes.getMetadata();
										StreamReader rdr = new StreamReader(resp.getMetadata());
										data = rdr.ReadToEnd();
										rdr.Close();

										//remove xml declaration
										int pos = data.IndexOf("<?xml");
										if (pos != -1)
										{
											pos = data.IndexOf("<", pos + 1);
											data = data.Substring(pos);
										}
									}
									catch (Exception ex)
									{
										TpLog.debug("Error resolving LSID : " + data + " : " + ex.Message + " : " + ex.StackTrace);
										new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, "Error resolving LSID : " + data + ".  No data returned.", TpConfigManager.DIAG_WARN);
									}
								}
							}
							else
							{
								if (TpConfigManager.TP_LOG_DEBUG)
								{
									TpLog.debug("Not found when ResultSet content is:");
									
									foreach ( DataColumn k in this.mrResultSet.Tables[0].Columns ) 
									{
										object v = this.mrResultSet.Tables[0].Columns[k.ColumnName];
										TpLog.debug("[" + k + "] (type=" + k.GetType().ToString() + ")= [" + v + "]");
									}										
									
								}
								
								return "";
							}
						}
					}
				}
			}
			
			return data;
		}// end of _GetMappedData
		
		public virtual int GetTotalReturned()
		{
			return this.mTotalReturned;
		}// end of GetTotalReturned
	}
}
