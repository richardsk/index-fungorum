using System;
using System.Web;
using System.Data;
using System.Data.OleDb;

namespace TapirDotNET 
{

	public class TpSearchResponse:TpResponse
	{
		public int mTotalReturned = 0;
		public string mMainSql = "";
		
		public TpSearchResponse(TpRequest request) : base(request)
		{
			TP_STATISTICS_TRACKING = true;
			
			this.mCacheLife = TpConfigManager.TP_SEARCH_CACHE_LIFE_SECS;
			
			base.Init();
		}
		
		
		public override void  Header()
		{
			if (this.mRequest.GetEnvelope())
			{
				base.Header();
			}
			else
			{
				this.XmlHeader();
			}
		}// end of member function Header
		
		public override void  Footer()
		{
			if (this.mRequest.GetEnvelope())
			{
				base.Footer();
			}
		}// end of member function Footer
		
		public override void  Body()
		{
			//global $g_dlog
			TpSearchParameters parameters;
			string msg;
			TpResource r_resource = null;
			TpDataSource r_data_source = null;
			TpTables r_tables = null;
			TpLocalMapping r_local_mapping = null;
			TpLocalFilter r_local_filter = null;
			TpSettings r_settings;
			int max_repetitions;
			int max_levels;
			TpOutputModel output_model;
			TpResponseStructure response_structure;
			Utility.OrderedMap unsupported_schema_constructs;
			Utility.OrderedMap partial;
			TpSchemaInspector schema_inspector;
			Utility.OrderedMap rejected_paths;
			Utility.OrderedMap accepted_paths;
			TpSqlBuilder sql_builder;
			TpConcept concept;
			Utility.OrderedMap order_by_concepts;
			OleDbConnection cn = null;
			string db_encoding;
			TpFilter filter;
			string filter_sql;
			string local_filter_sql;
			int start;
			int limit;
			int matched;
			string sql;
			string encoded_sql;
			DataSet result_set = null;
			string err = "";
			TpXmlGenerator xml_generator;
			string main_content;
			double next;
			string concept_id;
			
			TpLog.debug("[Search Body]");
			
			parameters = (TpSearchParameters)this.mRequest.GetOperationParameters();
			
			if (parameters == null)
			{
				msg = "No parameters specified";
				
				this.Error(msg);
				return ;
			}
			
			// Load resource config
			
			r_resource = this.mRequest.GetResource();
			
			r_resource.LoadConfig();
			
			r_data_source = r_resource.GetDataSource();
			
			r_tables = r_resource.GetTables();
			
			r_local_mapping = r_resource.GetLocalMapping();
			
			r_local_filter = r_resource.GetLocalFilter();
			
			r_settings = r_resource.GetSettings();
			
			max_repetitions = r_settings.GetMaxElementRepetitions();
			
			max_levels = r_settings.GetMaxElementLevels();
			
			// Output model
			
			output_model = parameters.GetOutputModel();
			
			if (output_model == null)
			{
				this.Error("Failed to load output model");
				
				return ;
			}
			
			// Report unsupported schema constructs if not in debug mode
			if (!TpConfigManager._DEBUG)
			{
				response_structure = output_model.GetResponseStructure();
				
				if (response_structure != null)
				{
					unsupported_schema_constructs = Utility.TypeSupport.ToArray(response_structure.GetUnsupportedConstructs());
					
					foreach ( string construct in unsupported_schema_constructs.Keys ) 
					{
						Utility.OrderedMap schemas = (Utility.OrderedMap)unsupported_schema_constructs[construct];
						msg = "Unsupported schema construct \"" + construct + "\" found in " + Utility.StringSupport.Join(",", schemas);
						new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_WARN);
					}
					
				}
			}
			
			partial = parameters.GetPartial();
			
			// For memory management and processing reasons, it is better to perform
			// a previous inspection in the response schema. The reason is that certain 
			// checkings can be done per generic path instead of per node instance. 
			schema_inspector = new TpSchemaInspector(output_model, r_local_mapping, max_levels, partial);
			
			schema_inspector.Inspect();
			
			if (schema_inspector.MustAbort())
			{
				this.Error("Invalid or unsupported response structure");
				return ;
			}
			
