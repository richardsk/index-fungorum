using System;
using System.IO;
using System.Xml;
using System.Net;

namespace TapirDotNET 
{

	public class TpResponseStructure
	{
		public TpXmlReader mReader;
		public Utility.OrderedMap mInTagsStack = new Utility.OrderedMap(new Utility.OrderedMap());
		private Utility.OrderedMap mCurrentLocationStack = new Utility.OrderedMap();
		public string mTargetNamespace;
		public string mDefaultNamespace;
		public Utility.OrderedMap mTargetNamespaces = new Utility.OrderedMap();
		public Utility.OrderedMap mObjects = new Utility.OrderedMap();
		public string mIgnoreNode = "";
		private Utility.OrderedMap mIncludeStack = new Utility.OrderedMap(); // stack 
			// of boolan flags, one for each schema 
			// being parsed, to indicate if the current
			// schema was included or not (imported)
		public int mNumParsings = 0;
		public Utility.OrderedMap mNamespaces = new Utility.OrderedMap();
		public Utility.OrderedMap mUnsupportedConstructs = new Utility.OrderedMap();// array 
			// of "intags" arrays (element stack  
			// during XML parsing) for each schema being 
			// parsed// stack to keep track of current namespace
			// should be ignored or not.// Control the maximum number of consecutive includes/imports
			// when parsing <import> statements and to store all
			// global declarations
			//
			// namespace => array( 'loc'   => schema location, 
			//                     'el'    => array, 
			//                     'attr'  => array,
			//                     'type'  => array )
			// 
			// note: all schema components subarrays have this format: 
			// 
			// local name => corresponding Xs obj
		
		public TpResponseStructure()
		{
			
		}

        private string GetNamespace(string prefix)
        {
            string ns = mReader.GetNamespace(prefix);

            if (ns == null)
            {
                foreach (TpNamespace tns in this.mNamespaces.Values)
                {
                    if (tns.GetPrefix() == prefix)
                    {
                        ns = tns.GetUri();
                        break;
                    }
                }
            }

            if (ns == null)
            {
                string error = "Could not find namespace declaration for prefix \"" + prefix + "\"";
                new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
            }

            return ns;
        }
		
