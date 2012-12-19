namespace TapirDotNET 
{

	public class TpContact:TpBusinessObject
	{
		public string mFullName = "";
		public Utility.OrderedMap mTitles;
		public object mTelephone;
		public string mEmail = "";
		
		public TpContact() : base()
		{
			this.mTitles = new Utility.OrderedMap();
		}
		
		
		public virtual void  LoadDefaults()
		{
			this.AddTitle("", "");
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession(string prefix)
		{
			this.mFullName = TpUtils.FindVar(":" + prefix + "_fullname", "").ToString();
			
			this.LoadLangElementFromSession(prefix + "_title", this.mTitles);
			
			this.mTelephone = TpUtils.FindVar(prefix + "_telephone", "");
			
			this.mEmail = TpUtils.FindVar(prefix + "_email", "").ToString();
		}// end of member function LoadFromSession
		
		public virtual void  AddTitle(string title, string lang)
		{
			this.mTitles.Push(new TpLangString(title, lang));
		}// end of member function AddTitle
		
		public virtual string GetFullName()
		{
			return this.mFullName;
		}// end of member function GetFullName
		
		public virtual void  SetFullName(string name)
		{
			this.mFullName = (name == null ? "" : name);
		}// end of member function SetFullName
		
		public virtual object GetTelephone()
		{
			return this.mTelephone;
		}// end of member function GetTelephone
		
		public virtual void  SetTelephone(object tel)
		{
			this.mTelephone = tel;
		}// end of member function SetTelephone
		
		public virtual string GetEmail()
		{
			return this.mEmail;
		}// end of member function GetEmail
		
		public virtual void  SetEmail(string email)
		{
			this.mEmail = (email == null ? "" : email);
		}// end of member function SetEmail
		
		public virtual Utility.OrderedMap GetTitles()
		{
			return this.mTitles;
		}// end of member function GetTitles
		
		public virtual bool Validate(bool raiseErrors, object defaultLang)
		{
			bool ret_val;
			string error;
			ret_val = true;
			
			// Validate full name
			if (this.mFullName.Length == 0)
			{
				if (raiseErrors)
				{
					error = "At least one of the contacts has no name!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate email
			if (this.mEmail.Length == 0)
			{
				if (raiseErrors)
				{
					error = "At least one of the contacts has no e-mail!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate titles
			if (!new TpConfigUtils().ValidateLangSection("Contact Title", this.mTitles, raiseErrors, false, defaultLang))
			{
				ret_val = false;
			}
			
			return ret_val;
		}// end of member function validate
		
		public virtual string GetXml(string offset, string indentWith)
		{
			string indent;
			string xml;
			indent = offset + indentWith;
			
			xml = TpUtils.OpenTag(TpConfigManager.TP_VCARD_PREFIX, "VCARD", offset, new Utility.OrderedMap());
			
			xml += TpUtils.MakeTag(TpConfigManager.TP_VCARD_PREFIX, "FN", this.mFullName, indent, new Utility.OrderedMap());
			
			foreach ( TpLangString lang_string in this.mTitles.Values ) 
			{
				xml += TpUtils.MakeLangTag(TpConfigManager.TP_VCARD_PREFIX, "TITLE", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent);
			}
			
			
			if (!Utility.VariableSupport.Empty(this.mTelephone))
			{
				xml += TpUtils.MakeTag(TpConfigManager.TP_VCARD_PREFIX, "TEL", this.mTelephone.ToString(), indent, new Utility.OrderedMap());
			}
			
			xml += TpUtils.MakeTag(TpConfigManager.TP_VCARD_PREFIX, "EMAIL", this.mEmail, indent, new Utility.OrderedMap());
			
			xml += TpUtils.CloseTag(TpConfigManager.TP_VCARD_PREFIX, "VCARD", offset);
			
			return xml;
		}// end of member function GetXml
	}
}