			rejected_paths = schema_inspector.GetRejectedPaths();
			accepted_paths = schema_inspector.GetAcceptedPaths();
			
			if (TpConfigManager.TP_LOG_DEBUG)
			{
				TpLog.debug("Paths that were understood from the structure:");
				
				foreach ( string path in accepted_paths.Keys ) 
				{
					object min_occurs = accepted_paths[path];
					TpLog.debug("Accepted path: " + path);
				}
				
			}
			
			if (!output_model.IsValid())
			{
				this.Error("Invalid or unsupported output model");
				return ;
			}
			
			// Prepare SQL builder
			
			TpLog.debug("--------------");
			TpLog.debug("Preparing SQL Builder");
			
			sql_builder = new TpSqlBuilder();
			
			// Add output model mapped concepts to SQL
			foreach ( string path in output_model.GetMapping().Keys ) 
			{
				object expressions = Utility.TypeSupport.ToArray(output_model.GetMapping())[path];
				if (accepted_paths.GetKeysOrderedMap(null).Search(path) != null)
				{
					foreach ( TpExpression expression in Utility.TypeSupport.ToArray(expressions).Values ) 
					{
						if (expression.GetType() == TpFilter.EXP_CONCEPT)
						{
							concept_id = expression.GetReference().ToString();
							
							concept = r_local_mapping.GetConcept(concept_id);
							
							if (concept == null || !concept.IsMapped())
							{
								msg = "Concept \"" + concept_id + "\" is not mapped";
								
								this.Error(msg);
								return ;
							}
							
							sql_builder.AddTargetConcept(concept);
							
							TpLog.debug("Adding target: " + concept_id);
						}
					}
					
				}
			}
			
			
			// Add "order by" concepts to SQL
			
			order_by_concepts = parameters.GetOrderBy();
			
			if (Utility.OrderedMap.CountElements(order_by_concepts) > 0)
			{
				foreach ( string cid in order_by_concepts.Keys ) 
				{
					object descend = order_by_concepts[cid];
					concept = r_local_mapping.GetConcept(cid);
					
					if (concept == null || !concept.IsMapped())
					{
						msg = "Concept \"" + cid + "\" is not mapped";
						
						this.Error(msg);
						return ;
					}
					
					// Field should usually be present in the output model,
					// but let's add it here just in case...
					sql_builder.AddTargetConcept(concept);
				}
				
				
				sql_builder.OrderBy(order_by_concepts);
			}
			
			sql_builder.AddRecordSource(r_tables.GetStructure());
			
			// DB connection
			
			if (!r_data_source.Validate(true))
			{
				this.Error("Failed to connect to database");
				return ;
			}
			
			cn = r_data_source.GetConnection();
			
			db_encoding = r_data_source.GetEncoding();
			
			// Filter
			
			filter = parameters.GetFilter();
			
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
			
			if (!r_local_filter.IsEmpty())
			{
				local_filter_sql = r_local_filter.GetSql(r_resource);
				
				sql_builder.AddCondition(local_filter_sql);
			}
			
			// Additional settings 
			
			start = this.mRequest.GetStart();
			
			limit = this.mRequest.GetLimit();
			
			if (limit == -1)
			{
				limit = max_repetitions;
			}
			else if (limit > max_repetitions)
			{
				msg = "Parameter \"limit\" exceeded maximum element repetitions";
				new TpDiagnostics().Append(TpConfigManager.DC_TRUNCATED_RESPONSE, msg, TpConfigManager.DIAG_WARN);
				
				limit = max_repetitions;
			}
			
			// Count total matched records, if requested
			
			matched = 0;
			
