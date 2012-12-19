using System;
using System.Collections;
using System.Xml;
using System.Xml.XPath;
using System.Data;
using System.Data.OleDb;
using System.Web;
using System.Text;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using TapirDotNET;

namespace TapirDotNET.Controls
{

	public partial class TpTablesForm : TpWizardForm
	{
		public Hashtable mAllTablesAndColumns = new Hashtable();
		public XmlDocument mXpr;
		public object mXpt;
		public bool mDetectedInconsistency = false;
		

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
			Load += new EventHandler(TpTablesForm_Load);
			PreRender += new EventHandler(TpTablesForm_PreRender);
		}
		#endregion

		public TpTablesForm()
		{
			mStep = 3;
			mLabel = "Tables";
			
		}
		
		private void TpTablesForm_Load(object sender, EventArgs e)
		{
			ID = "TpTablesForm";
		}

		private void TpTablesForm_PreRender(object sender, EventArgs e)
		{
			LoadTables();
		}
		
		private void LoadTables()
		{
			string html = "<span class=\"label\">Root table and key field: </span>" + 
				new TpHtmlUtils().GetCombo("root", this.GetRoot(), this.GetOptions("AllTablesAndColumns"), false, false, "document.forms[1].refresh.value='root';document.forms[1].submit()") +
				"<br/>";
            
			if (this.GetRoot().Length > 0 && !this.mDetectedInconsistency)
			{
				html += this.GetJoins(this.GetRootTable());
				html += "<br/><br/>";
				html += "<span class=\"label\">New join: </span>" + 
					new TpHtmlUtils().GetCombo("from", TpUtils.GetVar("from", "0"), this.GetOptions("TablesAndColumnsInside"), false, 0, "") +
					"&nbsp;" + 
					new TpHtmlUtils().GetCombo("to", TpUtils.GetVar("to", "0"), this.GetOptions("TablesAndColumnsOutside"), false, 0, "") +
					"&nbsp;<input type = \"submit\" name = \"addjoin\" value = \"add\"/>";
			}
		
			HtmlGenericControl ctrl = new HtmlGenericControl();
			ctrl.InnerHtml = html;
			tablesPanel.Controls.Add(ctrl);
		}

		public override void  LoadDefaults()
		{
			TpDataSource r_data_source = null;
			string config_file = "";
			TpTables r_tables = null;
			if (this.mResource.ConfiguredTables())
			{
				this.LoadFromXml();
			}
			else
			{
				this.SetMessage("At this point, you'll need to indicate the main table that will serve records to the network (root table).\nYou can optionally add links to other tables if the relationship between them is one-to-one.\nIf you are unsure about which parts of your database you will need to use, just choose the main table, complete the configuration process, and then refine the configuration later.");
				
				r_data_source = this.mResource.GetDataSource();
				
				if (!r_data_source.IsLoaded())
				{
					config_file = this.mResource.GetConfigFile();
					
					r_data_source.LoadFromXml(config_file, null);
				}
				
				r_tables = this.mResource.GetTables();
				
				r_tables.LoadDefaults();
				
				this.LoadDatabaseMetadata();
			}
		}// end of member function LoadDefaults
		
		public override void  LoadFromSession()
		{
			TpTables r_tables = this.mResource.GetTables();
			
			// Tables must already be stored in the session
			if (r_tables.GetXml() == null)
			{
				// If not, the only reason I can think of is that the session expired,
				// so load everything from XML
				this.LoadFromXml();
				
				return ;
			}
			
			// Note: there should be no need to load the datasource!
			// situation 1: "Restarting the wizard from this step"
			//              In this case LoadDefaults would be called first
			//              so the datasource properties would be in the resources
			//              session object.
			// situation 2: "Coming from the previous step"
			//              In this case the datasource properties would also be in 
			//              the resources session object already.
			// situation 3: "Session expired"
			//              In this case LoaFromXml would be called above. 
			
			this.LoadDatabaseMetadata();
			
			r_tables.LoadFromSession();
		}// end of member function LoadFromSession
		
