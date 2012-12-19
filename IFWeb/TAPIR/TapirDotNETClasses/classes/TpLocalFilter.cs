using System;
using System.Xml;
using System.Data;


namespace TapirDotNET 
{

	public class TpLocalFilter 
	{
		public TpFilter mFilter;
		
		public TpLocalFilter()
		{
			bool is_local;
			is_local = true;
			
			this.mFilter = new TpFilter(is_local);
		}
		
		
		public virtual void  LoadDefaults()
		{
			
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			
		}// end of member function LoadFromSession
		
		public virtual void  LoadFromXml(string file, XmlDocument xpr)
		{
			string error;
			string path_to_filter;
			string xml_filter;
			
			if (xpr == null)
			{
				xpr = new XmlDocument();
				
				try
				{
					xpr.Load(file);
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file: " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return ;
				}
			}
						
			path_to_filter = "/configuration[1]/filter[1]";
			
			XmlNode dsnode = xpr.SelectSingleNode(path_to_filter);

			if (dsnode != null && dsnode.InnerXml.Length > 0)
			{
				xml_filter = dsnode.InnerXml; 
			}						
			else
			{
				xml_filter = "<filter />";
			}
			
			this._LoadFilter(xml_filter);
		}// end of member function LoadFromXml
		
		public virtual void  SetFilter(TpFilter filter)
		{
			this.mFilter = filter;
		}// end of member function SetFilter
		
		public virtual bool IsLoaded()
		{
			return (this.mFilter != null);
		}// end of member function IsLoaded
		
		public virtual string GetXml()
		{
			return this.mFilter.GetXml();
		}// end of member function GetXml
		
		public virtual string GetHtml(Utility.OrderedMap tablesAndColumns)
		{
			TpFilterToHtml filter_to_html;
			filter_to_html = new TpFilterToHtml();
			
			filter_to_html.SetTablesAndColumns(tablesAndColumns);
			
			return filter_to_html.GetHtml(this.mFilter);
		}// end of member function GetHtml
		
		public virtual bool Refresh(Utility.OrderedMap tablesAndColumns)
		{
			TpFilterRefresher filter_refresher;
			filter_refresher = new TpFilterRefresher();
			
			filter_refresher.SetTablesAndColumns(tablesAndColumns);
			
			return filter_refresher.Refresh(this.mFilter);
		}// end of member function Refresh
		
		public virtual bool Remove(string path)
		{
			return this.mFilter.Remove(path);
		}// end of member function Remove
		
		public virtual bool AddOperator(string path, object booleanType, int specificType)
		{
			return this.mFilter.AddOperator(path, booleanType, specificType);
		}// end of member function AddOperator
		
		public virtual object Find(string path)
		{
			return this.mFilter.Find(path);
		}// end of member function Find
		
		public virtual string GetSql(object rResource)
		{
			return this.mFilter.GetSql(rResource);
		}// end of member function GetSql
		
		public virtual bool IsEmpty()
		{
			return this.mFilter.IsEmpty();
		}// end of member function IsEmpty
		
		public virtual bool IsValid(bool force)
		{
			return this.mFilter.IsValid(force);
		}// end of member function IsValid
		
		public virtual bool _LoadFilter(string xml)
		{
			bool is_local;
			string error = "";
			
			if (!this.mFilter.IsEmpty())
			{
				// Overwrite filter
				is_local = true;
				
				this.mFilter = new TpFilter(is_local);
			}

			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(mFilter.StartElement);
			rdr.EndElementHandler = new EndElement(mFilter.EndElement);
			rdr.CharacterDataHandler = new CharacterData(mFilter.CharacterData);
								
			try
			{
				rdr.ReadXmlStr(xml);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			return true;
		}// end of member function _LoadFilter
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mFilter");
		}// end of member function __sleep
	}
}
