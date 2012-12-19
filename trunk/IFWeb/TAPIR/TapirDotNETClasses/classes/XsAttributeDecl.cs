namespace TapirDotNET 
{

	public class XsAttributeDecl:XsDeclaration
	{
		public object mDefaultValue;
		public object mSimpleType;
		
		public XsAttributeDecl(string name, string targetNamespace, string defaultNamespace, bool isGlobal):base(name, targetNamespace, defaultNamespace, isGlobal)
		{
		}
		
		
		public virtual void  SetType(object simpleType)
		{
			if (this.mrRefObj != null)
			{
				this.mrRefObj.GetType().InvokeMember("SetType", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{simpleType});
			}
			
			this.mSimpleType = simpleType;
		}// end of member function SetType
		
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
			if (this.mrRefObj != null)
			{
				return (bool)this.mrRefObj.GetType().InvokeMember("HasDefaultValue", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mDefaultValue != null;
		}// end of member function HasDefaultValue
		
		public virtual object GetDefaultValue()
		{
			if (this.mrRefObj != null)
			{
				return this.mrRefObj.GetType().InvokeMember("GetDefaultValue", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mDefaultValue;
		}// end of member function GetDefaultValue
		
		public override bool HasFixedValue()
		{
			if (this.mrRefObj != null)
			{
				return (bool)this.mrRefObj.GetType().InvokeMember("HasFixedValue", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mFixedValue != null;
		}// end of member function HasFixedValue
		
		public virtual object GetFixedValue()
		{
			if (this.mrRefObj != null)
			{
				return this.mrRefObj.GetType().InvokeMember("GetFixedValue", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mFixedValue;
		}// end of member function GetFixedValue
		
		public new object GetType()
		{
			if (this.mrRefObj != null)
			{
				return this.mrRefObj.GetType().InvokeMember("GetType", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mSimpleType;
		}// end of member function GetType
		
		public virtual void  SetProperties(Utility.OrderedMap attrs)
		{
			if (attrs["type"] != null)
			{
				this.SetType(attrs["type"]);
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
		}// end of member function SetProperties
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mFixedValue", "mDefaultValue", "mSimpleType"));
		}// end of member function __sleep
	}
}
