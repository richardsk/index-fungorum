namespace TapirDotNET 
{

	public class XsElementDecl:XsDeclaration
	{
		public int mMinOccurs = 1;
		public int mMaxOccurs = 1;
		public object mDefaultValue;
		public bool mAbstract = false;
		public bool mNillable = false;
		public object mrType;
		
		public XsElementDecl(string name, string targetNamespace, string defaultNamespace, bool isGlobal):base(name, targetNamespace, defaultNamespace, isGlobal)
		{
		}
		
		
		public virtual void  SetType(object rType)
		{
			if (this.mrRefObj != null)
			{
				this.mrRefObj.GetType().InvokeMember("SetType", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{rType});
			}
			
			this.mrType = rType;
		}// end of member function SetType
		
		public new object GetType()
		{
			if (this.mrRefObj != null)
            {
                return this.mrRefObj.GetType().InvokeMember("GetType", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[] {});
			}
			
			return this.mrType;
		}// end of member function GetType
		
		public virtual void  SetMinOccurs(int minOccurs)
		{
			this.mMinOccurs = minOccurs;
		}// end of member function SetMinOccurs
		
		public virtual void  SetMaxOccurs(int maxOccurs)
		{
			this.mMaxOccurs = maxOccurs;
		}// end of member function SetMaxOccurs
		
		public virtual int GetMinOccurs()
		{
			return this.mMinOccurs;
		}// end of member function GetMinOccurs
		
		public virtual int GetMaxOccurs()
		{
			return this.mMaxOccurs;
		}// end of member function GetMaxOccurs
		
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
		
		public virtual void  SetAbstract(string abstract_Renamed)
		{
			if (abstract_Renamed == "true" || abstract_Renamed == "1")
			{
				this.mAbstract = true;
			}
		}// end of member function SetAbstract
		
		public virtual void  SetNillable(string nillable)
		{
			if (nillable == "true" || nillable == "1")
			{
				this.mNillable = true;
			}
		}// end of member function SetNillable
		
		public virtual bool IsAbstract()
		{
			if (this.mrRefObj != null)
			{
				return (bool)this.mrRefObj.GetType().InvokeMember("IsAbstract", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mAbstract;
		}// end of member function IsAbstract
		
		public virtual bool IsNillable()
		{
			if (this.mrRefObj != null)
			{
				return (bool)this.mrRefObj.GetType().InvokeMember("IsNillable", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mNillable;
		}// end of member function IsNillable
		
		public virtual void  SetProperties(Utility.OrderedMap attrs)
		{
			if (attrs["minOccurs"] != null)
			{
				this.SetMinOccurs(Utility.TypeSupport.ToInt32(attrs["minOccurs"]));
			}
			
			if (attrs["maxOccurs"] != null)
			{
				if (attrs["maxOccurs"].ToString().ToLower() == "unbounded")
				{
					this.SetMaxOccurs(-1);
				}
				else
				{
					this.SetMaxOccurs(Utility.TypeSupport.ToInt32(attrs["maxOccurs"]));
				}
			}
			
			if (attrs["ref"] != null)
			{
				this.SetRef(attrs["ref"].ToString());
			}
			else
			{
				if (attrs["type"] != null)
				{
					this.SetType(attrs["type"].ToString());
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
				
				if (attrs["abstract"] != null)
				{
					this.SetAbstract(Utility.TypeSupport.ToString(attrs["abstract"]));
				}
				
				if (attrs["nillable"] != null)
				{
					this.SetNillable(Utility.TypeSupport.ToString(attrs["nillable"]));
				}
			}
		}// end of member function SetProperties
		
		public virtual object Accept(object visitor, object path)
		{
			return ((TpSchemaVisitor)visitor).VisitElementDecl(this, path);
		}// end of member function Accept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mMinOccurs", "mMaxOccurs", "mFixedValue", "mDefaultValue", "mAbstract", "mNillable", "mrType"));
		}// end of member function __sleep
	}
}
