namespace TapirDotNET 
{

	
	public class TpStatistics
	{
		public const int TBL_MONTH = 0;
		public const int TBL_YEAR = 1;
		//for table resources
		public const int TBL_RESOURCE = 2;
		public const int TBL_DAYS = 3;
		public const int TBL_HITS = 4;
		public const int TBL_MATCHES = 5;
		public const int TBL_0_MATCHES = 6;
		//for table schema
		public const int TBL_SCHEMA_RESOURCE = 2;
		public const int TBL_SCHEMA_SCHEMA = 3;
		public const int TBL_SCHEMA_HITS = 4;
		public const int TBL_SCHEMA_MATCHES = 5;
		//for table month
		public const int TBL_MONTH_DATE = 0;
		public const int TBL_MONTH_TIME = 1;
		public const int TBL_MONTH_PORTAL = 2;
		public const int TBL_MONTH_LEVEL = 3;
		public const int TBL_MONTH_TYPE = 4;
		public const int TBL_MONTH_STATUS = 5;
		public const int TBL_MONTH_METHOD = 6;
		public const int TBL_MONTH_RESOURCE = 7;
		public const int TBL_MONTH_FILTER = 8;
		public const int TBL_MONTH_STARTREC = 9;
		public const int TBL_MONTH_MAXRECS = 10;
		public const int TBL_MONTH_RETURNEDRECS = 11;
		public const int TBL_MONTH_SOURCE_IP = 12;
		public const int TBL_MONTH_SOURCE_HOST = 13;
		//For search requests
		public const int TBL_MONTH_SCHEMA = 14;
		public const int TBL_MONTH_WHERE = 15;
		//For inventory requests
		public const int TBL_MONTH_WHERE_INV = 14;
		public const int TBL_MONTH_COLUMN_INV = 15;
		public const int TBL_MONTH_REQUEST = 16;


		public virtual void  LogSchemaInfo(string statsFile, Utility.OrderedMap params_Renamed, string currentMonth, string currentYear)
		{
//			string recstr;
//			AndWhereClause whereClause;
//			Utility.OrderedMap row;
//			double newMatches;
//			double newHits;
//			if (rStatsDb)
//			{
//				//CONVERSION_ISSUE: Static function call <'TpUtils.IsUrl()'> was converted to a new instance call which may cause side effects. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1011.htm 
//				if (new TpUtils().IsUrl(Utility.TypeSupport.ToString(params_Renamed["output_model"])))
//				{
//					recstr = Utility.TypeSupport.ToString(params_Renamed["output_model"]);
//				}
//				else if (Utility.TypeSupport.ToString(params_Renamed["operation"]) == "inventory")
//				{
//					recstr = "inventory";
//				}
//				else
//				{
//					recstr = "custom";
//				}
//				
//				whereClause = new AndWhereClause();
//				whereClause.add(new SimpleWhereClause(TBL_MONTH, "=", currentMonth));
//				whereClause.add(new SimpleWhereClause(TBL_YEAR, "=", currentYear));
//				whereClause.add(new SimpleWhereClause(TBL_SCHEMA_SCHEMA, "=", recstr));
//				whereClause.add(new SimpleWhereClause(TBL_SCHEMA_RESOURCE, "=", params_Renamed["resource"]));
//				row = Utility.TypeSupport.ToArray(rStatsDb.selectWhere(TP_STATISTICS_SCHEMA_TABLE, whereClause));
//				
//				if (Utility.OrderedMap.CountElements(row) > 0)
//				{
//					newMatches = Utility.TypeSupport.ToDouble(row.GetValue(0, TBL_SCHEMA_MATCHES)) + Utility.TypeSupport.ToDouble(params_Renamed["returned"]);
//					newHits = Utility.TypeSupport.ToDouble(row.GetValue(0, TBL_SCHEMA_HITS)) + 1;
//					rStatsDb.updateSetWhere(TP_STATISTICS_SCHEMA_TABLE, new Utility.OrderedMap(new object[]{TBL_SCHEMA_MATCHES, newMatches}, new object[]{TBL_SCHEMA_HITS, newHits}), whereClause);
//				}
//				else
//				{
//					row = new Utility.OrderedMap(new object[]{TBL_MONTH, currentMonth}, new object[]{TBL_YEAR, currentYear}, new object[]{TBL_SCHEMA_RESOURCE, params_Renamed["resource"]}, new object[]{TBL_SCHEMA_SCHEMA, recstr}, new object[]{TBL_SCHEMA_HITS, 1}, new object[]{TBL_SCHEMA_MATCHES, params_Renamed["returned"]});
//					rStatsDb.insert(TP_STATISTICS_SCHEMA_TABLE, row);
//				}
//			}
		}// end of LogSchemaInfo
		
