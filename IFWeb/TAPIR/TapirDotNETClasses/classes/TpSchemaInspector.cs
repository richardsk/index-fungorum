namespace TapirDotNET 
{

	public class TpSchemaInspector:TpSchemaVisitor
	{
		public TpOutputModel mrOutputModel;
		public TpResponseStructure mResponseStructure;
		public string mIndexingElement;
		public TpLocalMapping mrLocalMapping;
		public int mMaxLevels;
		public int mModelGroupVisits = 0;
		public Utility.OrderedMap mPartialNodes;
		public Utility.OrderedMap mAcceptedPaths = new Utility.OrderedMap();
		public Utility.OrderedMap mRejectedPaths = new Utility.OrderedMap();
		public bool mAbort = false;
		public bool mFoundIndexingElement = false;
		public bool mGreedy = true;
		
		public TpSchemaInspector(TpOutputModel rOutputModel, TpLocalMapping rLocalMapping, int maxLevels, Utility.OrderedMap partial)
		{
			this.mrOutputModel = rOutputModel;
			this.mResponseStructure = rOutputModel.GetResponseStructure();
			this.mIndexingElement = rOutputModel.GetIndexingElement().ToString();
			this.mrLocalMapping = rLocalMapping;
			this.mMaxLevels = maxLevels;
			this.mPartialNodes = partial;
						
			if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(partial)))
			{
				this.mGreedy = false;
			}
		}
		
		
		public virtual void  Inspect()
		{
			string error;
			Utility.OrderedMap global_elements;
			string path;
			int num_globals;
			bool lacks_concrete;
			
			TpLog.debug("[Schema Inspector]");
			
			if (this.mResponseStructure == null)
			{
				error = "Could not find a response structure in the output model";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
				
				this.mAbort = true;
				
				return ;
			}
			
			global_elements = Utility.TypeSupport.ToArray(this.mResponseStructure.GetElementDecls(null));
			
			path = "";
			
			num_globals = Utility.OrderedMap.CountElements(global_elements);
			
			if (num_globals == 0)
			{
				error = "No global element defined in response structure";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
				
				this.mAbort = true;
				
				return ;
			}
			else
			{
				lacks_concrete = true;
				
				foreach ( string el_name in global_elements.Keys ) 
				{
					object xs_element_decl = global_elements[el_name];
					if (!((XsElementDecl)xs_element_decl).IsAbstract())
					{
						lacks_concrete = false;
						
						// First "concrete" global element declaration
						((XsElementDecl)xs_element_decl).Accept(this, path);
						
						break;
					}
				}
				
				
				if (lacks_concrete)
				{
					error = "No concrete (non abstract) global element defined in " + "response structure";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
					
					this.mAbort = true;
					
					return ;
				}
			}
			
			if (!this.mFoundIndexingElement)
			{
				error = "Final response structure has no indexingElement";
				new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN);
			}
		}// end of member function Inspect
		
		public override object VisitElementDecl(object rXsElementDecl, object path) //path = string
		{
			bool is_root;
			string refElement;
			object rReferencedElement;
			string error;
			string name;
			int min_occurs;
			object r_type;
			string type_str;
			Utility.OrderedMap r_declared_attribute_uses;
			Utility.OrderedMap r_basetype_declared_attribute_uses;
			int i;
			object r_content_type;
			object r_base_content_type;

			string pathStr = path.ToString();
			is_root = (pathStr == "");
			
			XsElementDecl eldec = (XsElementDecl)rXsElementDecl;
            string ns = eldec.GetTargetNamespace();

			if (eldec.IsReference())
			{
				refElement = eldec.GetRef();
				
				TpLog.debug("Found element reference " + refElement);
				
				rReferencedElement = this.mResponseStructure.GetElementDecl(ns, refElement);
				
				if (rReferencedElement != null)
				{
					eldec.SetReferencedObj(rReferencedElement);
                    ns = eldec.GetTargetNamespace();
				}
				else
				{
					error = "Cannot find reference to element \"" + refElement + "\"";
					
					new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_ERROR);
					
					this.mAbort = true;
					
					return null;
				}
			}
			
			name = eldec.GetName();
			        
            string prefix = mrOutputModel.GetPrefix( ns );

            if (prefix != null && prefix.Length > 0)
            {
                prefix += ":";
            }

            path += "/" + prefix + name;

			pathStr = path.ToString();
			
			TpLog.debug("Visiting " + path);
			
			min_occurs = eldec.GetMinOccurs();
			
			if (Utility.OrderedMap.CountElements(new Utility.OrderedMap(pathStr.Split("/".ToCharArray()))) > this.mMaxLevels)
			{
				if (min_occurs > 0)
				{
					error = "Exceeded maximum number of element levels (element \"" + path + "\")";
					new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_ERROR);
					
					this.mAbort = true;
				}
				else
				{
					error = "Optional Element \"" + path + "\" exceeds the maximum number " + "of element levels. It will be discarded.";
					new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN);
				}
				
				this.mRejectedPaths.Push(path);
				
			}
			
			if ((!this.mGreedy) && min_occurs == 0 && (!this._BelongsToSomePartialAxis(pathStr)))
			{
				TpLog.debug("Element " + path + " will be ignored because it does not " + "belong to any partial axis and it is optional in a " + "non-greedy context");
				
				this.mRejectedPaths.Push(path);
				
				return null;
			}

            r_type = eldec.GetType();
			
			if (r_type is System.String)
			{
				TpLog.debug("Has string type " + r_type);
				
				type_str = r_type.ToString();
				
				r_type = this.mResponseStructure.GetType(eldec.GetDefaultNamespace(), r_type.ToString());
				
				if (r_type.ToString() == "")
				{
					if (min_occurs > 0)
					{
						error = "Unknown type " + type_str + " for mandatory element \"" + path + "\"";
						
						new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN);
						
						this.mAbort = true;
					}
					else
					{
						error = "Unknown type \"" + r_type.ToString() + "\" for element \"" + path + "\". It " + "will be discarded";
						
						new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN);
					}
					
					this.mRejectedPaths.Push(path);
					
					return null;
				}
				
				TpLog.debug("Setting object type");
				
				eldec.SetType(r_type);
			}
			else if (r_type == null)
			{
				if (min_occurs > 0)
				{
					error = "Unknown type \"" + r_type.ToString() + "\" for mandatory element \"" + path + "\"";
					new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN);
					
					this.mAbort = true;
				}
				else
				{
					error = "Unknown type \"" + r_type.ToString() + "\" for element \"" + path + "\". It " + "will be discarded";
					new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN);
				}
				
				this.mRejectedPaths.Push(path);
				
				return null;
			}
			        
			object r_basetype = ((XsType)r_type).BaseType;

			// Set base type object if necessary
			if ( r_basetype != null )
			{
				TpLog.debug( "Has base type" );

				if ( r_basetype is string )
				{
					TpLog.debug( "Base type is string " + r_basetype );

					string basetype_str = r_basetype.ToString();

					r_basetype = this.mResponseStructure.GetType( ((XsElementDecl)rXsElementDecl).GetDefaultNamespace(), basetype_str );

					if ( r_basetype == null )
					{
						if ( min_occurs > 0 )
						{
							error = "Unknown base type " + basetype_str + " for mandatory element " + path;

							new TpDiagnostics().Append( TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN );

							this.mAbort = true;
						}
						else
						{
							error = "Unknown base type '" + basetype_str + "' for element '" + path + "'. It will be discarded";
							new TpDiagnostics().Append( TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_WARN );
						}

						this.mRejectedPaths.Push(path);

						return null;
					}

					TpLog.debug( "Setting base type object" );

					((XsType)r_type).BaseType = r_basetype;
				}
			}

			if (((XsType)r_type).IsComplexType())
			{
				TpLog.debug("Is complex");
				
				string derivation_method = ((XsType)r_type).DerivationMethod;

				// Attributes
				if ( derivation_method == "extension" &&
					r_basetype != null && ((XsType)r_basetype).IsComplexType() )
				{
					// Base attributes, in case of extension
					r_basetype_declared_attribute_uses = ((XsComplexType)r_basetype).GetDeclaredAttributeUses();

					for ( i = 0; i < r_basetype_declared_attribute_uses.Count; ++i )
					{
						((XsAttributeUse)r_basetype_declared_attribute_uses[i]).Accept( this, path );
					}
				}

				// Current content type (real extended attributes or attributes
				// from a not extended type)
				r_declared_attribute_uses = ((XsComplexType)r_type).GetDeclaredAttributeUses();
				
				for (i = 0; i < Utility.OrderedMap.CountElements(r_declared_attribute_uses); ++i)
				{
					((XsAttributeUse)r_declared_attribute_uses[i]).Accept(this, path);
				}
				
				// Content type
				if ( derivation_method == "extension" && r_basetype != null )
				{
					if ( ((XsType)r_basetype).IsComplexType() )
					{
						TpLog.debug( "Checking content of base type " + ((XsType)r_basetype).GetName() );

						// Base content type, in case of extension
						r_base_content_type = ((XsComplexType)r_basetype).GetContentType();

						this._CheckContentType( r_base_content_type, (string)path );
					}
					else
					{
						if ( ! this._CheckSimpleContent( rXsElementDecl, (string)path, (min_occurs>0) ) )
						{
							this.mAbort = true;
						}
					}
				}

				// Current content type (real extended content or content
				// from a not extended type)
				r_content_type = ((XsComplexType)r_type).GetContentType();
				            
				// Always check if it's not derived from a base type.
				// If it's derived from a base type, the current content can be null
				// (because it inherits from a base type)
				if ( derivation_method == null || 
					(! this.mAbort && r_content_type  != null) )
				{
					TpLog.debug( "Checking content of type " + ((XsType)r_type).GetName() );

					this._CheckContentType( r_content_type, (string)path );
				}
				
				if (pathStr == this.mIndexingElement)
				{
					this.mFoundIndexingElement = true;
				}
				
				if (this.mAbort)
				{
					if (min_occurs == 0)
					{
						this.mAbort = false;
					}
					
					if (this.mRejectedPaths.Search(pathStr) != null)
					{
						this.mRejectedPaths.Push(pathStr);
					}
				}
				else
				{
					this.mAcceptedPaths[pathStr] = min_occurs;
				}
			}
			else
			{
				TpLog.debug("Is simple");
				
				// Simple content
				if (this._CheckSimpleContent(rXsElementDecl, pathStr, (min_occurs>0)))
				{
					this.mAcceptedPaths[path] = min_occurs;
				}
			}

			return null;
		}// end of member function VisitElementDecl
		
		public override object VisitAttributeUse(object rXsAttributeUse, object path) //path = string
		{
			XsAttributeDecl attribute_decl;
			string refElement;
			string ns;
			object rReferencedAttribute;
			string error;
			string name;
			int min_occurs;
			
			attribute_decl = ((XsAttributeUse)rXsAttributeUse).GetDecl();
			ns = attribute_decl.GetTargetNamespace();
			
			if (Utility.TypeSupport.ToBoolean(attribute_decl.IsReference()))
			{
				refElement = attribute_decl.GetRef();
				
				TpLog.debug("Found attribute reference " + refElement + " in namespace " + Utility.TypeSupport.ToString(ns));
				
				rReferencedAttribute = this.mResponseStructure.GetAttributeDecl(ns, refElement);
				
				if (rReferencedAttribute != null)
				{
					attribute_decl.SetReferencedObj(rReferencedAttribute);
                    ns = attribute_decl.GetTargetNamespace();
				}
				else
				{
					error = "Cannot find attribute reference to \"" + refElement + "\"";
					
					new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_ERROR);
					
					this.mAbort = true;
					
					return null;
				}
			}
			
			name = attribute_decl.GetName();
			string prefix = mrOutputModel.GetPrefix( ns );

            if (prefix != null && prefix != "")
            {
                prefix += ":";
            }

			path += "/@" + prefix + name;
			
			TpLog.debug("Visiting " + path);
			
			min_occurs = 0;
			
			if (((XsAttributeUse)rXsAttributeUse).IsRequired())
			{
				min_occurs = 1;
			}
			
			if (this._CheckSimpleContent(rXsAttributeUse, path.ToString(), (min_occurs>0)))
			{
				if ((!this.mGreedy) && min_occurs == 0)
				{
					this.mRejectedPaths.Push(path);
					
					TpLog.debug("Attribute " + path + " will be ignored because " + "it is optional in a non-greedy context");
					
					return null;
				}
				
				this.mAcceptedPaths[path] = min_occurs;
			}

			return null;
		}// end of member function VisitAttributeUse
		
		public override object VisitModelGroup(object rXsModelGroup, object path)
		{
			string error;
			Utility.OrderedMap r_particles;
			int i;
			
			TpLog.debug("Visiting model group " + Utility.TypeSupport.ToString(((XsModelGroup)rXsModelGroup).GetCompositor()));
			
			++this.mModelGroupVisits;
			
			if (this.mModelGroupVisits > 20)
			{
				error = "Exceed maximum number of model group nesting";
				
				new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, error, TpConfigManager.DIAG_ERROR);
				
				this.mAbort = true;
				
				return null;
			}
			
			r_particles = ((XsModelGroup)rXsModelGroup).GetParticles();
			
			TpLog.debug("Num particles: " + Utility.OrderedMap.CountElements(r_particles).ToString());
			
			for (i = 0; i < Utility.OrderedMap.CountElements(r_particles); ++i)
			{				
				if (r_particles[i] is XsElementDecl) ((XsElementDecl)r_particles[i]).Accept(this, path);
				if (r_particles[i] is XsModelGroup) ((XsModelGroup)r_particles[i]).Accept(this, path);
			}
			
			--this.mModelGroupVisits;

			return null;
		}// end of member function VisitModelGroup
		
		public bool _CheckContentType( object rContentType, string path )
        {
            TpLog.debug("Is null: " + (rContentType == null ? "1" : "0"));
            if (rContentType == null) return true;

			TpLog.debug( "Content type: " + rContentType.GetType().ToString() );

			if ( rContentType.GetType().ToString().ToLower() == "tapirdotnet.xsmodelgroup" )
			{
				((XsModelGroup)rContentType).Accept( this, path );
			}
			else
			{
				// Reject the path (simple content and complex content extensions
				// or restrictions will fall here).

				TpLog.debug( "Rejecting " + path + " for having unknown content type: " + rContentType.GetType().ToString() );

				this.mAbort = true;
			}

			return true;
		} // end of _CheckContentType

		public virtual bool _CheckSimpleContent(object obj, string path, bool isMandatory)
		{
			Utility.OrderedMap mapping = Utility.TypeSupport.ToArray(this.mrOutputModel.GetMappingForNode(path));
			int i;
			TpExpression expression = null;
			string reference;
			string msg;
			TpConcept concept = null;
			string mapping_type;
			string concept_id;

			bool hasFV = false;
			bool hasDV = false;
			int minOcc = -1;
			if (obj is XsAttributeUse) 
			{
				hasFV = ((XsAttributeUse)obj).HasFixedValue();
				hasDV = ((XsAttributeUse)obj).HasDefaultValue();				
			}
			else
			{
				hasFV = ((XsDeclaration)obj).HasFixedValue();
								
				if (obj is XsElementDecl) 
				{
					minOcc = ((XsElementDecl)obj).GetMinOccurs();
					hasDV = ((XsElementDecl)obj).HasDefaultValue();
				}
			}
			
			if (!hasFV && !hasDV && mapping != null)
			{
				for (i = 0; i < Utility.OrderedMap.CountElements(mapping); ++i)
				{
					expression = (TpExpression)mapping[i];
					
					reference = expression.GetReference().ToString();
					
					if (expression.GetType() == TpFilter.EXP_CONCEPT)
					{
						if (obj is XsElementDecl && minOcc > 1 && TpServiceUtils.Contains(path, this.mIndexingElement))
						{
							msg = "Node \"" + path + "\" has incompatible cardinality " + "(greater than one) for being inside the " + "indexingElement and locally mapped to a concept";
							
							new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_OUTPUT_MODEL, msg, TpConfigManager.DIAG_ERROR);
							this.mAbort = true;
							
							this.mRejectedPaths.Push(path);
							
							return false;
						}
						
						concept = this.mrLocalMapping.GetConcept(reference);
						
						if (concept != null && concept.IsMapped())
						{
							if (concept.GetMapping().GetLocalType().ToString() == TpConceptMapping.TYPE_XML) expression.XmlEncode = false;

							mapping_type = concept.GetMappingType();
														
							if (Utility.StringSupport.StringCompare(mapping_type, "SingleColumnMapping", false) == 0 && !TpServiceUtils.Contains(path, this.mIndexingElement))
							{
								msg = "Node \"" + path + "\" has an incompatible local " + "mapping type for being outside the indexingElement " + "(the mapping type is bound to the local database).";
								
								if (isMandatory)
								{
									new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_OUTPUT_MODEL, msg, TpConfigManager.DIAG_ERROR);
									
									this.mAbort = true;
								}
								else
								{
									msg += " It will be discarded.";
									
									new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_WARN);
								}
								
								this.mRejectedPaths.Push(path);
								
								return false;
							}
						}
						else
						{
							concept_id = reference;
							
							if (concept != null)
							{
								concept_id = Utility.TypeSupport.ToString(concept.GetId());
							}
							
							msg = "Concept \"" + concept_id + "\" was not mapped " + "to the local database.";
							
							if (isMandatory)
							{
								new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_OUTPUT_MODEL, msg, TpConfigManager.DIAG_WARN);
								
								this.mAbort = true;
							}
							else
							{
								msg += " It will be discarded.";
								
								new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_WARN);
							}
							
							this.mRejectedPaths.Push(path);
							
							return false;
						}
					}
				}
			}
			
			return true;
		}// end of _CheckSimpleContent
		
		public virtual bool _BelongsToSomePartialAxis(string path)
		{
			foreach ( object partial_node in this.mPartialNodes.Values ) 
			{
				if (TpServiceUtils.Contains(Utility.TypeSupport.ToString(partial_node), path))
				{
					return true;
				}
			}
			
			
			return false;
		}// end of member function _BelongsToSomePartialAxis
		
		public virtual bool MustAbort()
		{
			return this.mAbort;
		}// end of member function MustAbort
		
		public virtual Utility.OrderedMap GetAcceptedPaths()
		{
			return this.mAcceptedPaths;
		}// end of member function GetAcceptedPaths
		
		public virtual Utility.OrderedMap GetRejectedPaths()
		{
			return this.mRejectedPaths;
		}// end of member function GetRejectedPaths
	}
}
