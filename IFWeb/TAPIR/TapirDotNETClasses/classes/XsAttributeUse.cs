namespace TapirDotNET 
{

	public class XsAttributeUse
	{
		public XsAttributeDecl mAttributeDecl;
		public string mUse;
		public object mFixedValue;
		public object mDefaultValue;
		
		public XsAttributeUse(XsAttributeDecl xsAttributeDecl)
		{
			this.mAttributeDecl = xsAttributeDecl;
		}
		
		
		public virtual void  SetUse(string use)
		{
			this.mUse = use;
		}// end of member function SetUse
		
		public virtual void  SetDefaultValue(object defaultValue)
		{
			this.mDefaultValue = defaultValue;
		}// end of member function SetDefaultValue
		
		public virtual void  SetFixedValue(object fixedValue)
		{
			this.mFixedValue = fixedValue;
		}// end of member function SetFixedValue
		
		public virtual bool HasDefaultValue()
		{
			if (this.mDefaultValue != null)
			{
				return true;
			}
			
			return this.mAttributeDecl.HasDefaultValue();
		}// end of member function HasDefaultValue
		
		public virtual object GetDefaultValue()
		{
			if (this.mDefaultValue != null)
			{
				return this.mDefaultValue;
			}
			
			if (this.mAttributeDecl.HasDefaultValue())
			{
				return this.mAttributeDecl.GetDefaultValue();
			}
			
			return null;
		}// end of member function GetDefaultValue
		
		public virtual bool HasFixedValue()
		{
			if (this.mFixedValue != null)
			{
				return true;
			}
			
			return this.mAttributeDecl.HasFixedValue();
		}// end of member function HasFixedValue
		
		public virtual object GetFixedValue()
		{
			if (this.mFixedValue != null)
			{
				return this.mFixedValue;
			}
			
			if (this.mAttributeDecl.HasFixedValue())
			{
				return this.mAttributeDecl.GetFixedValue();
			}
			
			return null;
		}// end of member function GetFixedValue
		
		public virtual XsAttributeDecl GetDecl()
		{
			return this.mAttributeDecl;
		}// end of member function GetDecl
		
		public virtual bool IsRequired()
		{
			if (this.mUse == "required")
			{
				return true;
			}
			
			return false;
		}// end of member function IsRequired
		
		public virtual void  SetProperties(Utility.OrderedMap attrs)
		{
			if (attrs["ref"] != null)
			{
				this.mAttributeDecl.SetRef(attrs["ref"].ToString());
			}
			
			if (attrs["fixed"] != null)
			{
				this.SetFixedValue(attrs["fixed"]);
			}
			else
			{
				if (attrs["default"] != null)
				{
					this.SetDefaultValue(attrs["default"]);
				}
			}
			
			if (attrs["use"] != null)
			{
				this.SetUse(Utility.TypeSupport.ToString(attrs["use"]));
			}
		}// end of member function SetProperties
		
		public virtual object Accept(object visitor, object path)
		{
			return ((TpSchemaVisitor)visitor).VisitAttributeUse(this, path);
		}// end of member function Accept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mAttributeDecl", "mUse", "mFixedValue", "mDefaultValue");
		}// end of member function __sleep
	}
}