		public virtual void  LogResourceInfo(object rStatsLog, object rStatsDb, Utility.OrderedMap params_Renamed, object currentMonth, object currentYear)
		{
			//TODO

//			double log_str;
//			AndWhereClause whereClause;
//			Utility.OrderedMap row;
//			double newMatches;
//			double newHits;
//			object newZeroMatches;
//			int zeroMatches;
//			//CONVERSION_ISSUE: Static function call <'TpServiceUtils.GetLogString()'> was converted to a new instance call which may cause side effects. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1011.htm 
//			log_str = Utility.TypeSupport.ToDouble(new TpServiceUtils().GetLogString(params_Renamed));
//			
//			rStatsLog.log(log_str, PEAR_LOG_INFO);
//			
//			if (rStatsDb)
//			{
//				whereClause = new AndWhereClause();
//				whereClause.add(new SimpleWhereClause(TBL_MONTH, "=", currentMonth));
//				whereClause.add(new SimpleWhereClause(TBL_YEAR, "=", currentYear));
//				whereClause.add(new SimpleWhereClause(TBL_RESOURCE, "=", params_Renamed["resource"]));
//				row = Utility.TypeSupport.ToArray(rStatsDb.selectWhere(TP_STATISTICS_RESOURCE_TABLE, whereClause));
//				
//				if (Utility.OrderedMap.CountElements(row) > 0)
//				{
//					newMatches = Utility.TypeSupport.ToDouble(row.GetValue(0, TBL_MATCHES)) + Utility.TypeSupport.ToDouble(params_Renamed["returned"]);
//					newHits = Utility.TypeSupport.ToDouble(row.GetValue(0, TBL_HITS)) + 1;
//					newZeroMatches = row.GetValue(0, TBL_0_MATCHES);
//					
//					//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
//					if (Utility.TypeSupport.ToInt32(params_Renamed["returned"]) == 0)
//					{
//						//CONVERSION_ISSUE: Incrementing/decrementing only supported on numerical types, '++' was not converted. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1000.htm 
//						newZeroMatches++;
//					}
//					
//					rStatsDb.updateSetWhere(TP_STATISTICS_RESOURCE_TABLE, new Utility.OrderedMap(new object[]{TBL_MATCHES, newMatches}, new object[]{TBL_HITS, newHits}, new object[]{TBL_0_MATCHES, newZeroMatches}), whereClause);
//				}
//				else
//				{
//					zeroMatches = 0;
//					
//					//CONVERSION_TODO: The equivalent in .NET for converting to integer may return a different value. Copy this link in your browser for more info: ms-its:C:\Program Files\Microsoft Corporation\PHP to ASP.NET Migration Assistant\PHPToAspNet.chm::/1007.htm 
//					if (Utility.TypeSupport.ToInt32(params_Renamed["returned"]) == 0)
//					{
//						zeroMatches = 1;
//					}
//					
//					row = new Utility.OrderedMap(new object[]{TBL_MONTH, currentMonth}, new object[]{TBL_YEAR, currentYear}, new object[]{TBL_RESOURCE, params_Renamed["resource"]}, new object[]{TBL_DAYS, 0}, new object[]{TBL_HITS, 1}, new object[]{TBL_MATCHES, params_Renamed["returned"]}, new object[]{TBL_0_MATCHES, zeroMatches});
//					
//					rStatsDb.insert(TP_STATISTICS_RESOURCE_TABLE, row);
//				}
//			}
		}// end of LogResourceInfo
	}
}
