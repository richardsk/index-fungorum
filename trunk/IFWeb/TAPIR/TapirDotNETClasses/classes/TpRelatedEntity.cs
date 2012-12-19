namespace TapirDotNET 
{

	public class TpRelatedEntity:TpBusinessObject
	{
		public Utility.OrderedMap mRoles;
		public TpEntity mEntity;
		
		public TpRelatedEntity()
		{
			this.mRoles = new Utility.OrderedMap();
		}
		
		
		public virtual TpEntity GetEntity()
		{
			return this.mEntity;
		}// end of member function GetEntity
		
		public virtual void  SetEntity(TpEntity entity)
		{
			this.mEntity = entity;
		}// end of member function SetEntity
		
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
				if (raiseErrors)
				{
					error = "At least one of the related entities was " + "not associated with any role!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			if (this.mEntity == null)
			{
				if (raiseErrors)
				{
					error = "Resource has no entity specified!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			else
			{
				if (!this.mEntity.Validate(raiseErrors, defaultLang))
				{
					ret_val = false;
				}
			}
			
			return ret_val;
		}// end of member function Validate
		
		public virtual string GetXml(string offset, string indentWith)
		{
			string indent;
			string xml;
			indent = offset + indentWith;
			
			xml = TpUtils.OpenTag("", "relatedEntity", offset, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			
			foreach ( object role in this.mRoles.Values ) 
			{
				xml += TpUtils.MakeTag("", "role", Utility.TypeSupport.ToString(role), indent, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			}
			
			
			xml += this.mEntity.GetXml(indent, indentWith);
			
			xml += TpUtils.CloseTag("", "relatedEntity", offset);
			
			return xml;
		}// end of member function GetXml
	}
}
