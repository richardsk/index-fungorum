
using System.Collections;

namespace TapirDotNET 
{

	public class TpNamespace
	{
		public string mPrefix = "";
		public string mUri;
		public Utility.OrderedMap mFlags = new Utility.OrderedMap(); // flags are 
		// used during XML parsing just to help detecting
		// the element where the namespace has been declared
		public Utility.OrderedMap mSchemas = new Utility.OrderedMap(); // location => TpXmlSchema obj
		public string mFirstLocation; // location of the first schema
	
		public TpNamespace(string prefix, string uri, string flag)
		{
			this.mPrefix = prefix;
			this.mUri = uri;
			
			if (!(flag == null))
			{
				this.mFlags[0] = flag;
			}
		}
		
		
		public virtual string GetUri()
		{
			return this.mUri;
		}// end of member function GetUri
		
		public virtual string GetPrefix()
		{
			return this.mPrefix;
		}// end of member function GetPrefix
		
		public virtual bool HasFlag(string flag)
		{
			return (this.mFlags.Search(flag) != null);
		}// end of member function HasFlag
		
		public virtual void  RemoveFlag(string flag)
		{
			this.mFlags[flag] = null;
		}// end of member function RemoveFlag
	

		public void PushSchema( string location, object rParser )
		{
			if ( this.mSchemas.Count == 0 )
			{
				this.mFirstLocation = location;
			}

			if ( this.mSchemas[location] == null )
			{
				this.mSchemas[location] = new TpXmlSchema( this.mUri, location, rParser );
			}

		} // end of member function PushSchema

		public void AddSchema( TpXmlSchema rSchema )
		{
			string location = rSchema.GetLocation();

			if ( this.mSchemas.Count == 0 )
			{
				this.mFirstLocation = location;
			}

			if ( this.mSchemas[location] == null )
			{
				this.mSchemas[location] = rSchema;
			}

		} // end of member function AddSchema

		public string GetFirstLocation( )
		{
			return this.mFirstLocation;

		} // end of member function GetFirstLocation

		public string[] GetLocations( )
		{
			return this.mSchemas.Keys;

		} // end of member function GetLocations

		public bool HasSchema( string location )
		{
			return (this.mSchemas[location] != null);

		} // end of member function HasSchema

		public TpXmlSchema GetSchema( string location )
		{
			TpXmlSchema r_schema = null;

			if ( this.mSchemas[location] != null )
			{
				r_schema = (TpXmlSchema)this.mSchemas[location];
			}

			return r_schema;

		} // end of member function GetSchema

		public void AddElementDecl( string schema, XsElementDecl rElementDecl )
		{
			((TpXmlSchema)this.mSchemas[schema]).AddElementDecl( rElementDecl );

		} // end of member function AddElementDecl

		public void AddAttributeDecl( string schema, XsAttributeDecl rAttributeDecl )
		{
			((TpXmlSchema)this.mSchemas[schema]).AddAttributeDecl( rAttributeDecl );

		} // end of member function AddAttributeDecl

		public void AddType( string schema, XsType rType )
		{
			((TpXmlSchema)this.mSchemas[schema]).AddType( rType );

		} // end of member function AddType

		public Utility.OrderedMap GetElementDecls( ) 
		{
			ArrayList ret = new ArrayList();

			foreach ( TpXmlSchema schema in this.mSchemas.Values )
			{
				ret.AddRange( schema.GetElementDecls().Values );
			}

			return new Utility.OrderedMap(ret, false);

		} // end of member function GetElementDecls

		public Utility.OrderedMap GetAttributeDecls( ) 
		{
			ArrayList ret = new ArrayList();

			foreach ( TpXmlSchema schema in this.mSchemas.Values )
			{
				ret.AddRange( schema.GetAttributeDecls().Values );
			}

			return new Utility.OrderedMap(ret, false);

		} // end of member function GetAttributeDecls

		public XsElementDecl GetElementDecl( string name ) 
		{
			foreach ( TpXmlSchema schema in this.mSchemas.Values )
			{
				XsElementDecl el = schema.GetElementDecl( name );

				if ( el != null )
				{
					return el;
				}
			}

			return null;

		} // end of member function GetElementDecl

		public XsAttributeDecl GetAttributeDecl( string name ) 
		{
			foreach ( TpXmlSchema schema in this.mSchemas.Values )
			{
				XsAttributeDecl attr = schema.GetAttributeDecl( name );

				if ( attr != null )
				{
					return attr;
				}
			}

			return null;

		} // end of member function GetAttributeDecl

		public XsType GetType( string name ) 
		{
			XsType r_type = null;

			foreach ( TpXmlSchema schema in this.mSchemas.Values )
			{
				r_type = schema.GetType( name );

				if ( r_type != null )
				{
					return r_type;
				}
			}

			return r_type;

		} // end of member function GetType

	}

}
