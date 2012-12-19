using System;
using System.Data;
using System.Data.OleDb;
using System.Web;

namespace TapirDotNET.Controls
{

	public partial class TpSettingsForm : TpWizardForm
	{
		public Utility.OrderedMap mTablesAndColumns = new Utility.OrderedMap();
		
		protected TpSettings r_settings;

		public TpSettingsForm()
		{
			mStep = 6;
			mLabel = "Settings";
			
		}
		
		
		public override void  LoadDefaults()
		{
			TpDataSource r_data_source;
			string config_file;
			TpTables r_tables;
			
			if (this.mResource.ConfiguredSettings())
			{
				this.LoadFromXml();
			}
			else
			{
				this.SetMessage("To finish the configuration, please specify the additional settings below.\nYou can find more information about each field by clicking over the label.");
				
				r_data_source = this.mResource.GetDataSource();
				
				if (!r_data_source.IsLoaded())
				{
					config_file = this.mResource.GetConfigFile();
					
					r_data_source.LoadFromXml(config_file, null);
				}
				
				r_tables = this.mResource.GetTables();
				
				if (!r_tables.IsLoaded())
				{
					config_file = this.mResource.GetConfigFile();
					
					r_tables.LoadFromXml(config_file, null);
				}
				
				r_settings = this.mResource.GetSettings();
				
				r_settings.LoadDefaults(false);
				
				this.LoadDatabaseMetadata();
			}
		}// end of member function LoadDefaults
		
		public override void  LoadFromSession()
		{
			TpDataSource r_data_source = null;
			bool raiseErrors = false;
			string config_file = null; 
			TpTables r_tables = null;
			
			r_settings = this.mResource.GetSettings();
			
			// Settings must already be stored in the session
			if (r_settings.GetLogOnly() == null)
			{
				// If not, the only reason I can think of is that the session expired,
				// so load everything from XML
				this.LoadFromXml();
				
				return ;
			}
			
			// Get datasource
			r_data_source = this.mResource.GetDataSource();
			
			// If data source is not valid it's because it's empty, so load it from XML
			raiseErrors = false;
			
			if (!r_data_source.Validate(raiseErrors))
			{
				config_file = this.mResource.GetConfigFile();
				
				r_data_source.LoadFromXml(config_file, null);
			}
			
			r_tables = this.mResource.GetTables();
			
			r_settings.LoadFromSession();
			
			this.LoadDatabaseMetadata();
		}// end of member function LoadFromSession
		
		public override void  LoadFromXml()
		{
			string config_file = null;
			string capabilities_file = null;
			TpDataSource r_data_source = null;
			TpTables r_tables = null;
			string modifier = null;
			string msg = null;
			string err_str;
			
			if (this.mResource.ConfiguredSettings())
			{
				r_settings = this.mResource.GetSettings();
				
				config_file = this.mResource.GetConfigFile();
				
				capabilities_file = this.mResource.GetCapabilitiesFile();
				
				r_settings.LoadFromXml(config_file, capabilities_file, false);
				
				r_data_source = this.mResource.GetDataSource();
				
				r_data_source.LoadFromXml(config_file, null);
				
				r_tables = this.mResource.GetTables();
				
				r_tables.LoadFromXml(config_file, null);
				
				this.LoadDatabaseMetadata();
				
				modifier = r_settings.GetModifier();
				
				if (!Utility.VariableSupport.Empty(modifier))
				{
					string[] mn = modifier.Split('.');
					bool ok = false;

					if (mn.Length == 2)
					{
						DataTable t = (DataTable)mTablesAndColumns[mn[0]];
						foreach (DataRow r in t.Rows)
						{
							if (r["COLUMN_NAME"].ToString() == mn[1])
							{
								ok = true;
								break;
							}
						}
					}

					if (!ok)
					{
						msg = "Date last modified table/field (" + modifier + ") " + "does not exist in the database";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
					}
				}
			}
			else
			{
				err_str = "There is no \"settings\" XML configuration to be loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return ;
			}
		}// end of member function LoadFromXml
		
		public virtual void  LoadDatabaseMetadata()
		{
			TpDataSource r_data_source = null;
			TpTables r_tables = null;
			TpTable root_table = null;
			OleDbConnection cn;
			string err_str;
			Utility.OrderedMap tables = null;
			
			r_data_source = this.mResource.GetDataSource();			
			r_tables = this.mResource.GetTables();			
			root_table = r_tables.GetRootTable();
			tables = root_table.GetAllTables();
						
			if (r_data_source.Validate(true))
			{
				cn = r_data_source.GetConnection();
				
				if (cn == null)
				{
					err_str = "Problem when getting connection to database!";
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
					return ;
				}							

				DataTable valid_tables = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[]{null,null,null,"TABLE"});
				DataTable views = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[]{null,null,null,"VIEW"});
				foreach (DataRow r in views.Rows)
				{
					valid_tables.Rows.Add(r.ItemArray);
				}

				if (Utility.OrderedMap.CountElements(tables) == 0)
				{
					err_str = "No tables inside database!";
					new TpDiagnostics().Append(TpConfigManager.DC_DATABASE_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				}
				else
				{
					foreach ( string table in tables.Values ) 
					{
						DataTable cols = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Columns, new object[]{null, null, table});
										
						if (valid_tables.Select("TABLE_NAME='" + table + "'").Length != 0)  
						{
							this.mTablesAndColumns[table] = cols;
						}
					}
				}
								
