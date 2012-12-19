using System;
using System.Web;
using System.Xml;
using System.IO;
using System.Net;

namespace TapirDotNET 
{

	public class TpOperationParameters
	{
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public object mLabel;
		public object mDocumentation;
		public string mTemplate;
		public TpFilter mFilter;// name element stack during XML parsing
		
		public TpOperationParameters()
		{
			this.mFilter = new TpFilter(false);
		}
		
		
		public virtual bool LoadKvpParameters()
		{
			// Filter
			object filter = null;
			if (HttpContext.Current.Request["filter"] != null)
			{
				filter = HttpContext.Current.Request["filter"];
			}
			else
			{
				if (HttpContext.Current.Request["f"] != null)
				{
					filter = HttpContext.Current.Request["f"];
				}
			}
			
			if (filter != null)
			{
				this.mFilter.LoadFromKvp(System.Web.HttpUtility.UrlDecode(filter.ToString()));
			}
			
			return true;
		}// end of member function LoadKvpParameters
		
		public virtual bool ParseTemplate(string location)
		{
			string error = "";

			this.mTemplate = location;
			
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
								
			try
			{
				
				WebRequest wr = HttpWebRequest.Create(location);
				if ( TpConfigManager.TP_WEB_PROXY.Length > 0 )
				{
					wr.Proxy = new WebProxy(TpConfigManager.TP_WEB_PROXY);
				}

				WebResponse resp = wr.GetResponse();
				StreamReader sr = new StreamReader(resp.GetResponseStream());
				string xml = sr.ReadToEnd();
				sr.Close();

				rdr.ReadXmlStr(xml);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			return true;
		}// end of member function ParseTemplate
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			string name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			this.mInTags.Push(name.ToLower());
			
			if (this.mInTags.Search("filter") != null)
			{
				// Delegate to filter parser
				this.mFilter.StartElement(reader, attrs);
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			if (this.mInTags.Search("filter") != null)
			{
				// Delegate to filter parser
				this.mFilter.EndElement(reader);
			}
			
			this.mInTags.Pop();
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			if (this.mInTags.Search("filter") != null)
			{
				// Delegate to filter parser
				this.mFilter.CharacterData(reader, data);
			}
		}// end of member function CharacterData
		
		public virtual string GetTemplate()
		{
			return this.mTemplate;
		}// end of member function GetTemplate
		
		public virtual object GetLabel()
		{
			return this.mLabel;
		}// end of member function GetLabel
		
		public virtual object GetDocumentation()
		{
			return this.mDocumentation;
		}// end of member function GetDocumentation
		
		public virtual TpFilter GetFilter()
		{
			return this.mFilter;
		}// end of member function GetFilter
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mTemplate", "mFilter");
		}// end of member function __sleep
	}
}