		public virtual bool Parse(string location, bool wasIncluded)
		{
			string msg;
			string error;
			
			TpLog.debug("Parsing schema " + location);
			
			string sch = "";
			if (!TpUtils.IsUrl(location) // the URI is not absolute already (or is wrong!)
				&& this.mCurrentLocationStack.Count > 0 ) // this is not the first call to the parser
				// and we have a base URI to work with
			{			
				string including_location = mCurrentLocationStack.End().ToString();
				TpLog.debug( "Calculating absolute URI from " + including_location + " and " + location);
            
				string[] base_parts = including_location.Split('/');            
				string[] relative_parts = location.Split('/');

				string base_location = "";
				string relative_location = "";
            
				// chop off parent directories
				int pos = 0;
				while( relative_parts[pos] == ".." )
				{
					pos += 1;
				}

				for (int index = 0; index < base_parts.Length - (pos+1); index++ )
				{
					if (base_location.Length > 0) base_location += "/";
					base_location += base_parts[index];
				}

				for (int index = pos; index < relative_parts.Length; index++ )
				{
					if (relative_location.Length > 0) relative_location += "/";
					relative_location += relative_parts[index];
				}

				// Replace with absolute location
				location = base_location + "/" + relative_location;
			}

			TpLog.debug( "Reading response structure from " + location);

			if (TpUtils.IsUrl(location))
			{
				WebRequest wr = HttpWebRequest.Create(location);
				if ( TpConfigManager.TP_WEB_PROXY.Length > 0 )
				{
					wr.Proxy = new WebProxy(TpConfigManager.TP_WEB_PROXY);
				}

				WebResponse resp = wr.GetResponse();
				StreamReader sr = new StreamReader(resp.GetResponseStream());
				sch = sr.ReadToEnd();
				sr.Close();
			}
			else
			{
				StreamReader sr = File.OpenText(location);
				sch = sr.ReadToEnd();
				sr.Close();
			}
						
			foreach ( TpNamespace ns in this.mNamespaces.Values ) 
			{
				if (ns.HasSchema(location))
				{
					// Before skipping, see if it's necessary to add the corresponding
					// TpXmlSchema object to the current namespace
					if ( wasIncluded )
					{
						string current_namespace = this.mTargetNamespaces.End().ToString();

						if ( !((TpNamespace)this.mNamespaces[current_namespace]).HasSchema(location) )
						{
							TpXmlSchema r_schema = ns.GetSchema( location ); 

							((TpNamespace)this.mNamespaces[current_namespace]).AddSchema( r_schema );
						}
					}

					msg = "Skipping XML Schema that was already parsed " + "(" + location + ")";
					
					new TpDiagnostics().Append(TpConfigManager.DC_XML_PARSE_ERROR, msg, TpConfigManager.DIAG_WARN);
					
					return false;
				}
			}

            ++this.mNumParsings;

            if (this.mNumParsings > 20)
            {
                msg = "Exceeded maximum number of schema parsing (20). Stopped at \"" + location + "\"";

                new TpDiagnostics().Append(TpConfigManager.DC_XML_PARSE_ERROR, msg, TpConfigManager.DIAG_ERROR);

                return false;
            }

			this.mInTagsStack.Push(new Utility.OrderedMap());
			this.mCurrentLocationStack.Push(location);
			this.mIncludeStack.Push(wasIncluded);

			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
											
			try
			{
				rdr.ReadXmlStr(sch);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
									
			this.mInTagsStack.Pop();
			this.mCurrentLocationStack.Pop();
			this.mIncludeStack.Pop();
						
			return true;
		}// end of member function Parse
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			//global $g_dlog
			string name;
			object g_dlog;
			int num_namespaces;
			int parse_step;
			Utility.OrderedMap in_tags;
			string node_path;
			int depth;
			int num_objects;
			object r_current_object = null;
			string error;
			string imported_namespace;
			bool is_include;
			bool is_global;
			XsElementDecl xs_element_decl;
			XsComplexType xs_complex_type;
			XsSimpleType xs_simple_type;
			XsAttributeDecl xs_attribute_declaration;
			XsAttributeUse xs_attribute_use;
			XsModelGroup xs_model_group;
			string msg;
			
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.LocalName).ToLower();
			
			TpLog.debug("Starting Element: " + name);
			
			num_namespaces = Utility.OrderedMap.CountElements(this.mTargetNamespaces);
			
			string ns = "";
			
			if (num_namespaces > 0)
			{
				ns = this.mTargetNamespaces[num_namespaces - 1].ToString();
			}
			
			string defNs = mDefaultNamespace;
			if (defNs == null || defNs == "") defNs = ns;

			parse_step = Utility.OrderedMap.CountElements(this.mInTagsStack);
			
			((Utility.OrderedMap)this.mInTagsStack[parse_step - 1]).Push(name.ToLower());
			
			in_tags = Utility.TypeSupport.ToArray(this.mInTagsStack[parse_step - 1]);
			
			node_path = Utility.StringSupport.Join("/", in_tags);
			
			TpLog.debug("Node path: " + node_path);
			
			if (this.mIgnoreNode != "" && this.mIgnoreNode != null)
			{
				TpLog.debug("Ignoring start node");
				
				return ;
			}
			
			depth = Utility.OrderedMap.CountElements(in_tags);
			
			num_objects = Utility.OrderedMap.CountElements(this.mObjects);
			
			if (num_objects > 0)
			{
				r_current_object = this.mObjects[num_objects - 1];
			}
			
			string current_location = "";
			if (mCurrentLocationStack.Count == 0)
				current_location = reader.XmlReader.NamespaceURI;
			else current_location = mCurrentLocationStack.End().ToString();