				r_data_source.ResetConnection();
			}
			else
			{
				// No need to raise errors (it happens inside "Validate")
			}
		}// end of member function LoadDatabaseMetadata
		
		
		public override void  HandleEvents()
		{
			r_settings = this.mResource.GetSettings();
			string modified;
			
			// Clicked next or save
			if (HttpContext.Current.Request["next"] != null || HttpContext.Current.Request["update"] != null || HttpContext.Current.Request["save"] != null)
			{
				if (!r_settings.Validate(true))
				{
					return ;
				}
				
				if (!this.mResource.SaveSettings(true))
				{
					return ;
				}
				
				// Clicked update
				if (HttpContext.Current.Request["update"] != null)
				{
					this.SetMessage("Changes successfully saved!");
				}
				
				this.mDone = true;
			}
			// Clicked on button "set to now"for date last modified
			else
			{
				if (HttpContext.Current.Request["set_modified"] != null)
				{
					modified = TpUtils.TimestampToXsdDateTime(DateTime.Now);
					
					r_settings.SetModified(modified);
				}
			}
		}// end of member function HandleEvents
		
		public virtual Utility.OrderedMap GetOptions(string id)
		{
			Utility.OrderedMap options;
			options = new Utility.OrderedMap();
			
			if (id == "logonly")
			{
				options = new Utility.OrderedMap(new object[]{"required", "required"}, new object[]{"accepted", "accepted"}, new object[]{"denied", "denied"});
			}
			else if (id == "boolean")
			{
				options = new Utility.OrderedMap(new object[]{"true", "yes"}, new object[]{"false", "no"});
			}
			else if (id == "tables_and_columns")
			{
				foreach ( string table in this.mTablesAndColumns.Keys ) 
				{
					DataTable columns = (DataTable)this.mTablesAndColumns[table];
					foreach ( DataRow col in columns.Rows ) 
					{
						options.Push(table + "." + col["COLUMN_NAME"].ToString());
					}
					
				}
				options = TpUtils.GetHash(options);
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
				Utility.OrderedMap.Unshift(ref options, "-- columns --");
			}
			
			return options;
		}// end of member function GetOptions
		public virtual string GetHtmlLabel(string labelId, bool required)
		{
			string label;
			string doc;
			string js;
			string form_label;
			string html;
			label = "?";
			doc = "";
			
			if (labelId == "max_repetitions")
			{
				label = "Maximum element repetitions";
				doc = "Maximum element repetitions in search and inventory responses. " + "This setting defines the maximum number of occurrences for any " + "XML element inside the search or inventory envelope. You can " + "see this as a way of limiting the number of records returned, " + "forcing clients to page over results (instead of getting " + "big XML responses with all records, clients will be forced to " + "send individual requests to retrieve data in smaller parts).";
			}
			else if (labelId == "max_levels")
			{
				label = "Maximum element levels";
				doc = "Maximum element levels in search responses. " + "This setting defines the maximum number of nested XML elements " + "inside the search envelope. It can be used to prevent processing " + "output models that are too deeply nested.";
			}
			else if (labelId == "log_only")
			{
				label = "Log only requests";
				doc = "Indicates if \"log only\" requests are desired, accepted or denied. " + "\"Log only\" requests are used to propagate remote usage on top of " + "data aggregators. Imagine that your data is copied and then served " + "from a third-party web portal, so other users are searching and " + "retrieving data that originally came from your database. \"Log " + "only\" requests allow that portal to forward search requests to your " + "provider just as a means of communicating what searches are being " + "performed on your data. These kind of requests don\'t require the " + "software to process the request as it would normally do, only log it. " + "Setting this option to \"denied\" will make the provider respond with " + "an error to \"log only\" requests. Setting to \"desired\" will enforce " + "your wish to receive any searches performed on your data on top of " + "third-party servers. \"Accepted\" means that you are not worried about " + "receiving these kind of requests.";
			}
			else if (labelId == "case_sensitive_equals")
			{
				label = "Equals operators are case sensitive";
				doc = "Indicates if equals operators should be case sensitive or not.";
			}
			else if (labelId == "case_sensitive_like")
			{
				label = "Like operators are case sensitive";
				doc = "Indicates if like operators should be case sensitive or not.";
			}
			else if (labelId == "date_last_modified")
			{
				label = "Date last modified";
				doc = "Date and time when data was last modified. It can be either a " + "timestamp field from where this value will be dynamically " + "retrieved or a fixed value following the xsd:dateTime format: " + "[-]CCYY-MM-DDThh:mm:ss[Z|(+|-)hh:mm]";
			}
			
			js = string.Format("onClick=\"javascript:window.open('help.aspx?name={0}&amp;doc={1}','help','width=400,height=250,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,personalbar=no,locationbar=no,statusbar=no').focus(); return false;\" onMouseOver=\"javascript:window.status='{2}'; return true;\" onMouseOut=\"window.status=''; return true;\"", label, System.Web.HttpUtility.UrlEncode(doc), doc);
			
			form_label = label;
			
			html = string.Format("<a href=\"help.aspx?name={0}&amp;doc={1}\" {2}>{3}: </a>", label, System.Web.HttpUtility.UrlEncode(doc), js, form_label);
			if (required)
			{
				html = TpConfigManager.TP_MANDATORY_FIELD_FLAG + html;
			}
			return html;
		}// end of member function GetHtmlLabel
	}
}
