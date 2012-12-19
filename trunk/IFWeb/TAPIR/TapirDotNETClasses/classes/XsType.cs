namespace TapirDotNET 
{

	public class XsType:XsDeclaration
	{
		public string DerivationMethod;
		public object BaseType;

		protected bool mIsSimple;
		
		public XsType(string name, string targetNamespace, string defaultNamespace, bool isGlobal):base(name, targetNamespace, defaultNamespace, isGlobal)
		{
		}
		
		
		public virtual bool IsComplexType()
		{
			return !this.mIsSimple;
		}// end of member function IsComplexType
		
		public virtual bool IsSimpleType()
		{
			return this.mIsSimple;
		}// end of member function IsSimpleType
		


		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mIsSimple"));
		}// end of member function __sleep
	}
}
