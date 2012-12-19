namespace TapirDotNET 
{

	public class TpConceptualSchema
	{
		public string mAlias;
		public string mNamespace;
		public string mLocation;
		public Utility.OrderedMap mConcepts = new Utility.OrderedMap();
		public string mSchemaHandler;
		
		public TpConceptualSchema()
		{
			
		}
		
		
		public virtual bool IsMapped(bool setErrors)
		{
			bool ret_val;
			string error;
			ret_val = true;
			
			foreach ( TpConcept concept in this.mConcepts.Values ) 
			{
				if (concept.IsRequired() && !concept.IsMapped())
				{
					if (setErrors)
					{
						error = "Concept \"" + concept.GetName().ToString() + "\" was not mapped!";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					}
					
					ret_val = false;
				}
			}
			
			
			return ret_val;
		}// end of member function IsMapped
		
		public virtual void  SetHandler(string handlerId)
		{
			this.mSchemaHandler = handlerId;
		}// end of member function SetHandler
		
		public virtual void  SetAlias(string alias)
		{
			this.mAlias = alias;
		}// end of member function SetAlias
		
		public virtual string GetAlias()
		{
			return (this.mAlias != null) ? this.mAlias : this.mNamespace;
		}// end of member function GetAlias
		
		public virtual void  SetNamespace(string namespace_Renamed)
		{
			this.mNamespace = namespace_Renamed;
		}// end of member function SetNamespace
		
		public virtual string GetNamespace()
		{
			return this.mNamespace;
		}// end of member function GetNamespace
		
		public virtual void  SetLocation(string location)
		{
			this.mLocation = location;
		}// end of member function SetLocation
		
		public virtual string GetLocation()
		{
			return this.mLocation;
		}// end of member function GetLocation
		
		public virtual void  AddConcept(TpConcept concept)
		{
			this.mConcepts[concept.GetId()] = concept;
		}// end of member function AddConcept
		
		public virtual Utility.OrderedMap GetConcepts()
		{
			return this.mConcepts;
		}// end of member function GetConcepts
		
		public virtual bool FetchConcepts()
		{
			string error;
			object handler;
			if (this.mSchemaHandler == "")
			{
				error = "Schema has no associated schema handler!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			handler = new TpConceptualSchemaHandlerFactory().GetInstance(this.mSchemaHandler);
			
			if (handler == null)
			{
				error = "Could not instantiate schema handler \"" + this.mSchemaHandler + "\"";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			return ((TpConceptualSchemaHandler)handler).Load(this);
		}// end of member function FetchConcepts
		
		public virtual string GetConfigXml()
		{
			string xml;
			xml = "\t\t";
			xml += "<schema namespace=\"" + TpUtils.EscapeXmlSpecialChars(this.mNamespace) + "\" " + "location=\"" + TpUtils.EscapeXmlSpecialChars(Utility.TypeSupport.ToString(this.GetLocation())) + "\" " + "alias=\"" + TpUtils.EscapeXmlSpecialChars(this.GetAlias()) + "\" " + "handler=\"" + TpUtils.EscapeXmlSpecialChars(this.mSchemaHandler) + "\">" + "\n";
			
			foreach ( string id in this.mConcepts.Keys ) 
			{
				TpConcept concept = (TpConcept)this.mConcepts[id];
				xml = xml + concept.GetConfigXml();
			}
			
			
			xml += "\t\t</schema>\n";
			
			return xml;
		}// end of member function GetConfigXml
		
		public virtual string GetCapabilitiesXml()
		{
			string xml;
			xml = "\t\t";
			xml += "<schema namespace=\"" + TpUtils.EscapeXmlSpecialChars(this.mNamespace) + "\" " + "location=\"" + TpUtils.EscapeXmlSpecialChars(Utility.TypeSupport.ToString(this.GetLocation())) + "\">" + "\n";
			
			foreach ( string id in this.mConcepts.Keys ) 
			{
				TpConcept concept = (TpConcept)this.mConcepts[id];
				if (concept.IsMapped())
				{
					xml = xml + concept.GetCapabilitiesXml();
				}
			}
			
			
			xml += "\t\t</schema>\n";
			
			return xml;
		}// end of member function GetCapabilitiesXml
		
		public void Reset( ) 
		{
			this.mConcepts = new Utility.OrderedMap();
		} // end of member function Reset

		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mAlias", "mNamespace", "mLocation", "mConcepts", "mSchemaHandler");
		}// end of member function __sleep
	}
}
