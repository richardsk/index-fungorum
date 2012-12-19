namespace TapirDotNET.Controls
{
	using System;
	using System.Xml;
	using System.Data;
	using System.Data.OleDb;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	public partial class TpLocalFilterForm : TpWizardForm
	{
		public XmlDocument mXpr = null;
		public Utility.OrderedMap mTablesAndColumns = new Utility.OrderedMap();
		
		public string mHtml = "";


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
			this.PreRender += new EventHandler(TpLocalFilterForm_PreRender);

		}
		#endregion

		public TpLocalFilterForm()
		{
			mStep = 4;
			mLabel = "Local filter";
		}

		protected void Page_Load(object sender, System.EventArgs e)
		{
			ID = "TpLocalFilterForm";
		}

		private void TpLocalFilterForm_PreRender(object sender, EventArgs e)
		{
			HtmlGenericControl ctrl = new HtmlGenericControl();
			ctrl.InnerHtml = mHtml;
			Panel1.Controls.Add(ctrl);
		}

		public override void  LoadDefaults()
		{
			TpDataSource r_data_source = null;
			string config_file = null;
			TpTables r_tables = null;
			TpLocalFilter r_local_filter = null;
			if (this.mResource.ConfiguredLocalFilter())
			{
				this.LoadFromXml();
			}
			else
			{
				this.SetMessage("Here you can optionally set a local filter to select which records you want to provide.");
				
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
				
				this.LoadDatabaseMetadata();
				
				// Default filter
				r_local_filter = this.mResource.GetLocalFilter();
				
				r_local_filter.LoadDefaults();
				
				this.mHtml = r_local_filter.GetHtml(this.mTablesAndColumns);
			}
		}// end of member function LoadDefaults
		
		public override void  LoadFromSession()
		{
			TpLocalFilter r_local_filter = null;
			TpTables r_tables = null;
			r_local_filter = this.mResource.GetLocalFilter();
			
			// Local filter must already be stored in the session
			if (!r_local_filter.IsLoaded())
			{
				// If not, the only reason I can think of is that the session expired,
				// so load everything from XML
				this.LoadFromXml();
				
				return ;
			}
			
			// Note: there should be no need to load datasource and tables!
			// situation 1: "Restarting the wizard from this step"
			//              In this case LoadDefaults would be called first
			//              so the datasource properties would be in the resources
			//              session object.
			// situation 2: "Coming from the previous step"
			//              In this case the datasource properties would also be in 
			//              the resources session object already.
			// situation 3: "Session expired"
			//              In this case LoaFromXml would be called above. 
			
			r_local_filter.LoadFromSession();
			
			r_tables = this.mResource.GetTables();
			
			// Get available tables/columns
			this.LoadDatabaseMetadata();
			
			this.mHtml = r_local_filter.GetHtml(this.mTablesAndColumns);
		}// end of member function LoadFromSession
		
		public override void  LoadFromXml()
		{
			string config_file;
			XmlDocument xpr;
			TpDataSource r_data_source = null;
			TpTables r_tables = null;
			TpLocalFilter r_local_filter = null;
			string err_str;

			if (this.mResource.ConfiguredLocalFilter())
			{
				config_file = this.mResource.GetConfigFile();
				
				xpr = this.GetXmlDocForOriginalData();
				
				if (xpr == null)
				{
					return ;
				}
				
				// Load datasource
				r_data_source = this.mResource.GetDataSource();
				
				r_data_source.LoadFromXml(config_file, xpr);
				
				// Load tables
				r_tables = this.mResource.GetTables();
				
				r_tables.LoadFromXml(config_file, xpr);
				
				this.LoadDatabaseMetadata();
				
				// Load filter
				r_local_filter = this.mResource.GetLocalFilter();
				
				r_local_filter.LoadFromXml(config_file, xpr);
				
				this.mHtml = r_local_filter.GetHtml(this.mTablesAndColumns);
			}
			else
			{
				err_str = "There is no local filter XML configuration to be loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return ;
			}
		}// end of member function LoadFromXml
		
		public virtual void  LoadDatabaseMetadata()
		{
			TpDataSource r_data_source = null;
			OleDbConnection cn;
			string err_str;
			TpTables r_tables = null;
			TpTable root_table = null;
			Utility.OrderedMap tables = null;
			string msg;

			r_data_source = this.mResource.GetDataSource();
			
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
				
				r_tables = this.mResource.GetTables();
				
				root_table = r_tables.GetRootTable();
				
				tables = root_table.GetAllTables();

				foreach ( string table in tables.Values ) 
				{
					DataTable cols = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Columns, new object[]{null, null, table});
					
					this.mTablesAndColumns[table] = cols;
					
					if (valid_tables.Select("TABLE_NAME='" + table + "'").Length == 0)  
					{
						msg = "Table \"" + table.ToString() + "\" is referenced by the \"Tables\" section " + "but does not exist in the database.";
						new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
					}
				}
				
				r_data_source.ResetConnection();
			}
			else
			{
				// No need to raise errors (it happens inside "Validate")
			}
		}// end of member function LoadDatabaseMetadata
		
		public virtual XmlDocument GetXmlDocForOriginalData()
		{
			string error;
			if (this.mXpr == null)
			{
				this.mXpr = new XmlDocument();
				
				try
				{
					mXpr.Load(this.mResource.GetConfigFile());
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file: " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return null;
				}
			}
			
			return this.mXpr;
		}// end of member function GetXmlParserForOriginalData
		
		public override void  HandleEvents()
		{
			TpLocalFilter r_local_filter = null;
			string op_location;
			Utility.OrderedMap refresh;
			TpLogicalOperator r_lop;
			Utility.OrderedMap operators;
			int num_operators = -1;
			int cut_point;
			int num_operators_before_cut = -1;
			int new_type;
			int old_type;
			TpLogicalOperator upper_lop;
			int num_operators_after_cut = -1;
			TpLogicalOperator bottom_lop;
			bool force;

			r_local_filter = this.mResource.GetLocalFilter();
			
			r_local_filter.Refresh(this.mTablesAndColumns);
			
			if (HttpContext.Current.Request.Form["remove"] != null)
			{
				op_location = TpUtils.GetVar("refresh", "").ToString();
				
				r_local_filter.Remove(op_location);
			}
			else
			{
				if (HttpContext.Current.Request.Form["add_cop"] != null)
				{
					op_location = TpUtils.GetVar("refresh", "").ToString();
					
					r_local_filter.AddOperator(op_location, TpFilter.COP_TYPE, TpFilter.COP_EQUALS);
				}
				else
				{
					if (HttpContext.Current.Request.Form["add_multi_lop"] != null)
					{
						op_location = TpUtils.GetVar("refresh", "").ToString();
						
						r_local_filter.AddOperator(op_location, TpFilter.LOP_TYPE, TpFilter.LOP_AND);
					}
					else
					{
						if (HttpContext.Current.Request.Form["add_not_lop"] != null)
						{
							op_location = TpUtils.GetVar("refresh", "").ToString();
							
							r_local_filter.AddOperator(op_location, TpFilter.LOP_TYPE, TpFilter.LOP_NOT);
						}
						else
						{
							if (TpUtils.GetVar("refresh", "").ToString().EndsWith("_lopchange"))
							{
								refresh = new Utility.OrderedMap(TpUtils.GetVar("refresh", "").ToString().Split("_".ToCharArray()));
								
								op_location = refresh[0].ToString();
								
								r_lop = (TpLogicalOperator)r_local_filter.Find(op_location);
								
								if (r_lop != null)
								{
									operators = r_lop.GetBooleanOperators();//TODO need a copy here!
									
									num_operators = Utility.OrderedMap.CountElements(operators);
									
									// Try to split the operator
									if (num_operators > 2)
									{
										r_lop.ResetBooleanOperators();
										
										cut_point = Utility.TypeSupport.ToInt32(refresh[1]);
										
										num_operators_before_cut = cut_point + 1;
										
										new_type = r_lop.GetLogicalType();
										
										old_type = (new_type == TpFilter.LOP_AND) ? TpFilter.LOP_OR : TpFilter.LOP_AND;
										
										if (num_operators_before_cut > 1)
										{
											upper_lop = new TpLogicalOperator(old_type);
											
											for (int i = 0; i < num_operators_before_cut; ++i)
											{
												upper_lop.AddBooleanOperator(operators[i]);
											}
											r_lop.AddBooleanOperator(upper_lop);
										}
										else
										{
											r_lop.AddBooleanOperator(operators[0]);
										}
										
										num_operators_after_cut = num_operators - num_operators_before_cut;
										
										if (num_operators_after_cut > 1)
										{
											bottom_lop = new TpLogicalOperator(old_type);
											
											for (int i = num_operators_before_cut; i < num_operators; ++i)
											{
												bottom_lop.AddBooleanOperator(operators[i]);
											}
											r_lop.AddBooleanOperator(bottom_lop);
										}
										else
										{
											r_lop.AddBooleanOperator(operators[num_operators - 1]);
										}
									}
								}
							}
							else
							{
								if (HttpContext.Current.Request.Form["update"] != null || HttpContext.Current.Request.Form["next"] != null)
								{
									force = true;
									
									if (!r_local_filter.IsValid(force))
									{
										this.mHtml = r_local_filter.GetHtml(this.mTablesAndColumns);
										
										return ;
									}
									
									if (!this.mResource.SaveLocalFilter(true))
									{
										this.mHtml = r_local_filter.GetHtml(this.mTablesAndColumns);
										
										return ;
									}
									
									if (HttpContext.Current.Request.Form["update"] != null)
									{
										this.SetMessage("Changes successfully saved!");
									}
									
									this.mResource.UpdateResources(false);
									
									this.mDone = true;
								}
							}
						}
					}
				}
			}
			
			this.mHtml = r_local_filter.GetHtml(this.mTablesAndColumns);
		}// end of member function HandleEvents

	}
}
