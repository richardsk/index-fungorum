using System;
using System.Xml;
using System.IO;
using System.Collections;

namespace TapirDotNET
{
	public delegate void StartElement(TpXmlReader reader, Utility.OrderedMap attrs);
	public delegate void EndElement(TpXmlReader reader);
	public delegate void CharacterData(TpXmlReader reader, string data);
	public delegate void DeclareNamespace(TpXmlReader reader);

	/// <summary>
	/// Summary description for TpXmlReader.
	/// </summary>
	public class TpXmlReader
	{
		protected NameTable nt = null;
		protected XmlNamespaceManager nsMgr = null;
		protected Hashtable namesapces = new Hashtable();
		//protected Hashtable flaggedNamespaces = new Hashtable();
		
		public StartElement StartElementHandler = null;
		public EndElement EndElementHandler = null;
		public CharacterData CharacterDataHandler = null;

		public string XmlData = null;
		
		public XmlTextReader XmlReader = null;

		public TpXmlReader()
		{			
			nt = new NameTable();
			nsMgr = new XmlNamespaceManager(nt);
			
			//add TAPIR namespaces
			nsMgr.AddNamespace(TpConfigManager.TP_DC_PREFIX, "http://purl.org/dc/elements/1.1/");
			nsMgr.AddNamespace(TpConfigManager.TP_DCT_PREFIX, "http://purl.org/dc/terms/");
			nsMgr.AddNamespace(TpConfigManager.TP_VCARD_PREFIX, "http://www.w3.org/2001/vcard-rdf/3.0#");
			nsMgr.AddNamespace(TpConfigManager.TP_GEO_PREFIX, "http://www.w3.org/2003/01/geo/wgs84_pos#");

			namesapces.Add(TpConfigManager.TP_DC_PREFIX, "http://purl.org/dc/elements/1.1/");
			namesapces.Add(TpConfigManager.TP_DCT_PREFIX, "http://purl.org/dc/terms/");
			namesapces.Add(TpConfigManager.TP_VCARD_PREFIX, "http://www.w3.org/2001/vcard-rdf/3.0#");
			namesapces.Add(TpConfigManager.TP_GEO_PREFIX, "http://www.w3.org/2003/01/geo/wgs84_pos#");
		}

		public void AddNamespace(string prefix, string nsUri)
		{
			nsMgr.AddNamespace(prefix, nsUri);
		}

		public void ReadXmlStr(string data)
		{			
			XmlParserContext xpc = new XmlParserContext(nt, nsMgr, "en", XmlSpace.Default);
			xpc.Encoding = new System.Text.UTF8Encoding();

			XmlReader = new XmlTextReader(data, XmlNodeType.Document, xpc);  

			while(XmlReader.Read())
			{
				if (XmlReader.NamespaceURI.Length > 0 && !namesapces.ContainsKey(XmlReader.Prefix)) namesapces.Add(XmlReader.Prefix, XmlReader.NamespaceURI);

				if (XmlReader.NodeType == XmlNodeType.Element)
				{
					if (StartElementHandler != null)
					{
						Utility.OrderedMap attrs = new Utility.OrderedMap();
						if (XmlReader.HasAttributes)
						{
							for (int i = 0; i < XmlReader.AttributeCount; i++)
							{
								XmlReader.MoveToAttribute(i);
								attrs.Add(XmlReader.Name, XmlReader.Value);

								if (XmlReader.Name.StartsWith("xmlns:"))
								{
									string pref = TpUtils.GetUnqualifiedName(XmlReader.Name);
									string ns = XmlReader.Value;
									if (ns.Length > 0 && !namesapces.ContainsKey(pref)) namesapces.Add(pref, ns);									
								}
							}
							XmlReader.MoveToElement();
						}

						StartElementHandler(this, attrs);
					}
					
					if (XmlReader.IsEmptyElement && EndElementHandler != null) 
					{
						EndElementHandler(this);
					}					
				}
				else if (XmlReader.NodeType == XmlNodeType.EndElement)
				{
					if (EndElementHandler != null) EndElementHandler(this);
				}
				else if (XmlReader.NodeType == XmlNodeType.Text || XmlReader.NodeType == XmlNodeType.CDATA)
				{
					if (CharacterDataHandler != null && XmlReader.Value != null && XmlReader.Value.Length > 0)
					{
						CharacterDataHandler(this, XmlReader.Value);
					}
				}
				
			}
		}

		public void ReadXml(string file)
		{
			System.IO.StreamReader rdr = System.IO.File.OpenText(file);
			XmlData = rdr.ReadToEnd();
			rdr.Close();
						
			ReadXmlStr(XmlData);
		}
		
		public virtual string GetNamespace(string prefix)
		{
			return (string)namesapces[prefix]; 
		}// end of member function GetNamespace
		
		public virtual string GetPrefix(string namespace_Renamed)
		{
			IDictionaryEnumerator en = namesapces.GetEnumerator();
			while (en.MoveNext())
			{
				if ((string)en.Value == namespace_Renamed) return (string)en.Key;
			}
			
			return "";
		}// end of member function GetPrefix

        public Utility.OrderedMap GetNamespaces()
        {
            Utility.OrderedMap namespaces_to_return = new Utility.OrderedMap();

            foreach (string key in namesapces.Keys)
            {
                namespaces_to_return.Add(key, new TpNamespace(key, namesapces[key].ToString(), ""));
            }

            return namespaces_to_return;
        }

        //public virtual Utility.OrderedMap GetFlaggedNamespaces(string flag)
        //{
        //    Utility.OrderedMap namespaces_to_return = new Utility.OrderedMap();
			
        //    foreach (string key in flaggedNamespaces.Keys)
        //    {
        //        string f = flaggedNamespaces[key].ToString();
        //        if (f == flag)
        //        {
        //            namespaces_to_return.Add(GetPrefix(key), key);
        //        }
        //    }
			
        //    return namespaces_to_return;
        //}// end of member function GetFlaggedNamespaces
		
        //public virtual void  RemoveFlag(string flag)
        //{            			
        //    foreach (string key in flaggedNamespaces.Keys)
        //    {
        //        string f = flaggedNamespaces[key].ToString();
        //        if (f == flag)
        //        {
        //            flaggedNamespaces.Remove(key);
        //        }
        //    }
        //}// end of member function RemoveFlag

	}
}
