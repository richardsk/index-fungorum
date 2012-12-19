namespace TapirDotNET 
{

	public class XsDeclaration
	{
		public string mName;
		public string mTargetNamespace;
		public string mDefaultNamespace;
		public bool mIsGlobal;
		public string mRef;
		public object mrRefObj;
		public object mFixedValue = null;

		public XsDeclaration(string name, string targetNamespace, string defaultNamespace, bool isGlobal)
		{
			this.mName = name;
			this.mTargetNamespace = targetNamespace;
			this.mDefaultNamespace = defaultNamespace;
			this.mIsGlobal = isGlobal;
		}
		
		public virtual string GetName()
		{
			if (this.mrRefObj != null)
			{
                return (string)this.mrRefObj.GetType().InvokeMember("GetName", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[] { });                
			}
			
			return this.mName;
		}// end of member function GetName
		
		public virtual string GetTargetNamespace()
		{
			if (this.mrRefObj != null)
			{
				return (string)this.mrRefObj.GetType().InvokeMember("GetTargetNamespace", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mTargetNamespace;
		}// end of member function GetTargetNamespace
		
		public virtual string GetDefaultNamespace()
		{
			return mDefaultNamespace;
		}

		public virtual bool IsGlobal()
		{
			return this.mIsGlobal;
		}// end of member function IsGlobal
		
		public virtual bool IsLocal()
		{
			return !this.mIsGlobal;
		}// end of member function IsLocal
		
		public virtual void  SetRef(string refVal)
		{
            this.mRef = refVal;
		}// end of member function SetRef
		
		public virtual string GetRef()
		{
			return this.mRef;
		}// end of member function GetRef
		
		public virtual bool IsReference()
		{
			return !Utility.VariableSupport.Empty(this.mRef);
		}// end of member function IsReference
		
		public virtual void  SetReferencedObj(object rReference)
		{
			this.mrRefObj = rReference;
		}// end of member function SetReferencedObj
				
		public virtual bool HasFixedValue()
		{
			if (this.mrRefObj != null)
			{
				return (bool)this.mrRefObj.GetType().InvokeMember("HasFixedValue", System.Reflection.BindingFlags.InvokeMethod, null, mrRefObj, new object[]{});
			}
			
			return this.mFixedValue != null;
		}// end of member function HasFixedValue

		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mName", "mTargetNamespace", "mIsGlobal", "mRef", "mrRefObj");
		}// end of member function __sleep
	}
}
