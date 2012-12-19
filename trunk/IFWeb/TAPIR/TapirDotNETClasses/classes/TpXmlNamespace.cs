namespace TapirDotNET 
{

	public class TpXmlNamespace
	{
		public object mNamespace;
		public object mPrefix;
		public object mSchemaLocation;
		
		public TpXmlNamespace(object namespace_Renamed, object prefix, object schemaLocation)
		{
			this.mNamespace = namespace_Renamed;
			this.mPrefix = prefix;
			this.mSchemaLocation = schemaLocation;
		}
		
		
		public virtual object GetNamespace()
		{
			return this.mNamespace;
		}// end of member function GetNamespace
		
		public virtual object GetPrefix()
		{
			return this.mPrefix;
		}// end of member function GetPrefix
		
		public virtual object GetSchemaLocation()
		{
			return this.mSchemaLocation;
		}// end of member function GetSchemaLocation
	}
}
