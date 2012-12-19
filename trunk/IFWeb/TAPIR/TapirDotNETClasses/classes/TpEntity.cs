using System.Web;

namespace TapirDotNET 
{

	public class TpEntity:TpBusinessObject
	{
		public string mIdentifier = "";
		public Utility.OrderedMap mNames;
		public string mAcronym = "";
		public string mLogoUrl = "";
		public Utility.OrderedMap mDescriptions;
		public string mRelatedInformation;
		public Utility.OrderedMap mRelatedContacts;
		public string mLatitude = "";
		public string mLongitude = "";
		public string mAddress = "";
		
		public TpEntity() : base()
		{
			this.mNames = new Utility.OrderedMap();
			this.mDescriptions = new Utility.OrderedMap();
			this.mRelatedContacts = new Utility.OrderedMap();
		}
		
		
		public virtual void  LoadDefaults()
		{
			TpRelatedContact related_contact;
			TpContact contact;
			this.AddName("", "");
			this.AddDescription("", "");
			
			related_contact = new TpRelatedContact();
			contact = new TpContact();
			contact.LoadDefaults();
			related_contact.SetContact(contact);
			this.AddRelatedContact(related_contact);
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession(string prefix)
		{
			this.mIdentifier = TpUtils.FindVar(":" + prefix + "_id", "").ToString();
			
			this.LoadLangElementFromSession(prefix + "_name", this.mNames);
			
			this.mAcronym = TpUtils.FindVar(":" + prefix + "_acronym", "").ToString();
			
			this.LoadLangElementFromSession(prefix + "_description", this.mDescriptions);
			
			this.mLogoUrl = System.Web.HttpUtility.UrlDecode(TpUtils.GetVar(prefix + "_logoURL", "").ToString());
			
			this.mAddress = TpUtils.FindVar(":" + prefix + "_address", "").ToString();
			
			this.mRelatedInformation = System.Web.HttpUtility.UrlDecode(TpUtils.GetVar(prefix + "_relatedInformation", "").ToString());
			
			this.mLongitude = TpUtils.FindVar(":" + prefix + "_longitude", "").ToString();
			
			this.mLatitude = TpUtils.FindVar(":" + prefix + "_latitude", "").ToString();
			
			this.LoadRelatedContacts(prefix);
		}// end of member function LoadFromSession
		
		public virtual void  LoadRelatedContacts(string prefix)
		{
			int cnt = 1;
						
			while (HttpContext.Current.Request.Params[prefix + "_contact_" + cnt.ToString()] != null && cnt < 6)
			{
				string newprefix = prefix + "_contact_" + cnt.ToString();
				
				if (TpUtils.FindVar("del_" + newprefix, null) == null)
				{
					Utility.OrderedMap roles = new Utility.OrderedMap();
					
					int cnt2 = 1;
					
					while (cnt2 < 10)
					// Max number of roles is hard coded!
					{
						if (HttpContext.Current.Request.Params[newprefix + "_role_" + cnt2.ToString()] != null)
						{
							roles.Push(HttpContext.Current.Request.Params[newprefix + "_role_" + cnt2.ToString()]);
						}
						
						++cnt2;
					}
					
					TpRelatedContact related_contact = new TpRelatedContact();
					TpContact contact = new TpContact();
					contact.LoadFromSession(newprefix);
					related_contact.SetContact(contact);
					related_contact.SetRoles(roles);
					this.AddRelatedContact(related_contact);
				}
				++cnt;
			}

			if (HttpContext.Current.Request.Params["add_" + prefix + "_contact"] != null)
			{
				TpRelatedContact related_contact = new TpRelatedContact();
				TpContact contact = new TpContact();
				contact.LoadDefaults();
				related_contact.SetContact(contact);
				this.AddRelatedContact(related_contact);
			}
		}// end of member function LoadRelatedContacts
		
		public virtual void  AddRelatedContact(TpRelatedContact relatedContact)
		{
			this.mRelatedContacts.Push(relatedContact);
		}// end of member function AddRelatedContact
		
		public virtual void  AddName(string name, string lang)
		{
			this.mNames.Push(new TpLangString(name, lang));
		}// end of member function AddName
		
		public virtual void  AddDescription(string description, string lang)
		{
			this.mDescriptions.Push(new TpLangString(description, lang));
		}// end of member function AddDescription
		
		public virtual string GetIdentifier()
		{
			return this.mIdentifier;
		}// end of member function GetIdentifier
		
		public virtual void  SetIdentifier(string id)
		{
			this.mIdentifier = (id == null ? "" : id);
		}// end of member function SetIdentifier
		
		public virtual Utility.OrderedMap GetNames()
		{
			return this.mNames;
		}// end of member function GetNames
		
		public virtual Utility.OrderedMap GetDescriptions()
		{
			return this.mDescriptions;
		}// end of member function GetDescriptions
		
		public virtual string GetAcronym()
		{
			return this.mAcronym;
		}// end of member function GetAcronym
		
		public virtual void  SetAcronym(string acronym)
		{
			this.mAcronym = (acronym == null ? "" : acronym);
		}// end of member function SetAcronym
		
		public virtual string GetLogoUrl()
		{
			return this.mLogoUrl;
		}// end of member function GetLogoUrl
		
		public virtual void  setLogoUrl(string logo)
		{
			this.mLogoUrl = (logo == null ? "" : logo);
		}// end of member function SetLogoURL
		
		public virtual string GetAddress()
		{
			return this.mAddress;
		}// end of member function GetAddress
		
		public virtual void  SetAddress(string address)
		{
			this.mAddress = address;
		}// end of member function SetAddress
		
		public virtual string GetRelatedInformation()
		{
			return this.mRelatedInformation;
		}// end of member function GetRelatedInformation
		
		public virtual void  SetRelatedInformation(string info)
		{
			this.mRelatedInformation = info;
		}// end of member function SetRelatedInformation
		
		public virtual string GetLongitude()
		{
			return this.mLongitude;
		}// end of member function GetLongitude
		
		public virtual void  SetLongitude(string long_Renamed)
		{
			this.mLongitude = long_Renamed;
		}// end of member function SetLongitude
		
		public virtual string GetLatitude()
		{
			return this.mLatitude;
		}// end of member function GetLatitude
		
		public virtual void  SetLatitude(string lat)
		{
			this.mLatitude = lat;
		}// end of member function SetLatitude
		
		public virtual Utility.OrderedMap GetRelatedContacts()
		{
			return this.mRelatedContacts;
		}// end of member function GetRelatedContacts
		
		public virtual TpRelatedContact GetLastRelatedContact()
		{
			int cnt;
			cnt = Utility.OrderedMap.CountElements(this.mRelatedContacts);
			
			return (TpRelatedContact)this.mRelatedContacts[cnt - 1];
		}// end of member function GetLastRelatedContact
		
		public virtual bool Validate(bool raiseErrors, object defaultLang)
		{
			bool ret_val;
			string error;
			int cnt;
			ret_val = true;
			
			// Validate identifier
			if (this.mIdentifier.Length == 0)
			{
				if (raiseErrors)
				{
					error = "One of the entities has no identifier!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate names
			if (!new TpConfigUtils().ValidateLangSection("Entity Name", this.mNames, raiseErrors, true, defaultLang))
			{
				ret_val = false;
			}
			
			// Validate acronym
			if (this.mAcronym.Length == 0)
			{
				if (raiseErrors)
				{
					error = "One of the entity acronyms was not specified!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate descriptions
			if (!new TpConfigUtils().ValidateLangSection("Entity Description", this.mDescriptions, raiseErrors, false, defaultLang))
			{
				ret_val = false;
			}
			
			// Validate related contacts
			cnt = 0;
			foreach ( TpRelatedContact related_contact in this.mRelatedContacts.Values ) 
			{
				if (!related_contact.Validate(raiseErrors, defaultLang))
				{
					ret_val = false;
				}
				++cnt;
			}
			
			
			if (cnt == 0)
			{
				if (raiseErrors)
				{
					error = "All entities must have at least one contact!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			return ret_val;
		}// end of member function Validate
		
		public virtual string GetXml(string offset, string indentWith)
		{
			string indent1;
			string indent2;
			string xml;
			indent1 = offset + indentWith;
			indent2 = offset + indentWith + indentWith;
			
			xml = TpUtils.OpenTag("", "entity", offset, new Utility.OrderedMap());
			
			xml += TpUtils.MakeTag("", "identifier", this.mIdentifier, indent1, new Utility.OrderedMap());
			
			foreach ( TpLangString lang_string in this.mNames.Values ) 
			{
				xml += TpUtils.MakeLangTag("", "name", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent1);
			}
			
			
			xml += TpUtils.MakeTag("", "acronym", this.mAcronym, indent1, new Utility.OrderedMap());
			
			if (!Utility.VariableSupport.Empty(this.mLogoUrl))
			{
				xml += TpUtils.MakeTag("", "logoURL", this.mLogoUrl, indent1, new Utility.OrderedMap());
			}
			
			foreach ( TpLangString lang_string in this.mDescriptions.Values ) 
			{
				xml += TpUtils.MakeLangTag("", "description", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent1);
			}
			
			
			xml += TpUtils.MakeTag("", "address", this.mAddress, indent1, new Utility.OrderedMap());
			
			// geo:Point
			if (this.mLatitude != "" && this.mLongitude != "")
			{
				xml += TpUtils.OpenTag(TpConfigManager.TP_GEO_PREFIX, "Point", indent1, new Utility.OrderedMap());
				xml += TpUtils.MakeTag(TpConfigManager.TP_GEO_PREFIX, "lat", this.mLatitude, indent2, new Utility.OrderedMap());
				xml += TpUtils.MakeTag(TpConfigManager.TP_GEO_PREFIX, "long", this.mLongitude, indent2, new Utility.OrderedMap());
				xml += TpUtils.CloseTag(TpConfigManager.TP_GEO_PREFIX, "Point", indent1);
			}
			
			if (!Utility.VariableSupport.Empty(this.mRelatedInformation))
			{
				xml += TpUtils.MakeTag("", "relatedInformation", this.mRelatedInformation, indent1, new Utility.OrderedMap());
			}
			
			foreach ( TpRelatedContact related_contact in this.mRelatedContacts.Values ) 
			{
				xml = xml + related_contact.getXml(indent1, indentWith);
			}
			
			
			xml += TpUtils.CloseTag("", "entity", offset);
			
			return xml;
		}// end of member function getXml
	}
}
