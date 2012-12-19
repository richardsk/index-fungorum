using System.Web;
using System.Web.UI;
using System.IO;
using System.Configuration;
using System.Collections;

using TapirDotNET.Controls;

namespace TapirDotNET 
{

	public class TpConfigManager
	{
		public object g_log;
		public object g_dlog;

		public static string TP_CACHE_DIRECTORY = "cache";
		public static string TP_DEBUG_DIR = "debug";
		public static string TP_CONFIG_DIR = "config";
		public static string TP_TEMPLATES_DIR = "templates";
		public static string TP_STATISTICS_DIR = "statistics"; 
		public static string TP_WWW_DIR = "www";
		public static string TP_LOG_DIR = "log";
		public static string TP_WEB_CONTROLS_DIR = "controls";
		public static string TP_OAIPMH_DIR = "oai-pmh";

		public static string TP_WEB_PROXY = "";

		public static string TP_RESOURCES_FILE = "resources.xml";
		public static string TP_SCHEMAS_FILE = "schemas.xml";
		public static string TP_STASH_FILE = "req.txt";
		
		public static Utility.OrderedMap TP_LANG_OPTIONS;
		
		public static bool TP_USE_CACHE = false;
		public static bool TP_STASH_REQUEST = false;
		public static int TP_CAPABILITIES_CACHE_LIFE_SECS = 86400;
		public static int TP_OUTPUT_MODEL_CACHE_LIFE_SECS = 31536000;
		public static int TP_TEMPLATE_CACHE_LIFE_SECS = 31536000;
		public static int TP_RESP_STRUCTURE_CACHE_LIFE_SECS = 31536000;
		public static int TP_METADATA_CACHE_LIFE_SECS = 86400;
		public static int TP_INVENTORY_CACHE_LIFE_SECS = 3600;
		public static int TP_SEARCH_CACHE_LIFE_SECS = 3600;

		public static string TP_SQL_QUOTE = "'";
		public static string TP_SQL_QUOTE_ESCAPE = "''";
		public static string TP_SQL_WILDCARD = "%";
		
		public static bool _DEBUG = false;
		public static bool TP_LOG_DEBUG = false;
		public static string TP_LOG_OPTIONS = "";
		public static string TP_LOG_LEVEL = "";
		public static string TP_LOG_NAME = "history.txt";
		public static string TP_DEBUG_LOGFILE = "debug.txt";
		public static string TP_PATH_SEP = ";";
		
		public static bool TP_STATISTICS_TRACKING = true;
		public static string TP_STATISTICS_RESOURCE_TABLE = "resources.tbl";
		public static string TP_STATISTICS_SCHEMA_TABLE = "schema.tbl";

		public static string TP_UDDI_TMODEL_NAME = "TAPIR";
		public static string TP_UDDI_OPERATOR_NAME = "";
		public static string TP_UDDI_INQUIRY_URL = "";
		public static int TP_UDDI_INQUIRY_PORT = 80;
		public static string TP_UDDI_PUBLISH_URL = "";
		public static int TP_UDDI_PUBLISH_PORT = 80;

		public static string CFG_UDDI_ERROR = "UDDI_ERROR";
		public static string CFG_DATA_VALIDATION_ERROR = "DATA_VALIDATION_ERROR";
		public static string CFG_INTERNAL_ERROR = "INTERNAL_ERROR";
		public static string DC_INVALID_REQUEST = "INVALID_REQUEST";
		public static string DC_TRUNCATED_RESPONSE = "TRUNCATED_RESPONSE";
		public static string DC_RESOURCE_NOT_FOUND = "RESOURCE_NOT_FOUND";
		public static string DC_UNSUPPORTED_OUTPUT_MODEL = "UNSUPPORTED_OUTPUT_MODEL";
		public static string DC_UNSUPPORTED_CAPABILITY = "UNSUPPORTED_CAPABILITY";
		public static string DC_UNSEARCHABLE_CONCEPT = "UNSEARCHABLE_CONCEPT";
		public static string DC_UNSUPPORTED_SCHEMA_COMPONENT = "UNSUPPORTED_SCHEMA_COMPONENT";
		public static string DC_INVALID_FILTER = "INVALID_FILTER";	
		public static string DC_INVALID_FILTER_TERM = "INVALID_FILTER_TERM";
		public static string DC_UNKNOWN_VARIABLE = "UNKNOWN_VARIABLE";
		public static string DC_UNMAPPED_CONCEPT = "UNMAPPED_CONCEPT";	
		public static string DC_MISSING_PARAMETER = "MISSING_PARAMETER";
		public static string DC_RESPONSE_STRUCTURE_ISSUE = "RESPONSE_STRUCTURE_ISSUE";
		public static string DC_IO_ERROR = "IO_ERROR";
		public static string DC_VERSION_MISMATCH = "VERSION_MISMATCH";
		public static string DC_DEBUG_MSG = "DEBUG_MESSAGE";
		public static string DC_DURATION = "DURATION";
		public static string DC_SERVER_SETUP_ERROR = "SERVER_SETUP_ERROR";
		public static string DC_DB_CONNECTION_ERROR = "DB_CONNECTION_ERROR";
		public static string DC_DEBUG_SQL = "DEBUG_SQL";
		public static string DC_GENERAL_ERROR = "GENERAL_ERROR";
		public static string DC_XML_PARSE_ERROR = "XML_PARSE_ERROR";
		public static string DC_DATABASE_ERROR = "DATABASE_ERROR";
		public static string DC_CONFIG_FAILURE = "CONFIG_FAILURE";
		public static string DC_LOG_ERROR = "LOG_ERROR";
		public static string DC_WARN = "WARN";

