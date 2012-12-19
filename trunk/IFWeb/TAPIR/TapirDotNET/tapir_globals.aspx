
<script runat="server" language="c#">

	public static string TP_WWW_DIR;
	public static string TP_CONFIG_DIR;
	public static string TP_CLASSES_DIR;
	public static string TP_TEMPLATES_DIR;
	public static string TP_LOG_DIR;
	public static string TP_STATISTICS_DIR;
	public static string TP_CACHE_DIR;
	public static string TP_DEBUG_DIR;
	public const string TP_PATH_SEP = ";";
	//CONVERSION_ISSUE: There is a conflict with declaration of 'TP_PATH_SEP'. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1005.htm 
	public const string TP_PATH_SEP = ":";
	public static string TP_INCLUDE_PATH;
	public const bool TP_STASH_REQUEST = false;
	public const string TP_STASH_FILE = "req.txt";
	//CONVERSION_ISSUE: There is a conflict with declaration of 'TP_LOG_DEBUG'. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1005.htm 
	public const bool TP_LOG_DEBUG = false;
	public const string TP_DEBUG_LOGFILE = "debug.txt";
	public const int TP_MAX_RUNTIME = 120;
	public const string TP_RESOURCES_FILE = "resources.xml";
	public const string TP_SCHEMAS_FILE = "schemas.xml";
	public const bool TP_USE_CACHE = false;
	public const int TP_GETHOST_CACHE_LIFE_SECS = 172800;
	public const int TP_METADATA_CACHE_LIFE_SECS = 86400;
	public const int TP_CAPABILITIES_CACHE_LIFE_SECS = 86400;
	public const int TP_INVENTORY_CACHE_LIFE_SECS = 3600;
	public const int TP_SEARCH_CACHE_LIFE_SECS = 3600;
	public const int TP_TEMPLATE_CACHE_LIFE_SECS = 31536000;
	public const int TP_OUTPUT_MODEL_CACHE_LIFE_SECS = 31536000;
	public const int TP_RESP_STRUCTURE_CACHE_LIFE_SECS = 31536000;
	public const string TP_XPATH_LIBRARY = "xpath/XPath.class.php";
	public const string TP_ADODB_LIBRARY = "adodb/adodb.inc.php";
	public const bool TP_USE_MBSTRING = true;
	public const string TP_LOG_TYPE = "file";
	public const string TP_LOG_NAME = "history.txt";
	public static object TP_LOG_LEVEL;
	public static string TP_LOG_OPTIONS;
	public const bool TP_STATISTICS_TRACKING = true;
	public const string TP_STATISTICS_RESOURCE_TABLE = "resources.tbl";
	public const string TP_STATISTICS_SCHEMA_TABLE = "schema.tbl";
	//CONVERSION_ISSUE: There is a conflict with declaration of 'TP_ALLOW_DEBUG'. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1005.htm 
	public const bool TP_ALLOW_DEBUG = false;
	public const string TP_SQL_QUOTE = "'";
	public const string TP_SQL_QUOTE_ESCAPE = "''";
	public const string TP_SQL_WILDCARD = "%";
	public const string TP_UDDI_TMODEL_NAME = "TAPIR 1.0";
	public const string TP_UDDI_OPERATOR_NAME = "";
	public const string TP_UDDI_INQUIRY_URL = "";
	public const int TP_UDDI_INQUIRY_PORT = 80;
	public const string TP_UDDI_PUBLISH_URL = "";
	public const int TP_UDDI_PUBLISH_PORT = 80;
	public const string TP_MIN_PHP_VERSION = "4.2.3";
	public const string TP_VERSION = "0.2";
	public static string TP_REVISION;
	public const string TP_NAMESPACE = "http://rs.tdwg.org/tapir/1.0";
	public const string TP_SCHEMA_LOCATION = "http://rs.tdwg.org/tapir/1.0/schema/tapir.xsd";
	public const string XMLSCHEMANS = "http://www.w3.org/2001/XMLSchema";
	public const string XMLSCHEMAINST = "http://www.w3.org/2001/XMLSchema-instance";
	public const string TP_DC_PREFIX = "dc";
	public const string TP_DCT_PREFIX = "dct";
	public const string TP_GEO_PREFIX = "geo";
	public const string TP_VCARD_PREFIX = "vcard";
	public const string TP_XML_PREFIX = "xml";
	public const string TP_XSI_PREFIX = "xsi";
	public const string XML_HEADER = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>";
</script>


