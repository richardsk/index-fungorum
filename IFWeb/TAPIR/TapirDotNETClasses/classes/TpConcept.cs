namespace TapirDotNET 
{

	public class TpConcept
	{
		public string mId;
		public string mName;
		public bool mRequired = false;	// This comes from the conceptual schema and it indicates
										// if the concept should be mapped or not. It has nothing
										// to do with the "required" attribute of TAPIR 
										// capabilities responses which is intended to indicate
										// if the concept should be present in output models.
		public bool mSearchable = true;
		public TpConceptMapping mMapping;
		public string mType;
		public string mDocumentation;
		
		public TpConcept()
		{
			
		}

		public override string ToString()
		{
			return mId;
		}
		
		
		public virtual void  SetId(string id)
		{
			this.mId = id;
		}// end of member function SetId
		
		public virtual string GetId()
		{
			return this.mId;
		}// end of member function GetId
		
		public virtual void  SetName(string name)
		{
			this.mName = name;
		}// end of member function SetName
		
		public virtual string GetName()
		{
			return (Utility.VariableSupport.Empty(this.mName))?this.mId:this.mName;
		}// end of member function GetName
		
		public virtual void  SetType(string type)
		{
			this.mType = type;
		}// end of member function SetType
		
		public new string GetType()
		{
			return this.mType;
		}// end of member function GetType
		
		public virtual void  SetRequired(bool required)
		{
			this.mRequired = required;
		}// end of member function SetRequired
		
		public virtual bool IsRequired()
		{
			return this.mRequired;
		}// end of member function IsRequired
		
		public virtual void  SetSearchable(bool searchable)
		{
			this.mSearchable = searchable;
		}// end of member function SetSearchable
		
		public virtual bool IsSearchable()
		{
			return this.mSearchable;
		}// end of member function IsSearchable
		
		public virtual void  SetDocumentation(string doc)
		{
			this.mDocumentation = doc;
		}// end of member function SetDocumentation
		
		public virtual string GetDocumentation()
		{
			return this.mDocumentation;
		}// end of member function GetDocumentation
		
		public virtual bool IsMapped()
		{
			if (this.mMapping == null)
			{
				return false;
			}
			else
			{
				return this.mMapping.IsMapped();
			}
		}// end of member function IsMapped
		
		public virtual void  SetMapping(TpConceptMapping mapping)
		{
			//TODO Copy?
			this.mMapping = mapping;// work on a copy!
			
			if (mapping != null)
			{
				this.mMapping.SetConcept(this);
			}
		}// end of member function SetMapping
		
		public virtual TpConceptMapping GetMapping()
		{
			// Just in case, set the concept
			// (property mConcept is not serialized in concept mappings to 
			//  avoid recursion problems)
			if (this.mMapping != null)
			{
				this.mMapping.SetConcept(this);
			}
			
			return this.mMapping;
		}// end of member function GetMapping
		
		public virtual string GetMappingType()
		{
			if (this.mMapping != null)
			{
				return this.mMapping.GetMappingType();
			}
			
			return "unmapped";
		}// end of member function GetMappingType
		
		public virtual string GetMappingHtml()
		{
			if (this.mMapping != null)
			{
				return this.mMapping.GetHtml();
			}
			
			return "";
		}// end of member function GetMappingHtml
		
		public virtual string GetConfigXml()
		{
			string required;
			string searchable;
			string type_str;
			string doc_str;
			string xml;
			object mapping;
			required = (this.IsRequired())?"true":"false";
			searchable = (this.IsSearchable())?"true":"false";
			
			type_str = "";
			
			if (this.mType != "")
			{
				type_str = "type=\"" + this.mType + "\" ";
			}
			
			doc_str = "";
			
			if (this.mDocumentation != null)
			{
				doc_str = "documentation=\"" + TpUtils.EscapeXmlSpecialChars(this.mDocumentation) + "\" ";
			}
			
			xml = "\t\t\t";
			xml += "<concept id=\"" + TpUtils.EscapeXmlSpecialChars(this.GetId().ToString()) + "\" " + "name=\"" + TpUtils.EscapeXmlSpecialChars(this.GetName().ToString()) + "\" " + type_str + doc_str + "required=\"" + required + "\" " + "searchable=\"" + searchable + "\">" + "\n";
			
			if (this.IsMapped())
			{
				mapping = this.GetMapping();
				
				xml = xml + ((TpConceptMapping)mapping).GetXml();
			}
			
			xml += "\t\t\t</concept>\n";
			
			return xml;
		}// end of member function GetConfigXml
		
		public virtual string GetCapabilitiesXml()
		{
			string searchable;
			string xml;
			searchable = (this.IsSearchable())?"true":"false";
			
			xml = "\t\t\t";
			xml += "<mappedConcept searchable=\"" + searchable + "\">" + TpUtils.EscapeXmlSpecialChars(Utility.TypeSupport.ToString(this.GetId())) + "</mappedConcept>\n";
			
			return xml;
		}// end of member function GetCapabilitiesXml
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mId", "mName", "mType", "mRequired", "mSearchable", "mDocumentation", "mMapping");
		}// end of member function __sleep
	}
}
