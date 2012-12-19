using System;
using System.Xml;
using System.Net;

namespace TapirDotNET 
{

	public class DarwinSchemaHandler_v2:TpConceptualSchemaHandler
	{
		public TpConceptualSchema mConceptualSchema;
		public string mXmlSchemaNs = "http://www.w3.org/2001/XMLSchema";
		public string mDarwinElementPrefix = "?";
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public Utility.OrderedMap mNamespaces = new Utility.OrderedMap();
		public bool mInterrupt = false;
		public TpConcept mConcept;
		public string mXmlSchemaPrefix = "http://www.w3.org/2001/XMLSchema";
		
		public DarwinSchemaHandler_v2()
		{
			
		}
		
		
		public override bool Load(TpConceptualSchema conceptualSchema)
		{
			string file = conceptualSchema.GetLocation();
			string error = "";

			this.mConceptualSchema = conceptualSchema;
			
			try
			{
				string xml = "";

				//if file is a url then get file first
				if (file.IndexOf("://") != -1)
				{
					WebRequest r = FileWebRequest.Create(file);
					if ( TpConfigManager.TP_WEB_PROXY.Length > 0 )
					{
						r.Proxy = new WebProxy(TpConfigManager.TP_WEB_PROXY);
					}

					WebResponse resp = r.GetResponse();
					System.IO.StreamReader srdr = new System.IO.StreamReader(resp.GetResponseStream());
					xml = srdr.ReadToEnd();
					srdr.Close();
				}
				else
				{
					System.IO.StreamReader srdr = new System.IO.StreamReader(file);
					xml = srdr.ReadToEnd();
					srdr.Close();
				}

				TpXmlReader rdr = new TpXmlReader();
				rdr.StartElementHandler = new StartElement(this.StartElement);
				rdr.EndElementHandler = new EndElement(this.EndElement);
								
				try
				{
					rdr.ReadXmlStr(xml);
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file: " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			catch(Exception ex)
			{
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, ex.Message, TpConfigManager.DIAG_ERROR);
			}
			
			return true;
		}// end of member function Load
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			int depth;
			string remoteNamespace;
			string expectedNamespace;
			string error;
			if (this.mInterrupt)
			{
				return ;
			}
			
			this.mInTags.Push(reader.XmlReader.Name);
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			// Schema root element
			if (depth == 1)
			{
				for ( int i = 0; i < attrs.Count; i++)
				{
					string attr_name = attrs.GetEntryAt(i).Key.ToString();
					object attr_val = attrs[attr_name];
					if (attr_val.ToString() == "http://www.w3.org/2001/XMLSchema")
					{
						this.mXmlSchemaPrefix = attr_name.Substring(attr_name.IndexOf(":") + 1);
					}
					if (attr_val.ToString() == "http://rs.tdwg.org/dwc/dwelement")
					{
						this.mDarwinElementPrefix = attr_name.Substring(attr_name.IndexOf(":") + 1);
					}
				}
				
				
				remoteNamespace = attrs["targetNamespace"].ToString();
				expectedNamespace = this.mConceptualSchema.GetNamespace();
				
				if (expectedNamespace == null)
				{
					// Incorporate the namespace if object has no ns defined
					this.mConceptualSchema.SetNamespace(remoteNamespace);
				}
				else
				{
					if (expectedNamespace != remoteNamespace)
					{
						// Check if namespaces match
						error = string.Format("Remote schema targetNamespace ({0}) does not " + "match the expected namespace ({1})!", remoteNamespace, expectedNamespace);
						new TpDiagnostics().Append(TpConfigManager.DC_XML_PARSE_ERROR, error, TpConfigManager.DIAG_ERROR);
						
						this.mInterrupt = true;
						this.mInTags = new Utility.OrderedMap();
						this.mNamespaces = new Utility.OrderedMap();
						this.mDarwinElementPrefix = "?";
					}
				}
			}
			// Global elements are potential concept candidates
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, this.mXmlSchemaPrefix + ":element", false) == 0 && depth == 2)
				{
					// If there is a substitutionGroup attribute pointing to 
					// a darwin element, then it is a concept
					if (attrs["substitutionGroup"] != null && attrs["substitutionGroup"].ToString() == this.mDarwinElementPrefix + ":dwElement")
					{
						this.PrepareConcept(attrs);
					}
				}
				else
				{
					if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, this.mXmlSchemaPrefix + ":documentation", false) == 0 && this.mConcept != null && attrs["source"] != null)
					{
						// Add documentation to the concept
						this.mConcept.SetDocumentation(attrs["source"].ToString());
					}
				}
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			if (this.mInterrupt)
			{
				return ;
			}
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, this.mXmlSchemaPrefix + ":element", false) == 0 && this.mConcept != null)
			{
				// Assuming that if this is closing an element tag and there is
				// a pending concept, then it is time to add the concept
				
				this.mConceptualSchema.AddConcept(this.mConcept);
				
				this.mConcept = null;
			}
			
			this.mInTags.Pop();
		}// end of member function EndElement
		
		public virtual void  PrepareConcept(Utility.OrderedMap attrs)
		{
			string error;
			string local_name;
			string ns;
			string id;
			bool required;
			string type;
			Utility.OrderedMap parts;
			string prefix;
			string type_name;
			
			if (attrs["name"] == null)
			{
				error = "Could not add concept without a \"name\" attribute. " + "Did you use \"ref\"? DarwinSchemaHandler is not prepared " + "to understand referenced concepts...";
				new TpDiagnostics().Append(TpConfigManager.DC_XML_PARSE_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return ;
			}
			
			local_name = attrs["name"].ToString();
			
			ns = this.mConceptualSchema.GetNamespace();
			
			id = ns + local_name;
			
			required = true;
			
			if (attrs["nillable"] != null && attrs["nillable"].ToString() == "true")
			{
				required = false;
			}
			
			type = "";
			
			if (attrs["type"] != null)
			{
				type = attrs["type"].ToString();
				
				// Try to get the fully qualified type, but only from the type attribute
				parts = new Utility.OrderedMap(type.Split(":".ToCharArray()));
				
				if (Utility.OrderedMap.CountElements(parts) == 2)
				{
					prefix = parts[0].ToString();
					type_name = parts[1].ToString();
					
					if (this.mNamespaces[prefix] != null)
					{
						type = this.mNamespaces[prefix].ToString() + ":" + type_name;
					}
				}
			}
			
			this.mConcept = new TpConcept();
			this.mConcept.SetId(id);
			this.mConcept.SetName(local_name);
			this.mConcept.SetRequired(required);
			this.mConcept.SetType(type);
		}// end of member function AddConcept
	}
}