		public static string DIAG_WARN = "warn";
		public static string DIAG_ERROR = "error";
		public static string DIAG_FATAL = "fatal";
		public static string DIAG_DEBUG = "debug";
		public static string DIAG_INFO = "info";

		public static string TP_DC_PREFIX = "dc";
		public static string TP_XSI_PREFIX = "xsi";
		public static string TP_GEO_PREFIX = "geo";
		public static string TP_XML_PREFIX = "xml";
		public static string TP_DCT_PREFIX = "dct";
		public static string TP_VCARD_PREFIX = "vcard";

		public static string TP_NAMESPACE = "http://rs.tdwg.org/tapir/1.0";

		public static string XML_HEADER = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>";
		public static string XMLSCHEMAINST = "http://www.w3.org/2001/XMLSchema-instance";
		public static string XMLSCHEMANS = "http://www.w3.org/2001/XMLSchema";
		public static string TP_SCHEMA_LOCATION = "http://rs.tdwg.org/tapir/1.0/schema/tapir.xsd";
		
		public static string TP_MANDATORY_FIELD_FLAG = "(*) ";
		public static double INITIAL_TIMESTAMP = 0;
		public static string TP_MIN_NET_VERSION = "1.1.4322";
		public static string TP_SKIN = "default";
		
		public static string TP_VERSION = "0.1";
		public static string TP_REVISION = "";

		public TpConfigManager()
		{
			//LoadConfig();
		}

		static TpConfigManager()
		{
			LoadConfig();
		}
		
