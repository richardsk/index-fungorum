using System;

namespace TapirDotNET
{
	/// <summary>
	/// Summary description for TpXmlSchema.
	/// </summary>
	public class TpXmlSchema
	{
		public string mPrefix;
		public string mNamespace;
		public string mLocation;
		public object mrParser;
		public Utility.OrderedMap mElementDecls = new Utility.OrderedMap(); // name => XmlElementDecl obj
		public Utility.OrderedMap mAttributeDecls = new Utility.OrderedMap(); // name => XmlAttributeDecl obj
		public Utility.OrderedMap mTypes = new Utility.OrderedMap(); // name => XmlType obj
		

		public TpXmlSchema( string ns, string location, object rParser ) 
		{
			this.mNamespace = ns;
			this.mLocation  = location;
			this.mrParser   = rParser;

		} // end of member function TpXmlSchema

		public string GetNamespace( ) 
		{
			return this.mNamespace;
        
		} // end of member function GetNamespace

		public string GetLocation( ) 
		{
			return this.mLocation;
        
		} // end of member function GetLocation

		public string GetPrefix( ) 
		{
			return this.mPrefix;
        
		} // end of member function GetPrefix

		public object GetParser( ) 
		{
			return this.mrParser;
        
		} // end of member function GetParser

		public void AddElementDecl( XsElementDecl rElementDecl )
		{
			string name = rElementDecl.GetName();

			this.mElementDecls[name] = rElementDecl;

		} // end of member function AddElementDecl

		public void AddAttributeDecl( XsAttributeDecl rAttributeDecl )
		{
			string name = rAttributeDecl.GetName();

			this.mAttributeDecls[name] = rAttributeDecl;

		} // end of member function AddAttributeDecl

		public void AddType( XsType rType )
		{
			string name = rType.GetName();

			this.mTypes[name] = rType;

		} // end of member function AddType

		public Utility.OrderedMap GetElementDecls( ) 
		{
			return this.mElementDecls;

		} // end of member function GetElementDecls

		public Utility.OrderedMap GetAttributeDecls( ) 
		{
			return this.mAttributeDecls;

		} // end of member function GetAttributeDecls

		public XsElementDecl GetElementDecl( string name ) 
		{
			if ( this.mElementDecls[name] != null )
			{
				return (XsElementDecl)this.mElementDecls[name];
			}

			return null;

		} // end of member function GetElementDecl

		public XsAttributeDecl GetAttributeDecl( string name ) 
		{
			if ( this.mAttributeDecls[name] != null )
			{
				return (XsAttributeDecl)this.mAttributeDecls[name];
			}

			return null;

		} // end of member function GetAttributeDecl

		public XsType GetType( string name ) 
		{
			XsType r_type = null;

			if ( this.mTypes[name] != null )
			{
				r_type = (XsType)this.mTypes[name];
			}

			return r_type;

		} // end of member function GetType

	}
}
