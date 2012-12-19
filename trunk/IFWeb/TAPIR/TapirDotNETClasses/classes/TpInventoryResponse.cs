using System;
using System.Web;
using System.Data;
using System.Data.OleDb;

namespace TapirDotNET 
{

	public class TpInventoryResponse:TpResponse
	{
		public int mTotalReturned = 0;
		public string mMainSql = "";
		
		public TpInventoryResponse(TpRequest request) : base(request)
		{
			TP_STATISTICS_TRACKING = true;
			
			this.mCacheLife = TpConfigManager.TP_INVENTORY_CACHE_LIFE_SECS;
			mRequest = request;
			
			base.Init();
		}
		
		
		public override void  Body()
		{
			TpInventoryParameters inventory_parameters;
			string msg;
			Utility.OrderedMap concepts;
			TpResource r_resource;
			TpDataSource r_data_source;
			TpLocalMapping r_local_mapping;
			TpSqlBuilder sql_builder;
			string concepts_xml;
			TpConcept concept;
			TpTables r_tables;
			TpSettings r_settings;
			OleDbConnection cn;
			object db_encoding;
			TpFilter filter;
			string filter_sql;
			TpLocalFilter r_local_filter;
			string local_filter_sql;
			int num_recs;
			int num_concepts;
			Utility.OrderedMap tag_names;
			
			inventory_parameters = (TpInventoryParameters)this.mRequest.GetOperationParameters();
			
			if (inventory_parameters == null)
			{
				msg = "No parameters specified";
				
				this.Error(msg);
				return ;
			}
			
            concepts = inventory_parameters.GetConcepts();
			
			if (Utility.OrderedMap.CountElements(concepts) == 0)
			{
				msg = "No concepts specified";
				
				this.Error(msg);
				return ;
			}
			
			// Load resource config
			
			r_resource = this.mRequest.GetResource();
			
			r_resource.LoadConfig();
			
			r_data_source = r_resource.GetDataSource();
			
			r_local_mapping = r_resource.GetLocalMapping();
			
			// Prepare SQL builder
			
			sql_builder = new TpSqlBuilder();
			
			concepts_xml = "";
			
			foreach ( string concept_id in concepts.Keys ) 
			{
				object tag_name = concepts[concept_id];
				concept = r_local_mapping.GetConcept(concept_id);
				
				if (concept == null || !concept.IsMapped())
				{
					msg = "Concept \"" + concept_id + "\" is not mapped";
					
					this.Error(msg);
					return ;
				}
				
				sql_builder.AddTargetConcept(concept);
				
				concepts_xml += "\n" + "<concept id=\"" + concept_id + "\" />";
			}
			
			
			r_tables = r_resource.GetTables();
			
			sql_builder.AddRecordSource(r_tables.GetStructure());
			
			r_settings = r_resource.GetSettings();
			
			// DB connection
			if (!r_data_source.Validate(true))
			{
				this.Error("Failed to connect to database");
				return ;
			}
			
			cn = r_data_source.GetConnection();
			
			db_encoding = r_data_source.GetEncoding();
			
			// Filter
			
			filter = inventory_parameters.GetFilter();
			
			if (!filter.IsEmpty())
			{
				// This verifies only the syntax
				if (!filter.IsValid(false))
				{
					this.Error("Invalid filter");
					return ;
				}
				
				filter_sql = filter.GetSql(r_resource);
				
				// Need to check if other run time errors were found
				if (new TpDiagnostics().Count(new Utility.OrderedMap(TpConfigManager.DIAG_ERROR, TpConfigManager.DIAG_FATAL)) > 0)
				{
					this.Error("Runtime error");
					return ;
				}
				
				sql_builder.AddCondition(filter_sql);
			}
			
			// Local filter
			
			r_local_filter = r_resource.GetLocalFilter();
			
			if (!r_local_filter.IsEmpty())
			{
				local_filter_sql = r_local_filter.GetSql(r_resource);
				
				sql_builder.AddCondition(local_filter_sql);
			}
			
			// Additional settings 
			
			int start = this.mRequest.GetStart();
			
			int limit = this.mRequest.GetLimit();
			
			int max_limit = r_settings.GetMaxElementRepetitions();
			
			if (limit == -1)
			{
				limit = max_limit;
			}
			else if (limit > max_limit)
			{
				msg = "Parameter \"limit\" exceeded maximum element repetitions";
				new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_WARN);
				
				limit = max_limit;
			}
			
			sql_builder.AddCountColumn(true);
			sql_builder.GroupAll();
			
			// Count total matched records, if requested
			
			DataSet result_set = null;
			string encoded_sql = "";
			string sql = "";
			int matched = 0;
			
