
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "TpStatistics.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "TpStatistics.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "flatfile/flatfile.aspx" -->
	<%@ Page CodeBehind="statistics_include.aspx.cs" Language="c#" AutoEventWireup="false" Inherits="TapirDotNETAdmin.stats.statistics_include" %>
<script runat="server" language="c#">
	
		public virtual void  removeDebug(object name, object value_Renamed, int vardump)
		{
			if (!System.Convert.ToBoolean(vardump))
			{
				Response.Write(name + " = :" + value_Renamed + ":");
			}
			else
			{
				Response.Write(name + " = ");
				Utility.VariableSupport.PrintHumanReadable(value_Renamed, false);
			}
		}
		public virtual Utility.OrderedMap getAllMonthsAsText()
		{
			return new Utility.OrderedMap(new object[]{"01", "Jan"}, new object[]{"02", "Feb"}, new object[]{"03", "Mar"}, new object[]{"04", "Apr"}, new object[]{"05", "May"}, new object[]{"06", "Jun"}, new object[]{"07", "Jul"}, new object[]{"08", "Aug"}, new object[]{"09", "Sep"}, new object[]{"10", "Oct"}, new object[]{"11", "Nov"}, new object[]{"12", "Dec"});
		}
		public virtual Utility.OrderedMap getAllMonths()
		{
			return new Utility.OrderedMap("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12");
		}
		public virtual string generateMonthsHeader()
		{
			return " <TD colspan=\"12\" align=\"center\" >Months</TD>";
		}
		public virtual string generateAvailableDataTableHeader()
		{
			
			return "\r\n" +
"                            <TABLE border>\r\n" +
"                                <TR bgcolor=DFE5FA> <TD>Year</TD><TD></TD> " + generateMonthsHeader() + "</TR>\n";
		}
		public virtual string generateAvailableDataTableCloser()
		{
			return "\r\n" +
"                            </TABLE>\r\n";
		}
		public virtual string monthNumberToText(string monthAsNumber)
		{
			string monthAsText;
			monthAsText = "";
			switch (monthAsNumber)
			{
				
				case "01": monthAsText = "Jan";
					break;
				
				case "02": monthAsText = "Feb";
					break;
				
				case "03": monthAsText = "Mar";
					break;
				
				case "04": monthAsText = "Apr";
					break;
				
				case "05": monthAsText = "May";
					break;
				
				case "06": monthAsText = "Jun";
					break;
				
				case "07": monthAsText = "Jul";
					break;
				
				case "08": monthAsText = "Aug";
					break;
				
				case "09": monthAsText = "Sep";
					break;
				
				case "10": monthAsText = "Oct";
					break;
				
				case "11": monthAsText = "Nov";
					break;
				
				case "12": monthAsText = "Dec";
					break;
				
			}
			return monthAsText;
		}
		//BUGBUG could be made more effecient with filtering
		public virtual string generateMonthLink(string targetMonth, string targetYear, Utility.OrderedMap availableLogFileNames)
		{
			//global $mainPage
			object monthAsText;
			string returnValue;
			string targetFileName;
			monthAsText = monthNumberToText(targetMonth);
			returnValue = "\r\n" +
"                                    <TD>" + monthAsText + "</TD>\r\n";
			
			targetFileName = targetYear + "_" + targetMonth + ".tbl";
			foreach ( object availableDate in availableLogFileNames.Values ) {
				if (Utility.StringSupport.StringCompare(availableDate, targetFileName, true) == 0)
				{
					returnValue = "                                  <TD><A HREF=\"" + mainPage + "?startmonth=" + targetMonth + "&startyear=" + targetYear + "&endmonth=" + targetMonth + "&endyear=" + targetYear + "\">" + monthAsText + "</A></TD>\n";
					break;
				}
			}
			
			
			return returnValue;
		}
		public virtual string getCustomPageCenter(object providerName, string startDay, string endDay, string startMonth, string startYear, string endMonth, string endYear, string selectHost, string textHost, string selectIP, string textIP, string selectRecs, object textRecs, string selectQuery, string textQuery, string selectSchema, object textSchema, Utility.OrderedMap resources, bool textbox, bool astab)
		{
			Flatfile db_connection;
			AndWhereClause fieldClauses;
			string strClause;
			string strClauseAnd;
			bool newClause;
			string ipv4Regex;
			Utility.OrderedMap resourceArray;
			string dlResourceArgs;
			int dlResourceCount;
			string resourceClause;
			int resCount;
			int currentRes;
			string currentMonth;
			string currentYear;
			Utility.OrderedMap numMatchesFound = new Utility.OrderedMap();
			Utility.OrderedMap numRecsReturned = new Utility.OrderedMap();
			Utility.OrderedMap rows;
			string end;
			object filename;
			Utility.OrderedMap newRows;
			bool doStartDayCheck;
			bool doEndDayCheck;
			int index;
			int removed;
			string day;
			object numSearchMatchesFound;
			object numInventoryMatchesFound;
			object numSearchRecordsFound;
			object numInventoryRecordsFound;
			string dlLink;
			string returnValue;
			double totalRecords;
			double textrows;
			int TBL_WHERE_OFFSET;
			int TBL_SCHEMA_OFFSET;
			object date;
			object time;
			string host;
			string recs;
			string query;
			string schema;
			string resource;
			string type;
			
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			
			fieldClauses = new AndWhereClause();
			strClause = "";
			strClauseAnd = "";
			newClause = System.Convert.ToBoolean(null);
			
			//global $mainPage
			
			if (System.Convert.ToBoolean(get_magic_quotes_runtime()) || System.Convert.ToBoolean(get_magic_quotes_gpc()))
			{
				textHost = Utility.StringSupport.RemoveSlashes(textHost);
				textIP = Utility.StringSupport.RemoveSlashes(textIP);
				textQuery = Utility.StringSupport.RemoveSlashes(textQuery);
			}
			
			switch (selectHost)
			{
				
				case "starts with": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_HOST, "source_host=" + textHost + "%"));strClause += "Host name starts with " + textHost;break;
				
				case "ends with": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_HOST, "source_host=%" + textHost));strClause += "Host name ends with " + textHost;break;
				
				case "com": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_HOST, "source_host=%.com"));strClause += "Host name is from .com";break;
				
				case "edu": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_HOST, "source_host=%.edu"));strClause += "Host name is from .edu";break;
				
				case "gov": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_HOST, "source_host=%.gov"));strClause += "Host name is from .gov";break;
				
				case "regex": newClause = Utility.TypeSupport.ToBoolean(new RegexWhereClause(TBL_MONTH_SOURCE_HOST, textHost));strClause += "Host name matches regular expression " + textHost;break;
				
				case "contains": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_HOST, "source_host=%" + textHost + "%"));strClause += "Host name contains \"" + textHost + "\"";break;
				
				case "equals": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_SOURCE_HOST, "=", "source_host=" + textHost, STRING_COMPARISON));strClause += "Host name is " + textHost;break;
				
				case "localhost": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_SOURCE_HOST, "=", "source_host=localhost", STRING_COMPARISON));strClause += "Host name is localhost";break;
				
				case "is an ip": ipv4Regex = "(\\d|[1-9]\\d|1\\d\\d|2[0-4]\\d|25[0-5])";newClause = Utility.TypeSupport.ToBoolean(new RegexWhereClause(TBL_MONTH_SOURCE_HOST, "/^source_host.*" + ipv4Regex + "\\." + ipv4Regex + "\\." + ipv4Regex + "\\." + ipv4Regex + "$/"));strClause += "Host name did not resolve";break;
				
			}
			
			if (newClause)
			{
				fieldClauses.add(newClause);
				strClauseAnd = " and ";
			}
			
			newClause = System.Convert.ToBoolean(null);
			
			switch (selectIP)
			{
				
				case "starts with": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_IP, "source_ip=" + textIP + "%"));strClause += strClauseAnd + "IP Address starts with " + textIP;break;
				
				case "ends with": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_IP, "source_ip=%" + textIP));strClause += strClauseAnd + "IP Address ends with " + textIP;break;
				
				case "regex": newClause = Utility.TypeSupport.ToBoolean(new RegexWhereClause(TBL_MONTH_SOURCE_IP, textIP));strClause += strClauseAnd + "IP Address matches regular expression " + textIP;break;
				
				case "contains": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SOURCE_IP, "source_ip=%" + textIP + "%"));strClause += strClauseAnd + "IP Address contains \"" + textIP + "\"";break;
				
				case "equals": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_SOURCE_IP, "=", "source_ip=" + textIP, STRING_COMPARISON));strClause += strClauseAnd + "IP Address is " + textIP;break;
				
				case "localhost": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_SOURCE_IP, "=", "source_ip=127.0.0.1", STRING_COMPARISON));strClause += strClauseAnd + "IP Address is localhost";break;
				
			}
			if (newClause)
			{
				fieldClauses.add(newClause);
				strClauseAnd = " and ";
			}
			
			newClause = System.Convert.ToBoolean(null);
			
			switch (selectRecs)
			{
				
				case "less than": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_RETURNEDRECS, "<", "returnedrecs=" + textRecs, STRING_COMPARISON));strClause += strClauseAnd + "Records returned is less than " + textRecs;break;
				
				case "greater than": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_RETURNEDRECS, ">", "returnedrecs=" + textRecs, STRING_COMPARISON));strClause += strClauseAnd + "Records returned is greater than " + textRecs;break;
				
				case "equals": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_RETURNEDRECS, "=", "returnedrecs=" + textRecs, STRING_COMPARISON));strClause += strClauseAnd + "Records returned is " + textRecs;break;
				
			}
			
			if (newClause)
			{
				fieldClauses.add(newClause);
				strClauseAnd = " and ";
			}
			
			newClause = System.Convert.ToBoolean(null);
			
			switch (selectQuery)
			{
				
				//BUGBUG the leading white space for "whereclause=<space>"could cause problems
				case "regex": newClause = Utility.TypeSupport.ToBoolean(new RegexWhereClause(TBL_MONTH_SOURCE_HOST, Utility.StringSupport.RemoveSlashes(textQuery)));strClause += strClauseAnd + "search clause matches regular expression " + Utility.StringSupport.RemoveSlashes(textQuery);break;
				
				case "contains": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_WHERE, "whereclause= %" + textQuery + "%"));strClause += strClauseAnd + "search clause contains \"" + textQuery + "\"";break;
				
				case "equals": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_WHERE, "=", "whereclause= " + textQuery, STRING_COMPARISON));strClause += strClauseAnd + "search clause equals " + textQuery;break;
				
			}
			
			if (newClause)
			{
				fieldClauses.add(newClause);
				strClauseAnd = " and ";
			}
			
			newClause = System.Convert.ToBoolean(null);
			
			switch (selectSchema)
			{
				
				case "any": break;
				
				case "inventory": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_TYPE, "=", "type=inventory", STRING_COMPARISON));strClause += strClauseAnd + "Schema is inventory";break;
				
				case "contains": newClause = Utility.TypeSupport.ToBoolean(new LikeWhereClause(TBL_MONTH_SCHEMA, "recstr=%" + textSchema + "%"));strClause += strClauseAnd + "Schema contains " + textSchema;break;
				
				case "equals": newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_SCHEMA, "=", "recstr=" + textSchema, STRING_COMPARISON));strClause += strClauseAnd + "Schema is " + textSchema;break;
				
				default: newClause = Utility.TypeSupport.ToBoolean(new SimpleWhereClause(TBL_MONTH_SCHEMA, "=", "recstr=" + selectSchema, STRING_COMPARISON));strClause += strClauseAnd + "Schema is " + selectSchema;break;
				
			}
			
			if (newClause)
			{
				fieldClauses.add(newClause);
				strClauseAnd = " and ";
			}
			
			newClause = System.Convert.ToBoolean(null);
			resourceArray = new Utility.OrderedMap();
			
			dlResourceArgs = "";
			dlResourceCount = 0;
			
			resourceClause = "";
			
			foreach ( object resource in resources.Values ) {
				if (Utility.TypeSupport.ToString(resource1) == "all")
				{
					resourceArray = new Utility.OrderedMap();
					dlResourceArgs = "&resource[0]=all";
					resourceClause = "For all resources ";
					break;
				}
				else
				{
					resourceArray.Push("resource=" + resource1);
					dlResourceArgs += "&resource[" + dlResourceCount + "]=" + resource1;
					dlResourceCount++;
				}
			}
			
			
			resCount = Utility.OrderedMap.CountElements(resourceArray);
			if (resCount > 0)
			{
				newClause = Utility.TypeSupport.ToBoolean(new ListWhereClause(TBL_MONTH_RESOURCE, resourceArray));
				fieldClauses.add(newClause);
				
				if (resCount > 1)
				{
					resourceClause = "For Resources ";
				}
				else
				{
					resourceClause += "For Resource ";
				}
				
				currentRes = 0;
				
				foreach ( object resource in resources.Values ) 
				{
					currentRes++;
					resourceClause += " " + resource1;
					if (currentRes != resCount)
					{
						resourceClause += ", ";
					}
				}
				
			}
			
			strClause = "Report equals: " + resourceClause + " where " + strClause;
			//BUGBUG security flaw, a person could hand craft get params to cause near inifinite query
			//try to reduce it here
			//end security flaw
			
			//normalize years in case person didn't set them properly
			if (endYear.CompareTo(startYear) < 0)
			{
				endYear = startYear;
				endMonth = startMonth;
			}
			
			if (startYear == endYear && endMonth.CompareTo(startMonth) < 0)
			{
				endMonth = startMonth;
			}
			
			currentMonth = startMonth;
			currentYear = startYear;
			
			numMatchesFound = new Utility.OrderedMap();
			numRecsReturned = new Utility.OrderedMap();
			
			rows = new Utility.OrderedMap();
			
			
			while (currentYear.CompareTo(endYear) <= 0)
			{
				if (currentYear != endYear)
				{
					end = 12.ToString();
				}
				else
				{
					end = endMonth;
				}
				
				while (currentMonth.CompareTo(end) <= 0)
				{
					
					filename = getLogFileName(currentMonth, currentYear);
					newRows = Utility.TypeSupport.ToArray(db_connection.selectWhere(filename, fieldClauses));
					
					doStartDayCheck = System.Convert.ToBoolean(0);
					doEndDayCheck = System.Convert.ToBoolean(0);
					
					if (startMonth == currentMonth && currentYear == startYear)
					{
						doStartDayCheck = System.Convert.ToBoolean(1);
					}
					
					if (endMonth == currentMonth && currentYear == endYear)
					{
						doEndDayCheck = System.Convert.ToBoolean(1);
					}
					
					index = 0;
					foreach ( object row in newRows.Values ) {
						removed = 0;
						if (doStartDayCheck || doEndDayCheck)
						{
							day = row[TBL_MONTH_DATE].Substring(4, 2);
							
							if (doStartDayCheck && !doEndDayCheck)
							{
								if (day.CompareTo(startDay) < 0)
								{
									Utility.OrderedMap.Splice(ref newRows, index, 1, null);
									removed = 1;
									index--;
								}
							}
							else if (!doStartDayCheck && doEndDayCheck)
							{
								if (day.CompareTo(endDay) > 0)
								{
									Utility.OrderedMap.Splice(ref newRows, index, 1, null);
									removed = 1;
									index--;
								}
							}
							else
							{
								if (!(day.CompareTo(endDay) <= 0 && day.CompareTo(startDay) >= 0))
								{
									Utility.OrderedMap.Splice(ref newRows, index, 1, null);
									removed = 1;
									index--;
								}
							}
						}
						if (!System.Convert.ToBoolean(removed))
						{
							numRecsReturned[row[TBL_MONTH_METHOD]] = Utility.TypeSupport.ToDouble(numRecsReturned[row[TBL_MONTH_METHOD]]) + Utility.TypeSupport.ToDouble(Utility.StringSupport.LastSubstring(row[TBL_MONTH_RETURNEDRECS], "=").Substring(1));
							numMatchesFound[row[TBL_MONTH_METHOD]] = Utility.TypeSupport.ToDouble(numMatchesFound[row[TBL_MONTH_METHOD]]) + 1;
						}
						index++;
					}
					
					rows = Utility.OrderedMap.Merge(rows, newRows);
					currentMonth = (Utility.TypeSupport.ToDouble(currentMonth) + 1).ToString();
				}
				
				currentYear = (Utility.TypeSupport.ToDouble(currentYear) + 1).ToString();
				currentMonth = 1.ToString();
			}
			
			numSearchMatchesFound = numMatchesFound["op=search"];
			numInventoryMatchesFound = numMatchesFound["op=inventory"];
			numSearchRecordsFound = numRecsReturned["op=search"];
			numInventoryRecordsFound = numRecsReturned["op=inventory"];
			
			dlLink = "<A HREF=\"" + mainPage + "?action=custom&selectHost=" + selectHost + "&textHost=" + textHost + "&selectIP=" + selectIP + "&textIP=" + textIP + "&selectRecs=" + selectRecs + "&textRecs=" + textRecs + "&selectQuery=" + selectQuery + "&textQuery=" + textQuery + "&selectSchema=" + selectSchema + "&textSchema=" + textSchema + "&resource%5B3%5D=MVZMaNISDwC2&startmonth=" + startMonth + "&startyear=" + startYear + "&startday=" + startDay + "&endmonth=" + endMonth + "&endyear=" + endYear + "&endday=" + endDay + dlResourceArgs + "&download=1\">Download</A>";
			
			//&generate=    &textbox%5Btextbox%5D=Display+in+a+text+box";
			
			
			
			if (astab)
			{
				Response.AppendHeader("Content-type: application/vnd.ms-excel", "");
				Response.AppendHeader("Content-disposition: attachment; filename=" + startMonth + startYear + "-" + endMonth + endYear + ".xls", "");
				returnValue += "Date\tTime\tResource\tSource\tRecords Returned\tType\tSearch Clause\tResults Schema\r\n";
			}
			else
			{
				totalRecords = 0;
				foreach ( object type in numRecsReturned.Values ) {
					totalRecords = totalRecords + Utility.TypeSupport.ToDouble(type1);
				}
				
				returnValue = "<TABLE border=1>\r\n";
				returnValue += "<TR><TD colspan=8>Queries: " + numSearchMatchesFound + "<BR>Records returned: " + numSearchRecordsFound + "<BR>Inventories: " + numInventoryMatchesFound + "<BR>Records returned: " + numInventoryRecordsFound + "<BR>Total records: " + totalRecords + "<br>" + strClause + " from " + startMonth + " " + startDay + " " + startYear + " to " + endMonth + " " + endDay + " " + endYear + "<BR>" + dlLink + "</TD></TR>\r\n";
				if (!textbox)
				{
					returnValue += "<TR><TD>Date</TD><TD>Time</TD><TD>Resource</TD><TD>Source</TD><TD>Records Returned</TD><TD>Type</TD><TD>Search Clause</TD><TD>Results Schema</TD></TR>\r\n";
				}
			}
			
			if (textbox && !astab)
			{
				textrows = Utility.OrderedMap.CountElements(rows) + 1;
				if (textrows < 4)
				{
					textrows = 4;
				}
				returnValue += "<TR>\r\n" +
"                            <TD COLSPAN=\"8\">\r\n" +
"                                <FORM name=\"textarea\">\r\n" +
"                                <TEXTAREA COLS=60 ROWS=" + textrows + " WRAP=OFF name=\"textresults\">\r\n" +
"Date\tTime\tResource\tSource\tRecords Returned\tType\tSearch Clause\tResults Schema\r\n";
			}
			
			
			TBL_WHERE_OFFSET = TBL_MONTH_WHERE;
			TBL_SCHEMA_OFFSET = TBL_MONTH_SCHEMA;
			
			//Inventory records are different than search records
			
			foreach ( object row in rows.Values ) {
				if (!textbox && !astab)
				{
					returnValue += "<TR>";
				}
				
				date = row[TBL_MONTH_DATE];
				time = row[TBL_MONTH_TIME];
				
				resource = Utility.StringSupport.LastSubstring(row[TBL_MONTH_RESOURCE], "=").Substring(1);
				host = Utility.StringSupport.LastSubstring(row[TBL_MONTH_SOURCE_HOST], "=").Substring(1);
				recs = Utility.StringSupport.LastSubstring(row[TBL_MONTH_RETURNEDRECS], "=").Substring(1);
				type = Utility.StringSupport.LastSubstring(row[TBL_MONTH_METHOD], "=").Substring(1);
				
				if (type == "inventory")
				{
					TBL_WHERE_OFFSET = TBL_MONTH_WHERE_INV;
					TBL_SCHEMA_OFFSET = TBL_MONTH_COLUMN_INV;
				}
				
				query = row[TBL_WHERE_OFFSET].Substring(row[TBL_WHERE_OFFSET].IndexOf("=") + 1);
				schema = Utility.StringSupport.LastSubstring(row[TBL_SCHEMA_OFFSET], "=").Substring(1);
				
				
				
				//          $query    = substr( $row[ TBL_MONTH_WHERE ], strpos( $row[ TBL_MONTH_WHERE ], "=" )+1);
				//          $schema   = substr( strrchr( $row[ TBL_MONTH_SCHEMA ], "=" ),1);
				
				if (type == "inventory")
				{
					query = "DISTINCT " + schema;
				}
				
				if (textbox || astab)
				{
					returnValue += date + "\t" + time + "\t" + resource + "\t" + host + "\t" + recs + "\t" + type + "\t" + query + "\t" + schema + "\r\n";
				}
				else
				{
					returnValue += "<TD>" + date + "</TD>";
					returnValue += "<TD>" + time + "</TD>";
					returnValue += "<TD>" + resource + "</TD>";
					returnValue += "<TD>" + host + "</TD>";
					returnValue += "<TD>" + recs + "</TD>";
					returnValue += "<TD>" + type + "</TD>";
					returnValue += "<TD>" + query + "</TD>";
					returnValue += "<TD>" + schema + "</TD>";
					returnValue += "</TR>\r\n";
				}
			}
			
			
			if (astab)
			{
				;
			}
			else if (textbox)
			{
				returnValue += "</TEXTAREA></FORM></TD></TR>";
			}
			
			if (!astab)
			{
				returnValue += "</TABLE>";
			}
			
			return returnValue;
		}
		public virtual object getCustomPageFooter(object month, object year, object resource, object columncount)
		{
			return getResourcePageFooter(month, year, resource, columncount);
		}
		public virtual string getCustomPage(object providerName, object startDay, object endDay, object startMonth, object startYear, object endMonth, object endYear, object selectHost, object textHost, object selectIP, object textIP, object selectRecs, object textRecs, object selectQuery, object textQuery, object selectSchema, object textSchema, object resources, object textbox, bool astab)
		{
			string returnValue;
			object month;
			object year;
			object resource;
			if (astab)
			{
				;
			}
			else
			{
				returnValue = getResourcePageHeader("Custom Report", "Custom Report", "", "", "", "");
			}
			
			returnValue += getCustomPageCenter(providerName, Utility.TypeSupport.ToString(startDay), Utility.TypeSupport.ToString(endDay), Utility.TypeSupport.ToString(startMonth), Utility.TypeSupport.ToString(startYear), Utility.TypeSupport.ToString(endMonth), Utility.TypeSupport.ToString(endYear), Utility.TypeSupport.ToString(selectHost), Utility.TypeSupport.ToString(textHost), Utility.TypeSupport.ToString(selectIP), Utility.TypeSupport.ToString(textIP), Utility.TypeSupport.ToString(selectRecs), textRecs, Utility.TypeSupport.ToString(selectQuery), Utility.TypeSupport.ToString(textQuery), Utility.TypeSupport.ToString(selectSchema), textSchema, Utility.TypeSupport.ToArray(resources), Utility.TypeSupport.ToBoolean(textbox), astab);
			if (astab)
			{
				;
			}
			else
			{
				returnValue = returnValue + Utility.TypeSupport.ToString(getCustomPageFooter(month, year, resource, 5));
			}
			
			return returnValue;
		}
		public virtual string generateAvailableMonthsForYear(object availableLogFileNames, object targetYear)
		{
			Utility.OrderedMap availableMonths;
			string returnValue;
			availableMonths = getAllMonths();
			
			
			foreach ( object month in availableMonths.Values ) {
				//$year = substr( $year, 0, 4 );
				//if( $year == $targetYear )
				//{
				returnValue += generateMonthLink(Utility.TypeSupport.ToString(month), Utility.TypeSupport.ToString(targetYear), Utility.TypeSupport.ToArray(availableLogFileNames));
				//}
			}
			
			return returnValue;
		}
		public virtual string generateAvailableDataTableRows(object availableLogFileNames)
		{
			//global $mainPage
			string returnValue;
			Utility.OrderedMap availableYears;
			returnValue = "";
			availableYears = new Utility.OrderedMap(System.DateTime.Now.ToString("Y"));
			availableYears = Utility.TypeSupport.ToArray(getAvailableYears(availableLogFileNames));
			
			foreach ( object year in availableYears.Values ) {
				returnValue += "\r\n" +
"                                <TR>\r\n" +
"                                    <TD>\r\n" +
"                                        <A HREF=\"" + mainPage + "?startmonth=01&startyear=" + year + "&endmonth=12&endyear=" + year + "\">\r\n" +
"                                            " + year + "\r\n" +
"                                        </A>\r\n" +
"                                    <TD>\r\n" +
"                                    </TD>\r\n" +
"                                    </TD>" + generateAvailableMonthsForYear(availableLogFileNames, year) + "                               </TR>";
			}
			
			return returnValue;
		}
		public virtual string getStatisticsMenu()
		{
			//                <TD class=\"border\" width=\"15%\" valign=\"top\">.
			
			//global $mainPage
			
			return "\r\n" +
"                    <!------------------ begin SIDE MENU ------------------>\r\n" +
"                    \r\n" +
"                    <A href=\"logfile_admin.aspx\" class=\"side_bar\">\r\n" +
"                        Log File Administration\r\n" +
"                    </A>\r\n" +
"                    <BR /><BR />\r\n" +
"                    <A href=\"" + mainPage + "\" class=\"side_bar\">\r\n" +
"                        Log File Statistics\r\n" +
"                    </A>\r\n" +
"                    <BR />\r\n" +
"                    <!------------------ end SIDE MENU ------------------>\r\n" +
"    ";
			//                </TD>
		}
		public virtual string getStatisticsCloser()
		{
			//                    </DIV>
			//                </TD>
			return "\r\n" +
"            </TR>\r\n" +
"        </TABLE>\r\n" +
"    </BODY>\r\n" +
"</HTML>\n";
		}
		public virtual string generateAvailableDataTable(object availableLogFileNames)
		{
			
			return "" + generateAvailableDataTableHeader() + generateAvailableDataTableRows(availableLogFileNames) + generateAvailableDataTableCloser();
			//. 
			//"                 </TD>\n";
		}
		public virtual string generateSelectTextPair(object selectName, object textName, object title, object selectData, object and)
		{
			string select;
			string return_val;
			select = generateOpenSelect(selectName, "") + generateDataForSelectBox(Utility.TypeSupport.ToArray(selectData), Utility.TypeSupport.ToInt32("any")) + generateCloseSelect();
			//<TD>
			//                      $and
			//                </TD>
			
			return_val = "\r\n" +
"                            <TR>\r\n" +
"                                <TD>\r\n" +
"                                    " + title + "\r\n" +
"                                </TD>\r\n" +
"                                <TD>\r\n" +
"                                    " + select + "\r\n" +
"                                </TD>\r\n" +
"                                <TD>\r\n" +
"                                    <INPUT TYPE=TEXT NAME=\"" + textName + "\">\r\n" +
"                                </TD>                                                                \r\n" +
"                            </TR>\r\n";
			return return_val;
		}
		public virtual string generateCheckbox(string name, object index, object text, string javascript, string checked_Renamed)
		{
			string returnValue;
			if (Utility.TypeSupport.ToBoolean(checked_Renamed))
			{
				checked_Renamed = "CHECKED";
			}
			
			name = name + "[" + index + "]";
			returnValue = "<INPUT TYPE=CHECKBOX NAME=\"" + name + "\" VALUE=\"" + text + "\" " + checked_Renamed + " onClick=\"" + javascript + "\">" + text + "<br>";
			
			return returnValue;
		}
		//BUGBUG might be better to pull from the xml file, or combine with results from XML file
		//resources with no hits won't show
		public virtual Utility.OrderedMap getResources()
		{
			string returnValue;
			Flatfile db_connection;
			Utility.OrderedMap rows;
			Utility.OrderedMap resources;
			
			returnValue = "";
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			rows = Utility.TypeSupport.ToArray(db_connection.selectAll(TP_STATISTICS_RESOURCE_TABLE));
			
			resources = new Utility.OrderedMap();
			
			foreach ( object row in rows.Values ) {
				resources.Push(row[TBL_RESOURCE]);
			}
			
			
			resources = Utility.OrderedMap.Unique(resources);
			
			Utility.OrderedMap.SortValue(ref resources, 0);
			return resources;
		}
		//BUGBUG might be better to pull from the xml file, or combine with results from XML file
		//resources with no hits won't show
		public virtual Utility.OrderedMap getSchemas()
		{
			Utility.OrderedMap returnValue;
			Flatfile db_connection;
			Utility.OrderedMap rows;
			Utility.OrderedMap schemas;
			
			returnValue = new Utility.OrderedMap();
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			rows = Utility.TypeSupport.ToArray(db_connection.selectAll(TP_STATISTICS_SCHEMA_TABLE));
			
			schemas = new Utility.OrderedMap();
			
			foreach ( object row in rows.Values ) {
				schemas.Push(row[TBL_SCHEMA_SCHEMA]);
			}
			
			
			schemas = Utility.OrderedMap.Unique(schemas);
			
			Utility.OrderedMap.SortValue(ref schemas, 0);
			return schemas;
		}
		public virtual string generateResources()
		{
			string returnValue;
			Utility.OrderedMap resources;
			double count;
			returnValue = generateCheckbox("resource", 0, "all", "", 1.ToString());
			resources = getResources();
			count = 0;
			foreach ( object resource in resources.Values ) {
				count = count + 1;
				returnValue += generateCheckbox("resource", count, resource, "", "");
			}
			
			return returnValue;
		}
		public virtual Utility.OrderedMap getDaysArray()
		{
			Utility.OrderedMap returnValue;
			return new Utility.OrderedMap(new object[]{"01", 1}, new object[]{"02", 2}, new object[]{"03", 3}, new object[]{"04", 4}, new object[]{"05", 5}, new object[]{"06", 6}, new object[]{"07", 7}, new object[]{"08", 8}, new object[]{"09", 9}, new object[]{"10", 10}, new object[]{"11", 11}, new object[]{"12", 12}, new object[]{"13", 13}, new object[]{"14", 14}, new object[]{"15", 15}, new object[]{"16", 16}, new object[]{"17", 17}, new object[]{"18", 18}, new object[]{"19", 19}, new object[]{"20", 20}, new object[]{"21", 21}, new object[]{"22", 22}, new object[]{"23", 23}, new object[]{"24", 24}, new object[]{"25", 25}, new object[]{"26", 26}, new object[]{"27", 27}, new object[]{"28", 28}, new object[]{"29", 29}, new object[]{"30", 30}, new object[]{"31", 31});
			return returnValue;
		}
		public virtual string generateDaysSelectBox(object name, object day)
		{
			string returnValue;
			
			returnValue = generateOpenSelect(name, "") + generateDataForSelectBox(getDaysArray(), Utility.TypeSupport.ToInt32(day)) + generateCloseSelect();
			
			return returnValue;
		}
		public virtual int compareURLs(string urlA, string urlB)
		{
			string A;
			string B;
			if (urlA == "custom")
			{
				return 0;
			}
			else if (urlA == "inventory")
			{
				if (urlB != "custom")
				{
					return 0;
				}
				return 1;
			}
			else
			{
				A = Utility.StringSupport.LastSubstring(urlA, "/").Substring(1);
				B = Utility.StringSupport.LastSubstring(urlB, "/").Substring(1);
				return Utility.StringSupport.StringCompare(A, B, true);
			}
		}
		public virtual string generateCustomQueryForm(object availableLogFileNames)
		{
			Utility.OrderedMap hostSelect;
			Utility.OrderedMap ipSelect;
			Utility.OrderedMap recsSelect;
			Utility.OrderedMap querySelect;
			Utility.OrderedMap basicSelect;
			Utility.OrderedMap tempArray = new Utility.OrderedMap();
			Utility.OrderedMap schemaSelect = new Utility.OrderedMap();
			string day;
			string month;
			string year;
			string return_val;
			
			//global $mainPage
			hostSelect = new Utility.OrderedMap(new object[]{"any", "any"}, new object[]{"starts with", "starts with"}, new object[]{"ends with", "ends with"}, new object[]{"contains", "contains"}, new object[]{"equals", "equals"}, new object[]{"regex", "regex (start with /^source_host=)"}, new object[]{"is an ip", "is an ip"}, new object[]{"localhost", "is localhost"}, new object[]{"edu", "ends with .edu"}, new object[]{"gov", "ends with .gov"}, new object[]{"com", "ends with .com"});
			//    $hostSelect     = array( "any" => "any", "starts with" => "starts with",    "ends with"    => "ends with",    "contains" =>"contains", "equals" =>"equals", "is an ip" =>"is an ip", "localhost" =>"localhost", "edu" =>".edu", "gov" =>".gov", "com" =>".com" );
			
			ipSelect = new Utility.OrderedMap(new object[]{"any", "any"}, new object[]{"starts with", "starts with"}, new object[]{"ends with", "ends with"}, new object[]{"contains", "contains"}, new object[]{"equals", "equals"}, new object[]{"regex", "regex (start with /^source_ip=)"}, new object[]{"localhost", "is localhost"});
			//    $ipSelect       = array( "any" => "any", "starts with" => "starts with",    "ends with"    => "ends with",    "contains" =>"contains", "equals" =>"equals", "localhost" =>"localhost" );
			
			recsSelect = new Utility.OrderedMap(new object[]{"any", "any"}, new object[]{"less than", "less than"}, new object[]{"greater than", "greater than"}, new object[]{"equals", "equals"});
			
			querySelect = new Utility.OrderedMap(new object[]{"any", "any"}, new object[]{"contains", "contains"}, new object[]{"regex", "regex (start with /^whereclause=\\s+)"}, new object[]{"equals", "equals"});
			//    $querySelect    = array( "any" => "any", "contains"    => "contains",       "equals" =>"equals" );
			
			basicSelect = new Utility.OrderedMap(new object[]{"any", "any"}, new object[]{"contains", "contains"}, new object[]{"equals", "equals"});
			
			//$schemaSelect   = array( "any" => "any", "contains"    => "TEXT: contains", "equals"       => "TEXT: equals", "custom" => "custom" , "inventory" => "inventory" );
			
			//BUGBUG ineffecient temp variable usage
			tempArray = getSchemas();
			
			Utility.OrderedMap.SortValue(ref tempArray, 0);
			
			schemaSelect = new Utility.OrderedMap();
			
			foreach ( object row in tempArray.Values ) {
				schemaSelect[row] = row;
			}
			
			schemaSelect = Utility.OrderedMap.Unique(schemaSelect);
			
			Utility.OrderedMap.SortValueUser(ref schemaSelect, "compareURLs", this);
			
			tempArray = new Utility.OrderedMap();
			foreach ( object ss in schemaSelect.Values ) {
				tempArray[ss] = "is " + ss;
			}
			
			
			
			schemaSelect = Utility.OrderedMap.Merge(basicSelect, tempArray);
			
			
			day = System.DateTime.Now.ToString("d");
			month = System.DateTime.Now.ToString("m");
			year = System.DateTime.Now.ToString("Y");
			
			return_val = "\r\n" +
"                            <TABLE>\r\n" +
"                                <TR>\r\n" +
"                                    <TD>\r\n" + generateFormOpen(mainPage, "custom", "custom", "GET") + "                                       <TABLE>\r\n" +
"                                            <TR>\r\n" +
"                                                <TD>\r\n" +
"                                                <TABLE>\r\n" + generateSelectTextPair("selectHost", "textHost", "Host Name", hostSelect, "") + generateSelectTextPair("selectIP", "textIP", "IP Address", ipSelect, "") + generateSelectTextPair("selectRecs", "textRecs", "Num Records", recsSelect, "") + generateSelectTextPair("selectQuery", "textQuery", "Query String", querySelect, "") + "                  	                        </TABLE> " + "                                               <TABLE>\r\n" + generateSelectTextPair("selectSchema", "textSchema", "Results Schema", schemaSelect, "") + "                   	                        </TABLE>" + generateResources() + "<BR>In Date Range<BR>" + generateMonthsSelectBox("startmonth", month) + generateYearsSelectBox("startyear", availableLogFileNames, year) + generateDaysSelectBox("startday", "01") + generateMonthsSelectBox("endmonth", month) + generateYearsSelectBox("endyear", availableLogFileNames, year) + generateDaysSelectBox("endday", day) + generateSubmitButton("generate", "View Report") + generateSubmitButton("download", "Download as Excel (Tab)") + generateRestButton("", "Clear Form") + "                                               </TD>\r\n" +
"                                            </TR>\r\n" +
"                                        </TABLE>\r\n" + Utility.TypeSupport.ToString(generateAsTextBox()) + generateFormClose() + "                                  </TD>\r\n" +
"                                </TR>\r\n" +
"                            </TABLE>\r\n";
			
			
			return return_val;
		}
		public virtual void  generateOrderBy()
		{
			//	"<BR>Order By<BR>" . 
			//	generateOrderBy() .
			
			// return "NOT IMPLEMENTED";
		}
		public virtual void  generateShowFields()
		{
			//	"<BR>Returning Fields<BR>" . 
			//	generateShowFields() .
			
			// return "NOT IMPLEMENTED";
		}
		public virtual string generatePeriodForm(object availableLogFileNames)
		{
			//global $mainPage
			string month;
			string year;
			string return_Renamed;
			month = System.DateTime.Now.ToString("m");
			year = System.DateTime.Now.ToString("Y");
			return_Renamed = "\r\n" + "                           <TABLE>\r\n" +
"                                <TR>\r\n" +
"                                    <TD>\r\n" + generateFormOpen(mainPage, "period", "period", "GET") + generateMonthsSelectBox("startmonth", month) + generateYearsSelectBox("startyear", availableLogFileNames, year) + generateMonthsSelectBox("endmonth", month) + generateYearsSelectBox("endyear", availableLogFileNames, year) + generateSubmitButton("view", "View Statistics") + generateFormClose() + "                                   </TD>\r\n" +
"                               </TR>\r\n" +
"                            </TABLE>\r\n";
			
			return return_Renamed;
		}
		public virtual string generateDataForSelectBox(Utility.OrderedMap availableData, int selectedKey)
		{
			string returnValue;
			string selected;
			returnValue = "";
			foreach ( object key in availableData.GetKeysOrderedMap(null).Values ) {
				selected = "";
				if (Utility.TypeSupport.ToInt32(key) == selectedKey)
				{
					selected = "SELECTED";
				}
				returnValue += "                               <OPTION value=\"" + key + "\" " + selected + ">" + Utility.TypeSupport.ToString(availableData[key]) + "\n";
			}
			
			
			return returnValue;
		}
		public virtual string generateAvailableMonthsForYearForSelectBox(object availableLogFileNames, object targetYear)
		{
			Utility.OrderedMap availableMonths;
			string returnValue;
			availableMonths = getAllMonths();
			foreach ( object month in availableMonths.Values ) {
				returnValue += generateMonthExists(Utility.TypeSupport.ToString(month), Utility.TypeSupport.ToString(targetYear), Utility.TypeSupport.ToArray(availableLogFileNames));
			}
			
			return returnValue;
		}
		public virtual string generateMonthExists(string targetMonth, string targetYear, Utility.OrderedMap availableLogFileNames)
		{
			string monthAsText;
			string returnValue;
			string targetFileName;
			monthAsText = monthNumberToText(targetMonth);
			returnValue = "";
			targetFileName = targetYear + "_" + targetMonth + ".tbl";
			foreach ( object availableDate in availableLogFileNames.Values ) {
				if (Utility.StringSupport.StringCompare(availableDate, targetFileName, true) == 0)
				{
					returnValue = "                                <OPTION value=\"" + monthAsText + targetYear + "\">" + monthAsText + " " + targetYear + "\n";
					break;
				}
			}
			
			
			return returnValue;
		}
		public virtual string generateOpenSelect(object name, object optionNull)
		{
			string returnValue;
			returnValue = "                            <SELECT name=\"" + name + "\">\n";
			//						<option value=\"0\">$optionNull\n";
			return returnValue;
		}
		public virtual string generateCloseSelect()
		{
			string returnValue;
			returnValue = "                            </SELECT>\n";
			return returnValue;
		}
		public virtual string generateFormOpen(object file, object action, object name, string method)
		{
			string returnValue;
			returnValue = "                            <FORM action=\"" + file + "\" method=\"" + method + "\" name=\"" + name + "\">\r\n" +
"                                                    <INPUT TYPE=hidden name=action VALUE=\"" + action + "\">\n";
			return returnValue;
		}
		public virtual object generateAsTextBox()
		{
			return generateCheckbox("textbox", "textbox", "Display in a text box", "", "");
		}
		public virtual string generateFormClose()
		{
			string returnValue;
			returnValue = "\r\n" +
"                                </FORM>";
			return returnValue;
		}
		//BUGBUG could be combined into a genric BUTTON maker
		//CONVERSION_NOTE: Conditional function 'generateSubmitButton' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string generateSubmitButton(object name, object value_Renamed)
		{
			string returnValue;
			returnValue = "                            <INPUT type=\"submit\" name=\"" + name + "\" value=\"" + value_Renamed + "\">";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'generateRestButton' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string generateRestButton(object name, object value_Renamed)
		{
			string returnValue;
			returnValue = "                            <INPUT type=\"reset\" name=\"" + name + "\" value=\"" + value_Renamed + "\">";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'generatePeriodSelectBoxes' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string generatePeriodSelectBoxes(object startingPeriod, object Start_Month, object availableLogFileNames)
		{
			return generateOpenSelect(startingPeriod, Start_Month) + Utility.TypeSupport.ToString(generateAvailableDataSelectBox(availableLogFileNames)) + generateCloseSelect();
		}
		//CONVERSION_NOTE: Conditional function 'generateYearsSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string generateYearsSelectBox(object name, object availableLogFileNames, object year)
		{
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			return generateOpenSelect(name, "") + generateDataForSelectBox(Utility.TypeSupport.ToArray(getAvailableYears(availableLogFileNames)), Utility.TypeSupport.ToInt32(year)) + generateCloseSelect();
		}
		//CONVERSION_NOTE: Conditional function 'generateMonthsSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string generateMonthsSelectBox(object name, object month)
		{
			
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			return generateOpenSelect(name, "") + generateDataForSelectBox(getAllMonthsAsText(), Utility.TypeSupport.ToInt32(month)) + generateCloseSelect();
		}
		//CONVERSION_NOTE: Conditional function 'getResourcePageHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourcePageHeader(object title, object header, object month, object day, object year, object resource)
		{
			//global $mainPage
			string action;
			string link;
			object monthStr;
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			action = (Request.QueryString["action"] != null)?Utility.TypeSupport.ToString(Request.QueryString["action"]):"";
			
			link = "<A HREF=\"" + mainPage + "\">Database Query Statistics</A>";
			
			monthStr = monthNumberToText(Utility.TypeSupport.ToString(month));
			if (action == "summary")
			{
				link += " > " + resource + " Queries";
			}
			else if (action == "monthdetail")
			{
				
				//$link .= " > <A HREF=\"$mainPage?action=summary&month=$month&year=$year&resource=$resource\">$resource Queries</a>";
				link += " > " + monthStr + " " + year;
			}
			else if (action == "daydetail")
			{
				///$link .= " > <A HREF=\"$mainPage?action=summary&month=$month&year=$year&resource=$resource\">$resource Queries</a>";
				link += " > <A HREF=\"" + mainPage + "?action=monthdetail&month=" + month + "&year=" + year + "&day=" + day + "&resource=" + resource + "\">" + monthStr + " " + year + "</a>";
				link += " > " + monthStr + " " + day + ", " + year;
			}
			else if (action == "custom")
			{
				link += " > Custom Report";
			}
			
			return "\r\n" +
"<HTML><HEAD>\r\n" +
"<TITLE>" + title + "</TITLE>\r\n" +
"</HEAD>\r\n" +
"<BODY BGCOLOR=#FFFFFF>\r\n" +
"<table align=center width=90% border=0 cellspacing=0 cellpadding=0>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA>\r\n" +
"            <br>\r\n" +
"        </td>\r\n" +
"        <td align=left valign=bottom>\r\n" +
"            <table border=0 cellpadding=5>\r\n" +
"                <tr>\r\n" +
"                    <td align=left valign=bottom>\r\n" +
"                        <font face=\"Helvetica,Arial,Verdana\" color=23238E>\r\n" +
"                            <big><big>" + header + "</big></big>\r\n" +
"                        </font>&nbsp;&nbsp;\r\n" +
"                    </td>\r\n" +
"            </table>\r\n" +
"        </td>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=100% colspan=2 bgcolor=23238E>\r\n" +
"            <br>\r\n" +
"        </td>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA>\r\n" +
"        </td>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"            <center><i><small>" + link + "</small></i></center><p>\r\n" +
"        </td>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA>\r\n" +
"        </td>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>    \r\n";
		}
		//CONVERSION_NOTE: Conditional function 'getSchemaTDs' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getSchemaTDs(int schemaCount, ref object schemas, ref object db_connection, object month, object year, object resource, int totalMatches, int totalHits)
		{
			int i;
			AndWhereClause whereClause;
			Utility.OrderedMap rows;
			double percentHits;
			int hits;
			double percentMatches;
			int matches;
			string returnValue;
			
			for (i = 0; i < schemaCount; i++)
			{
				whereClause = new AndWhereClause();
				whereClause.add(new SimpleWhereClause(TBL_MONTH, "=", month));
				whereClause.add(new SimpleWhereClause(TBL_YEAR, "=", year));
				whereClause.add(new SimpleWhereClause(TBL_SCHEMA_SCHEMA, "=", schemas[i]));
				whereClause.add(new SimpleWhereClause(TBL_SCHEMA_RESOURCE, "=", resource));
				
				rows = Utility.TypeSupport.ToArray(db_connection.selectWhere(TP_STATISTICS_SCHEMA_TABLE, whereClause));
				percentHits = 0;
				hits = 0;
				percentMatches = 0;
				matches = 0;
				
				
				if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(rows)))
				{
					//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
					hits = Utility.TypeSupport.ToInt32(rows.GetValue(0, TBL_SCHEMA_HITS));
					percentHits = System.Math.Round((hits * 100) / totalHits);
					
					//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
					matches = Utility.TypeSupport.ToInt32(rows.GetValue(0, TBL_SCHEMA_MATCHES));
					percentMatches = System.Math.Round((matches * 100) / totalMatches);
				}
				
				returnValue += "\r\n" +
"            <TD align=right>\r\n" +
"                " + hits + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right >\r\n" +
"                <font color=009900>" + percentHits + " %</font>\r\n" +
"            </TD>\r\n" +
"            <TD align=right>\r\n" +
"                " + matches + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right >\r\n" +
"                <font color=009900>" + percentMatches + " %</font>\r\n" +
"            </TD>\r\n";
			}
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryRow' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceSummaryRow(ref Utility.OrderedMap row, object schemaCount, ref object schemas, ref object db_connection, object month, object year, bool doSchemas)
		{
			//global $mainPage
			int totalQueries;
			int totalMatches;
			int totalZeroMatches;
			int days;
			double averageQueriesDay;
			double averageMatchesDay;
			double zeroMatchesPercent;
			double averageMatchesPerQuery;
			object resource;
			object schemaTDs;
			object monthStr;
			string returnValue;
			
			month = row[TBL_MONTH];
			
			year = row[TBL_YEAR];
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalQueries = Utility.TypeSupport.ToInt32(row[TBL_HITS]);
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalMatches = Utility.TypeSupport.ToInt32(row[TBL_MATCHES]);
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalZeroMatches = Utility.TypeSupport.ToInt32(row[TBL_0_MATCHES]);
			
			days = Utility.TypeSupport.ToInt32(daysInMonth(month, year));
			
			averageQueriesDay = System.Math.Round(totalQueries / days);
			averageMatchesDay = System.Math.Round(totalMatches / days);
			zeroMatchesPercent = System.Math.Round((totalZeroMatches * 100) / totalQueries);
			averageMatchesPerQuery = System.Math.Round(totalMatches / totalQueries);
			resource = row[TBL_RESOURCE];
			
			if (doSchemas)
			{
				//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
				schemaTDs = getSchemaTDs(Utility.TypeSupport.ToInt32(schemaCount), ref schemas, ref db_connection, month, year, resource, totalMatches, totalQueries);
			}
			monthStr = monthNumberToText(Utility.TypeSupport.ToString(month));
			
			returnValue = "\r\n" +
"        <TR>\r\n" +
"            <TD>\r\n" +
"                <A HREF=\"" + mainPage + "?action=monthdetail&resource=" + resource + "&month=" + month + "&year=" + year + "\">" + monthStr + " " + year + "</a>\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + days + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + totalQueries + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + averageQueriesDay + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + totalMatches + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + averageMatchesPerQuery + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + totalZeroMatches + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                <font color=009900>" + zeroMatchesPercent + " %</font>\r\n" +
"            </TD>\r\n" +
"            " + schemaTDs + "\r\n" +
"        </TR>\r\n";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceSummaryTableHeader(int schemaCount, Utility.OrderedMap schemas, bool doSchemas)
		{
			string returnValue;
			int i;
			string schema;
			string hrefBegin;
			string hrefEnd;
			string schemaName;
			
			returnValue = "\r\n" +
"    <TABLE border>\r\n" +
"        <TR>\r\n" +
"            <TH>\r\n" +
"                Month\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Days\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Total<BR>Queries\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Queries<BR>\r\n" +
"                per Day\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Total<br>Records Returned\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Records Returned<BR>\r\n" +
"                per Query\r\n" +
"            </TH>\r\n" +
"            <TH colspan=2 bgcolor=DDDDDD>\r\n" +
"                Zero Records Returned<br>\r\n" +
"                Queries | %\r\n" +
"            </TH>\r\n";
			
			if (doSchemas)
			{
				for (i = 0; i < schemaCount; i++)
				{
					schema = Utility.TypeSupport.ToString(schemas[i]);
					
					
					hrefBegin = "<A HREF=" + schema + ">";
					hrefEnd = "</A>";
					
					if (schema == "custom")
					{
						schemaName = "custom";
						hrefBegin = "";
						hrefEnd = "";
					}
					else if (schema == "inventory")
					{
						schemaName = "inventory";
						hrefBegin = "";
						hrefEnd = "";
					}
					else
					{
						//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
						schemaName = Utility.StringSupport.LastSubstring(schema, "/").Substring(1);
					}
					
					returnValue += "\r\n" +
"                <TH colspan=4>\r\n" +
"                    " + hrefBegin + schemaName + hrefEnd + "<br>\r\n" +
"                    Queries | %<br>\r\n" +
"                    Records Returned | %<br>\r\n" +
"                </TH>\r\n" +
"    ";
				}
			}
			
			returnValue += "\r\n" +
"        </TR>\r\n";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getAvailableSchemas' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual void  getAvailableSchemas(ref int schemaCount, ref Utility.OrderedMap schemas, ref object db_connection, object resource)
		{
			Utility.OrderedMap orderBy;
			Utility.OrderedMap rows;
			int count;
			orderBy = new Utility.OrderedMap(new OrderBy(TBL_YEAR, DESCENDING, INTEGER_COMPARISON), new OrderBy(TBL_MONTH, DESCENDING, STRING_COMPARISON));
			rows = Utility.TypeSupport.ToArray(db_connection.selectWhere(TP_STATISTICS_SCHEMA_TABLE, new SimpleWhereClause(TBL_RESOURCE, "=", resource), - 1, orderBy));
			
			
			schemas = new Utility.OrderedMap();
			count = 0;
			
			foreach ( object row in rows.Values ) {
				schemas[count] = row[TBL_SCHEMA_SCHEMA];
				count++;
			}
			
			
			schemas = Utility.OrderedMap.Unique(schemas);
			Utility.OrderedMap.SortValue(ref schemas, 0);
			Utility.OrderedMap.SortValueUser(ref schemas, "compareURLs", this);
			schemaCount = Utility.OrderedMap.CountElements(schemas);
		}
		//BUGBUG this function has no protection from bad dates
		//CONVERSION_NOTE: Conditional function 'getAvailableSchemasForDateRange' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual void  getAvailableSchemasForDateRange(ref int schemaCount, ref Utility.OrderedMap schemas, ref object db_connection, object resource, object startMonth, int endMonth, int endMonth, object endYear)
		{
			Utility.OrderedMap orderBy;
			object rows;
			int beginStartMonth;
			int StartMonth;
			int beginEndMonth;
			Utility.OrderedMap allRows;
			object currentYear;
			int currentMonth;
			int beginMonth;
			int count;
			orderBy = new Utility.OrderedMap(new OrderBy(TBL_YEAR, DESCENDING, INTEGER_COMPARISON), new OrderBy(TBL_MONTH, DESCENDING, STRING_COMPARISON));
			rows = db_connection.selectWhere(TP_STATISTICS_SCHEMA_TABLE, new SimpleWhereClause(TBL_RESOURCE, "=", resource), - 1, orderBy);
			
			beginStartMonth = StartMonth;
			beginEndMonth = 12;
			
			allRows = new Utility.OrderedMap();
			//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
			//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
			for (currentYear = startYear; currentYear <= endYear; currentYear++)
			{
				//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
				if (currentYear == endYear)
				{
					beginEndMonth = endMonth;
				}
				
				for (currentMonth = beginStartMonth; currentMonth <= beginEndMonth; currentMonth++)
				{
					rows = db_connection.selectWhere(TP_STATISTICS_SCHEMA_TABLE, new SimpleWhereClause(TBL_RESOURCE, "=", resource), - 1, orderBy);
					allRows = Utility.OrderedMap.Merge(allRows, rows);
				}
				beginMonth = 1;
			}
			
			schemas = new Utility.OrderedMap();
			count = 0;
			
			foreach ( object row in allRows.Values ) {
				schemas[count] = row[TBL_SCHEMA_SCHEMA];
				count++;
			}
			
			
			schemas = Utility.OrderedMap.Unique(schemas);
			
			usort(schemas);
			
			schemaCount = Utility.OrderedMap.CountElements(schemas);
		}
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceSummaryCenter(object month, object year, object resource, ref object schemaCount, object doSchemas, object startMonth, object endMonth, object startYear, object endYear)
		{
			Flatfile db_connection;
			object schemas;
			Utility.OrderedMap rows;
			string returnValue;
			object currentMonth;
			object currentYear;
			int inRange;
			//CONVERSION_ISSUE: Language Construct 'require_once' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
			require_once(Utility.TypeSupport.ToString(TP_WWW_DIR) + "/" + "tapir_statistics.php");
			
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			
			
			
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			getAvailableSchemas(ref Utility.TypeSupport.ToInt32(schemaCount), ref (Utility.TypeSupport.ToArray(schemas))[0], ref db_connection, resource);
			
			//    $rows = $db_connection->selectAll( TP_STATISTICS_RESOURCE_TABLE );
			rows = Utility.TypeSupport.ToArray(db_connection.selectWhere(TP_STATISTICS_RESOURCE_TABLE, new SimpleWhereClause(TBL_RESOURCE, "=", resource)));
			rows = Utility.OrderedMap.Reverse(rows, false);
			
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			returnValue = getResourceSummaryTableHeader(Utility.TypeSupport.ToInt32(schemaCount), Utility.TypeSupport.ToArray(schemas), Utility.TypeSupport.ToBoolean(doSchemas));
			foreach ( object row in rows.Values ) {
				currentMonth = row[0];
				currentYear = row[1];
				
				inRange = 1;
				
				//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
				if (currentYear == startYear)
				{
					//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
					if (currentMonth < startMonth)
					{
						inRange = 0;
					}
				}
				
				//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
				if (currentYear == endYear)
				{
					//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
					if (currentMonth > endMonth)
					{
						inRange = 0;
					}
				}
				
				//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
				if (currentYear < startYear || currentYear > endYear)
				{
					inRange = 0;
				}
				
				if (System.Convert.ToBoolean(inRange))
				{
					returnValue += getResourceSummaryRow(ref (Utility.TypeSupport.ToArray(row))[0], schemaCount, ref schemas, ref db_connection, month, year, Utility.TypeSupport.ToBoolean(doSchemas));
				}
			}
			
			
			returnValue += "</table></td></tr>";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourcePageFooter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourcePageFooter(object month, object year, object resource, object columnCount)
		{
			return "\r\n" +
"</table>\r\n" +
"</body></html>\r\n";
		}
		//CONVERSION_NOTE: Conditional function 'getLogFileName' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getLogFileName(string month, string year)
		{
			if (month.Length < 2)
			{
				month = "0" + month;
			}
			return year + "_" + month + ".tbl";
		}
		//CONVERSION_NOTE: Conditional function 'daysInMonth' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string daysInMonth(object month, object year)
		{
			string year-;
			string month-01;
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			//CONVERSION_ISSUE: Method 'strtotime' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
			return Utility.DateTimeSupport.NewDateTime(strtotime(year- + month-01)).ToString("t");
		}
		//CONVERSION_NOTE: Conditional function 'convertRowToLine' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string convertRowToLine(Utility.OrderedMap row)
		{
			string returnValue;
			string element	;
			returnValue = "";
			foreach ( object element in row.Values ) {
				returnValue += element	;
			}
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceMonthDetailRow' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceMonthDetailRow(object month, object monthStr, int day, object year, int queries, int matches, int zeroMatches, int schemaCount, ref Utility.OrderedMap schemaHits, object resource, int dolink, int doSchemas)
		{
			//global $mainPage
			string nbsp;
			string space;
			double zeroMatchesPercent;
			string hrefBegin;
			string hrefEnd;
			string returnValue;
			int i;
			string schemaQueries;
			double schemaPercentQueries;
			string schemaMatches;
			double schemaPercentMatches;
			nbsp = "";
			if (day < 10)
			{
				space = " ";
				nbsp = "&nbsp;&nbsp;";
			}
			
			zeroMatchesPercent = System.Math.Round((zeroMatches * 100) / queries, 0);
			if (System.Convert.ToBoolean(dolink))
			{
				hrefBegin = "<A HREF=\"" + mainPage + "?action=daydetail&month=" + month + "&day=" + day + "&year=" + year + "&resource=" + resource + "\">";
				hrefEnd = "</a>";
			}
			
			returnValue = "\r\n" +
"        <TR>\r\n" +
"            <TD align=center>\r\n" +
"                " + hrefBegin + monthStr + " " + nbsp + day + hrefEnd + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + queries + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + matches + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                " + zeroMatches + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right bgcolor=EEEEEE>\r\n" +
"                <font color=009900>" + zeroMatchesPercent + " %</font>\r\n" +
"            </TD>\r\n";
			
			if (System.Convert.ToBoolean(doSchemas))
			{
				for (i = 0; i < schemaCount; i++)
				{
					
					
					schemaQueries = Utility.TypeSupport.ToString(schemaHits.GetValue(i, "queries"));
					schemaPercentQueries = System.Math.Round((Utility.TypeSupport.ToDouble(schemaHits.GetValue(i, "queries")) * 100) / queries, 0);
					
					schemaMatches = Utility.TypeSupport.ToString(schemaHits.GetValue(i, "matches"));
					schemaPercentMatches = System.Math.Round((Utility.TypeSupport.ToDouble(schemaHits.GetValue(i, "matches")) * 100) / matches, 0);
					if ((schemaQueries == "") && (schemaQueries.GetType() == null.GetType()))
					{
						schemaQueries = "0";
					}
					
					if ((schemaPercentQueries == System.Convert.ToDouble(null)) && (schemaPercentQueries.GetType() == null.GetType()))
					{
						schemaPercentQueries = Utility.TypeSupport.ToDouble("0");
					}
					if ((schemaMatches == "") && (schemaMatches.GetType() == null.GetType()))
					{
						schemaMatches = "0";
					}
					if ((schemaPercentMatches == System.Convert.ToDouble(null)) && (schemaPercentMatches.GetType() == null.GetType()))
					{
						schemaPercentMatches = Utility.TypeSupport.ToDouble("0");
					}
					
					returnValue += "\r\n" +
"                <TD align=right>\r\n" +
"                    " + schemaQueries + "\r\n" +
"                </TD>\r\n" +
"                <TD align=right>\r\n" +
"                    <font color=009000>" + schemaPercentQueries + " %</font>\r\n" +
"                </TD>\r\n" +
"                <TD align=right>\r\n" +
"                    " + schemaMatches + "\r\n" +
"                </TD>\r\n" +
"                <TD align=right>\r\n" +
"                    <font color=009000>" + schemaPercentMatches + " %</font>\r\n" +
"                </TD>\r\n" +
"    ";
				}
			}
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceMonthTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceMonthTableHeader(int schemaCount, Utility.OrderedMap schemas, bool doSchemas)
		{
			string returnValue;
			int i;
			string schema;
			string hrefBegin;
			string hrefEnd;
			string schemaName;
			returnValue = "\r\n" +
"    <TABLE border>\r\n" +
"        <TR>\r\n" +
"            <TH>\r\n" +
"                Day\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Queries\r\n" +
"            </TH>\r\n" +
"            <TH bgcolor=DDDDDD>\r\n" +
"                Records<br>Returned\r\n" +
"            </TH>\r\n" +
"            <TH colspan=2 bgcolor=DDDDDD>\r\n" +
"                Zero Records Returned<br>\r\n" +
"                Queries | %\r\n" +
"            </TH>\r\n";
			
			if (doSchemas)
			{
				for (i = 0; i < schemaCount; i++)
				{
					schema = Utility.TypeSupport.ToString(schemas[i]);
					
					hrefBegin = "<A HREF=" + schema + ">";
					hrefEnd = "</A>";
					
					if (schema == "custom")
					{
						schemaName = "custom";
						hrefBegin = "";
						hrefEnd = "";
					}
					else if (schema == "inventory")
					{
						schemaName = "inventory";
						hrefBegin = "";
						hrefEnd = "";
					}
					else
					{
						//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
						schemaName = Utility.StringSupport.LastSubstring(schema, "/").Substring(1);
					}
					
					returnValue += "\r\n" +
"                <TH colspan=4>\r\n" +
"                    " + hrefBegin + schemaName + hrefEnd + "<br>\r\n" +
"                    Queries | %<br>\r\n" +
"                    Records Returned | %<br>\r\n" +
"                </TH>\r\n" +
"    ";
				}
			}
			returnValue += "\r\n" +
"        </TR>\r\n";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceMonthDetailCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceMonthDetailCenter(string month, string year, object resource, int schemaCount, ref Utility.OrderedMap schemas, ref object db_connection, object doSchemas)
		{
			string returnValue;
			object filename;
			int daysInMonth;
			object monthStr;
			double totalMonthMatches;
			double totalMonthQueries;
			double totalMonthZeroMatches;
			Utility.OrderedMap totalMonthSchemaHits = new Utility.OrderedMap();
			int i;
			string space;
			AndWhereClause whereClause;
			Utility.OrderedMap rows;
			int queries;
			double matches;
			int zeroMatches;
			Utility.OrderedMap schemaHits = new Utility.OrderedMap();
			Utility.OrderedMap infoArray;
			int index;
			int j;
			
			
			returnValue = getResourceMonthTableHeader(schemaCount, schemas, Utility.TypeSupport.ToBoolean(doSchemas));
			
			filename = getLogFileName(month, year);
			
			daysInMonth = Utility.TypeSupport.ToInt32(daysInMonth(month, year));
			
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			if (month == Utility.DateTimeSupport.NewDateTime(Utility.DateTimeSupport.Time()).ToString("m") && year == Utility.DateTimeSupport.NewDateTime(Utility.DateTimeSupport.Time()).ToString("Y"))
			{
				//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
				daysInMonth = Utility.TypeSupport.ToInt32(Utility.DateTimeSupport.NewDateTime(Utility.DateTimeSupport.Time()).ToString("j"));
			}
			
			monthStr = monthNumberToText(month);
			
			totalMonthMatches = 0;
			totalMonthQueries = 0;
			totalMonthZeroMatches = 0;
			totalMonthSchemaHits = new Utility.OrderedMap();
			
			
			for (i = 1; i <= daysInMonth; i++)
			{
				space = "";
				if (i < 10)
				{
					space = "0";
				}
				
				whereClause = new AndWhereClause();
				
				whereClause.add(new SimpleWhereClause(TBL_MONTH_RESOURCE, "=", "resource=" + Utility.TypeSupport.ToString(resource)));
				whereClause.add(new SimpleWhereClause(TBL_MONTH_DATE, "=", monthStr + " " + space + i + " " + year));
				rows = Utility.TypeSupport.ToArray(db_connection.selectWhere(filename, whereClause));
				
				queries = 0;
				matches = 0;
				zeroMatches = 0;
				schemaHits = new Utility.OrderedMap();
				if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(rows)))
				{
					infoArray = new Utility.OrderedMap();
					foreach ( object row in rows.Values ) {
						parseDataLine(ref (infoArray)[0], convertRowToLine(Utility.TypeSupport.ToArray(row)));
						if (Utility.TypeSupport.ToBoolean(infoArray["wellformed"]) == true)
						{
							queries++;
							matches = matches + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
							//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
							if (Utility.TypeSupport.ToInt32(infoArray["returnedrecs"]) == 0)
							{
								zeroMatches++;
							}
							//BUGBUG bad, defaults to first index.
							index = 0;
							
							//BUGBUG this could be made much more effcient by associative arrays
							if (Utility.TypeSupport.ToString(infoArray["type"]) == "inventory")
							{
								for (j = 0; j < schemaCount; j++)
								{
									if (Utility.TypeSupport.ToString(schemas[j]) == "inventory")
									{
										index = j;
										j = schemaCount;
									}
								}
								schemaHits.SetValue(Utility.TypeSupport.ToDouble(schemaHits.GetValue(index, "matches")) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]), index, "matches");
								schemaHits.SetValue(Utility.TypeSupport.ToDouble(schemaHits.GetValue(index, "queries")) + 1, index, "queries");
							}
							else
							{
								//BUGBUG could be made much faster using associative array
								for (j = 0; j < schemaCount; j++)
								{
									//CONVERSION_WARNING: Converted Operator might not behave as expected. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1009.htm 
									if (schemas[j] == infoArray["recstr"])
									{
										index = j;
										j = schemaCount;
									}
								}
								schemaHits.SetValue(Utility.TypeSupport.ToDouble(schemaHits.GetValue(index, "matches")) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]), index, "matches");
								schemaHits.SetValue(Utility.TypeSupport.ToDouble(schemaHits.GetValue(index, "queries")) + 1, index, "queries");
							}
						}
					}
					
				}
				
				
				//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
				returnValue += getResourceMonthDetailRow(month, monthStr, i, year, queries, (int) (matches), zeroMatches, schemaCount, ref (schemaHits)[0], resource, 1, Utility.TypeSupport.ToInt32(doSchemas));
				
				totalMonthMatches = totalMonthMatches + matches;
				totalMonthQueries = totalMonthQueries + queries;
				totalMonthZeroMatches = totalMonthZeroMatches + zeroMatches;
				foreach ( object key in schemaHits.GetKeysOrderedMap(null).Values ) {
					totalMonthSchemaHits.SetValue(Utility.TypeSupport.ToDouble(totalMonthSchemaHits.GetValue(key, "queries")) + Utility.TypeSupport.ToDouble(schemaHits.GetValue(key, "queries")), key, "queries");
					totalMonthSchemaHits.SetValue(Utility.TypeSupport.ToDouble(totalMonthSchemaHits.GetValue(key, "matches")) + Utility.TypeSupport.ToDouble(schemaHits.GetValue(key, "matches")), key, "matches");
				}
				
			}
			
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			returnValue += getResourceMonthDetailRow("Total", "Total", Utility.TypeSupport.ToInt32(""), year, (int) (totalMonthQueries), (int) (totalMonthMatches), (int) (totalMonthZeroMatches), schemaCount, ref (totalMonthSchemaHits)[0], resource, 0, Utility.TypeSupport.ToInt32(doSchemas));
			
			returnValue += "\r\n" +
"</table></td></tr>\r\n";
			
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceSummaryPage(object providerName, object month, object year, object resource, object doSchemas, object startMonth, object endMonth, object startYear, object endYear)
		{
			string returnValue;
			int schemaCount;
			int schemas;
			Flatfile db_connection;
			returnValue = "";
			schemaCount = 0;
			schemas = 0;
			
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			getAvailableSchemas(ref schemaCount, ref (new Utility.OrderedMap(schemas))[0], ref db_connection, resource);
			
			
			//, $startMonth, $endMonth, $startYear, $endYear
			returnValue += getResourcePageHeader(providerName + ": " + resource + " Resource", resource, month, "1", year, resource);
			returnValue += getResourceSummaryCenter(month, year, resource, ref schemaCount, doSchemas, startMonth, endMonth, startYear, endYear);
			returnValue += getResourcePageFooter(month, year, resource, (schemaCount * 4) + 8);
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceMonthDetailPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceMonthDetailPage(object providerName, object month, object year, object resource, object doSchemas)
		{
			Flatfile db_connection;
			object monthStr;
			string title;
			object schemaCount;
			object schemas;
			string returnValue;
			object day;
			
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			monthStr = monthNumberToText(Utility.TypeSupport.ToString(month));
			title = providerName + ": " + resource + " " + monthStr + " " + year;
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			getAvailableSchemas(ref Utility.TypeSupport.ToInt32(schemaCount), ref (Utility.TypeSupport.ToArray(schemas))[0], ref db_connection, resource);
			returnValue = "";
			//CONVERSION_NOTE: One or more parameters were removed from the invocation to the 'getResourcePageHeader' function. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1015.htm 
			returnValue += getResourcePageHeader(title, title, month, day, year, resource);
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			returnValue += getResourceMonthDetailCenter(Utility.TypeSupport.ToString(month), Utility.TypeSupport.ToString(year), resource, Utility.TypeSupport.ToInt32(schemaCount), ref (Utility.TypeSupport.ToArray(schemas))[0], ref db_connection, doSchemas);
			returnValue += getResourcePageFooter(month, year, resource, (Utility.TypeSupport.ToDouble(schemaCount) * 4) + 8);
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getStatisticsPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getStatisticsPage(object providerName, object availableLogFileNames, object cachedMonthsFiles, bool startMonth, bool startYear, bool endMonth, bool endYear)
		{
			int count;
			string month;
			string year;
			object monthStr;
			string seperator;
			string period;
			string title;
			string returnValue;
			string resource;
			count = 0;
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			month = System.DateTime.Now.ToString("m");
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			year = System.DateTime.Now.ToString("Y");
			
			monthStr = monthNumberToText(month);
			
			
			if (startMonth == false || endMonth == false || startYear == false || endYear == false)
			{
				seperator = "";
				//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
				period = monthNumberToText(System.DateTime.Now.ToString("m")) + " " + System.DateTime.Now.ToString("Y");
			}
			else if (startYear == endYear && startMonth == endMonth)
			{
				period = monthNumberToText(startMonth?"1":"") + " " + (startYear?"1":"");
			}
			else
			{
				period = monthNumberToText(startMonth?"1":"") + " " + startYear + " - " + monthNumberToText(endMonth?"1":"") + " " + endYear;
			}
			
			title = providerName + ": Database Query Statistics for " + period;
			returnValue = getResourcePageHeader(title, title, month, "01", year, "");
			
			
			 /*
			<tr>
			<td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>
			<font face=\"Helvetica,Arial,Verdana\"><p></font>
			</td>
			<td>*/
			
			
			
			
			returnValue += "\r\n" +
"            </tr>\r\n" +
"    </TD>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"            <big><B>Query statistics for all resources for " + period + "</B></big>\r\n" +
"        </TD>\r\n" +
"    </TR>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n";
			
			
			returnValue += getResultsTables(availableLogFileNames, cachedMonthsFiles);
			
			
			returnValue += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"        <br>\r\n" +
"        <br>\r\n" +
"        <TD>\r\n" +
"    </TR>\r\n";
			
			
			returnValue += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"            <big><B>Select another reporting period</b></big>\r\n" +
"        <TD>\r\n" +
"    </TR>\r\n";
			returnValue += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n";
			
			
			//CONVERSION_NOTE: One or more parameters were removed from the invocation to the 'generateAvailableDataTable' function. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1015.htm 
			returnValue += generateAvailableDataTable(availableLogFileNames);
			
			returnValue += "\r\n" +
"       </TD>\r\n" +
"    </TR>\r\n";
			
			
			
			
			returnValue += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"            <BR>\r\n";
			
			returnValue += generatePeriodForm(availableLogFileNames);
			
			returnValue += "\r\n" +
"        </TD>\r\n" +
"    </TR>\r\n" +
"    <TR>\r\n" +
"        <td width=100% colspan=2 bgcolor=23238E>\r\n" +
"            <br>\r\n" +
"        </td>\r\n" +
"    </TR>        \r\n";
			
			returnValue += getCustomQueriesTable(availableLogFileNames);
			
			
			returnValue += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"                            <TD>\r\n" +
"                            <br>\r\n" +
"                            </TD>\r\n" +
"    </tr>\r\n";
			resource = "";// rdg: included this line because it must be defined somewhere (?)
			
			returnValue += getResourcePageFooter(month, year, resource, 4);
			//$returnValue .= "
			//        </TD>
			//  </TR>
			//";
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'findCachedFile' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual int findCachedFile(string startMonth, string startYear, Utility.OrderedMap cachedMonthsFiles)
		{
			int returnValue;
			int length;
			string targetFile;
			int i;
			object temp;
			return 0;
			returnValue = 0;
			length = Utility.OrderedMap.CountElements(cachedMonthsFiles);
			targetFile = startYear + "_" + startMonth + ".html";
			for (i = 0; i < length; i++)
			{
				temp = cachedMonthsFiles[i];
				if (Utility.TypeSupport.ToString(cachedMonthsFiles[i]) == targetFile)
				{
					//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
					returnValue = Utility.TypeSupport.ToInt32(cachedMonthsFiles[i]);
					i = length;
				}
			}
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResultsTables' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResultsTables(object availableLogFileNames, object cachedMonthsFiles)
		{
			string current_month;
			string current_year;
			string returnValue;
			string startMonth;
			string endMonth;
			string startYear;
			string endYear;
			string cacheFile;
			string textOutput;
			object resource;
			string tf;
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			current_month = System.DateTime.Now.ToString("m");
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			current_year = System.DateTime.Now.ToString("Y");
			
			returnValue = false?"1":"";
			
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			startMonth = (Request.QueryString["startmonth"] != null)?Utility.TypeSupport.ToString(Request.QueryString["startmonth"]):current_month;
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			endMonth = (Request.QueryString["endmonth"] != null)?Utility.TypeSupport.ToString(Request.QueryString["endmonth"]):current_month;
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			startYear = (Request.QueryString["startyear"] != null)?Utility.TypeSupport.ToString(Request.QueryString["startyear"]):current_year;
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			endYear = (Request.QueryString["endyear"] != null)?Utility.TypeSupport.ToString(Request.QueryString["endyear"]):current_year;
			
			cacheFile = findCachedFile(startMonth, startYear, Utility.TypeSupport.ToArray(cachedMonthsFiles)).ToString();
			if ((startMonth != endMonth) || (startYear != endYear) || ((startMonth == current_month) && (startYear == current_year)) || Utility.TypeSupport.ToInt32(cacheFile) == 0)
			// cache file doesn't exist
			{
				textOutput = "";
				returnValue = getResultsTableHeader(startMonth, startYear, endMonth, endYear);
				returnValue += getResultsTableCenter(startMonth, startYear, endMonth, endYear, availableLogFileNames, ref textOutput);
				returnValue += getResultsTableFooter(textOutput);
				 /*
				if( $startMonth == $endMonth && $startYear == $endYear && ( $startMonth != $current_month || $startYear != $current_year )   )
				{
				$cacheFile = TP_STATISTICS_DIR . $startYear . "_" . $startMonth . ".html";
				$resource = fopen( $cacheFile, "w+"  );
				if( $resource )
				{
				fwrite( $resource, $returnValue );
				fclose( $resrouce );
				}
				}
				*/
			}
			else
			{
				cacheFile = startYear + "_" + startMonth + ".html";
				//$returnValue = file_get_contents( TP_STATISTICS_DIR . $cacheFile );
				//CONVERSION_WARNING: Method 'fopen' was converted to 'Utility.FileSystemSupport.FileOpen' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/fopen.htm 
				resource = Utility.FileSystemSupport.FileOpen(TP_STATISTICS_DIR + cacheFile, "r");
				tf = TP_STATISTICS_DIR + cacheFile;
				if (Utility.TypeSupport.ToBoolean(resource))
				{
					//CONVERSION_WARNING: Method 'fread' was converted to 'Utility.FileSystemSupport.FileOpen' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/fread.htm 
					returnValue = Utility.FileSystemSupport.Read(resource, new System.IO.FileInfo(TP_STATISTICS_DIR + cacheFile).Length);
					//CONVERSION_WARNING: Method 'fclose' was converted to 'Utility.FileSystemSupport.Close' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/fclose.htm 
					Utility.FileSystemSupport.Close(resource);
				}
			}
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getCustomQueriesTable' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getCustomQueriesTable(object availableLogFileNames)
		{
			string returnVal;
			returnVal = "\r\n" +
" \r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <TD>\r\n" +
"            <BIG><B>Custom Report</B></big>\r\n" +
"        </TD>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"            <TABLE border>\r\n" +
"                <TR >\r\n" +
"                    <TD>\r\n";
			
			returnVal += generateCustomQueryForm(availableLogFileNames);
			returnVal += "\r\n" +
"                    </TD>\r\n" +
"                </TR>\r\n" +
"            </TABLE>\r\n" +
"        </TD>\r\n" +
"    </TR>\r\n" +
"    \r\n" +
"    \r\n" +
"    ";
			return returnVal;
		}
		//CONVERSION_NOTE: Conditional function 'getResultsTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResultsTableHeader(object startMonth, object startYear, object endMonth, object endYear)
		{
			object stringStartMonth;
			object stringEndMonth;
			stringStartMonth = monthNumberToText(Utility.TypeSupport.ToString(startMonth));
			stringEndMonth = monthNumberToText(Utility.TypeSupport.ToString(endMonth));
			
			 /*
			<TR>
			<TD colspan=\"1\">Start: $stringStartMonth $startYear</TD>
			<TD colspan=\"3\">End: $stringEndMonth $endYear</TD>
			</TR>*/
			
			
			
			return 
				"\r\n" +
"                            <TABLE border>\r\n" +
"                                <TR bgcolor=DFE5FA>\r\n" +
"                                    <TD colspan=2>\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"right\">\r\n" +
"                                    </TD>\r\n" +
"                                    <TD colspan=3 align=\"center\">\r\n" +
"                                        Search\r\n" +
"                                    </TD>\r\n" +
"                                    <TD colspan=3 align=\"center\">\r\n" +
"                                        Inventory\r\n" +
"                                    </TD>\r\n" +
"                                    <TD colspan=2 align=\"center\">\r\n" +
"                                        Total\r\n" +
"                                    </TD>\r\n" +
"                                    <TD colspan=2 align=\"center\">\r\n" +
"                                        Records Returned\r\n" +
"                                    </TD>\r\n" +
"                                </TR>\r\n" +
"                                <TR bgcolor=DFE5FA>\r\n" +
"                                    <TD colspan=2 align=\"center\">\r\n" +
"                                        Month\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Days\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Queries\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Records Returned\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        % of Total\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Queries\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Records Returned\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        % of Total\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Queries\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        Records Returned\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        per Day\r\n" +
"                                    </TD>\r\n" +
"                                    <TD align=\"center\">\r\n" +
"                                        per Query\r\n" +
"                                    </TD>\r\n" +
"                                </TR>\r\n"
				;
		}
		//CONVERSION_NOTE: Conditional function 'addMonthTodDate' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual double addMonthTodDate(double currentDate)
		{
			currentDate++;
			//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
			//CONVERSION_TODO: The equivalent in .NET for strval may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			if (Utility.TypeSupport.ToInt32(currentDate.ToString().Substring(4, 2)) == 13)
			{
				currentDate = currentDate + 100 - 12;
			}
			return currentDate;
		}
		//CONVERSION_NOTE: Conditional function 'parseDataLine' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual void  parseDataLine(ref Utility.OrderedMap dataArray, string dataLine)
		{
			Utility.OrderedMap infoArray;
			int elementCount;
			int i;
			Utility.OrderedMap element;
			
			//CONVERSION_WARNING: Method 'explode' was converted to 'System.String.Split' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/explode.htm 
			infoArray = new Utility.OrderedMap(dataLine.Split("\t".ToCharArray()));
			dataArray = new Utility.OrderedMap();
			dataArray["wellformed"] = false;
			//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
			if (infoArray[4].Substring(0, 4) == "type")
			{
				elementCount = Utility.OrderedMap.CountElements(infoArray);
				dataArray["wellformed"] = true;
				dataArray["time"] = infoArray[1];
				dataArray["destination_ip"] = infoArray[2];
				dataArray["date"] = infoArray[0];
				for (i = 4; i < elementCount; i++)
				{
					//CONVERSION_WARNING: Method 'explode' was converted to 'System.String.Split' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/explode.htm 
					element = new Utility.OrderedMap(infoArray[i].Split("=".ToCharArray()));
					if (Utility.TypeSupport.ToString(element[0]) == "filter")
					{
						//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
						dataArray["filter"] = infoArray[i].Substring(7);
					}
					else if (Utility.TypeSupport.ToString(element[0]) == "request")
					{
						dataArray["request"] = infoArray[i];
					}
					else if (Utility.TypeSupport.ToString(element[0]) == "whereclause")
					{
						//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
						dataArray["whereclause"] = infoArray[i].Substring(12);
					}
					else
					{
						dataArray[element[0]] = element[1];
					}
				}
			}
		}
		//CONVERSION_NOTE: Conditional function 'compareSchemaArray' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual int compareSchemaArray(Utility.OrderedMap recordA, Utility.OrderedMap recordB)
		{
			//CONVERSION_TODO: The equivalent in .NET for strcmp may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			return Utility.StringSupport.StringCompare(recordA[0], recordB[0], true);
		}
		//CONVERSION_NOTE: Conditional function 'getResultsTableCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResultsTableCenter(string startMonth, string startYear, string endMonth, string endYear, object availableLogFileNames, ref string textOutput)
		{
			//global $mainPage
			string period;
			string seperator;
			int doMonthDetailColumn;
			string monthDetailHeader;
			string columnHeader;
			string returnValue;
			string colorBackground1;
			string colorBackground2;
			double total_inventory_hits;
			double total_search_hits;
			double total_custom_hits;
			int currentPosition;
			bool notFound;
			int totalFiles;
			string tableCenter;
			int endDate;
			int currentDate;
			int startDate;
			bool continue_Renamed;
			Utility.OrderedMap destinationAddresses;
			Utility.OrderedMap sourceAddresses;
			Utility.OrderedMap sourceHosts;
			Utility.OrderedMap resources;
			Utility.OrderedMap returnedRecs = new Utility.OrderedMap();
			Utility.OrderedMap recordStructs = new Utility.OrderedMap();
			object daysCounted;
			Utility.OrderedMap resourceDaysCounted = new Utility.OrderedMap();
			double totalDaysCounted;
			int inventory_hits;
			int search_hits;
			int custom_hits;
			double inventory_matches;
			double search_matches;
			int custom_matches;
			string currentMonth;
			string currentYear;
			string file;
			object data;
			Utility.OrderedMap infoArray = new Utility.OrderedMap();
			string day;
			string currentColor;
			double monthHits;
			double monthMatches;
			double averageMatchesPerQuery;
			double inventoryPercentage;
			double searchPercentage;
			double customPercentage;
			double averageMatchesPerDay;
			double totalHits;
			int totalMatches;
			double totalInventoryPercentage;
			double totalSearchPercentage;
			double totalCustomPercentage;
			int totalInventoryHits;
			int totalSearchHits;
			int totalCustomHits;
			int count;
			string monthLinks;
			Utility.OrderedMap recsArray = new Utility.OrderedMap();
			Utility.OrderedMap customArray = new Utility.OrderedMap();
			Utility.OrderedMap inventoryArray = new Utility.OrderedMap();
			string name;
			string hrefBegin;
			string hrefEnd;
			object link;
			string hits;
			string total;
			string url;
			
			period = monthNumberToText(startMonth) + " " + startYear + " - " + monthNumberToText(endMonth) + " " + endYear;
			if (startMonth == (false?"1":"") || endMonth == (false?"1":"") || startYear == (false?"1":"") || endYear == (false?"1":"") || (startYear == endYear && startMonth == endMonth))
			{
				seperator = "";
				period = monthNumberToText(startMonth) + " " + startYear;
			}
			
			//BUGBUG always 1
			doMonthDetailColumn = 0;
			monthDetailHeader = "";
			
			columnHeader = "Resource";
			
			if (startMonth == endMonth && startYear == endYear)
			{
				doMonthDetailColumn = 1;
				columnHeader = "Month";
			}
			
			monthDetailHeader = "                                                <TD>\r\n" +
"                                                    " + columnHeader + " Detail\r\n" +
"                                                </TD>\r\n";
			
			textOutput = "";
			
			returnValue = "";
			
			colorBackground1 = "#DDDDFF";
			colorBackground2 = "#FFFFFF";
			
			total_inventory_hits = 0;
			total_search_hits = 0;
			total_custom_hits = 0;
			
			currentPosition = 0;
			notFound = true;
			
			totalFiles = Utility.OrderedMap.CountElements(availableLogFileNames);
			
			textOutput = "Date     \tTotal\tInv\tSearch\tCustom\n----------------------------------------------------------";
			tableCenter = "";
			
			endDate = Utility.VariableSupport.IntVal(endYear + endMonth, 10);
			
			currentDate = Utility.VariableSupport.IntVal(startYear + startMonth, 10);
			startDate = Utility.VariableSupport.IntVal(startYear + startMonth, 10);
			
			continue_Renamed = true;
			
			destinationAddresses = new Utility.OrderedMap();
			sourceAddresses = new Utility.OrderedMap();
			sourceHosts = new Utility.OrderedMap();
			resources = new Utility.OrderedMap();
			returnedRecs = new Utility.OrderedMap();
			recordStructs = new Utility.OrderedMap();
			
			
			daysCounted = new Utility.OrderedMap();
			resourceDaysCounted = new Utility.OrderedMap();
			totalDaysCounted = 0;
			
			while (currentDate <= endDate)
			{
				
				inventory_hits = 0;
				search_hits = 0;
				custom_hits = 0;
				
				inventory_matches = 0;
				search_matches = 0;
				custom_matches = 0;
				
				//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
				//CONVERSION_TODO: The equivalent in .NET for strval may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
				currentMonth = currentDate.ToString().Substring(4, 2);
				//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
				//CONVERSION_TODO: The equivalent in .NET for strval may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
				currentYear = currentDate.ToString().Substring(0, 4);
				
				file = TP_STATISTICS_DIR + "/" + currentYear + "_" + currentMonth + ".tbl";
				
				if (System.IO.File.Exists(file) || System.IO.Directory.Exists(file))
				{
					//CONVERSION_WARNING: Method 'fopen' was converted to 'Utility.FileSystemSupport.FileOpen' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/fopen.htm 
					data = Utility.FileSystemSupport.FileOpen(file, "r");
					
					if (Utility.TypeSupport.ToBoolean(data))
					{
						daysCounted = new Utility.OrderedMap();
						//CONVERSION_WARNING: Method 'feof' was converted to 'System.IO.FileStream.Position' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/feof.htm 
						while (!(data.Position >= data.Length))
						{
							
							//CONVERSION_WARNING: Method 'fgets' was converted to 'Utility.FileSystemSupport.ReadLine' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/fgets.htm 
							parseDataLine(ref (infoArray)[0], Utility.FileSystemSupport.ReadLine(data, 8192));
							
							if (Utility.TypeSupport.ToBoolean(infoArray["wellformed"]) == true)
							{
								//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
								day = infoArray["date"].Substring(4, 2);
								//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
								daysCounted[day]++;
								
								if (Utility.TypeSupport.ToString(infoArray["type"]) == "search" || Utility.TypeSupport.ToString(infoArray["type"]) == "custom")
								{
									search_hits++;
									search_matches = search_matches + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
								}
								else if (Utility.TypeSupport.ToString(infoArray["type"]) == "inventory")
								{
									inventory_hits++;
									inventory_matches = inventory_matches + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
								}
								else
								{
									infoArray["wellformed"] = false;
								}
								
								if (Utility.TypeSupport.ToBoolean(infoArray["wellformed"]) == true)
								{
									//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
									destinationAddresses[infoArray[1]]++;
									//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
									sourceAddresses[infoArray["source_ip"]]++;
									//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
									sourceHosts[infoArray["source_host"]]++;
									//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
									resources[infoArray["resource"]]++;
									
									resourceDaysCounted.SetValue(1, infoArray["resource"], currentMonth + " " + currentYear + " " + day);
									
									returnedRecs[infoArray["resource"]] = Utility.TypeSupport.ToDouble(returnedRecs[infoArray["resource"]]) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
									
									if (Utility.TypeSupport.ToString(infoArray["type"]) == "search" || Utility.TypeSupport.ToString(infoArray["type"]) == "custom")
									{
										returnedRecs["search"] = Utility.TypeSupport.ToDouble(returnedRecs["search"]) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
									}
									else
									{
										returnedRecs[infoArray["type"]] = Utility.TypeSupport.ToDouble(returnedRecs[infoArray["type"]]) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
									}
									
									//BUGBUG is a resource is named total, this will cause problems
									returnedRecs["total"] = Utility.TypeSupport.ToDouble(returnedRecs["total"]) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]);
									//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
									recordStructs.GetValue(infoArray["recstr"], "hits")++;
									recordStructs.SetValue(Utility.TypeSupport.ToDouble(recordStructs.GetValue(infoArray["recstr"], "total")) + Utility.TypeSupport.ToDouble(infoArray["returnedrecs"]), infoArray["recstr"], "total");
								}
							}
						}
					}
				}
				else
				{
					inventory_hits = Utility.TypeSupport.ToInt32("No Data");
					search_hits = Utility.TypeSupport.ToInt32("No Data");
					custom_hits = Utility.TypeSupport.ToInt32("No Data");
				}
				
				
				if (currentDate % 2 == 0)
				{
					currentColor = colorBackground1;
				}
				else
				{
					currentColor = colorBackground2;
				}
				daysCounted = Utility.OrderedMap.CountElements(daysCounted);
				totalDaysCounted = totalDaysCounted + Utility.TypeSupport.ToDouble(daysCounted);
				
				currentMonth = monthNumberToText(currentMonth);
				monthHits = inventory_hits + search_hits + custom_hits;
				monthMatches = inventory_matches + search_matches + custom_matches;
				
				if (monthHits > 0)
				{
					averageMatchesPerQuery = System.Math.Round(monthMatches / monthHits, 2);
					inventoryPercentage = System.Math.Round((inventory_hits * 100) / monthHits, 2);
					searchPercentage = System.Math.Round((search_hits * 100) / monthHits, 2);
					customPercentage = System.Math.Round((custom_hits * 100) / monthHits, 2);
				}
				else
				{
					averageMatchesPerQuery = 0;
					inventoryPercentage = 0;
					searchPercentage = 0;
					customPercentage = 0;
				}
				
				//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
				if (Utility.TypeSupport.ToInt32(daysCounted) > 0)
				{
					averageMatchesPerDay = System.Math.Round(monthMatches / Utility.TypeSupport.ToDouble(daysCounted), 2);
				}
				else
				{
					averageMatchesPerDay = 0;
				}
				 /*bgcolor=\"$currentColor\"*/
				tableCenter += "\r\n" +
"                                <TR >\r\n" +
"                                    <TD colspan=2> " + currentMonth + " " + currentYear + " </TD>\r\n" +
"                                    <TD align=\"right\"> " + daysCounted + " </TD>\r\n" +
"                                    <TD align=\"right\"> " + search_hits + " </TD><TD align=\"right\"> " + search_matches + " </TD><TD align=\"right\"><font color=009900>" + searchPercentage + " % </font></TD>\r\n" +
"                                    <TD align=\"right\"> " + inventory_hits + " </TD><TD align=\"right\"> " + inventory_matches + " </TD><TD align=\"right\"><font color=009900>" + inventoryPercentage + " % </font></TD>\r\n" +
"                                    <!--<TD align=\"right\">" + custom_hits + " / " + custom_hits + "</TD>\r\n" +
"                                    <TD align=\"right\">" + customPercentage + "</TD >-->\r\n" +
"                                    <TD align=\"right\"> " + monthHits + " </td><TD align=\"right\"> " + monthMatches + " </TD>\r\n" +
"                                    <TD align=\"right\"> " + averageMatchesPerDay + " </TD >\r\n" +
"                                    <TD align=\"right\"> " + averageMatchesPerQuery + " </TD >\r\n" +
"                                </TR>\r\n";
				
				textOutput += "\n" + currentMonth + " " + currentYear + "\t" + monthHits.ToString() + "\t" + inventory_hits.ToString() + "\t" + search_hits.ToString() + "\t" + custom_hits.ToString();
				total_inventory_hits = total_inventory_hits + inventory_hits;
				total_search_hits = total_search_hits + search_hits;
				total_custom_hits = total_custom_hits + custom_hits;
				currentDate = (int) (addMonthTodDate(currentDate));
			}
			
			totalHits = total_inventory_hits + total_search_hits + total_custom_hits;
			
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalMatches = (returnedRecs["total"] != null)?Utility.TypeSupport.ToInt32(returnedRecs["total"]):0;
			
			if (totalHits > 0)
			{
				totalInventoryPercentage = System.Math.Round((total_inventory_hits * 100) / totalHits, 2);
				totalSearchPercentage = System.Math.Round((total_search_hits * 100) / totalHits, 2);
				totalCustomPercentage = System.Math.Round((total_custom_hits * 100) / totalHits, 2);
				averageMatchesPerQuery = System.Math.Round(totalMatches / totalHits, 2);
			}
			else
			{
				totalInventoryPercentage = 0;
				totalSearchPercentage = 0;
				totalCustomPercentage = 0;
				averageMatchesPerQuery = 0;
			}
			
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalInventoryHits = (returnedRecs["inventory"] != null)?Utility.TypeSupport.ToInt32(returnedRecs["inventory"]):0;
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalSearchHits = (returnedRecs["search"] != null)?Utility.TypeSupport.ToInt32(returnedRecs["search"]):0;
			//CONVERSION_WARNING: Method 'isset' was converted to '!=' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/isset.htm 
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			totalCustomHits = (returnedRecs["custom"] != null)?Utility.TypeSupport.ToInt32(returnedRecs["custom"]):0;
			
			if (totalDaysCounted > 0)
			{
				averageMatchesPerDay = System.Math.Round(totalMatches / totalDaysCounted, 2);
			}
			else
			{
				averageMatchesPerDay = 0;
			}
			
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			if (totalSearchHits == Utility.TypeSupport.ToInt32(null))
			{
				totalSearchHits = 0;
			}
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			if (totalInventoryHits == Utility.TypeSupport.ToInt32(null))
			{
				totalInventoryHits = 0;
			}
			
			tableCenter += "\r\n" +
"                                <TR>\r\n" +
"                                    <TD colspan=2>Totals:</TD><TD align=right>" + totalDaysCounted + "</TD>\r\n" +
"                                    <TD align=\"right\">" + total_search_hits + "</TD><TD align=\"right\">" + totalSearchHits + "</TD><TD align=\"right\"><font color=009900>" + totalSearchPercentage + " %</font</TD>\r\n" +
"                                    <TD align=\"right\">" + total_inventory_hits + "</TD><TD align=\"right\">" + totalInventoryHits + "</TD><TD align=\"right\"><font color=009900>" + totalInventoryPercentage + " %</font></TD>\r\n" +
"                                    <!--<TD align=\"right\">" + total_custom_hits + "</TD><TD align=\"right\">" + totalCustomHits + "</TD><TD align=\"right\">" + totalCustomPercentage + "</TD>-->\r\n" +
"                                    <TD align=\"right\">" + totalHits + "</TD><TD align=\"right\"> " + totalMatches + "</TD>\r\n" +
"                                    <TD align=\"right\">" + averageMatchesPerDay + "</TD>\r\n" +
"                                    <TD align=\"right\">" + averageMatchesPerQuery + "</TD>\r\n" +
"                                </TR>\r\n" +
"                            </TABLE>\r\n" +
"                            </TD>\r\n" +
"                        </TR>\r\n";
			
			
			tableCenter += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"                            <TD>\r\n" +
"                                <BR>\r\n" +
"                                <BR>\r\n" +
"                            </TD>\r\n" +
"    </tr>\r\n" +
"    \r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"            <big><B>Statistics by resource for " + period + "</b></big>\r\n" +
"        </TD>\r\n" +
"    </TR>\r\n" +
"\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"        \r\n" +
"                                        <TABLE border>\r\n" +
"                                            <TR bgcolor=DFE5FA>\r\n" +
"                                                <TD>\r\n" +
"                                                    Resource Name\r\n" +
"                                                </TD>\r\n" + monthDetailHeader + 
				"\r\n" +
"                                                <TD>\r\n" +
"                                                    Days\r\n" +
"                                                </TD>\r\n" +
"                                                <TD >\r\n" +
"                                                    Searches\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    Records Returned\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    Queries per Day\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    Records Returned per Day\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    Records Returned per Query\r\n" +
"                                                </TD>\r\n" +
"                                            </TR>\r\n" +
"                            ";
			
			count = 0;
			Utility.OrderedMap.SortValuePreserve(ref resources, Utility.OrderedMap.SORTSTRING);
			
			foreach ( object resource in resources.GetKeysOrderedMap(null).Values ) {
				
				currentColor = colorBackground1;
				if (System.Convert.ToBoolean(count % 2))
				{
					currentColor = colorBackground2;
				}
				monthLinks = "";
				if (System.Convert.ToBoolean(doMonthDetailColumn))
				{
					monthLinks = "                                                <TD align=\"right\"> \r\n" +
"                                                    <A href=\"" + mainPage + "?action=monthdetail&resource=" + resource + "&month=" + startMonth + "&year=" + startYear + "&detailed=0\">simple</A>                                                     <A href=\"" + mainPage + "?action=monthdetail&resource=" + resource + "&month=" + startMonth + "&year=" + startYear + "&detailed=1\">detailed</A>\r\n" +
"                                                </TD>                                                \r\n";
				}
				else
				{
					monthLinks = "                                                <TD align=\"right\"> \r\n" +
"                                                    <A href=\"" + mainPage + "?action=summary&resource=" + resource + "&startmonth=" + startMonth + "&startyear=" + startYear + "&endmonth=" + endMonth + "&endyear=" + endYear + "&detailed=0\">simple</A> <A href=\"" + mainPage + "?action=summary&resource=" + resource + "&startmonth=" + startMonth + "&startyear=" + startYear + "&endmonth=" + endMonth + "&endyear=" + endYear + "&detailed=1\">detailed</A>\r\n" +
"                                                </TD>                                                \r\n";
				}
				
				 /*bgcolor=\"$currentColor\"*/
				tableCenter += "\r\n" +
"                                            <TR >\r\n" +
"                                                <TD>\r\n" +
"                                                    " + resource + "\r\n" +
"                                                </TD>\r\n" + monthLinks + "\r\n" +
"                                                <TD align=\"right\"> \r\n" +
"                                                    " + Utility.OrderedMap.CountElements(resourceDaysCounted[resource]).ToString() + "\r\n" +
"                                                </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + Utility.TypeSupport.ToString(resources[resource]) + "                                               </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + Utility.TypeSupport.ToString(returnedRecs[resource]) + "                                               </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + System.Math.Round(Utility.TypeSupport.ToDouble(resources[resource]) / Utility.TypeSupport.ToDouble(daysCounted)).ToString() + "                                               </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + System.Math.Round(Utility.TypeSupport.ToDouble(returnedRecs[resource]) / Utility.TypeSupport.ToDouble(daysCounted)).ToString() + "                                               </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + System.Math.Round(Utility.TypeSupport.ToDouble(returnedRecs[resource]) / Utility.TypeSupport.ToDouble(resources[resource])).ToString() + 
					"                                               </TD>\r\n" +
"                                            </TR>\r\n";
				count++;
			}
			
			
			tableCenter += "\r\n" +
"                                        </TABLE>\r\n" +
"                                    </TD>\r\n" +
"                                </TR>\r\n";
			
			
			tableCenter += "\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"                            <TD>\r\n" +
"                            <br>\r\n" +
"                            <br>\r\n" +
"                            </TD>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"                            <TD>\r\n" +
"                                <BIG><B>Statistics by Results Schema for " + period + "</B></big>\r\n" +
"                            </TD>\r\n" +
"    </tr>\r\n" +
"    <tr>\r\n" +
"        <td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>\r\n" +
"            <font face=\"Helvetica,Arial,Verdana\"><p></font>\r\n" +
"        </td>\r\n" +
"        <td>\r\n" +
"                                        <TABLE border>\r\n" +
"                                            <TR bgcolor=DFE5FA>\r\n" +
"                                                <TD>\r\n" +
"                                                    Results Schema\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    Queries\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    Returned Records\r\n" +
"                                                </TD>\r\n" +
"                                                <TD>\r\n" +
"                                                    URL\r\n" +
"                                                </TD>\r\n" +
"                                            </TR>\r\n";
			
			
			count = 0;
			
			recsArray = new Utility.OrderedMap();
			customArray = new Utility.OrderedMap();
			inventoryArray = new Utility.OrderedMap();
			count = 0;
			
			
			foreach ( object key in recordStructs.GetKeysOrderedMap(null).Values ) {
				if (Utility.TypeSupport.ToString(key).Length == 0)
				{
					name = "inventory";
					inventoryArray[0] = name;
					inventoryArray[1] = "inventory";
					inventoryArray[2] = recordStructs.GetValue("", "hits");
					inventoryArray[3] = recordStructs.GetValue("", "total");
					inventoryArray[4] = "&nbsp;";
				}
				else if (Utility.TypeSupport.ToString(key) == "custom")
				{
					customArray[0] = name;
					customArray[1] = "custom";
					customArray[2] = recordStructs.GetValue("custom", "hits");
					customArray[3] = recordStructs.GetValue("custom", "total");
					customArray[4] = "&nbsp;";
				}
				else
				{
					hrefBegin = "<A HREF=\"" + key + "\">";
					hrefEnd = "</A>";
					
					//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
					name = Utility.StringSupport.LastSubstring(key, "/").Substring(1);
					recsArray.SetValue(name, count, 0);
					recsArray.SetValue(name, count, 1);
					recsArray.SetValue(recordStructs.GetValue(key, "hits"), count, 2);
					recsArray.SetValue(recordStructs.GetValue(key, "total"), count, 3);
					recsArray.SetValue(hrefBegin + key + hrefEnd, count, 4);
					
					count++;
				}
			}
			
			
			Utility.OrderedMap.SortValueUser(ref recsArray, "compareSchemaArray", this);
			
			if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(inventoryArray)))
			{
				Utility.OrderedMap.Unshift(ref recsArray, inventoryArray);
			}
			
			if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(customArray)))
			{
				Utility.OrderedMap.Unshift(ref recsArray, customArray);
			}
			
			foreach ( object recstr in recsArray.Values ) {
				link = recstr[1];
				hits = Utility.TypeSupport.ToString(recstr[2]);
				total = Utility.TypeSupport.ToString(recstr[3]);
				url = Utility.TypeSupport.ToString(recstr[4]);
				
				currentColor = colorBackground1;
				if (System.Convert.ToBoolean(count % 2))
				{
					currentColor = colorBackground2;
				}
				
				 /*bgcolor=\"$currentColor\"*/
				tableCenter += "\r\n" +
"                                            <TR >\r\n" +
"                                                <TD align=\"left\">\r\n" +
"                                                    " + link + "\r\n" +
"                                                </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + hits + "                                               </TD>\r\n" +
"                                                <TD align=\"right\">\r\n" +
"                                                    " + total + "                                               </TD>\r\n" +
"                                                <TD align=\"left\">\r\n" +
"                                                    " + url + "                                               </TD>\r\n" +
"                                            </TR>\r\n";
				count++;
			}
			
			
			tableCenter += "\r\n" +
"                                        </TABLE>\r\n" +
"                                    </TD>\r\n" +
"                                </TR>\r\n";
			
			
			
			textOutput = textOutput + "\n" + "----------------------------------------------------------\nTotals:     \t" + totalHits.ToString() + "\t" + total_inventory_hits.ToString() + "\t" + total_search_hits.ToString() + "\t" + total_custom_hits.ToString();
			return returnValue + tableCenter;
		}
		//CONVERSION_NOTE: Conditional function 'getResultsTableFooter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResultsTableFooter(object textOutput)
		{
			return "";
			 /*
			return "
			<tr>
			<td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>
			<font face=\"Helvetica,Arial,Verdana\"><p></font>
			</td>
			<TD>
			<br>
			</TD>
			</tr>
			<tr>
			<td width=5% bgcolor=DFE5FA align=center valign=top>&nbsp;<p>
			<font face=\"Helvetica,Arial,Verdana\"><p></font>
			</td>
			<TD colspan=\"3\">
			<FORM name=\"textarea\">
			<TEXTAREA cols=\"80\" rows=\"20\" readonly>
			$textOutput
			</TEXTAREA>
			</FORM>
			</TD>
			</TR>
			";
			*/
		}
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceDayDetailPage(object providerName, object month, object day, object year, object resource, object textbox)
		{
			Flatfile db_connection;
			object monthStr;
			string title;
			object schemaCount;
			object schemas;
			string returnValue;
			db_connection = new Flatfile();
			db_connection.datadir = TP_STATISTICS_DIR;
			monthStr = monthNumberToText(Utility.TypeSupport.ToString(month));
			//$day = date('d');
			title = providerName + ": " + resource + " Resource Queries for " + monthStr + " " + day + ", " + year;
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			getAvailableSchemas(ref Utility.TypeSupport.ToInt32(schemaCount), ref (Utility.TypeSupport.ToArray(schemas))[0], ref db_connection, resource);
			returnValue = "";
			returnValue += getResourcePageHeader(title, title, month, day, year, resource);
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			returnValue += getResourceDayDetailCenter(month, Utility.TypeSupport.ToInt32(day), year, resource, ref db_connection, Utility.TypeSupport.ToBoolean(textbox));
			returnValue += getResourcePageFooter(month, year, resource, 5);
			
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceDayDetailCenter(object month, int day, object year, object resource, ref object db_connection, bool textbox)
		{
			string returnValue;
			object filename;
			object monthStr;
			string space;
			AndWhereClause whereClause;
			Utility.OrderedMap rows;
			double textrows;
			Utility.OrderedMap infoArray;
			object time;
			object matches;
			string whereclause;
			object host;
			object schema;
			int dolink;
			
			//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
			returnValue = getResourceDayDetailTableHeader(Utility.TypeSupport.ToInt32(month), day, Utility.TypeSupport.ToInt32(year));
			
			
			filename = getLogFileName(Utility.TypeSupport.ToString(month), Utility.TypeSupport.ToString(year));
			
			monthStr = monthNumberToText(Utility.TypeSupport.ToString(month));
			
			space = "";
			
			if (day < 10)
			{
				space = "0";
			}
			
			whereClause = new AndWhereClause();
			whereClause.add(new SimpleWhereClause(TBL_MONTH_RESOURCE, "=", "resource=" + Utility.TypeSupport.ToString(resource)));
			whereClause.add(new SimpleWhereClause(TBL_MONTH_DATE, "=", monthStr + " " + space + day + " " + year));
			rows = Utility.TypeSupport.ToArray(db_connection.selectWhere(filename, whereClause));
			
			
			if (textbox)
			{
				textrows = Utility.OrderedMap.CountElements(rows) + 1;
				if (textrows < 4)
				{
					textrows = 4;
				}
				
				returnValue += "<tr><td colspan=5><FORM name=\"textarea\"><TEXTAREA COLS=60 ROWS=" + textrows + " WRAP=OFF name=\"textresults\">";
			}
			
			
			if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(rows)))
			{
				foreach ( object row in rows.Values ) {
					parseDataLine(ref (infoArray)[0], convertRowToLine(Utility.TypeSupport.ToArray(row)));
					if (Utility.TypeSupport.ToBoolean(infoArray["wellformed"]) == true)
					{
						time = infoArray["time"];
						matches = infoArray["returnedrecs"];
						//CONVERSION_WARNING: Method 'htmlspecialchars' was converted to 'System.Web.HttpUtility.HtmlEncode' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/htmlspecialchars.htm 
						whereclause = System.Web.HttpUtility.HtmlEncode(infoArray["whereclause"]);
						host = infoArray["source_host"];
						schema = infoArray["recstr"];
						dolink = 1;
						if (Utility.TypeSupport.ToString(infoArray["type"]) == "inventory")
						{
							dolink = 0;
							schema = infoArray["column"];
							//CONVERSION_WARNING: Method 'htmlspecialchars' was converted to 'System.Web.HttpUtility.HtmlEncode' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/htmlspecialchars.htm 
							whereclause = "DISTINCT " + System.Web.HttpUtility.HtmlEncode(infoArray["column"]) + " " + System.Web.HttpUtility.HtmlEncode(infoArray["whereclause"]);
						}
						else if (Utility.TypeSupport.ToString(infoArray["type"]) == "custom")
						{
							dolink = 0;
						}
						
						returnValue += getResourceDayDetailRow(time, host, matches, whereclause, Utility.TypeSupport.ToString(schema), textbox, System.Convert.ToBoolean(dolink));
					}
				}
				
			}
			if (textbox)
			{
				returnValue += "</TEXTAREA></FORM></td></tr>";
			}
			
			
			
			returnValue += "\r\n" +
"</table></td></tr>\r\n";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getjavaScript' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getjavaScript()
		{
			
			return "<SCRIPT LANGUAGE=\"JavaScript\">\r\n" +
"<!--\r\n" +
"\r\n" +
"function windowSize( direction )\r\n" +
"{\r\n" +
"    var myWidth = 0, myHeight = 0;\r\n" +
"    if( typeof( window.innerWidth ) == 'number' )\r\n" +
"    {\r\n" +
"        //Non-IE\r\n" +
"        myWidth = window.innerWidth;\r\n" +
"        myHeight = window.innerHeight;\r\n" +
"    }\r\n" +
"    else if( document.documentElement && \r\n" +
"                ( document.documentElement.clientWidth ||\r\n" +
"                  document.documentElement.clientHeight )\r\n" +
"           )\r\n" +
"    {\r\n" +
"        //IE 6+ in 'standards compliant mode'\r\n" +
"        myWidth = document.documentElement.clientWidth;\r\n" +
"        myHeight = document.documentElement.clientHeight;\r\n" +
"    }\r\n" +
"    else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) )\r\n" +
"    {\r\n" +
"        //IE 4 compatible\r\n" +
"        myWidth = document.body.clientWidth;\r\n" +
"        myHeight = document.body.clientHeight;\r\n" +
"    }\r\n" +
"    \r\n" +
"    if( direction )\r\n" +
"    {\r\n" +
"        return myWidth;\r\n" +
"    }\r\n" +
"     \r\n" +
"    return myHeight;\r\n" +
"}\r\n" +
"\r\n" +
"function setTextAreaSize() {\r\n" +
"    var the_form = document.forms[0];\r\n" +
"    \r\n" +
"    for ( var x in the_form )\r\n" +
"    {\r\n" +
"        if ( ! the_form[x] )\r\n" +
"        {\r\n" +
"            continue;\r\n" +
"        }\r\n" +
"        \r\n" +
"        if( typeof the_form[x].rows != \"number\" )\r\n" +
"        {\r\n" +
"            continue;\r\n" +
"        }\r\n" +
"        the_form[x].cols = windowSize( 1 ) / 14;\r\n" +
"    }\r\n" +
"    \r\n" +
"    setTimeout(\"setTextAreaSize();\", 300);\r\n" +
"}\r\n" +
"window.onload = setTextAreaSize;\r\n" +
"-->\r\n" +
"</SCRIPT>";
		}
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceDayDetailTableHeader(int month, int day, int year)
		{
			string tz;
			string returnValue;
			//CONVERSION_WARNING: Method 'date' was converted to 'System.DateTime.ToString' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/date.htm 
			tz = Utility.DateTimeSupport.NewDateTime(Utility.DateTimeSupport.Timestamp(Utility.DateTimeSupport.NewDateTime(0, 0, 0, month, day, year))).ToString("T");
			returnValue = "\r\n" +
"    <TABLE border>\r\n" +
"        <TR>\r\n" +
"            <TH>\r\n" +
"                " + tz + "\r\n" +
"            </TH>\r\n" +
"            <TH>\r\n" +
"                Remote Host\r\n" +
"            </TH>\r\n" +
"            <TH>\r\n" +
"                Records Returned\r\n" +
"            </TH>\r\n" +
"            <TH>\r\n" +
"                Query\r\n" +
"            </TH>\r\n" +
"            <TH>\r\n" +
"               Results Schema\r\n" +
"            </TH>\r\n" +
"        </TR>\r\n";
			return returnValue;
		}
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailRow' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		public virtual string getResourceDayDetailRow(object time, object host, object matches, object filter, string schema, bool textbox, bool dolink)
		{
			string hrefBegin;
			string hrefEnd;
			string schemaName;
			string returnValue;
			
			hrefBegin = "<A HREF=" + schema + ">";
			hrefEnd = "</A>";
			
			if (!dolink)
			{
				schemaName = schema;
				hrefBegin = "";
				hrefEnd = "";
			}
			else
			{
				//CONVERSION_WARNING: Method 'substr' was converted to 'System.String.Substring' which has a different behavior. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/substr.htm 
				schemaName = Utility.StringSupport.LastSubstring(schema, "/").Substring(1);
			}
			
			if (textbox)
			{
				returnValue = time + "\t" + host + "\t" + matches + "\t" + filter + "\t" + schema + "\r";
			}
			else
			{
				returnValue = "\r\n" +
"        <TR>\r\n" +
"            <TD align=right>\r\n" +
"                " + time + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right>\r\n" +
"                " + host + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right>\r\n" +
"                " + matches + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right>\r\n" +
"                " + filter + "\r\n" +
"            </TD>\r\n" +
"            <TD align=right>\r\n" +
"                " + hrefBegin + schemaName + hrefEnd + "\r\n" +
"            </TD>\r\n" +
"        </TR>\r\n";
			}
			
			return returnValue;
		}
	</script>
	
	
	<%
		
		
		//CONVERSION_NOTE: Conditional function 'removeDebug' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getAllMonthsAsText' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getAllMonths' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generateMonthsHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateAvailableDataTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateAvailableDataTableCloser' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'monthNumberToText' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateMonthLink' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getCustomPageCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//BUGBUG NEEDS to do it's own thing
		//function getCustomPageHeader( $title, $title, $month, $day, $year, $resource )
		//{
		//    return getResourcePageHeader( $title, $title, $month, $day, $year, $resource );
		//}
		
		//CONVERSION_NOTE: Conditional function 'getCustomPageFooter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getCustomPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateAvailableMonthsForYear' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateAvailableDataTableRows' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getStatisticsMenu' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getStatisticsCloser' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateAvailableDataTable' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateSelectTextPair' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generateCheckbox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResources' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getSchemas' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generateResources' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getDaysArray' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateDaysSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'compareURLs' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateCustomQueryForm' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateOrderBy' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateShowFields' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generatePeriodForm' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateDataForSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generateAvailableMonthsForYearForSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generateMonthExists' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateOpenSelect' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		//CONVERSION_NOTE: Conditional function 'generateCloseSelect' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateFormOpen' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateAsTextBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		 /*
		//BUGBUG depreacated
		function generateAsTab()
		{
		$returnValue = "                            <INPUT TYPE=submit name=\"a stab\" value=\"astab\" >\n";
		return $returnValue;
		}*/
		
		//CONVERSION_NOTE: Conditional function 'generateFormClose' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateSubmitButton' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateRestButton' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generatePeriodSelectBoxes' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'generateYearsSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'generateMonthsSelectBox' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		
		//CONVERSION_NOTE: Conditional function 'getResourcePageHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getSchemaTDs' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryRow' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getAvailableSchemas' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getAvailableSchemasForDateRange' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getResourcePageFooter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getLogFileName' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'daysInMonth' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'convertRowToLine' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResourceMonthDetailRow' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResourceMonthTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResourceMonthDetailCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResourceSummaryPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceMonthDetailPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getStatisticsPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'findCachedFile' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResultsTables' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getCustomQueriesTable' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//getLogArray( $availableLogFileNames );
		
		//CONVERSION_NOTE: Conditional function 'getResultsTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'addMonthTodDate' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'parseDataLine' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'compareSchemaArray' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResultsTableCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getResultsTableFooter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailPage' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailCenter' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getjavaScript' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailTableHeader' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
		
		
		//CONVERSION_NOTE: Conditional function 'getResourceDayDetailRow' was relocated. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1010.htm 
		
		
	%>
	
	