			// SCHEMA
			if (Utility.StringSupport.StringCompare(name, "schema", false) == 0)
			{
				bool wasIncluded = false;
				if (mIncludeStack.Count > 0) wasIncluded = (bool)mIncludeStack.End();
				if (wasIncluded)
				{
					// No need to have target a namespace.
					// Things belong to the last namespace.
					((TpNamespace)this.mNamespaces[ns]).PushSchema( current_location, null /*todo parser*/ );
				}
				else
				{
					if (attrs["targetNamespace"] == null || attrs["targetNamespace"].ToString() == "")
					{
						this.mIgnoreNode = node_path;
						
						error = "Response structures can only handle XML Schemas " + "with a \"targetNamespace\" attribute. " + "Ignoring schema loaded from \"" + current_location + "\"";
						
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
						
						return ;
					}
					
					
					this.mTargetNamespaces.Push(attrs["targetNamespace"]);
					
					string ts = attrs["targetNamespace"].ToString();

					if ( this.mNamespaces[ts] == null )
					{
						string prefix = ""; // not needed here

						TpNamespace ns_obj = new TpNamespace( prefix, ts, "" );

						this.mNamespaces[ts] = ns_obj;
					}

					((TpNamespace)this.mNamespaces[ts]).PushSchema( current_location, null /* todo ? parser */ );
				}

				foreach (string key in attrs.Keys)
				{
					if (key.StartsWith("xmlns:") && key.Length > 6)
					{
						string prefix = key.Split(':')[1];
						string ts = attrs[key].ToString();
						if (this.mNamespaces[ts] == null)
						{
							TpNamespace ns_obj = new TpNamespace(prefix, ts, "");
							this.mNamespaces[ts] = ns_obj;
							
							((TpNamespace)this.mNamespaces[ts]).PushSchema( current_location, null );
						}
					}
				}

				if (attrs.KeyExists("xmlns"))
				{
					this.mDefaultNamespace = attrs["xmlns"].ToString();
					
					string ts = attrs["xmlns"].ToString();
					if (this.mNamespaces[ts] == null)
					{
						TpNamespace ns_obj = new TpNamespace("", ts, "");
						this.mNamespaces[ts] = ns_obj;
						
						((TpNamespace)this.mNamespaces[ts]).PushSchema( current_location, null );
					}
				}
				
				if (Utility.VariableSupport.Empty(this.mTargetNamespace))
				{
					this.mTargetNamespace = attrs["targetNamespace"].ToString();
				}
				else
				{
					// inside <import> parsing. targetNamespace for the response
					// structure was already assigned.
				}
				
				if (!(this.mReader != null))
				{
					// Assign parser property here since it might have been 
					// instantiated outside this class
					this.mReader = reader;
				}
				else
				{
					// inside <import> parsing. no need to assign anything.
				}
			}
				// IMPORT
			else if (Utility.StringSupport.StringCompare(name, "import", false) == 0)
			{
				if (attrs["namespace"] != null && attrs["namespace"].ToString() != "")
				{
					imported_namespace = attrs["namespace"].ToString();
				}
				else
				{
					imported_namespace = ns;
				}
				
				if (attrs["schemaLocation"] == null || attrs["schemaLocation"].ToString() == "")
				{
					this.mIgnoreNode = node_path;
					
					error = "Only XML Schema \"import\" directives with a " + "\"schemaLocation\" attribute are supported. " + "Ignoring import declaration for \"" + imported_namespace + "\" in \"" + current_location + "\"";
					
					new TpDiagnostics().Append(TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR);
					
					return ;
				}
				
				this.Parse(attrs["schemaLocation"].ToString(), false);
			}
				// INCLUDE
			else if (Utility.StringSupport.StringCompare(name, "include", false) == 0)
			{
				if (attrs["schemaLocation"] == null || attrs["schemaLocation"].ToString() == "")
				{
					this.mIgnoreNode = node_path;
							
					error = "Found XML Schema \"include\" construct without a " + "\"schemaLocation\" attribute. " + "Ignoring declaration in \"" + current_location + "\"";
							
					new TpDiagnostics().Append(TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR);
							
					return ;
				}
						
				is_include = true;
						
				this.Parse(attrs["schemaLocation"].ToString(), is_include);
			}
				// ELEMENT
			else if (Utility.StringSupport.StringCompare(name, "element", false) == 0)
			{
				is_global = (in_tags[depth - 2].ToString().ToLower() == "schema");
						
				if (attrs["substitutionGroup"] != null && attrs["substitutionGroup"].ToString() != "")
				{
					if (TpConfigManager._DEBUG)
					{
						error = "\"substitutionGroup\" not supported. " + "Ignoring statement in \"" + current_location + "\"";
								
						if (attrs["name"] != null && attrs["name"].ToString() != "")
						{
							error += " for \"" + attrs["name"].ToString() + "\"";
						}
								
						new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_SCHEMA_COMPONENT, error, TpConfigManager.DIAG_WARN);
					}
					else
					{
						this.AddUnsupportedConstruct(current_location, "substitutionGroup");
					}
				}
						
