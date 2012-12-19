using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System;

using TapirDotNET;

namespace TapirDotNET.Controls
{

	public partial class TpDataSourceForm : TpWizardForm
	{
		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.Load += new EventHandler(TpDataSourceForm_Load);
			this.PreRender += new EventHandler(TpDataSourceForm_PreRender);
		}
		#endregion

		public string mTemplate = "";
		public string mTemplateTitle = "";

		public TpDataSource r_data_source;


		
		public TpDataSourceForm()
		{
			mStep = 2;
			mLabel = "Data source";			

		}
				
		private void LoadDataSource()
		{
			if (this.mTemplate.Length > 0)
			{
				HtmlGenericControl ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = "<br/><span class=\"tip\">there is a template available <a href=\"help.aspx?name=" + this.mTemplateTitle + 
							"&amp;doc=" + this.mTemplate + "\"" +
							" onClick=\"" + string.Format("window.open('help.aspx?name={0}&amp;doc={1}','help','width=600,height=140,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,personalbar=no,locationbar=no,statusbar=no').focus(); return false;\" style=\"text-decoration:none;\"", this.mTemplateTitle, this.mTemplate) +
                    		">here</a></span>";
				
				templTip.Controls.Add(ctrl);
			}
		}

		public override void  LoadDefaults()
		{
			r_data_source = ((TpResource)mResource).GetDataSource();
			
			if (((TpResource)mResource).ConfiguredDatasource())
			{
				r_data_source.LoadFromXml(((TpResource)mResource).GetConfigFile(), null);
			}
			else
			{
				this.SetMessage("Next steps depend on an open connection with your datasource.\r\nPlease, provide the necessary information here:");
				
				r_data_source.LoadDefaults();
			}
		}// end of member function LoadDefaults
		
		public override void  LoadFromSession()
		{
			r_data_source = ((TpResource)mResource).GetDataSource();
			r_data_source.LoadFromSession();
		}// end of member function LoadFromSession
		
		public override void  LoadFromXml()
		{
			r_data_source = ((TpResource)mResource).GetDataSource();
			string err_str;
			
			if (((TpResource)mResource).ConfiguredDatasource())
			{
				r_data_source.LoadFromXml(((TpResource)mResource).GetConfigFile(), null);
			}
			else
			{
				err_str = "There is no data source XML configuration to be loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return ;
			}
		}// end of member function LoadFromXml
		
		
		public override void  HandleEvents()
		{
			// Clicked next or save
			Utility.OrderedMap templates;
			Utility.OrderedMap drivers;
			int dbtype;
			if (HttpContext.Current.Request.Form["next"] != null || HttpContext.Current.Request.Form["update"] != null)
			{
				r_data_source = ((TpResource)mResource).GetDataSource();
				
				// Validate connection
				if (!r_data_source.Validate(true))
				{
					return ;
				}
				
				if (!((TpResource)mResource).SaveDataSource(true))
				{
					// Error message is already set internally (GetConfigFile)
					r_data_source.ResetConnection();
					return ;
				}
				
				if (HttpContext.Current.Request.Form["update"] != null)
				{
					this.SetMessage("Changes successfully saved!");
				}
				
				r_data_source.ResetConnection();
				
				this.mDone = true;
			}
			// Simple refresh
			else
			{
				if (HttpContext.Current.Request.Form["refresh"] != null)
				{
					r_data_source = ((TpResource)mResource).GetDataSource();
					
					templates = this.GetOptions("oledbTemplates");
					drivers = this.GetOptions("oledbDrivers");
					
					dbtype = Utility.TypeSupport.ToInt32(r_data_source.GetDriverName());
					
					if (templates[dbtype] != null)
					{
						this.mTemplate = System.Web.HttpUtility.UrlEncode(System.Web.HttpUtility.HtmlEncode(templates[dbtype].ToString()));
						this.mTemplateTitle = System.Web.HttpUtility.UrlEncode(System.Web.HttpUtility.HtmlEncode("Connection string template\n" + Utility.TypeSupport.ToString(drivers[dbtype])));
					}
					else
					{
						this.mTemplate = "";
						this.mTemplateTitle = "";
					}
				}
			}
		}// end of member function HandleEvents
		