<%
	 /**
	* $Id: tapir_globals.php 265 2007-02-23 00:15:00Z rdg $
	*
	* LICENSE INFORMATION
	*
	* This program is free software; you can redistribute it and/or
	* modify it under the terms of the GNU General Public License
	* as published by the Free Software Foundation; either version 2
	* of the License, or (at your option) any later version.
	*
	* This program is distributed in the hope that it will be useful,
	* but WITHOUT ANY WARRANTY; without even the implied warranty of
	* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	* GNU General Public License for more details:
	*
	* http://www.gnu.org/copyleft/gpl.html
	*
	*
	* @author Renato De Giovanni <renato [at] cria . org . br>
	* @author Dave Vieglais (Biodiversity Research Center, University of Kansas)
	*
	*
	* NOTES
	*
	* Global constants for the TapirDotNET provider and associated services
	* This script also sets the include_path for this instance of PHP
	* so that the libaries can be located.
	*
	* Running this script without being included within another script
	* such as TapirDotNET entry point results in a number of tests being run to
	* check the values of configurable variables.
	*
	* The default installation assumes the following folde structure
	*
	* TapirDotNET
	*    config    		(configuration files- NOT web accessible)
	*    classes   		(classes- NOT web accessible)
	*    templates 		(templates- NOT web accessible)
	*    cache     		(location of temporary cache files- writable by web)
	*    log		(location of log files - writable by web)
	*    www		(root folder of DiGIR script - web accessible)
	*    lib		(folder for external libraries - NOT web accessible)
	*       pear		(PEAR libraries)
	*       xpath		(XPath processor support library)
	*       adodb		(SQL database abstraction library)
	*
	*/
	
	// Change all parameter names to lower case
	Utility.OrderedMap.ChangeCase(_REQUEST, 0);
	
	// Load possible local configuration file, which can be used to override the default
	// values for the defines in this file.	
	//CONVERSION_ISSUE: Method 'ini_set' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
	ini_set("include_path", ".");
	
	try
	{
	%>
	<!--CONVERSION_WARNING: Language construct 'include_once' was converted to '#include' which has a different behavior.--><!-- #include file = "localconfig.aspx" -->
	<%
		tmp = true;
	}
	catch (System.Exception )
	{
	}
	
	// Set the root folder to the parent of the folder the script is being run from.
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_WWW_DIR".ToUpper()) != null)?1:0))
	{
		root_dir = System.IO.Path.GetDirectoryName(__FILE__);
		
		TP_WWW_DIR = root_dir;
	}
	
	// The full path to the directory used to contain configuration.
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_CONFIG_DIR".ToUpper()) != null)?1:0))
	{
		
		TP_CONFIG_DIR = System.IO.Path.GetFullPath(TP_WWW_DIR + "/../config");
	}
	
	// The full path to the directory used to contain classes.
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_CLASSES_DIR ".ToUpper()) != null)?1:0))
	{
		TP_CLASSES_DIR = System.IO.Path.GetFullPath(TP_WWW_DIR + "/../classes");
	}
	
	// The full path to the directory used to contain templates.
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_TEMPLATES_DIR".ToUpper()) != null)?1:0))
	{
		TP_TEMPLATES_DIR = System.IO.Path.GetFullPath(TP_WWW_DIR + "/../templates");
	}
	
	// The full path to the directory used to store log files
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_LOG_DIR".ToUpper()) != null)?1:0))
	{
		TP_LOG_DIR = System.IO.Path.GetFullPath(TP_WWW_DIR + "/../log");
	}
	
	// The full path to the directory used to track statistics
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_STATISTICS_DIR".ToUpper()) != null)?1:0))
	{
		TP_STATISTICS_DIR = System.IO.Path.GetFullPath(TP_WWW_DIR + "/../statistics/");
	}
	
	 /**
	* The directory that will be used by the cache. This is a full path to a folder
	* that has permissions for the php interpreter to create sub-folders and write
	* content. The specified folder must exist.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_CACHE_DIR".ToUpper()) != null)?1:0))
	{
		TP_CACHE_DIR = System.IO.Path.GetFullPath(TP_WWW_DIR + "/../cache");
	}
	
	 /**
	* This folder is used to stash incoming requests when TP_STASH_REQUEST is true and
	* to write detailed log for debugging when TP_LOG_DEBUG is true.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_DEBUG_DIR".ToUpper()) != null)?1:0))
	{
		TP_DEBUG_DIR = TP_LOG_DIR;
	}
	
	// Try and determine the appropriate path separator
	// windows = ";", unix = ":"
	// Note that the PHP constant PATH_SEPARATOR was only included in PHP 4.3.0
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_PATH_SEP".ToUpper()) != null)?1:0))
	{
		//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
		if (System.Environment.OSVersion.ToString().Substring(0, 3).ToUpper() == "WIN")
		{
		}
		else
		{
		}
	}
	
	// The include path to find libaries.
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_INCLUDE_PATH".ToUpper()) != null)?1:0))
	{
		pth = ".";
		
		pth += TP_PATH_SEP + System.IO.Path.GetFullPath(TP_WWW_DIR);
		pth += TP_PATH_SEP + System.IO.Path.GetFullPath(TP_CLASSES_DIR);
		pth += TP_PATH_SEP + System.IO.Path.GetFullPath(TP_WWW_DIR + "/../lib/pear");
		pth += TP_PATH_SEP + System.IO.Path.GetFullPath(TP_WWW_DIR + "/../lib");
		pth += TP_PATH_SEP + System.IO.Path.GetFullPath(TP_TEMPLATES_DIR);
		
		TP_INCLUDE_PATH = pth;
	}
	
	//CONVERSION_WARNING: Method 'ini_get' was converted to 'System.Configuration.ConfigurationSettings.GetConfig' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/ini_get.htm 
	current_include_path = (string) System.Configuration.ConfigurationSettings.GetConfig("include_path");
	
	//CONVERSION_ISSUE: Method 'ini_set' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
	ini_set("include_path", TP_INCLUDE_PATH + TP_PATH_SEP + current_include_path);
	
	// A mini-test of the include path
	
	try
	{
	%>
	<!--CONVERSION_WARNING: Language construct 'include_once' was converted to '#include' which has a different behavior.--><!-- #include file = "PEAR.aspx" -->
	<%
		tmp = true;
	}
	catch (System.Exception )
	{
	}
	try
	{
	%>
	<!--CONVERSION_WARNING: Language construct 'include_once' was converted to '#include' which has a different behavior.--><!-- #include file = "Log.aspx" -->
	<%
		tmp = true;
	}
	catch (System.Exception )
	{
	}
	
	if (!tmp)
	{
		// This is a serious problem. Log.php is in the PEAR
		// libraries, and if it can not be loaded then we can not
		// continue, since it is likely that the PEAR libraries are in the
		// wrong place.
		msg = "Fatal Error. This provider is not configured correctly. \n";
		msg += "The include_path does not resolve the location of the required libraries. \n";
		//CONVERSION_WARNING: Method 'ini_get' was converted to 'System.Configuration.ConfigurationSettings.GetConfig' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/ini_get.htm 
		msg += "Include path = " + (string) System.Configuration.ConfigurationSettings.GetConfig("include_path");
		
		//CONVERSION_ISSUE: Method 'headers_sent' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
		if (headers_sent())
		{
			Response.Write("<error>" + msg + "</error>");
		}
		else
		{
			Response.Write("<pre>\n" + msg);
		}
		
		flush();
		HttpContext.Current.Response.End();
	}
	
%>
<!--CONVERSION_WARNING: Language construct 'include_once' was converted to '#include' which has a different behavior.-->
<!-- #include file = "tapir_errors.aspx" -->
<%
	
	 /*
	* Indicates if the request must be stashed in TP_DEBUG_DIR*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_STASH_REQUEST".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_STASH_FILE".ToUpper()) != null)?1:0))
	{
	}
	
	 /*
	* Indicates if details debugging must be stored in a separate log file in TP_DEBUG_DIR*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_LOG_DEBUG".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_DEBUG_LOGFILE".ToUpper()) != null)?1:0))
	{
	}
	
	// This is the maximum time in seconds that the script can run.
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_MAX_RUNTIME".ToUpper()) != null)?1:0))
	{
		
	}
	
	/////////////////////////////////////////////
	//Stuff more specific to TapirDotNET operation
	
	 /**
	* The file name of the Resources xml file which contains a list of resource
	* names and associated configuration information.  Must be located in the
	* TP_CONFIG_DIR folder.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_RESOURCES_FILE".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* The file name of the Schemas xml file which contains a list of conceptual
	* schemas that can be used during provider configuration.  Must be located in the
	* TP_CONFIG_DIR folder.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_SCHEMAS_FILE".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Indicates whether the caching system should be used.  If you have a fast
	* system and like to see the CPU meter pegged, then it's probably ok to
	* turn caching off...*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_USE_CACHE".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Number of seconds that the php function gethostbyaddr will be used before
	* forcing an update. Default is two days.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_GETHOST_CACHE_LIFE_SECS".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Number of seconds that cached metadata will be used before forcing an update.
	* Default is once a day.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_METADATA_CACHE_LIFE_SECS".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Number of seconds that cached capabilities will be used before forcing an update.
	* Default is once a day.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_CAPABILITIES_CACHE_LIFE_SECS".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Indicates the time in seconds that an inventory response will remain in the cache.
	* Default duration is one hour.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_INVENTORY_CACHE_LIFE_SECS ".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Indicates the time in seconds that a search response will remain in the cache.
	* Default duration is one hour.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_SEARCH_CACHE_LIFE_SECS ".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Number of seconds that cached templates will be used before forcing an update.
	* Default is once a year.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_TEMPLATE_CACHE_LIFE_SECS".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Number of seconds that cached output models will be used before forcing an update.
	* Default is once a year.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_OUTPUT_MODEL_CACHE_LIFE_SECS".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Number of seconds that cached response structures will be used before
	* forcing an update. Default is once a year.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_RESP_STRUCTURE_CACHE_LIFE_SECS".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* This is the relative or absolute path to the xpath library*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_XPATH_LIBRARY".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* This is the relative or absolute path to the php ADODB library*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_ADODB_LIBRARY".ToUpper()) != null)?1:0))
	{
		
	}
	
	 /**
	* The enable or disable (FALSE) the use of the mb_string library. This library
	* is required for translation between character encodings, and so if your
	* data or metadata contain *any* characters outside of 7 bit ASCII, then you
	* *must* enable use of the mbstring library.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_USE_MBSTRING".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Load the mbstring library if not already loaded.
	* Note that dl() is only available when the PHP interpreter is running
	* in CGI mode.*/
	if (TP_USE_MBSTRING)
	{
		// try and load it using dl()
		//CONVERSION_ISSUE: Static function call <'TpUtils.LoadLibrary()'> was converted to a new instance call which may cause side effects. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1011.htm 
		res = Utility.TypeSupport.ToBoolean(TpUtils.LoadLibrary("mbstring"));
		
		if (!res)
		{
			msg = "The \"mbstring\" library is not available for character conversions";
			//CONVERSION_ISSUE: Static function call <'TpDiagnostics.Append()'> was converted to a new instance call which may cause side effects. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1011.htm 
			new TpDiagnostics().Append(DC_MISSING_LIBRARY, msg, DIAG_WARN);
		}
	}
	
	 /**
	* For logging.*/
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_LOG_TYPE".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_LOG_NAME".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Log level.  Valid values for this are
	* PEAR_LOG_EMERG
	* PEAR_LOG_ALERT
	* PEAR_LOG_CRIT
	* PEAR_LOG_ERR
	* PEAR_LOG_WARNING
	* PEAR_LOG_NOTICE
	* PEAR_LOG_INFO
	* PEAR_LOG_DEBUG
	* Table installations should set this to PEAR_LOG_INFO to record transactions*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_LOG_LEVEL".ToUpper()) != null)?1:0))
	{
		TP_LOG_LEVEL = PEAR_LOG_INFO;
	}
	
	// note for statistics to work, the log file format MUST have these options
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_LOG_OPTIONS".ToUpper()) != null)?1:0))
	{
		//CONVERSION_ISSUE: Method 'serialize' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
		TP_LOG_OPTIONS = serialize(new Utility.OrderedMap(new object[]{"timeFormat", "%b %d %Y	%H:%M:%S"}, new object[]{"lineFormat", "%1s	%2s	[%3s]	%4s"}));
	}
	
	 /*
	* Set to true if you want to track statistics*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_STATISTICS_TRACKING".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Other statistics settings*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_STATISTICS_RESOURCE_TABLE".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_STATISTICS_SCHEMA_TABLE".ToUpper()) != null)?1:0))
	{
	}
	
	 /**
	* Set this true to allow incoming debug requests.*/
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_ALLOW_DEBUG".ToUpper()) != null)?1:0))
	{
	}
	
	//////////////////////////////////////////////////////
	// SQL definitions
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_SQL_QUOTE".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_SQL_QUOTE_ESCAPE".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_SQL_WILDCARD".ToUpper()) != null)?1:0))
	{
	}
	
	//////////////////////////////////////////////////////
	// UDDI
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_UDDI_TMODEL_NAME".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_UDDI_OPERATOR_NAME".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_UDDI_INQUIRY_URL".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_UDDI_INQUIRY_PORT".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_UDDI_PUBLISH_URL".ToUpper()) != null)?1:0))
	{
	}
	
	if (!System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_UDDI_PUBLISH_PORT".ToUpper()) != null)?1:0))
	{
	}
	
	/////////////////////////////////////////////////////////////////////////////
	// Nothing to change past here
	/////////////////////////////////////////////////////////////////////////////
	
	
	
	revision = "$Revision: 265 $.";
	
	revision_regexp = "/^\\$" + "Revision:\\s(\\d+)\\s\\$\\.$/";
	
	//CONVERSION_TODO: Regular expression should be reviewed in order to make it .NET compliant. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1022.htm 
	if (Utility.RegExPerlSupport.Match(revision_regexp, revision, ref matches, - 1))
	{
		revision = Utility.TypeSupport.ToString(matches[1]);
	}
	
	TP_REVISION = revision;
	
	
	
	
	
%>