				if (attrs["ref"] != null && attrs["ref"].ToString() != "")
				{
					if (is_global)
					{
						this.mIgnoreNode = node_path;
								
						error = "Detected global element with \"ref\" attribute in \"" + current_location + "\"";
						new TpDiagnostics().Append(TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR);
								
						return ;
					}
							
					xs_element_decl = new XsElementDecl(null, ns, defNs, false);
				}
				else
				{
					if (attrs["name"] == null || attrs["name"].ToString() == "")
					{
						this.mIgnoreNode = node_path;
								
						error = "Detected element declaration without name " + "attribute in \"" + current_location + "\"";
						new TpDiagnostics().Append(TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR);
								
						return ;
					}
							
					name = attrs["name"].ToString();
							
					xs_element_decl = new XsElementDecl(name, ns, defNs, is_global);
				}
						
				xs_element_decl.SetProperties(attrs);
						
				if (is_global)
				{
					// Global element
					((TpNamespace)this.mNamespaces[ns]).AddElementDecl( current_location, xs_element_decl );
				}
				else
				{
					((XsModelGroup)r_current_object).AddParticle(xs_element_decl);
				}
						
				TpLog.debug("Changing current object to an element");
						
				this.mObjects[num_objects] = xs_element_decl;
			}
				// COMPLEX TYPE
			else if (Utility.StringSupport.StringCompare(name, "complextype", false) == 0)
			{
				is_global = (in_tags[depth - 2].ToString().ToLower() == "schema");
						
				name = "";
						
				if (attrs["name"] != null && attrs["name"].ToString() != "")
				{
					name = attrs["name"].ToString();
				}
						
				xs_complex_type = new XsComplexType(name, ns, defNs, is_global);
						
				if (is_global)
				{
					if (name == "")
					{
						error = "Detected global complex type without a name " + "attribute in response schema";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
								
						return ;
					}
							
					((TpNamespace)this.mNamespaces[ns]).AddType( current_location, xs_complex_type );									
				}
				else
				{
					//TODO correct?
					((XsElementDecl)r_current_object).SetType(xs_complex_type);
							
					TpLog.debug("Setting type of current object");
				}
						
				this.mObjects[num_objects] = xs_complex_type;
						
				TpLog.debug("Changing current object to a complex type");
			}
				// SIMPLE TYPE
			else if (Utility.StringSupport.StringCompare(name, "simpletype", false) == 0)
			{
				is_global = (in_tags[depth - 2].ToString().ToLower() == "schema");
						
				name = "";
						
				if (attrs["name"] != null && attrs["name"].ToString() != "")
				{
					name = attrs["name"].ToString();
				}
						
				xs_simple_type = new XsSimpleType(name, ns, defNs, is_global);
						
				if (is_global)
				{
					if (name == "")
					{
						error = "Detected global simple type without a name " + "attribute in \"" + current_location + "\"";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
								
						return ;
					}
							
					((TpNamespace)this.mNamespaces[ns]).AddType( current_location, xs_simple_type );										
				}
				else
				{
					XsAttributeDecl ad = null;
					if (r_current_object is XsAttributeDecl) ad = (XsAttributeDecl)r_current_object;
					else if (r_current_object is XsAttributeUse) ad = ((XsAttributeUse)r_current_object).GetDecl();
					if (ad != null) ad.SetType(xs_simple_type);
							
					TpLog.debug("Setting type of current object");
				}
						
				this.mObjects[num_objects] = xs_simple_type;
						
				TpLog.debug("Changing current object to a simple type");
			}
				// ATTRIBUTE
			else if (Utility.StringSupport.StringCompare(name, "attribute", false) == 0)
			{
				is_global = (in_tags[depth - 2].ToString().ToLower() == "schema");
						
				if (attrs["ref"] != null && attrs["ref"].ToString() != "")
				{
					if (is_global)
					{
						this.mIgnoreNode = node_path;
								
						error = "Detected global attribute declaration with \"ref\" " + "attribute in \"" + current_location + "\"";
						new TpDiagnostics().Append(TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR);
								
						return ;
					}
							
					xs_attribute_declaration = new XsAttributeDecl(null, ns, defNs, false);
				}
				else
				{
					name = "";
							
					if (attrs["name"] != null && attrs["name"].ToString() != "")
					{
						name = attrs["name"].ToString();
					}
							
					xs_attribute_declaration = new XsAttributeDecl(name, ns, defNs, is_global);
							
					if (is_global)
					{
						if (name == "")
						{
							this.mIgnoreNode = node_path;
									
							error = "Detected global attribute declaration without a " + "name attribute in \"" + current_location + "\"";
							new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
									
							return ;
						}
					}
				}
						
				if (is_global)
				{
					xs_attribute_declaration.SetProperties(attrs);
							
					((TpNamespace)this.mNamespaces[ns]).AddAttributeDecl( current_location, xs_attribute_declaration );
							
					this.mObjects[num_objects] = xs_attribute_declaration;
				}
				else
				{
					xs_attribute_use = new XsAttributeUse(xs_attribute_declaration);
							
					xs_attribute_use.SetProperties(attrs);
							
					((XsComplexType)r_current_object).AddDeclaredAttributeUse(xs_attribute_use);
							
					this.mObjects[num_objects] = xs_attribute_use;
				}
						
				//TOSO g_dlog.debug("Changing current object to an attribute");
			}
				// MODEL GROUP ( SEQUENCE, ALL, CHOICE )
			else if (Utility.StringSupport.StringCompare(name, "sequence", false) == 0 || Utility.StringSupport.StringCompare(name, "all", false) == 0 || Utility.StringSupport.StringCompare(name, "choice", false) == 0)
			{
				xs_model_group = new XsModelGroup(name.ToLower());
						
				if (attrs["minOccurs"] != null && attrs["minOccurs"].ToString() != "")
				{
					xs_model_group.SetMinOccurs(Utility.TypeSupport.ToInt32(attrs["minOccurs"]));
				}
						
				if (attrs["maxOccurs"] != null && attrs["maxOccurs"].ToString() != "")
				{
					xs_model_group.SetMaxOccurs(Utility.TypeSupport.ToInt32(attrs["maxOccurs"].ToString()));
				}
						
				if (in_tags[depth - 2].ToString().ToLower() == "complextype")
				{
					TpLog.debug("Adding content type \"" + name + "\" to current object");
							
					((XsComplexType)r_current_object).AddContentType(xs_model_group);
				}
				else
				{
					if (new Utility.OrderedMap("sequence", "all", "choice").Search(in_tags[depth - 2]) != null)
					{
						TpLog.debug("Adding particle \"" + name + "\" to current object");
								
						((XsModelGroup)r_current_object).AddParticle(xs_model_group);
					}
					else
					{
						error = "Container \"" + Utility.TypeSupport.ToString(in_tags[depth - 2]) + "\" does not " + "expect model group \"" + name + "\" in schema \"" + current_location + "\" (" + Utility.StringSupport.Join("/", in_tags) + ")";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
								
						return ;
					}
				}
						
				this.mObjects[num_objects] = xs_model_group;
						
				TpLog.debug("Changing current object to a model group");
			}
				// ANNOTATION
			else if (Utility.StringSupport.StringCompare(name, "annotation", false) == 0)
			{
				// ignore annotations
				this.mIgnoreNode = node_path;
						
				return ;
			}				
				// COMPLEX CONTENT
			else if ( Utility.StringSupport.StringCompare(name, "complexcontent", false) == 0)
			{
				if ( in_tags[depth-2].ToString() != "complextype" )
				{
					this.mIgnoreNode = node_path;

					error = "XML Schema 'complexContent' can only be used by complex types. " + 
						"Ignoring wrong usage by " + in_tags[depth-2].ToString();
					new TpDiagnostics().Append( TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR );

					return;
				}

				((XsComplexType)r_current_object).SetSimpleTypeDerivation( false );
			}
				// SIMPLE CONTENT
			else if ( Utility.StringSupport.StringCompare(name, "simplecontent", false) == 0 )
				
