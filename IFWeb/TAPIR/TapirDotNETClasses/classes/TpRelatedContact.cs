namespace TapirDotNET 
{

	public class TpRelatedContact:TpBusinessObject
	{
		public Utility.OrderedMap mRoles;
		public TpContact mContact;
		
		public TpRelatedContact() : base()
		{
			this.mRoles = new Utility.OrderedMap();
		}
		
		
		public virtual TpContact GetContact()
		{
			return this.mContact;
		}// end of member function GetContact
		
		public virtual void  SetContact(TpContact contact)
		{
			this.mContact = contact;
		}// end of member function SetContact
		
		public virtual Utility.OrderedMap GetRoles()
		{
			return this.mRoles;
		}// end of member function GetRoles
		
		public virtual void  SetRoles(Utility.OrderedMap roles)
		{
			this.mRoles = roles;
		}// end of member function SetRoles
		
		public virtual void  AddRole(object role)
		{
			this.mRoles.Push(role);
		}// end of member function AddRole
		
		public virtual bool Validate(bool raiseErrors, object defaultLang)
		{
			bool ret_val;
			string error;
			ret_val = true;
			
			// At least one role
			if (Utility.OrderedMap.CountElements(this.mRoles) == 0)
			{
				error = "At least one of the contacts was " + "not associated with any role!";
				new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				ret_val = false;
			}
			
			if (this.mContact == null)
			{
				error = "Entity has no contact specified!";
				new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				ret_val = false;
			}
			else
			{
				if (!this.mContact.Validate(raiseErrors, defaultLang))
				{
					ret_val = false;
				}
			}
			
			return ret_val;
		}// end of member function Validate
		
		public virtual string getXml(string offset, string indentWith)
		{
			string indent;
			string xml;
			indent = offset + indentWith;
			
			xml = TpUtils.OpenTag("", "hasContact", offset, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			
			foreach ( object role in this.mRoles.Values ) 
			{
				xml += TpUtils.MakeTag("", "role", Utility.TypeSupport.ToString(role), indent, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			}
			
			
			xml += this.mContact.GetXml(indent, indentWith);
			
			xml += TpUtils.CloseTag("", "hasContact", offset);
			
			return xml;
		}// end of member function GetXml
	}
}