		public static void LoadConfig()
		{
			TP_WWW_DIR = HttpContext.Current.Request.PhysicalApplicationPath.Trim('\\');

			//defaults
			TP_STATISTICS_DIR = Directory.GetParent(TP_WWW_DIR) + "\\" + "statistics";
			TP_CONFIG_DIR = Directory.GetParent(TP_WWW_DIR) + "\\" + "config";
			TP_WEB_CONTROLS_DIR = "~\\Controls";
			TP_TEMPLATES_DIR = Directory.GetParent(TP_WWW_DIR) + "\\" + "templates";
			TP_LOG_DIR = Directory.GetParent(TP_WWW_DIR) + "\\" + "log";
			TP_CACHE_DIRECTORY = Directory.GetParent(TP_WWW_DIR) + "\\" + "cache";
			TP_DEBUG_DIR = Directory.GetParent(TP_WWW_DIR) + "\\" + "debug";
			TP_OAIPMH_DIR = Directory.GetParent(TP_WWW_DIR) + "\\" + "oai-pmh";
			
			//get config from web.config
			
			TP_WEB_PROXY = GetConfigString("TP_WEB_PROXY", TP_WEB_PROXY);

			TP_CACHE_DIRECTORY = GetConfigString("TP_CACHE_DIRECTORY", TP_CACHE_DIRECTORY);
			TP_DEBUG_DIR = GetConfigString("TP_DEBUG_DIR", TP_DEBUG_DIR);
			TP_CONFIG_DIR = GetConfigString("TP_CONFIG_DIR", TP_CONFIG_DIR);
			TP_TEMPLATES_DIR = GetConfigString("TP_TEMPLATES_DIR", TP_TEMPLATES_DIR);
			TP_STATISTICS_DIR = GetConfigString("TP_STATISTICS_DIR", TP_STATISTICS_DIR); 
			TP_LOG_DIR = GetConfigString("TP_LOG_DIR", TP_LOG_DIR);
			TP_OAIPMH_DIR = GetConfigString("TP_OAIPMH_DIR", TP_OAIPMH_DIR);

			TP_RESOURCES_FILE = GetConfigString("TP_RESOURCES_FILE", TP_RESOURCES_FILE);
			TP_SCHEMAS_FILE = GetConfigString("TP_SCHEMAS_FILE", TP_SCHEMAS_FILE);
			TP_STASH_FILE = GetConfigString("TP_STASH_FILE", TP_STASH_FILE);
			
			//lang options
			TP_LANG_OPTIONS = GetConfigArray("TP_LANG_OPTIONS", TP_LANG_OPTIONS);

			TP_USE_CACHE = GetConfigBool("TP_USE_CACHE", TP_USE_CACHE);
			TP_STASH_REQUEST = GetConfigBool("TP_STASH_REQUEST", TP_STASH_REQUEST);
			TP_CAPABILITIES_CACHE_LIFE_SECS = GetConfigInt("TP_CAPABILITIES_CACHE_LIFE_SECS", TP_CAPABILITIES_CACHE_LIFE_SECS);
			TP_OUTPUT_MODEL_CACHE_LIFE_SECS = GetConfigInt("TP_OUTPUT_MODEL_CACHE_LIFE_SECS", TP_OUTPUT_MODEL_CACHE_LIFE_SECS);
			TP_TEMPLATE_CACHE_LIFE_SECS = GetConfigInt("TP_TEMPLATE_CACHE_LIFE_SECS", TP_TEMPLATE_CACHE_LIFE_SECS);
			TP_RESP_STRUCTURE_CACHE_LIFE_SECS = GetConfigInt("TP_RESP_STRUCTURE_CACHE_LIFE_SECS", TP_RESP_STRUCTURE_CACHE_LIFE_SECS);
			TP_METADATA_CACHE_LIFE_SECS = GetConfigInt("TP_METADATA_CACHE_LIFE_SECS", TP_METADATA_CACHE_LIFE_SECS);
			TP_INVENTORY_CACHE_LIFE_SECS = GetConfigInt("TP_INVENTORY_CACHE_LIFE_SECS", TP_INVENTORY_CACHE_LIFE_SECS);
			TP_SEARCH_CACHE_LIFE_SECS = GetConfigInt("TP_SEARCH_CACHE_LIFE_SECS", TP_SEARCH_CACHE_LIFE_SECS);

			TP_SQL_QUOTE = GetConfigString("TP_SQL_QUOTE", TP_SQL_QUOTE);
			TP_SQL_QUOTE_ESCAPE = GetConfigString("TP_SQL_QUOTE_ESCAPE", TP_SQL_QUOTE_ESCAPE);
			TP_SQL_WILDCARD = GetConfigString("TP_SQL_WILDCARD", TP_SQL_WILDCARD);
			
			_DEBUG = GetConfigBool("_DEBUG", _DEBUG);
			TP_LOG_DEBUG = GetConfigBool("TP_LOG_DEBUG", TP_LOG_DEBUG);
			TP_LOG_OPTIONS = GetConfigString("TP_LOG_OPTIONS", TP_LOG_OPTIONS);
			TP_LOG_LEVEL = GetConfigString("TP_LOG_LEVEL", TP_LOG_LEVEL);
			TP_LOG_NAME = GetConfigString("TP_LOG_NAME", TP_LOG_NAME);
			TP_DEBUG_LOGFILE = GetConfigString("TP_DEBUG_LOGFILE", TP_DEBUG_LOGFILE);
			TP_PATH_SEP = GetConfigString("TP_PATH_SEP", TP_PATH_SEP);
			
			TP_UDDI_TMODEL_NAME = GetConfigString("TP_UDDI_TMODEL_NAME", TP_UDDI_TMODEL_NAME);
			TP_UDDI_OPERATOR_NAME = GetConfigString("TP_UDDI_OPERATOR_NAME", TP_UDDI_OPERATOR_NAME);
			TP_UDDI_INQUIRY_URL = GetConfigString("TP_UDDI_INQUIRY_URL", TP_UDDI_INQUIRY_URL);
			TP_UDDI_INQUIRY_PORT = GetConfigInt("TP_UDDI_INQUIRY_PORT", TP_UDDI_INQUIRY_PORT);
			TP_UDDI_PUBLISH_URL = GetConfigString("TP_UDDI_PUBLISH_URL", TP_UDDI_PUBLISH_URL);
			TP_UDDI_PUBLISH_PORT = GetConfigInt("TP_UDDI_PUBLISH_PORT", TP_UDDI_PUBLISH_PORT);
			
			TP_DC_PREFIX = GetConfigString("TP_DC_PREFIX", TP_DC_PREFIX);
			TP_XSI_PREFIX = GetConfigString("TP_XSI_PREFIX", TP_XSI_PREFIX);
			TP_GEO_PREFIX = GetConfigString("TP_GEO_PREFIX", TP_GEO_PREFIX);
			TP_XML_PREFIX = GetConfigString("TP_XML_PREFIX", TP_XML_PREFIX);
			TP_DCT_PREFIX = GetConfigString("TP_DCT_PREFIX", TP_DCT_PREFIX);
			TP_VCARD_PREFIX = GetConfigString("TP_VCARD_PREFIX", TP_VCARD_PREFIX);

			TP_NAMESPACE = GetConfigString("TP_NAMESPACE", TP_NAMESPACE);

			TP_SCHEMA_LOCATION = GetConfigString("TP_SCHEMA_LOCATION", TP_SCHEMA_LOCATION);
						
			TP_SKIN = GetConfigString("TP_SKIN", TP_SKIN);

			TpLog.InitialiseLogs();
		}
		
