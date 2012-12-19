using System;
using System.Web;
using System.Net;
using System.IO;
using System.Xml;
using System.Data.OleDb;
using System.Data;

namespace TapirDotNET.admin
{
	/// <summary>
	/// Summary description for check.
	/// </summary>
	public partial class check : System.Web.UI.Page
	{
		public const bool _DEBUG = false;
		public string emsg;
		public string current_version;
		public bool ok;
		public string result;
		public bool register_globals;
		public Utility.OrderedMap includes;
		public int olderrorRep;
		public string olderrofunc;
		public object olderrorfunc;
		public Utility.OrderedMap dirs;
		public string dir;
		public string dir_permissions;
		public string res_file;
		public bool check_resources;
		public string resName;
		public string resFile;
		public XmlDocument Config;
		public object cn;
		public bool res;
		public Utility.OrderedMap tables;
		public bool warnCase;
		public string msg;
		public object ADODB_FETCH_MODE;
		public Utility.OrderedMap tableList;
		public string sql;
		public object rs;
		public Utility.OrderedMap arow;
		public Utility.OrderedMap ares;
		public bool tmp;
		public string root_dir;
		public string pth;
		public string current_include_path;
		public string revision;
		public string revision_regexp;
		public Utility.OrderedMap matches;
				

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
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
		}
		#endregion