			{
				if ( in_tags[depth-2].ToString() != "complextype" )
				{
					this.mIgnoreNode = node_path;

					error = "XML Schema 'simpleContent' can only be used by complex types. " + 
						"Ignoring wrong usage by " + in_tags[depth-2].ToString();
					new TpDiagnostics().Append( TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR );

					return;
				}

				((XsComplexType)r_current_object).SetSimpleTypeDerivation( true );
			}
				//ANY
			else if ( Utility.StringSupport.StringCompare(name, "any", false) == 0 )
			{				
				TpLog.debug("XML Any element.");
						
				xs_element_decl = new XsElementDecl(name, ns, defNs, false);
				xs_element_decl.SetProperties(attrs);
				xs_element_decl.SetType("string"); //just treat as a string
				
				((XsModelGroup)r_current_object).AddParticle(xs_element_decl);

				this.mObjects[num_objects] = xs_element_decl;
			}
				// RESTRICTION
			else if (Utility.StringSupport.StringCompare(name, "restriction", false) == 0)
			{
				// ignore restrictions
				this.mIgnoreNode = node_path;
						
				if (TpConfigManager._DEBUG)
				{
					msg = "XML Schema construct \"restriction\" not supported. " + "Ignoring statement at node \"" + node_path + "\" in \"" + current_location + "\"";
							
					new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_SCHEMA_COMPONENT, msg, TpConfigManager.DIAG_WARN);
				}
				else
				{
					this.AddUnsupportedConstruct(current_location, "restriction");
				}
						
