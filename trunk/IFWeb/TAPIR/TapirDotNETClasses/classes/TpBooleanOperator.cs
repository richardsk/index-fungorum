namespace TapirDotNET 
{

	public class TpBooleanOperator
	{
		public object mBooleanType;// Type of boolean operator (see constants defined in TpFilter.cs)
		
		public TpBooleanOperator(object type)
		{
			this.mBooleanType = type;
		}
		
		
		public virtual object GetBooleanType()
		{
			return this.mBooleanType;
		}// end of member function GetBooleanType
		
		public virtual string GetSql(TpResource rResource)
		{
			return null;
			// Must be overwritten by subclasses!!
		}// end of member function GetSql
		
		public virtual string GetLogRepresentation()
		{
			return null;
			// Must be overwritten by subclasses!!
		}// end of member function GetLogRepresentation
		
		public virtual string GetXml()
		{
			return null;
			// Must be overwritten by subclasses!!
		}// end of member function GetXml
		
		public virtual bool IsValid()
		{
			// Must be overwritten by subclasses!!
			return true;
		}// end of member function IsValid
		
		public virtual object Accept(object visitor, object args)
		{
			return null;
		}

		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mBooleanType");
		}// end of member function __sleep
	}
}