		protected void Page_Load(object sender, System.EventArgs e)
		{
			emsg = "";
		
			Response.Write("<h3>System</h3>\n");
			Response.Write("<table border=\"0\" cellpadding=\"3\">\n");
			Response.Write("<tr><td class=\"e\">.NET Version</td><td class=\"v\">" + System.Environment.Version.ToString() + "</td></tr>\n");
			Response.Write("<tr><td class=\"e\">Operating System</td><td class=\"v\">" + System.Environment.OSVersion.ToString() + "</td></tr>\n");
			Response.Write("<tr><td class=\"e\">Web Server</td><td class=\"v\">" + Request.ServerVariables["SERVER_SOFTWARE"] + "</td></tr>\n");
			Response.Write("<tr><td class=\"e\">Interface Version</td><td class=\"v\">" + Request.ServerVariables["GATEWAY_INTERFACE"] + "</td></tr>\n");
			Response.Write("<tr><td class=\"e\">Protocol</td><td class=\"v\">" + Request.ServerVariables["SERVER_PROTOCOL"] + "</td></tr>\n");
			Response.Write("</table>\n");
		
			/////////////////////////////////////////////////
			// Check version
	
			Response.Write("\n<h3>Checking version...</h3>\n");
			Response.Flush();

			current_version = System.Environment.Version.Major.ToString();
	
			ok = true;
	
			if (!(System.Environment.Version.Minor > 0 || System.Environment.Version.Major > 1))
			{	
				Response.Write("\n" + "<br\\><b>Warning:</b> .NET version " + TpConfigManager.TP_MIN_NET_VERSION + " or later required. Some features may not be available!<br />");
				ok = false;
			}

			if (ok)
			{
				Response.Write(" OK<br />");
			}
	
			/////////////////////////////////////////////////
			// Check configuration
	
			Response.Write("\n<h3>Checking configuration...</h3>\n");
			Response.Flush();
			
			/////////////////////////////////////////////////
			// Check Permissions
	
			Response.Write("\n<h3>Checking permissions...</h3>\n");
			Response.Flush();
	
			dirs = new Utility.OrderedMap(new object[]{"Configuration directory", new Utility.OrderedMap(TpConfigManager.TP_CONFIG_DIR, "rw")}, new object[]{"Templates directory", new Utility.OrderedMap(TpConfigManager.TP_TEMPLATES_DIR, "r")}, new object[]{"Log directory", new Utility.OrderedMap(TpConfigManager.TP_LOG_DIR, "rw")}, new object[]{"Cache directory", new Utility.OrderedMap(TpConfigManager.TP_CACHE_DIRECTORY, "rw")}, new object[]{"Debug directory", new Utility.OrderedMap(TpConfigManager.TP_DEBUG_DIR, "rw")});
	
			foreach ( string dir_name in dirs.Keys ) 
			{
				Utility.OrderedMap dir_data = (Utility.OrderedMap)dirs[dir_name];
				dir = Utility.TypeSupport.ToString(dir_data[0]);
				dir_permissions = Utility.TypeSupport.ToString(dir_data[1]);
		
				Response.Write("\n" + dir_name + " : ");
		
				if (Utility.VariableSupport.Empty(dir))
				{
					Response.Write("<b>not defined!</b><br/>");
					continue;
				}
				else if (!(System.IO.File.Exists(dir) || System.IO.Directory.Exists(dir)))
				{
					Response.Write("<b>does not exist!</b><br/>");
					continue;
				}
				else
				{
					if (!System.IO.Directory.Exists(dir))
					{
						Response.Write("<b>not readable!</b><br/>");
						continue;
					}
					else
					{
						if (dir_permissions == "rw" && !Utility.FileSystemSupport.IsWritable(dir))
						{
							Response.Write("<b>not writable!</b><br/>");
							continue;
						}
					}
				}
		
				Response.Write("OK<br/>");
			}
	
	
			Response.Write("<br/>");
	
			res_file = TpConfigManager.TP_CONFIG_DIR + "\\" + TpConfigManager.TP_RESOURCES_FILE;
	
			Response.Write("\nResources file [" + res_file + "]: ");
	
			check_resources = true;
	
			if (Utility.VariableSupport.Empty(res_file))
			{
				Response.Write("<b>not defined!</b><br/>");
				check_resources = false;
			}
			else if (!(System.IO.File.Exists(res_file) || System.IO.Directory.Exists(res_file)))
			{
				Response.Write("<b>does not exist</b>. Please run the <a href=\"configurator.aspx\">web configuration interface</a> to create it and to include at least one resource.");
				check_resources = false;
			}
			else
			{
				if (!System.IO.File.Exists(res_file))
				{
					Response.Write("<b>not readable!</b><br/>");
					check_resources = false;
				}
				else
				{
					if (!Utility.FileSystemSupport.IsWritable(res_file))
					{
						Response.Write("<b>not writable!</b><br/>");
						check_resources = false;
					}
				}
			}
	
			if (!check_resources)
			{
				Response.Write("</body></html>");
				try
				{
					HttpContext.Current.Response.End();
				}
				catch(Exception){}
			}
	
			/////////////////////////////////////////////////
			//Start checking resource configuration
			Response.Write("<h3>Checking Resources...</h3>\n");
			Response.Flush();
	
			resName = Utility.TypeSupport.ToString(TpUtils.GetVar("resource", ""));
			if (resName == "")
			{
				showHelp();
			}
	
			// TODO: revise and reactivate code below
			return ;
	
			/////////////////////////////////////////////////
			//ok process a resource file.
			//first extract the file name from the resources.xml file
			Response.Write("<p>Processing resource name: " + resName + "</p>");
			resFile = System.IO.Path.GetFileName(res_file);
			if (resFile == "")
			{
				Response.Write("<p><b>ERROR:</b> No configuration file is associated with resource name = ");
				Response.Write(resName + "</p>");
				showHelp();
			}
			resFile = System.IO.Path.GetFullPath(TpConfigManager.TP_CONFIG_DIR + "\\" + resFile);
	
			/////////////////////////////////////////////////
			//Now load the Config information from the file...
			Response.Write("<p>Processing file: " + resFile + "</p>");
			Response.Flush();

			Config = new XmlDocument();
			Config.Load(resFile);
			Response.Write("<h3>Your configuration file contents:</h3>");
			Response.Write(Config.OuterXml);
			Response.Flush();
	
			Response.Write("<hr /><h3>Checking Configuration Settings</h3>\n");
	
			/////////////////////////////////////////////////
			//Try connecting to the database 
			Response.Write("<p>Testing connection to database...<br />\n");
			Response.Flush();
			/*TODO cn = ADONewConnection(Config.connectionType);
			if (!Utility.VariableSupport.IsObject(cn))
			{
				Response.Write(" ERROR: could not create database connection object of type: " + Utility.TypeSupport.ToString(Config.connectionType) + "<br />");
				Utility.MiscSupport.End("can not continue tests.");
			}
			Response.Write("&nbsp;&nbsp;Created connection object OK.<br />\n");
			Response.Flush();
			res = Utility.TypeSupport.ToBoolean(cn.PConnect(Config.connectionString, Config.connectionUID, Config.connectionPWD, Config.connectionDB));
			if (!res)
			{
				Response.Write(" ERROR: Could not open database connection.<br />\n");
				Response.Write("ADODB:" + Utility.TypeSupport.ToString(cn.errorMsg()) + "<br />\n");
				Utility.MiscSupport.End("can not continue tests.");
			}*/
			Response.Write("&nbsp;&nbsp;Connected to database OK.<br />\n");
			Response.Flush();
	
			/////////////////////////////////////////////////
			//check list of tables - match names and case of names
			Response.Write("<h4>Checking for correct table names...</h4>\n");
			/*TODO tables = Utility.TypeSupport.ToArray(cn.MetaTables());
			Response.Write("<table border='1'>\n");
			Response.Write("<tr><th>Config Table Name</th><th>ADODB Table Name</th>\r\n" +
				"      <th>Message</th></tr>");
			warnCase = false;
			foreach ( string k in Utility.TypeSupport.ToArray(Config.m_tables).Keys ) 
			{
				object t = Utility.TypeSupport.ToArray(Config.m_tables)[k];
				Response.Write("<tr><td>" + Utility.TypeSupport.ToString(t.m_name) + "</td>");
				msg = "<td></td><td>Not found in database!</td>";
				foreach ( object atab in tables.Values ) 
				{
					if ((Utility.StringSupport.StringCompare(t.m_name, atab, false) == 0) && (Utility.StringSupport.StringCompare(t.m_name, atab, false).GetType() == 0.GetType()))
					{
						Response.Write("<td>" + Utility.TypeSupport.ToString(atab) + "</td>");
						msg = "<td>Check case of name in config file</td>";
						if (Utility.StringSupport.StringCompare(t.m_name, atab, true) == 0)
						{
							msg = "<td>OK</td>";
						}
						else if (!warnCase)
						{
							warnCase = true;
						}
					}
				}
		
				Response.Write(msg + "</tr>\n");
			}
	
			Response.Write("</table>\n");
			if (warnCase)
			{
				Response.Write("<p>The case of the table names in one or more &lt;table&gt; elements\r\n" +
					"    of your configuration file does\r\n" +
					"    not match the case of the names reported by the ADOdb library.  For some\r\n" +
					"    platform + database combinations this is not important, but to minimize the\r\n" +
					"    chances of unexpected errors it is always a good idea to ensure that the\r\n" +
					"    case of the table names in the configuration file match those that are\r\n" +
					"    reported by the ADOdb library.  Note that the case of the names reported\r\n" +
					"    by ADOdb may not match the case of the names as they appear in your\r\n" +
					"    database management application!  The simplest solution is generally to\r\n" +
					"    update your configuration file and leave the database alone.</p>");
			}*/
			Response.Flush();
	
			/////////////////////////////////////////////////
			//check relationships between tables.
			Response.Write("<h4>Checking relationships between tables</h4>\n");
	
			Response.Write("<pre>");
	
			//Utility.VariableSupport.PrintHumanReadable(Config.m_tables, false);
	
			Response.Write("</pre>");
	
	
			/////////////////////////////////////////////////
			//check concept field names and their data types
			Response.Write("<h4>Checking field names as known by database library...</h4>\n");
	
			//open database connection
			//Concepts = array:
			//[0] = type
			//[1] = table
			//[2] = field
			//[3] = name
			//[4] = zid
			//[5] = namespace
			//[6] = boolean searchable?
			//[7] = boolean returnable?
			/*TODO ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;
			tableList = getTableList(ref Config);
	
			foreach ( object t in tableList.Values ) 
			{
				Response.Write("<h5>Table: " + Utility.TypeSupport.ToString(t) + "</h5>\n");
				sql = "SELECT * FROM " + Utility.TypeSupport.ToString(t);
				rs = cn.SelectLimit(sql, 1);
				if (!Utility.VariableSupport.IsObject(rs))
				{
					Response.Write("<p>" + sql + " produced no result set.<br />");
					Response.Write("ADOdb reports: " + System.Web.HttpUtility.HtmlEncode(cn.ErrorMsg()) + "<br />");
				}
				else
				{
					arow = Utility.TypeSupport.ToArray(rs.FetchRow());
					Response.Write("<table border='1'>\n");
					Response.Write("<tr><th>ADOdb Field</th><th>Name</th><th>Field</th><th>Status</th></tr>\n");
					foreach ( string k in arow.Keys ) 
					{
						object v = arow[k];
						ares = checkColumn(k, Utility.TypeSupport.ToString(t), ref Config);
						Response.Write("<tr>");
						Response.Write("<td>" + Utility.TypeSupport.ToString(ares[0]) + "</td>");
						Response.Write("<td>" + Utility.TypeSupport.ToString(ares[1]) + "</td>");
						Response.Write("<td>" + Utility.TypeSupport.ToString(ares[2]) + "</td>");
						Response.Write("<td>" + Utility.TypeSupport.ToString(ares[3]) + "</td>");
						Response.Write("</tr>\n");
					}
			
					Response.Write("</table>");
					rs.Close();
				}
			}	
		
			cn.Close();*/
	
			Response.Write("<p>Completed.</p>");
		}