		private static Utility.OrderedMap GetConfigArray(string name, Utility.OrderedMap defaultVal)
		{
			Utility.OrderedMap vals = new Utility.OrderedMap();

			try
			{
				string val = ConfigurationSettings.AppSettings[name];
				if (val != null && val.Length > 0)
				{
					//values are lang,displayval;lang,displayval; ...
					string[] langs = val.Split(';');
					foreach (string lang in langs)
					{
						string[] ls = lang.Split(',');
						vals.Add(ls[0], ls[1]);
					}
				}
				else
				{
					return defaultVal;
				}
			}
			catch(System.Exception)
			{
				return defaultVal;
			}

			return vals;
		}

		private static string GetConfigString(string name, string defaultVal)
		{
			string val = ConfigurationSettings.AppSettings[name];
			if (val != null && val.Length > 0) return val;
			return defaultVal;
		}

		private static int GetConfigInt(string name, int defaultVal)
		{
			int val = -1;
			try
			{
				val = int.Parse(ConfigurationSettings.AppSettings[name]);
			}
			catch(System.Exception)
			{
				val = defaultVal;
			}
			return val;
		}
		
		private static bool GetConfigBool(string name, bool defaultVal)
		{
			bool val = false;
			try
			{
				val = bool.Parse(ConfigurationSettings.AppSettings[name]);
			}
			catch(System.Exception)
			{
				val = defaultVal;
			}
			return val;
		}