				return ;
			}
				// EXTENSION
			else if (Utility.StringSupport.StringCompare(name, "extension", false) == 0)
			{            
				if ( in_tags[depth-2].ToString().ToLower() == "complexContent" ||
					in_tags[depth-2].ToString().ToLower() == "simpleContent" ) 
				{
					this.mIgnoreNode = node_path;

					error = "XML Schema 'extension' can only be used inside 'simpleContent' or 'complexContent' " + 
						"Ignoring wrong usage by " + in_tags[depth-2].ToString();

					new TpDiagnostics().Append( TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR );

					return;
				}

				if ( attrs["base"] == null )
				{
					this.mIgnoreNode = node_path;

					error = "Detected 'extension' without 'base' attribute in " + current_location;
					new TpDiagnostics().Append( TpConfigManager.DC_RESPONSE_STRUCTURE_ISSUE, error, TpConfigManager.DIAG_ERROR );

					return;
				}

				((XsType)r_current_object).BaseType = attrs["base"].ToString();
				((XsType)r_current_object).DerivationMethod = "extension";
			}
				// UNION
			else if (Utility.StringSupport.StringCompare(name, "union", false) == 0)
			{
				this.mIgnoreNode = node_path;
						
				// ignore union
				if (TpConfigManager._DEBUG)
				{
					msg = "XML Schema construct \"union\" not supported. " + "Ignoring statement at node \"" + node_path + "\" in \"" + current_location + "\"";
							
					new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_SCHEMA_COMPONENT, msg, TpConfigManager.DIAG_WARN);
				}
				else
				{
					this.AddUnsupportedConstruct(current_location, "union");
				}
						
				return ;
			}
			else
			{
				this.mIgnoreNode = node_path;
						
				if (TpConfigManager._DEBUG)
				{
					error = "Unknown schema component \"" + node_path + "\" in \"" + current_location + "\"";
					new TpDiagnostics().Append(TpConfigManager.DC_UNSUPPORTED_SCHEMA_COMPONENT, error, TpConfigManager.DIAG_WARN);
				}
				else
				{
					this.AddUnsupportedConstruct(current_location, name);
				}
						
				return ;
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			//global $g_dlog
			string name;
			int parse_step;
			string node_path;
			object x;
			
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.LocalName).ToLower();
			
			parse_step = Utility.OrderedMap.CountElements(this.mInTagsStack);
			
			node_path = Utility.StringSupport.Join("/", (Utility.OrderedMap)this.mInTagsStack[parse_step - 1]);
			
			TpLog.debug("Ending element " + node_path);
			
			if (this.mIgnoreNode != "" && this.mIgnoreNode != null)
			{
				TpLog.debug("Ignoring end node");
				
				if (this.mIgnoreNode == node_path)
				{
					this.mIgnoreNode = "";
				}
				
				((Utility.OrderedMap)this.mInTagsStack[parse_step - 1]).Pop();
				
				return ;
			}
			
			if (reader.XmlReader.LocalName.ToLower() == "element" || 
				reader.XmlReader.LocalName.ToLower() == "attribute" || 
				reader.XmlReader.LocalName.ToLower() == "complextype" || 
				reader.XmlReader.LocalName.ToLower() == "simpletype" || 
				reader.XmlReader.LocalName.ToLower() == "sequence" || 
				reader.XmlReader.LocalName.ToLower() == "all" || 
				reader.XmlReader.LocalName.ToLower() == "choice" )
			{
				x = this.mObjects.Pop();
				
				TpLog.debug("Popping class " + x.GetType().Name);
			}
			else if (reader.XmlReader.LocalName.ToLower() == "schema")
			{
				bool wasInc = false;
				if (mIncludeStack.Count > 0) wasInc = (bool)this.mIncludeStack.End();
				if (!wasInc)
				{
					this.mTargetNamespaces.Pop();
				}
			}
			
			((Utility.OrderedMap)this.mInTagsStack[parse_step - 1]).Pop();
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			
		}// end of member function CharacterData
		
		public virtual void  AddUnsupportedConstruct(string schema, string construct)
		{
			if (!(this.mUnsupportedConstructs[construct] != null))
			{
				this.mUnsupportedConstructs[construct] = new Utility.OrderedMap();
			}
			
			if (((Utility.OrderedMap)this.mUnsupportedConstructs[construct]).Search(schema) == null 
				&& schema != null)
			{
				((Utility.OrderedMap)this.mUnsupportedConstructs[construct]).Push(schema);
			}
		}// end of member function AddUnsupportedConstruct
		
		public virtual Utility.OrderedMap GetUnsupportedConstructs()
		{
			return this.mUnsupportedConstructs;
		}// end of member function GetUnsupportedConstructs
		
		public virtual object GetLocation(string ns)
		{
			if (ns == null)
			{
				ns = this.mTargetNamespace;
			}
			
			if (this.mNamespaces[ns] != null)
			{            
				return ((TpNamespace)this.mNamespaces[ns]).GetFirstLocation();				
			}
			
			return null;
		}// end of member function GetLocation
		
		public virtual string GetTargetNamespace()
		{
			return this.mTargetNamespace;
		}// end of member function GetTargetNamespace
		
		public virtual string GetPrefix(string ns)
		{
			return mReader.GetPrefix(ns);
		}// end of member function GetPrefix
		
		public virtual Utility.OrderedMap GetImportedNamespaces()
		{
			Utility.OrderedMap namespaces = new Utility.OrderedMap();
			string prefix;
			
			int i = 0;
			
			foreach ( TpNamespace ns in this.mNamespaces.Values ) 
			{
				string nsLoc = ns.GetFirstLocation();
				// Skip first (target)
				if (i > 0)
				{
					prefix = ns.GetPrefix(); // this.GetPrefix(ns);
					
					namespaces[prefix] = nsLoc;
				}
				
				++i;
			}
			
			
			return namespaces;
		}// end of member function GetImportedNamespaces
		
		public virtual Utility.OrderedMap GetElementDecls(string ns)
		{        
			if (ns == null)
			{
				ns = this.mTargetNamespace;
			}
			
			if (this.mNamespaces[ns] != null)
			{
				return ((TpNamespace)this.mNamespaces[ns]).GetElementDecls();
			}
			
			return new Utility.OrderedMap();
		}// end of member function GetElementDecls
		
		public virtual object GetAttributeDecls(string ns)
		{
			if (ns == null)
			{
				ns = this.mTargetNamespace;
			}
			
			return ((TpNamespace)this.mNamespaces[ns]).GetAttributeDecls();
		}// end of member function GetAttributeDecls
		
		public virtual object GetElementDecl(string ns, string name)
		{
			Utility.OrderedMap parsed_name;
			string prefix;
			string local_name;
			
			parsed_name = new Utility.OrderedMap(name.Split(":".ToCharArray()));
			
			if (Utility.OrderedMap.CountElements(parsed_name) == 2)
			{
				prefix = parsed_name[0].ToString();
				
				local_name = Utility.TypeSupport.ToString(parsed_name[1]);
                ns = GetNamespace(prefix);                
			}
			else
			{
				local_name = name;
				
				if (ns == null)
				{
					ns = this.mTargetNamespace;
				}
			}
			
			if (((TpNamespace)this.mNamespaces[ns]).GetElementDecl(local_name) != null)
			{
				return ((TpNamespace)this.mNamespaces[ns]).GetElementDecl(local_name);
			}
			
			return null;
		}// end of member function GetElementDecl
		
		public virtual object GetAttributeDecl(string ns, string name)
		{
			Utility.OrderedMap parsed_name;
			string prefix;
			string local_name;
			
			parsed_name = new Utility.OrderedMap(name.Split(":".ToCharArray()));
			
			if (Utility.OrderedMap.CountElements(parsed_name) == 2)
			{
				prefix = parsed_name[0].ToString();
				
				local_name = parsed_name[1].ToString();
				ns = GetNamespace(prefix);
			}
			else
			{
				local_name = name;
				
				if (ns == null)
				{
					ns = this.mTargetNamespace;
				}
			}
			
			if (((TpNamespace)this.mNamespaces[ns]).GetAttributeDecl(local_name) != null)
			{
				return ((TpNamespace)this.mNamespaces[ns]).GetAttributeDecl(local_name);
			}
			
			return null;
		}// end of member function GetAttributeDecl
		
		public virtual object GetType(string ns, string name)
		{
			Utility.OrderedMap parsed_name;
			string prefix;
			string local_name;
			string uri;
			bool is_global;
			XsSimpleType xs_simple_type;
			string error;
			XsSimpleType type;

			parsed_name = new Utility.OrderedMap(name.Split(":".ToCharArray()));
			
			if (Utility.OrderedMap.CountElements(parsed_name) == 2)
			{
				// External reference
				
				prefix = parsed_name[0].ToString();
				
				local_name = parsed_name[1].ToString();
				
				uri = GetNamespace(prefix);				
			}
			else
			{
				// Reference to global definition
				if (ns == "")
				{
					uri = this.mTargetNamespace;
				}
				else
				{
					uri = ns;
				}
				
				local_name = name;
			}
			
			if (uri == "http://www.w3.org/2001/XMLSchema")
			{
				// XML Schema types
					
				is_global = true;
					
				xs_simple_type = new XsSimpleType(local_name, uri, uri, is_global);
					
				return xs_simple_type;
					
				// TODO: create simple types for each one, with
				//       specific data validation
				//if ( $local_name == 'string' ) 
				//{
				//return new XsStringType( $local_name, $uri, true );
				//}
				//else if ( $local_name == 'int' ) 
				//{
				//return new XsIntType( $local_name, $uri, true );
				//}
			}

			if (((TpNamespace)this.mNamespaces[uri]).GetType(local_name) != null)
			{
				return ((TpNamespace)this.mNamespaces[uri]).GetType(local_name);
			}
			
			error = "Unknown type \"" + name + "\"";
			new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
			
			type = null;
			
			return type;
		}// end of member function GetType
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mNamespaces", "mTargetNamespace");
		}// end of member function __sleep
	}
}