		public virtual void  includeErrorHandler(int errNo, string errMsg, object fileName, object lineNum, object vars)
		{
			//global $emsg
		
			if (errNo == 2048)
				// ignore compatibility warnings
			{
				emsg = "OK.<br />\n";
			}
			else
			{
				emsg = "<pre>\nERROR (" + errNo.ToString() + ")\n";
				emsg += errMsg + "\n\n</pre>";
			}
		}
		public virtual void  showHelp()
		{
			TpResources resources = new TpResources().GetInstance();
			Utility.OrderedMap ares;
			string code;
			string status;
			string configured_metadata;
			string configured_datasource;
			string configured_tables;
			string configured_localfilter;
			string configured_mapping;
			string configured_settings;
		
			ares = resources.GetAllResources();
		
			if (Utility.OrderedMap.CountElements(ares) > 0)
			{
				Response.Write("<p>Resources available:</p>");
				Response.Write("<table border=\"0\" cellpadding=\"3\">");
				foreach ( TpResource res in ares.Values ) 
				{
					new TpDiagnostics().Reset();
				
					code = res.GetCode();
					status = res.GetStatus();
					configured_metadata = (res.ConfiguredMetadata())?"OK":"<b>incomplete</b>";
					configured_datasource = (res.ConfiguredDatasource())?"OK":"<b>incomplete</b>";
					configured_tables = (res.ConfiguredTables())?"OK":"<b>incomplete</b>";
					configured_localfilter = (res.ConfiguredLocalFilter())?"OK":"<b>incomplete</b>";
					configured_mapping = (res.ConfiguredMapping())?"OK":"<b>incomplete</b>";
					configured_settings = (res.ConfiguredSettings())?"OK":"<b>incomplete</b>";
					Response.Write("<tr><td class=\"e\"><!-- a href=\"check.aspx?resource=" + code + "\" -->" + code + "<!-- /a --></td><td class=\"v\">status = " + status + "<br/>metadata: " + configured_metadata + "<br/>datasource: " + configured_datasource + "<br/>tables: " + configured_tables + "<br/>local filter: " + configured_localfilter + "<br/>mapping: " + configured_mapping + "<br/>settings: " + configured_settings + "</td></tr>");
				}
			
				Response.Write("</table>");
			}
			else
			{
				Response.Write("<p>No resources were found in your resources file (" + Utility.TypeSupport.ToString(resources.GetFile()) + ").</p>");
				Response.Write("<p>If you did not include any resource yet, you can use the " + "<a href=\"configurator.aspx\">web configuration interface</a>. " + "Otherwise, check that the path to the file is correct and if " + "the web server user has permission to read it.");
			}
			Response.Write("</body></html>");
			
			try
			{
				HttpContext.Current.Response.End();
			}
			catch(Exception){}
		}

	}
}
