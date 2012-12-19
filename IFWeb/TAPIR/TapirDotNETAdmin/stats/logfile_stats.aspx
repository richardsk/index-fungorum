
	
	<%@ Page CodeBehind="logfile_stats.aspx.cs" Language="c#" AutoEventWireup="false" Inherits="TapirDotNETAdmin.stats.logfile_stats" %>
<%
		
		if (!(mainPage != null))
		{
			mainPage = "index.aspx";
		}
		
		Response.AppendHeader("Pragma: no-cache", "");
		Response.AppendHeader("Cache-Control: no-cache", "");
	%>
	<!-- #include file = "../www/tapir_globals.aspx" -->
	<%
		
		//BUBU redundant?
		monthNames = new Utility.OrderedMap("null", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
		//BUGBUG should use TapirDotNET global variables
	%>
	<!-- #include file = "filesorter.aspx" -->
	<%//will sort any log files found in the log dir in chronological order
		
	%>
	<!-- #include file = "statistics_include.aspx" -->
	<%//will sort any log files found in the log dir in chronological order
		
	%>
	<!-- #include file = "TpStatistics.aspx" -->
	<%
		
		providerName = "TapirDotNET";
		
		if (!(System.IO.File.Exists(TP_STATISTICS_DIR + "/" + TP_STATISTICS_RESOURCE_TABLE) || System.IO.Directory.Exists(TP_STATISTICS_DIR + "/" + TP_STATISTICS_RESOURCE_TABLE)))
		{
			System.IO.File.SetLastWriteTime(TP_STATISTICS_DIR + "/" + TP_STATISTICS_RESOURCE_TABLE, System.DateTime.Now);
		}
		if (!(System.IO.File.Exists(TP_STATISTICS_DIR + "/" + TP_STATISTICS_SCHEMA_TABLE) || System.IO.Directory.Exists(TP_STATISTICS_DIR + "/" + TP_STATISTICS_SCHEMA_TABLE)))
		{
			System.IO.File.SetLastWriteTime(TP_STATISTICS_DIR + "/" + TP_STATISTICS_SCHEMA_TABLE, System.DateTime.Now);
		}
		
		action = (Request.QueryString["action"] != null)?Utility.TypeSupport.ToString(Request.QueryString["action"]):"";
		
		if (Utility.TypeSupport.ToString(action) == "summary")
		{
			month = Request.QueryString["month"];
			year = Request.QueryString["year"];
			
			startMonth = Request.QueryString["startmonth"];
			endMonth = Request.QueryString["endmonth"];
			startYear = Request.QueryString["startyear"];
			endYear = Request.QueryString["endyear"];
			
			resource = Request.QueryString["resource"];
			detailed = Request.QueryString["detailed"];
			Response.Write(getResourceSummaryPage(providerName, month, year, resource, detailed, startMonth, endMonth, startYear, endYear));
		}
		else if (Utility.TypeSupport.ToString(action) == "monthdetail")
		{
			//set_time_limit(180);
			month = Request.QueryString["month"];
			year = Request.QueryString["year"];
			resource = Request.QueryString["resource"];
			detailed = Request.QueryString["detailed"];
			Response.Write(getResourceMonthDetailPage(providerName, month, year, resource, detailed));
		}
		else if (Utility.TypeSupport.ToString(action) == "daydetail")
		{
			month = Request.QueryString["month"];
			day = Request.QueryString["day"];
			year = Request.QueryString["year"];
			resource = Request.QueryString["resource"];
			ascsv = Request.QueryString["ascsv"];
			Response.Write(getResourceDayDetailPage(providerName, month, day, year, resource, ascsv));
		}
		else if (Utility.TypeSupport.ToString(action) == "custom")
		{
			startMonth = Request.QueryString["startmonth"];
			endMonth = Request.QueryString["endmonth"];
			startYear = Request.QueryString["startyear"];
			endYear = Request.QueryString["endyear"];
			
			startDay = Request.QueryString["startday"];
			endDay = Request.QueryString["endday"];
			
			selectHost = Request.QueryString["selectHost"];
			selectIP = Request.QueryString["selectIP"];
			selectRecs = Request.QueryString["selectRecs"];
			selectQuery = Request.QueryString["selectQuery"];
			selectSchema = Request.QueryString["selectSchema"];
			
			textHost = Request.QueryString["textHost"];
			textIP = Request.QueryString["textIP"];
			textRecs = Request.QueryString["textRecs"];
			textQuery = Request.QueryString["textQuery"];
			textSchema = Request.QueryString["textSchema"];
			
			textBox = Request.QueryString["textbox"];
			resources = Request.QueryString["resource"];
			
			astab = Request.QueryString["download"];
			
			
			Response.Write(getCustomPage(providerName, startDay, endDay, startMonth, startYear, endMonth, endYear, selectHost, textHost, selectIP, textIP, selectRecs, textRecs, selectQuery, textQuery, selectSchema, textSchema, resources, textBox, Utility.TypeSupport.ToBoolean(astab)));
			
			if (!Utility.TypeSupport.ToBoolean(astab))
			{
				//TODO Response.Write(getjavaScript());
			}
		}
		else
		{
			
			availableLogFileNames = new Utility.OrderedMap();
			cachedMonthsFiles = new Utility.OrderedMap();
			getLogArray(ref (Utility.TypeSupport.ToArray(availableLogFileNames))[0], ref (Utility.TypeSupport.ToArray(cachedMonthsFiles))[0]);
			startMonth = (Request.QueryString["startmonth"] != null)?Request.QueryString["startmonth"]:g_current_month;
			endMonth = (Request.QueryString["endmonth"] != null)?Request.QueryString["endmonth"]:g_current_month;
			startYear = (Request.QueryString["startyear"] != null)?Request.QueryString["startyear"]:g_current_year;
			endYear = (Request.QueryString["endyear"] != null)?Request.QueryString["endyear"]:g_current_year;
			Response.Write(getStatisticsPage(providerName, availableLogFileNames, cachedMonthsFiles, Utility.TypeSupport.ToBoolean(startMonth), Utility.TypeSupport.ToBoolean(startYear), Utility.TypeSupport.ToBoolean(endMonth), Utility.TypeSupport.ToBoolean(endYear)));
		}
		
		
	%>