		public virtual Utility.OrderedMap GetOptions(string id)
		{
			Utility.OrderedMap options;
			string fullListOfEncodings;
			Utility.OrderedMap tmp;
			options = new Utility.OrderedMap();
			
			if (id == "oledbDrivers")
			{
				//TODO Excel ODBC driver??  Others??  ODBC?
				options = new Utility.OrderedMap(new object[]{"", "-- Select --"}, new object[]{"MSDAOSP", "ADO Simple Driver"}, new object[]{"SNAOLEDB", "AS400"}, new object[]{"DB2OLEDB", "DB2"}, new object[]{"firebird", "Firebird"}, new object[]{"Ardent.UniOLEDB", "Informix/Unidata"}, new object[]{"ADSDSOObject", "LDAP/Active Directory"}, new object[]{"Microsoft.Jet.OLEDB.4.0", "Microsoft Access/Jet"}, new object[]{"sqloledb", "Microsoft SQL Server"}, new object[]{"SQLXMLOLEDB.3.0", "Microsoft SQL Server using SQLXMLOLEDB"}, new object[]{"MSDASQL", "Microsoft SQL Server (using ODBC)"}, new object[]{"vfpoledb", "Microsoft Visual FoxPro"}, new object[]{"MySQLProv", "MySQL"}, new object[]{"MSDASQL", "ODBC generic driver"}, new object[]{"OraOLEDB.Oracle", "Oracle"}, new object[]{"msdaora", "Oracle (Microsoft)"}, new object[]{"pgoledb", "PostgreSQL"}, new object[]{"Sybase.ASEOLEDBProvider", "SQL Anywhere (Sybase)"}, new object[]{"sqlite", "SQLite"}, new object[]{"sqlitepo", "SQLite portable driver"}); 
				
				if (!((TpResource)mResource).IsNew())
				{
					// Remove "-- Select --"
					Utility.OrderedMap.Shift(options);
				}
			}
			else if (id == "encodings")
			{
				// TODO: figure out a way to get this list dynamically from .net (Encoding.GetEncodings in .NET 2.0)
				fullListOfEncodings = "UCS-4, UCS-4BE, UCS-4LE, UCS-2, UCS-2BE, UCS-2LE, UTF-32, UTF-32BE, UTF-32LE, UCS-2LE, UTF-16, UTF-16BE, UTF-16LE, UTF-8, UTF-7, ASCII, EUC-JP, SJIS, eucJP-win, SJIS-win, ISO-2022-JP, JIS, ISO-8859-1, ISO-8859-2, ISO-8859-3, ISO-8859-4, ISO-8859-5, ISO-8859-6, ISO-8859-7, ISO-8859-8, ISO-8859-9, ISO-8859-10, ISO-8859-13, ISO-8859-14, ISO-8859-15, byte2be, byte2le, byte4be, byte4le, BASE64, 7bit, 8bit, UTF7-IMAP, EUC-CN, CP936, HZ, EUC-TW, CP950, BIG-5, EUC-KR, UHC (CP949), ISO-2022-KR, Windows-1251 (CP1251), Windows-1252 (CP1252), CP866, KOI8-R";
				
				tmp = Utility.RegExPOSIXSupport.Split(", ", fullListOfEncodings, - 1, true);
				Utility.OrderedMap.SortValue(ref tmp, 0);
				
				options = TpUtils.GetHash(tmp);
			}
			else if (id == "oledbTemplates")
			{
				options = new Utility.OrderedMap();
				options["Microsoft.Jet.OLEDB.4.0"] = "Provider=Microsoft.JET.OLEDB.4.0;Data Source=\"c:\\MyDirectory\\MyDatabase.mdb\"";
			}
			
			return options;
		}// end of member function GetOptions

		private void TpDataSourceForm_PreRender(object sender, EventArgs e)
		{
			LoadDataSource();
		}

		private void TpDataSourceForm_Load(object sender, EventArgs e)
		{
			ID = "TpDataSourceForm";
		}
	}
}