		public override void  LoadFromXml()
		{
			string config_file;
			XmlDocument xpr = null;
			TpTables r_tables;
			TpDataSource r_data_source;
			TpTable r_root_table;
			string root_table_name;
			string root_key;
			string oledb_root_key;
			string msg;
			string err_str;
			
			if (this.mResource.ConfiguredTables())
			{
				config_file = this.mResource.GetConfigFile();
				
				xpr = this.GetXmlDocForOriginalData();
				
				if (xpr == null)
				{
					return ;
				}
				
				// Load tables
				r_tables = this.mResource.GetTables();
				
				r_tables.LoadFromXml(config_file, xpr);
				
				// Load datasource
				r_data_source = this.mResource.GetDataSource();
				
				r_data_source.LoadFromXml(config_file, xpr);
				
				this.LoadDatabaseMetadata();
				
				// Check that the root table exists in the db metadata
				r_root_table = r_tables.GetRootTable();
				
				if (r_root_table != null)
				{
					root_table_name = r_root_table.GetName();
					
					root_key = Utility.TypeSupport.ToString(r_root_table.GetKey());
					
					oledb_root_key = root_key.ToUpper();
					
					if (this.mAllTablesAndColumns[root_table_name] == null)
					{
						msg = "The root table currently configured (\"" + root_table_name + "\") does not exist in the database. " + "\n" + "Please select another table and save the changes.";
						new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_WARN);
						
						this.mDetectedInconsistency = true;
					}
					else
					{
						DataTable dt = (DataTable)this.mAllTablesAndColumns[root_table_name];
						DataRow[] rows = dt.Select("COLUMN_NAME = '" + oledb_root_key + "'");
						if (rows.Length == 0)
						{
							msg = "The key field for the root table currently configured (\"" + root_key + "\") does not exist in the table anymore. " + "\n" + "Please select another combination root table/key field " + "and save the changes.";
							new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_WARN);
							
							this.mDetectedInconsistency = true;
						}
					}
				}
			}
			else
			{
				err_str = "There is no XML configuration for tables to be loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return ;
			}
		}// end of member function LoadFromXml
		
		public virtual void  LoadDatabaseMetadata()
		{
			TpDataSource r_data_source = null;
			OleDbConnection cn = null;
			string err_str = "";
			
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

				DataTable tables = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[]{null,null,null,"TABLE"});
				DataTable views = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[]{null,null,null,"VIEW"});
				foreach (DataRow r in views.Rows)
				{
					tables.Rows.Add(r.ItemArray);
				}

				if (tables.Rows.Count == 0)
				{
					err_str = "No tables inside database!";
					new TpDiagnostics().Append(TpConfigManager.DC_DATABASE_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				}
				else
				{
					foreach ( DataRow table in tables.Rows ) 
					{
						string tn = table["TABLE_NAME"].ToString();
						DataTable cols = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Columns, new object[]{null, null, tn});
						
						this.mAllTablesAndColumns[tn] = cols;
					}
					
					
					if (this.mAllTablesAndColumns == null)
					{
						err_str = "There was a problem when getting the column names from all tables!";
						
						if (r_data_source.GetDriverName() == "Microsoft.Jet.OLEDB.4.0")
						{
							err_str += " It is possible that your access database has one or more broken links to external tables. Please, check it.";
						}
						else
						{
							// What should we do here? 
						}
						
						new TpDiagnostics().Append(TpConfigManager.DC_DATABASE_ERROR, err_str, TpConfigManager.DIAG_ERROR);
					}
				}
				
				r_data_source.ResetConnection();
			}
			else
			{
				// No need to raise errors (it happens inside "Validate")
			}
		}// end of member function LoadDatabaseMetadata
		
		public virtual string GetRoot()
		{
			TpTables r_tables = this.mResource.GetTables();
			
			return r_tables.GetRoot();
		}// end of member function GetRoot
		
		public virtual TpTable GetRootTable()
		{
			TpTables r_tables = this.mResource.GetTables();
			TpTable root = r_tables.GetRootTable();
			
			if (root != null)
			{
				return root;
			}
			
			return null;
		}// end of member function GetRootTable
		
		public virtual XmlDocument GetXmlDocForOriginalData()
		{
			string error;
			if (this.mXpr == null)
			{
				this.mXpr = new XmlDocument();
				
				try
				{
					this.mXpr.Load(this.mResource.GetConfigFile());
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file: " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return null;
				}
			}
			
			return this.mXpr;
		}
				
		public override void  HandleEvents()
		{
			TpTables r_tables = null;
			string error;
			string from_table_plus_field;
			string to_table_plus_field;
			string err_str;
			string from_table;
			string from_field;
			string to_table;
			string to_field;
			TpTable new_table;
			TpTable r_root_table = null;
			TpTable r_parent_table = null;
			string msg;
			string path_to_remove;
			TpTable r_table = null;
			Utility.OrderedMap table_stack;
			string table_name;
			string parent_table_name;
			string root;
			Utility.OrderedMap parts;
			string new_table_name;
			string new_key_name;
			
			r_tables = this.mResource.GetTables();
			
			// Clicked save or next
			if (HttpContext.Current.Request["update"] != null || HttpContext.Current.Request["next"] != null)
			{
				if (r_tables.GetRoot().Length == 0)
				{
					error = "Please, select at least a root table and its key field!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				if ((TpUtils.GetVar("from", "").ToString() != "0" && (TpUtils.GetVar("to", "").ToString() != "0")))
				{
					error = "The new join you have just selected will not be " + "automatically added." + "\n" + "Please, click on the " + "\"add\" button or unselect the values before " + "jumping to the next step.";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				// Save changes
				
				if (!this.mResource.SaveTables(true))
				{
					return ;
				}
				
				this.mDone = true;
				
				this.SetMessage("Changes successfully saved!");
			}
			else
			{
				if ((TpUtils.GetVar("refresh", "").ToString() == "root"))
				{
					root = TpUtils.GetVar("root", "").ToString();
					
					r_root_table = r_tables.GetRootTable();
					
					if (root.Length > 0)
					{
						parts = new Utility.OrderedMap(root.Split(".".ToCharArray()));
						
						new_table_name = parts[0].ToString();
						new_key_name = parts[1].ToString();
						
						r_root_table.SetName(new_table_name);
						r_root_table.SetKey(new_key_name);
					}
				}
				else
				{
					if (HttpContext.Current.Request["remove"] != null)
					{
						path_to_remove = TpUtils.GetVar("refresh", "").ToString();
						
						r_table = r_tables.GetRootTable();
						
						table_stack = new Utility.OrderedMap(path_to_remove.Split("/".ToCharArray()));
						
						Utility.OrderedMap.Shift(table_stack);// remove root table
						
						while (Utility.OrderedMap.CountElements(table_stack) > 0)
						{
							table_name = Utility.OrderedMap.Shift(table_stack).ToString();
							
							if (Utility.OrderedMap.CountElements(table_stack) == 0)
							{
								if (!Utility.TypeSupport.ToBoolean(r_table.RemoveChild(table_name)))
								{
									return ;
								}
							}
							else
							{
								parent_table_name = r_table.GetName();
								
								r_table = (TpTable)r_table.GetChild(table_name);
								
								if (r_table == null)
								{
									return ;
								}
							}
						}
					}
					else
					{
						if (HttpContext.Current.Request["addjoin"] != null || (TpUtils.GetVar("refresh", "").ToString() == "addjoin"))
						{
							from_table_plus_field = TpUtils.GetVar("from", "").ToString();
							to_table_plus_field = TpUtils.GetVar("to", "").ToString();
							
							if (!Utility.TypeSupport.ToBoolean(from_table_plus_field) || !Utility.TypeSupport.ToBoolean(to_table_plus_field))
							{
								err_str = "Please select a value from both combos before adding!";
								new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, err_str, TpConfigManager.DIAG_ERROR);
								return ;
							}
							
							from_table = from_table_plus_field.Substring(0, from_table_plus_field.IndexOf("."));
							
							from_field = from_table_plus_field.Substring(from_table_plus_field.IndexOf(".") + 1);
							
							to_table = to_table_plus_field.Substring(0, to_table_plus_field.IndexOf("."));
							
							to_field = to_table_plus_field.Substring(to_table_plus_field.IndexOf(".") + 1);
							
							new_table = new TpTable();
							new_table.SetName(to_table);
							new_table.SetKey(to_field);
							new_table.SetJoin(from_field);
							
							r_root_table = r_tables.GetRootTable();
							
							r_parent_table = r_root_table.Find(from_table);
							
							if (r_parent_table == null)
							{
								msg = "Could not find \"" + from_table + "\" in the tables data structure";
								new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
								
								return ;
							}
							
							r_parent_table.AddChild(new_table);
							
							//TODO session correct thing here?
							HttpContext.Current.Session["from"] = null;
							HttpContext.Current.Session["to"] = null;
						}
					}
				}
			}
		}// end of member function HandleEvents
		
		public virtual Utility.OrderedMap GetOptions(string id)
		{
			Utility.OrderedMap options;
			Utility.OrderedMap all;
			Utility.OrderedMap inside;
			TpTables r_tables;
			TpTable r_root_table;
			Utility.OrderedMap tables_inside;
			options = new Utility.OrderedMap();
			
			if (id == "AllTablesAndColumns")
			{
				foreach ( string table in this.mAllTablesAndColumns.Keys ) 
				{
					DataTable columns = (DataTable)this.mAllTablesAndColumns[table];
					foreach ( DataRow col in columns.Rows ) 
					{
						options.Push(table + "." + col["COLUMN_NAME"].ToString());
					}
					
				}
				
				
				options = TpUtils.GetHash(options);
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
				
				if (this.mResource.IsNew() || this.mDetectedInconsistency)
				{
					Utility.OrderedMap.Unshift(ref options, "-- select --");
				}
			}
			else if (id == "TablesAndColumnsInside")
			{
				r_tables = this.mResource.GetTables();
				
				r_root_table = r_tables.GetRootTable();
				
				tables_inside = Utility.TypeSupport.ToArray(r_root_table.GetAllTables());
				
				foreach ( string table in this.mAllTablesAndColumns.Keys ) 
				{
					DataTable columns = (DataTable)this.mAllTablesAndColumns[table];
					foreach ( DataRow col in columns.Rows ) 
					{
						if (tables_inside.Search(table) != null)
						{
							options.Push(table + "." + col["COLUMN_NAME"].ToString());
						}
					}
					
				}
				
				
				options = TpUtils.GetHash(options);
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
				
				Utility.OrderedMap.Unshift(ref options, "-- between --");
			}
			else if (id == "TablesAndColumnsOutside")
			{
				all = this.GetOptions("AllTablesAndColumns").GetKeysOrderedMap(null);
				
				inside = this.GetOptions("TablesAndColumnsInside").GetKeysOrderedMap(null);
				
				options = Utility.OrderedMap.Difference(all, inside);
				
				if (options == null) options = new Utility.OrderedMap();

				options = TpUtils.GetHash(options);
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
				
				Utility.OrderedMap.Unshift(ref options, "-- and --");
			}
			
			return options;
		}// end of member function GetOptions
		
		 /** Get HTML representation of table joins inside a specified table.
		*
		* @param string parentTable TpTable object
		*
		* @return string HTML representing all joins with the specified table
		*/
		public virtual string GetJoins(TpTable parentTable)
		{
			string out_Renamed = "";
			bool detected_error_in_join = false;
			string key;
			string join;
			string path;
			string oledb_key;
			string oledb_join;
			string msg;
			string remove_button;
			string tree_symbol;
			
			double level = parentTable.GetLevel() - 1;
			
			string parent_table_name = parentTable.GetName();
			
			Utility.OrderedMap joins = parentTable.GetChildren();
			
			
			foreach ( string table_name in joins.Keys ) 
			{
				TpTable table = (TpTable)joins[table_name];
				key = table.GetKey();
				join = table.GetJoin();
				path = table.GetPath();
				
				oledb_key = key.ToUpper();
				
				oledb_join = join.ToUpper();
				
				if (this.mAllTablesAndColumns[table_name] == null)
				{
					msg = "Table \"" + table_name + "\" is still part of the configuration" + "\n" + "but is not shown in a join below because it does not " + "\n" + "exist in the database. Please make any necessary updates " + "\n" + "in this form and save the changes.";
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_WARN);
					
					continue;
				}
				else
				{					
					DataTable dt = (DataTable)this.mAllTablesAndColumns[table_name];
					DataRow[] rows = dt.Select("COLUMN_NAME = '" + oledb_key + "'");
					if (rows.Length == 0)
					{
						msg = "Field \"" + table_name + "." + key + "\" is still part of the " + "configuration" + "\n" + "but is not shown in a join below because it does not " + "\n" + "exist in the database. Please make any necessary updates " + "\n" + "in this form and save the changes.";
						new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_WARN);
						
						continue;
					}
					else
					{
						dt = (DataTable)this.mAllTablesAndColumns[parent_table_name];
						rows = dt.Select("COLUMN_NAME = '" + oledb_join + "'");
						if ((!detected_error_in_join) && rows.Length == 0)
						{
							msg = "Field \"" + parent_table_name + "." + join + "\" is still part of the " + "configuration" + "\n" + "but is not shown in a join below because it does not " + "\n" + "exist in the database. Please make any necessary updates " + "\n" + "in this form and save the changes.";
							new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_WARN);
							
							detected_error_in_join = true;
							
							continue;
						}
					}
				}
				
				string indent = "";
				if (level > 0)
				{
					indent = (new StringBuilder().Insert(0, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;", (int)level)).ToString();
				}
				
				remove_button = "&nbsp;<input type=\"submit\" name=\"remove\" value=\"remove join\" onClick=\"document.forms[1].refresh.value=\'" + path + "\';document.forms[1].submit();\"><br/>";
				
				tree_symbol = "-";
				
				out_Renamed += "\n" + "           <br/><span class=\"label\">" + indent + " <span class=\"text\">" + tree_symbol + "</span> join with </span>" + "<span class=\"text\">" + table_name + "</span>" + "<span class=\"label\"> when </span>" + "<span class=\"text\">" + parent_table_name + "." + join + "</span>" + "<span class=\"label\"> equals </span>" + "<span class=\"text\">" + table_name + "." + key + "</span>" + remove_button;
				
				out_Renamed += this.GetJoins(table);
			}
			
			
			return out_Renamed;
		}// end of GetJoins

	}
}