		public virtual bool CheckEnvironment()
		{
			// It's important to start the session here (and not on configurator.aspx)
			// because there are objects being stored in the session, and they can
			// only be reloaded when the session is started after importing all necessary
			// class definitions
			//string current_version;
			string msg;
			//string session_auto_start;
			//string error_msg;
			string config_dir;
			bool config_dir_is_writable;
			string res_file;
			bool res_file_exists;
			System.IO.StreamWriter sw = null;

			
			// Do nothing if environment was already checked and if 
			// "force_reload" is not present
			if (HttpContext.Current.Session["envOk"] != null && !(HttpContext.Current.Request.QueryString["force_reload"] != null))
			{
				return true;
			}
						
			// Check permissions			
			config_dir = TpConfigManager.TP_CONFIG_DIR;
			
			msg = "Configuration directory (" + config_dir + ") ";
			
			config_dir_is_writable = false;
			
			if (Utility.VariableSupport.Empty(config_dir))
			{
				msg += "is not defined";
				new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
			}
			else if (!(System.IO.File.Exists(config_dir) || System.IO.Directory.Exists(config_dir)))
			{
				msg += "does not exist";
				new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
			}
			else
			{
				if (!System.IO.Directory.Exists(config_dir))
				{
					msg += "is not readable";
					new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
				}
				else
				{
					if (!Utility.FileSystemSupport.IsWritable(config_dir))
					{
						msg += "is not writable";
						new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
					}
					else
					{
						config_dir_is_writable = true;
					}
				}
			}
			
			res_file = config_dir + "\\" + TP_RESOURCES_FILE;
			
			msg = "Resources file (" + res_file + ") ";
			
			if (Utility.VariableSupport.Empty(res_file))
			{
				msg += "is not defined";
				new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
			}
			else
			{
				res_file_exists = false;
				
				if (!(System.IO.File.Exists(res_file) || System.IO.Directory.Exists(res_file)))
				{
					if (config_dir_is_writable)
					{
						try
						{
							sw = System.IO.File.CreateText(res_file);
						}
						catch (System.Exception )
						{
						}
						
						if (sw != null)
						{
							try
							{
								sw.WriteLine("<resources/>");	 
								
								res_file_exists = true;
							}
							catch(System.Exception)
							{
								msg += "could not be prepared with initial content";
								new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
							}
							
							sw.Close();
						}
						else
						{
							msg += "could not be created";
							new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
						}
					}
				}
				else
				{
					res_file_exists = true;
				}
				
				if (res_file_exists)
				{
					if (!System.IO.File.Exists(res_file))
					{
						msg += "is not readable";
						new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
					}
					else
					{
						if (!Utility.FileSystemSupport.IsWritable(res_file))
						{
							msg += "is not writable";
							new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
						}
					}
				}
			}

			//log file?
            msg = "";
			if (!Directory.Exists(TP_LOG_DIR))
			{
				msg += "Log dir, " + TP_LOG_DIR + ", does not exist.";
				new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);

			}
			else
			{
				string log_file_name = TP_LOG_DIR + "\\" + TP_LOG_NAME;

				try
				{
					if (File.Exists(log_file_name))
					{
						System.IO.File.SetLastWriteTime(log_file_name, System.DateTime.Now);
					}
				}
				catch(System.Exception ex)
				{
					msg += "Log file directory, or file, is not writable : " + log_file_name;
					new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
				}
			}

			if (TP_LOG_DEBUG)
			{
				if (!Directory.Exists(TP_DEBUG_DIR))
				{
					msg += "Debug dir, " + TP_DEBUG_DIR + ", does not exist.";
					new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);

				}
				else
				{
					string log_file_name = TP_DEBUG_DIR + "\\" + TP_DEBUG_LOGFILE;

					try
					{
						System.IO.File.SetLastWriteTime(log_file_name, System.DateTime.Now);
					}
					catch(System.Exception)
					{
						msg += "Debug directory or file, is not writable : " + log_file_name;
						new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, msg, TpConfigManager.DIAG_FATAL);
					}
				}
			}
									
			// Summing up
			if (!System.Convert.ToBoolean(new TpDiagnostics().Count(new Utility.OrderedMap(TpConfigManager.DIAG_ERROR, TpConfigManager.DIAG_FATAL))))
			{
				HttpContext.Current.Session["envOk"] = 1;
				
				return true;
			}
			else
			{
				return false;
			}
		}// end of member function CheckEnvironment
		
		public TpPage GetWizardPage(TemplateControl ownerPage, int step)
		{
			TpPage page;
			string error;
			if (step == 1)
			{
				page = (TpPage)ownerPage.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "/TpMetadataForm.ascx");
			}
			else if (step == 2)
			{
				page = (TpPage)ownerPage.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "/TpDataSourceForm.ascx");								
			}
			else if (step == 3)
			{
				page = (TpPage)ownerPage.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "/TpTablesForm.ascx");				
			}
			else if (step == 4)
			{
				page = (TpPage)ownerPage.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "/TpLocalFilterForm.ascx");
			}
			else if (step == 5)
			{
				page = (TpPage)ownerPage.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "/TpMappingForm.ascx");
			}
			else if (step == 6)
			{
				page = (TpPage)ownerPage.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "/TpSettingsForm.ascx");
			}
			else
			{
				// Display a form with an error message
				page = (TpPage) (new TpWizardForm());
				error = "Unknown wizard step!";
				new TpDiagnostics().Append(Utility.TypeSupport.ToString(DC_GENERAL_ERROR), error, Utility.TypeSupport.ToString(DIAG_ERROR));
			}
			
			return page;
		}// end of member function GetWizardPage
		
		public virtual int GetNumSteps()
		{
			TpWizardForm page;
			page = new TpWizardForm();
			
			return page.GetNumSteps();
		}// end of member function GetNumSteps
	}
}