			if (this.mRequest.GetCount())
			{
				sql = sql_builder.GetSql();
				
				new TpDiagnostics().Append(TpConfigManager.DC_DEBUG_MSG, "SQL to count: " + sql, TpConfigManager.DIAG_DEBUG);
				
				encoded_sql = TpServiceUtils.EncodeSql(sql, db_encoding);
				
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
			
			this.mMainSql = sql_builder.GetSql();
			
			new TpDiagnostics().Append(TpConfigManager.DC_DEBUG_MSG, "SQL to get records: " + this.mMainSql, TpConfigManager.DIAG_DEBUG);
			
			encoded_sql = TpServiceUtils.EncodeSql(this.mMainSql, db_encoding);
			
			result_set = TpDataAccess.SelectLimit(cn, encoded_sql, limit + 1, start);
			
			if (result_set == null || result_set.Tables.Count == 0 || result_set.Tables[0].Rows.Count == 0)
			{				
				this.Error("Failed to select records");
				
				r_data_source.ResetConnection();
				
				return ;
			}
			
			// TODO: Get and execute the SQL from inside "Render" guided by class mappings
			
			xml_generator = new TpXmlGenerator(output_model, rejected_paths, sql_builder, db_encoding, max_repetitions, limit, this.mRequest.GetOmitNamespaces());
			
			main_content = xml_generator.Render(result_set, r_resource);
			
			if (new TpDiagnostics().Count(new Utility.OrderedMap(TpConfigManager.DIAG_ERROR, TpConfigManager.DIAG_FATAL)) > 0)
			{
				this.Error("Runtime error");
				return ;
			}
			
			if (this.mRequest.GetEnvelope())
			{
				HttpContext.Current.Response.Write("\n<search>");
			}
			
			HttpContext.Current.Response.Write(main_content);
			
			// Search Summary
			
			if (this.mRequest.GetEnvelope())
			{
				this.mTotalReturned = xml_generator.GetTotalReturned();
				
				HttpContext.Current.Response.Write("\n" + "<summary start=\"" + start.ToString() + "\"");
				
				if (result_set.Tables[0].Rows.Count > limit && this.mTotalReturned > 0)
				{
					next = start + limit;
					
					HttpContext.Current.Response.Write(" next=\"" + next.ToString() + "\"");
				}
				
				HttpContext.Current.Response.Write(" totalReturned=\"" + this.mTotalReturned.ToString() + "\"");
				
				if (this.mRequest.GetCount())
				{
					HttpContext.Current.Response.Write(" totalMatched=\"" + matched.ToString() + "\"");
				}
				
				HttpContext.Current.Response.Write(" />");
				
				HttpContext.Current.Response.Write("\n</search>");
			}
						
			r_data_source.ResetConnection();
		}// end of member function Body
		
		public override Utility.OrderedMap _GetLogData()
		{
			Utility.OrderedMap data = new Utility.OrderedMap();
			TpSearchParameters parameters;
			TpOutputModel output_model;
			TpResponseStructure response_structure;
			TpFilter filter;
			Utility.OrderedMap order_by_concepts;
			string order_by_str;
			data = new Utility.OrderedMap();
			
			data["start"] = this.mRequest.GetStart();
			data["limit"] = this.mRequest.GetLimit();
			
			data["returned"] = this.mTotalReturned;
			
			parameters = (TpSearchParameters)this.mRequest.GetOperationParameters();
			
			data["template"] = parameters.GetTemplate();
			
			output_model = parameters.GetOutputModel();
			
			if (output_model != null)
			{
				data["output_model"] = output_model.GetLocation();
				
				response_structure = output_model.GetResponseStructure();
				
				if (response_structure != null)
				{
					data["response_structure"] = response_structure.GetLocation(null);
				}
				else
				{
					data["response_structure"] = null;
				}
			}
			else
			{
				data["output_model"] = null;
				
				data["response_structure"] = null;
			}
			
			data["partial"] = Utility.StringSupport.Join(",", parameters.GetPartial());
			
			data["sql"] = this.mMainSql;// note: will be empty for log-only requests
			
			filter = parameters.GetFilter();
			
			if (filter != null)
			{
				data["filter"] = filter.GetLogRepresentation();
			}
			else
			{
				data["filter"] = null;
			}
			
			order_by_concepts = parameters.GetOrderBy();
			
			order_by_str = "";
			
			foreach ( string concept_id in order_by_concepts.Keys ) 
			{
				bool descend = (bool)order_by_concepts[concept_id];
				if (order_by_str.Length > 0)
				{
					order_by_str += ",";
				}
				
				order_by_str += concept_id;
				
				order_by_str += descend ? "(DESC)" : "(ASC)";
			}
			
			
			data["order_by"] = order_by_str;
			
			return Utility.OrderedMap.Merge(base._GetLogData(), data);
		}// end of member function _GetLogData
	}
}