			if (this.mRequest.GetCount())
			{
				sql = sql_builder.GetSql();
				
				new TpDiagnostics().Append(TpConfigManager.DC_DEBUG_MSG, "SQL to count: " + sql, TpConfigManager.DIAG_DEBUG);
				
				encoded_sql = TpServiceUtils.EncodeSql(sql, db_encoding.ToString());
				
				result_set = TpDataAccess.Execute(cn, encoded_sql);
				
				if (result_set == null || result_set.Tables.Count == 0 || result_set.Tables[0].Rows.Count == 0)
				{
					this.Error("Failed to count matched records");
					
					r_data_source.ResetConnection();
					
					return ;
				}
				else
				{
					matched = result_set.Tables[0].Rows.Count;					
				}
			}
			
			// Retrieve records
			
			sql_builder.OrderBy(new Utility.OrderedMap());// empty array means order by all
			
			this.mMainSql = sql_builder.GetSql();
			
			new TpDiagnostics().Append(TpConfigManager.DC_DEBUG_MSG, "SQL to get records: " + this.mMainSql, TpConfigManager.DIAG_DEBUG);
			
			encoded_sql = TpServiceUtils.EncodeSql(this.mMainSql, db_encoding.ToString());
			
			// note: Select one record more just to know if there are further records
			result_set = TpDataAccess.SelectLimit(cn, encoded_sql, limit + 1, start);
			
			if (result_set == null)
			{				
				this.Error("Failed to select records");
				
				r_data_source.ResetConnection();
				
				return ;
			}
			
			// Inventory Header
			HttpContext.Current.Response.Write("\n<inventory>");
			HttpContext.Current.Response.Write("\n<concepts>");
			HttpContext.Current.Response.Write(concepts_xml);
			HttpContext.Current.Response.Write("\n</concepts>");
			
			// Inventory Records
			num_recs = 0;
			num_concepts = Utility.OrderedMap.CountElements(concepts);
			
			tag_names = concepts.GetValuesOrderedMap();
			
			while (num_recs < result_set.Tables[0].Rows.Count && (num_recs < limit))
			{				
				HttpContext.Current.Response.Write("\n<record");
				
				if (this.mRequest.GetCount())
				{
					HttpContext.Current.Response.Write(" count=\"" + result_set.Tables[0].Rows[num_recs][num_concepts] + "\"");
				}
				
				HttpContext.Current.Response.Write(">");
				
				for (int i = 0; i < num_concepts; ++i)
				{
					HttpContext.Current.Response.Write("\n<" + tag_names[i].ToString() + ">");
					HttpContext.Current.Response.Write(TpServiceUtils.EncodeData(result_set.Tables[0].Rows[num_recs][i].ToString(), db_encoding.ToString()));
										
					HttpContext.Current.Response.Write("</" + tag_names[i].ToString() + ">");
				}
				
				HttpContext.Current.Response.Write("\n</record>");	
				
				num_recs++;
			}
			
			// Inventory Summary
			
			HttpContext.Current.Response.Write("\n" + "<summary start=\"" + start.ToString() + "\"");
			
			if (num_recs < result_set.Tables[0].Rows.Count)
			{
				int next = start + limit;
				
				HttpContext.Current.Response.Write(" next=\"" + next.ToString() + "\"");
			}
			
			this.mTotalReturned = num_recs;
			
			HttpContext.Current.Response.Write(" totalReturned=\"" + num_recs.ToString() + "\"");
			
			if (this.mRequest.GetCount())
			{
				HttpContext.Current.Response.Write(" totalMatched=\"" + matched.ToString() + "\"");
			}
			
			HttpContext.Current.Response.Write(" />");
			
			HttpContext.Current.Response.Write("\n</inventory>");
						
			r_data_source.ResetConnection();
		}// end of member function Body
		
		public override Utility.OrderedMap _GetLogData()
		{
			Utility.OrderedMap data = new Utility.OrderedMap();
			TpInventoryParameters parameters;
			TpFilter filter;
			data = new Utility.OrderedMap();
			
			data["start"] = this.mRequest.GetStart();
			data["limit"] = this.mRequest.GetLimit();
			
			data["returned"] = this.mTotalReturned;
			
			parameters = (TpInventoryParameters)this.mRequest.GetOperationParameters();
			
			data["template"] = parameters.GetTemplate();
			
			data["concepts"] = Utility.StringSupport.Join(",", parameters.GetConcepts().GetKeysOrderedMap(null));
			
			data["sql"] = this.mMainSql;// note: will be empty for log-only requests
			
			filter = parameters.GetFilter();
			
			data["filter"] = filter.GetLogRepresentation();
			
			return Utility.OrderedMap.Merge(base._GetLogData(), data);
		}// end of member function _GetLogData
	}
	
}
