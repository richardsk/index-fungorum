using System;
using System.Xml;
using System.Data;
using System.Data.OleDb;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;


namespace TapirDotNET.Controls
{

	public partial class TpMappingForm : TpWizardForm
	{
		public TpLocalMapping mLocalMapping;
		public Utility.OrderedMap mTablesAndColumns = new Utility.OrderedMap();
		public XmlDocument mXpr = null;
		public bool has_mandatory_concepts;
		
		public Utility.OrderedMap unmapped_schemas;
		public TpLocalMapping r_local_mapping;
		public string mapping_input_name;


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
			this.Load += new System.EventHandler(this.TpMappingForm_Load);
			this.PreRender += new System.EventHandler(this.TpMappingForm_PreRender);

		}
		#endregion

		public TpMappingForm()
		{
			mStep = 5;
			mLabel = "Mapping";
			
		}
		
		protected void TpMappingForm_Load(object sender, EventArgs e)
		{
			ID = "TpMappingForm";
			unmapped_schemas = r_local_mapping.GetUnmappedSchemas();
			
		}
		
		protected void TpMappingForm_PreRender(object sender, EventArgs e)
		{
			foreach ( string csk in unmapped_schemas.Keys )
			{
				TpConceptualSchema cs = (TpConceptualSchema)unmapped_schemas[csk];

				HtmlGenericControl ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = "<input type=\"checkbox\" class=\"checkbox\" name=\"schema[]\" value=\"" + 
					cs.GetNamespace() + "\"/>&nbsp;<span class=\"label\">" + cs.GetAlias() + "</span><br/>";

				availableSchemas.Controls.Add(ctrl);
			}

			has_mandatory_concepts = false;
			string html = "";

			foreach ( string ns in r_local_mapping.GetMappedSchemas().Keys )
			{
				TpConceptualSchema schema = (TpConceptualSchema)r_local_mapping.GetMappedSchemas()[ns];

				html = "<br/>" + 
					"<span class=\"section\">" + schema.GetAlias() + "</span>" +
					"<br/><br/>" +
					"<input type=\"submit\" name=\"unmap\" value=\"unmap\" onclick=\"document.forms[1].refresh.value='" + 
					ns + "^unmap';document.forms[1].submit()\"/>" +
					"&nbsp;&nbsp;" +
					"<input type=\"submit\" name=\"automap\" value=\"automap\" onclick=\"document.forms[1].refresh.value='" + 
					ns + "^automap';document.forms[1].submit()\"/>" +
					"&nbsp;&nbsp;" +
					"<input type=\"submit\" name=\"fill\" value=\"fill unmapped\" onclick=\"document.forms[1].refresh.value='" + 
					ns + "^fill';document.forms[1].submit()\"/>" +
					"<br/>  <br/>";

				HtmlGenericControl fctrl = new HtmlGenericControl();
				fctrl.InnerHtml = html;
				fieldsPanel.Controls.Add(fctrl);

				TableRow tr = new TableRow();
				tr.BackColor = System.Drawing.Color.FromArgb(0xffffee);

				Table FieldsTable = new Table();
				FieldsTable.ID = "FieldsTable";
				FieldsTable.BorderColor = System.Drawing.Color.FromArgb(0x999999);
				FieldsTable.CellPadding = 1;
				FieldsTable.CellSpacing = 1;
				FieldsTable.Width = new Unit("95%");
				FieldsTable.HorizontalAlign = HorizontalAlign.Center;

				fieldsPanel.Controls.Add(FieldsTable);

				FieldsTable.Rows.Add(tr);

				TableCell tc = new TableCell();
				tc.Width = new Unit("25%");
				tc.CssClass = "label";
				tc.Text = "concept";
				
				tr.Cells.Add(tc);

				tc = new TableCell();
				tc.CssClass = "label";
				tc.Width = new Unit("5%");
				tc.HorizontalAlign = HorizontalAlign.Center;
				tc.Text = "searchable";

				tr.Cells.Add(tc);

				tc = new TableCell();
				tc.CssClass = "label";
				tc.Width = new Unit("70%");
				tc.HorizontalAlign = HorizontalAlign.Center;
				tc.Text = "mapping";

				tr.Cells.Add(tc);

				foreach (string cid in schema.GetConcepts().Keys)
				{					
					TpConcept concept = (TpConcept)schema.GetConcepts()[cid];
					
					mapping_input_name = GetInputName(concept, "mapping");
    
					tr = new TableRow();
					tr.BackColor = System.Drawing.Color.FromArgb(0xffffee);
					
					FieldsTable.Rows.Add(tr);

					tc = new TableCell();
					tc.HorizontalAlign = HorizontalAlign.Left;
					
					if (concept.IsRequired())
					{
						tc.CssClass = "label_required";
						has_mandatory_concepts = true; 
					}
					else
					{
						tc.CssClass = "label";
					}

					tc.Wrap = false;

					string val = "";
					if (concept.IsRequired())
					{
						val += TpConfigManager.TP_MANDATORY_FIELD_FLAG;
					}
					
					if (TpUtils.IsUrl(concept.GetDocumentation()))
					{
						val += "<a href=\"" + concept.GetDocumentation() + "\" target=\"_new\">";
					}
					
					val += concept.GetName();
						
					if (TpUtils.IsUrl(concept.GetDocumentation()))
					{
						val += "</a>";
					}
					
					tc.Text = val;

					tr.Cells.Add(tc);

					tc = new TableCell();
					tc.HorizontalAlign = HorizontalAlign.Center;
					
					CheckBox cb = new CheckBox();
					cb.CssClass = "checkbox";
					cb.ID = this.GetInputName(concept, "searchable");		
							
					if (concept.IsSearchable())
					{
						cb.Checked = true;
					}

					tc.Controls.Add(cb);

					tr.Cells.Add(tc);

					tc = new TableCell();
					tc.HorizontalAlign = HorizontalAlign.Left;
					tc.CssClass = "text";
					tc.Wrap = false;
					
					HtmlGenericControl ctrl = new HtmlGenericControl();
					ctrl.InnerHtml = new TpHtmlUtils().GetCombo(mapping_input_name, concept.GetMappingType(), new TpConceptMappingFactory().GetOptions(), false, false, "document.forms[1].refresh.value='" + mapping_input_name + "';document.forms[1].submit()") + "&nbsp;";
					tc.Controls.Add(ctrl);
					
					if (concept.GetMappingType() == "SingleColumnMapping")
					{
						SingleColumnMappingControl mc = (SingleColumnMappingControl)
							this.LoadControl("~/Controls/SingleColumnMappingControl.ascx");
						mc.Mapping = (SingleColumnMapping)concept.GetMapping();						
						tc.Controls.Add(mc);
					}
					else if (concept.GetMappingType() == "LSIDDataMapping")
					{
						LSIDDataMappingControl mc = (LSIDDataMappingControl)
							this.LoadControl("~/Controls/LSIDDataMappingControl.ascx");
						mc.Mapping = (LSIDDataMapping)concept.GetMapping();						
						tc.Controls.Add(mc);
					}
					else if (concept.GetMappingType() != "unmapped")
					{
						FixedValueMappingControl mc = (FixedValueMappingControl)
							this.LoadControl("~/Controls/FixedValueMappingControl.ascx");
						mc.Mapping = (FixedValueMapping)concept.GetMapping();
						tc.Controls.Add(mc);
					}					
						
					tr.Cells.Add(tc);
				}

				if (has_mandatory_concepts)
				{
					HtmlGenericControl mctrl = new HtmlGenericControl();
					mctrl.InnerHtml = "<p class=\"tip\">" + TpConfigManager.TP_MANDATORY_FIELD_FLAG + "Indicates mandatory concepts</p>";
					fieldsPanel.Controls.Add(mctrl);
				}
			}		 			
		}

		public override void  LoadDefaults()
		{
			TpDataSource r_data_source = null;
			string config_file = "";
			TpTables r_tables = null;
			
			r_local_mapping = null;

			if (this.mResource.ConfiguredMapping())
			{
				this.LoadFromXml();
			}
			else
			{
				this.SetMessage("In this step, you'll need to choose the federation schema(s) that you want to use \nand then map each concept from the federation schema(s) to a field in your local database:");
				
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
				
				// Local mapping
				r_local_mapping = this.mResource.GetLocalMapping();
				
				// If local mapping is already stored in session, initialize individual mappings
				if (Utility.OrderedMap.CountElements(r_local_mapping.GetMappedSchemas()) > 0)
				{
					this.InitializeMappings(false);
				}
			}
		}// end of member function LoadDefaults
		
		public override void  LoadFromSession()
		{
			TpTables r_tables = null;
			
			r_local_mapping = this.mResource.GetLocalMapping();
			
			// Local mapping must already be stored in the session
			if (this.mResource.ConfiguredMapping() && Utility.OrderedMap.CountElements(r_local_mapping.GetMappedSchemas()) == 0)
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
			
			r_tables = this.mResource.GetTables();
			
			// Get available tables/columns
			this.LoadDatabaseMetadata();
			
			this.InitializeMappings(false);
		}// end of member function LoadFromSession
		
		public override void  LoadFromXml()
		{
			string config_file = "";
			XmlDocument xpr = new XmlDocument();
			TpDataSource r_data_source = null;
			TpTables r_tables = null;
			bool check_consistency;
			string err_str;

			r_local_mapping = null;
			
			if (this.mResource.ConfiguredMapping())
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
				
				r_local_mapping = this.mResource.GetLocalMapping();
				
				r_local_mapping.LoadFromXml(config_file);
				
				check_consistency = true;
				
				this.InitializeMappings(check_consistency);
			}
			else
			{
				err_str = "There is no local mapping XML configuration to be loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return ;
			}
		}// end of member function LoadFromXml
		
		public virtual void  LoadDatabaseMetadata()
		{
			OleDbConnection cn = null;
			string err_str;
			TpTables r_tables = null;
			TpTable root_table = null;
			Utility.OrderedMap tables;

			TpDataSource r_data_source = this.mResource.GetDataSource();
			
			if (r_data_source.Validate(true))
			{
				cn = r_data_source.GetConnection();
				
				if (cn == null)
				{
					err_str = "Problem when getting connection to database!";
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				// Get tables involved
				
				r_tables = this.mResource.GetTables();
				
				root_table = r_tables.GetRootTable();
				
				tables = root_table.GetAllTables();

				DataTable valid_tables = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[]{null,null,null,"TABLE"});
				DataTable views = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[]{null,null,null,"VIEW"});
				foreach (DataRow r in views.Rows)
				{
					valid_tables.Rows.Add(r.ItemArray);
				}

				foreach ( string table in tables.Values ) 
				{
					DataTable cols = cn.GetOleDbSchemaTable(OleDbSchemaGuid.Columns, new object[]{null, null, table});
										
					if (valid_tables.Select("TABLE_NAME='" + table + "'").Length != 0)  
					{
						this.mTablesAndColumns[table] = cols;
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
				try
				{
					mXpr = new XmlDocument();
					mXpr.Load(mResource.GetConfigFile());
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
		
		public virtual void  InitializeMappings(bool checkConsistency)
		{
			Utility.OrderedMap r_mapped_schemas;
			bool missing_mandatory_mappings;
			Utility.OrderedMap r_concepts = null;
			TpConceptMapping r_mapping = null;
			string msg;
			string table;
			string field;
			string adodb_field;
			
			r_local_mapping = this.mResource.GetLocalMapping();
			
			r_mapped_schemas = r_local_mapping.GetMappedSchemas();
			
			missing_mandatory_mappings = false;
			
			foreach ( string ns in r_mapped_schemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)r_mapped_schemas[ns];
				r_concepts = ((TpConceptualSchema)r_mapped_schemas[ns]).GetConcepts();
				
				foreach ( string concept_id in r_concepts.Keys ) 
				{
					TpConcept concept = (TpConcept)r_concepts[concept_id];
					r_mapping = (TpConceptMapping)((TpConcept)r_concepts[concept_id]).GetMapping();
					
					// Single column mappings need tables and columns to render properly
					if (r_mapping == null)
					{
						if (checkConsistency)
						{
							if (concept.IsRequired() && !missing_mandatory_mappings)
							{
								msg = "Please specify mappings for all mandatory concepts";
								new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
								missing_mandatory_mappings = true;
							}
						}
					}
					else if (r_mapping.GetMappingType() == "SingleColumnMapping")
					{
						SingleColumnMapping scm = (SingleColumnMapping)r_mapping;
						table = scm.GetTable();
						field = scm.GetField();
							
						// Note: SetTablesAndColumns erases table/field data if they
						//       are not valid!
						scm.SetTablesAndColumns(this.mTablesAndColumns);
							
						if (checkConsistency)
						{
							adodb_field = field.ToUpper();
								
							if (this.mTablesAndColumns[table] == null || !(this.mTablesAndColumns[table] is DataTable) ||
								(((DataTable)mTablesAndColumns[table]).Select("COLUMN_NAME='" + adodb_field + "'").Length == 0))
							{
								msg = "Current mapping for concept \"" + concept.GetName() + "\"" + " (" + table + "." + field + ") does not exist in the " + "database";
								new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
							}
								
						}
					}
					else if (r_mapping.GetMappingType() == "LSIDDataMapping")
					{
						LSIDDataMapping dm = (LSIDDataMapping)r_mapping;
						table = dm.GetTable();
						field = dm.GetField();
							
						// Note: SetTablesAndColumns erases table/field data if they
						//       are not valid!
						dm.SetTablesAndColumns(this.mTablesAndColumns);
							
						if (checkConsistency)
						{
							adodb_field = field.ToUpper();
								
							if (this.mTablesAndColumns[table] == null || !(this.mTablesAndColumns[table] is DataTable) ||
								(((DataTable)mTablesAndColumns[table]).Select("COLUMN_NAME='" + adodb_field + "'").Length == 0))
							{
								msg = "Current mapping for concept \"" + concept.GetName() + "\"" + " (" + table + "." + field + ") does not exist in the " + "database";
								new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
							}
								
						}
					}
				}
				
			}
			
		}// end of member function InitializeMappings
		
		public override bool ReadyToProceed()
		{
			r_local_mapping = this.mResource.GetLocalMapping();
			int num_schemas = Utility.OrderedMap.CountElements(r_local_mapping.GetMappedSchemas());
			
			return (num_schemas > 0);
		}// end of member function ReadyToProceed
		
		
		public override void  HandleEvents()
		{
			string warn;
			string msg;
			Utility.OrderedMap parts;
			string automap_namespace;
			string fill_namespace;
			Utility.OrderedMap r_mapped_schemas;
			Utility.OrderedMap r_concepts;
			bool searchable;
			string mapping_input_name;
			string mapping_type;
			TpConceptMapping mapping;
			
			r_local_mapping = this.mResource.GetLocalMapping();
			
			// Clicked on load schemas
			if (HttpContext.Current.Request.Form["load_schemas"] != null)
			{
				if (HttpContext.Current.Request.Form["schema"] == null && HttpContext.Current.Request.Form["load_from_location"] == null)
				{
					warn = "Please select a schema to load!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, warn, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				if (HttpContext.Current.Request.Form.GetValues("schema[]") != null)
				{
					string[] schemas = HttpContext.Current.Request.Form.GetValues("schema[]");
					
					// Load each selected schema
					foreach ( string namespace_Renamed in schemas ) 
					{
						r_local_mapping.LoadSuggestedSchema(namespace_Renamed);
					}
					
				}
				
				// Load additional schema, if specified
				if (HttpContext.Current.Request.Form["load_from_location"] != null && HttpContext.Current.Request.Form["load_from_location"].Length > 0)
				{
					r_local_mapping.LoadNewSchema(HttpContext.Current.Request.Form["load_from_location"], null);
				}
			}
			else
			{
				if (HttpContext.Current.Request.Form["refresh"] != null || HttpContext.Current.Request.Form["next"] != null || HttpContext.Current.Request.Form["save"] != null)
				{
					if (HttpContext.Current.Request.Form["next"] != null && !this.ReadyToProceed())
					{
						msg = "Not a single schema has been mapped.\n" + "It is necessary to map at least one schema.";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
						return ;
					}
					
					if (HttpContext.Current.Request.Form["refresh"] != null && HttpContext.Current.Request.Form["refresh"].Length > 6 && HttpContext.Current.Request.Form["refresh"].EndsWith("^unmap"))
					{
						parts = new Utility.OrderedMap(HttpContext.Current.Request.Form["refresh"].Split("^".ToCharArray()));
						
						string namespace_Renamed = parts[0].ToString();
						
						r_local_mapping.UnmapSchema(namespace_Renamed);
					}
					
					automap_namespace = "";
					
					if (HttpContext.Current.Request.Form["refresh"] != null && HttpContext.Current.Request.Form["refresh"].Length > 8 && HttpContext.Current.Request.Form["refresh"].EndsWith("^automap"))
					{
						parts = new Utility.OrderedMap(HttpContext.Current.Request.Form["refresh"].Split("^".ToCharArray()));
						
						automap_namespace = parts[0].ToString();
					}
					
					fill_namespace = "";
					
					if (HttpContext.Current.Request.Form["refresh"] != null && HttpContext.Current.Request.Form["refresh"].Length > 5 && HttpContext.Current.Request.Form["refresh"].EndsWith("^fill"))
					{
						parts = new Utility.OrderedMap(HttpContext.Current.Request.Form["refresh"].Split("^".ToCharArray()));
						
						fill_namespace = parts[0].ToString();
					}
					
					// Refresh mappings
					r_mapped_schemas = r_local_mapping.GetMappedSchemas();
					
					foreach ( string ns in r_mapped_schemas.Keys ) 
					{
						TpConceptualSchema schema = (TpConceptualSchema)r_mapped_schemas[ns];
						r_concepts = ((TpConceptualSchema)r_mapped_schemas[ns]).GetConcepts();
						
						foreach ( string concept_id in r_concepts.Keys ) 
						{
							TpConcept concept = (TpConcept)r_concepts[concept_id];
							 /** Searchable **/
							
							searchable = false;
							
							if (TpUtils.FindVar(this.GetInputName(concept, "searchable"), null) != null)
							{
								searchable = true;
							}
							
							((TpConcept)r_concepts[concept_id]).SetSearchable(searchable);
							
							 /** Mapping **/
							
							mapping_input_name = this.GetInputName(concept, "mapping");
							
							if (TpUtils.FindVar(mapping_input_name, null) != null)
							{
								mapping_type = TpUtils.FindVar(mapping_input_name, "").ToString();
								
								mapping = concept.GetMapping();
								
								// If a new mapping type was specified, overwrite existing one
								if (mapping_type != concept.GetMappingType())
								{
									if (mapping_type == "unmapped")
									{
										if (automap_namespace == ns)
										{
											// Automap
											//TODO check this works
											mapping = this.GetAutoMapping(concept);
										}
										else if (fill_namespace == ns)
										{
											// Fill with fixed value mapping
											mapping = new TpConceptMappingFactory().GetInstance("FixedValueMapping");
											mapping.SetLocalType(TpConceptMapping.TYPE_TEXT);
											((FixedValueMapping)mapping).SetValue("");
										}
										else
										{
											// Erase mapping
											mapping = null;
										}
									}
									else 
									{
										mapping = new TpConceptMappingFactory().GetInstance(mapping_type);
										
										// Initialize single column mappings
										if (mapping_type == "SingleColumnMapping")
										{
											((SingleColumnMapping)mapping).SetTablesAndColumns(this.mTablesAndColumns);
										}
										else if (mapping_type == "LSIDDataMapping")
										{
											((LSIDDataMapping)mapping).SetTablesAndColumns(this.mTablesAndColumns);
										}
									}
								}
								else
								{
									if (mapping_type == "unmapped")
									{
										if (automap_namespace == ns)
										{
											// Automap
											mapping = this.GetAutoMapping(concept);
										}
										else if (fill_namespace == ns)
										{
											// Fill with fixed value mapping
											mapping = new TpConceptMappingFactory().GetInstance("FixedValueMapping");
											((FixedValueMapping)mapping).SetLocalType(TpConceptMapping.TYPE_TEXT);
											((FixedValueMapping)mapping).SetValue("");
										}
									}
									else
									{
										// Refresh the existing mapping
										mapping.Refresh(mTablesAndColumns);
									}
								}
								
								((TpConcept)r_concepts[concept_id]).SetMapping(mapping);
							}
						}
						
					}
					
					
					// Clicked next or save
					if (HttpContext.Current.Request.Form["next"] != null || HttpContext.Current.Request.Form["update"] != null)
					{
						if (!r_local_mapping.Validate())
						{
							return ;
						}
						
						if (!this.mResource.SaveLocalMapping(true))
						{
							return ;
						}
						
						// Clicked update
						if (HttpContext.Current.Request.Form["update"] != null)
						{
							this.SetMessage("Changes successfully saved!");
						}
						
						this.mDone = true;
					}
				}
			}
		}// end of member function HandleEvents
		
		public virtual TpConceptMapping GetAutoMapping(TpConcept concept)
		{
			SingleColumnMapping mapping = (SingleColumnMapping)new TpConceptMappingFactory().GetInstance("SingleColumnMapping");
			Utility.OrderedMap tables;
			object field_type;
						
			mapping.SetTablesAndColumns(this.mTablesAndColumns);
			
			// Auto mapping stuff
			if (Utility.OrderedMap.CountElements(this.mTablesAndColumns) == 1)
			{
				tables = this.mTablesAndColumns.GetKeysOrderedMap(null);
				
				mapping.SetTable(tables[0].ToString());
				
				foreach ( DataRow row in ((DataTable)this.mTablesAndColumns[tables[0]]).Rows ) 
				{
					if (Utility.StringSupport.StringCompare(concept.GetName(), row["COLUMN_NAME"].ToString(), false) == 0)
					{
						mapping.SetField(row["COLUMN_NAME"].ToString());
						
						field_type = new TpConfigUtils().GetFieldType(row["DATA_TYPE"].ToString());
						
						mapping.SetLocalType(field_type);
						
						break;
					}
				}
				
			}
			
			return mapping;
		}// end of member function GetAutoMapping
		
		public virtual TpLocalMapping GetLocalMapping()
		{
			return this.mLocalMapping;
		}// end of member function GetLocalMapping
		
		public virtual string GetInputName(TpConcept concept, string suffix)
		{
			return Utility.StringSupport.StringReplace(concept.GetId() + "^" + suffix, ".", "_");
		}// end of member function GetInputName
		
		public virtual Utility.OrderedMap GetTablesAndColumns()
		{
			// Needed by Refresh method of SingleColumnMapping class
			
			return this.mTablesAndColumns;
		}// end of member function GetTablesAndColumns
		
		public virtual string GetTable(TpConcept concept)
		{
			SingleColumnMapping mapping = (SingleColumnMapping)concept.GetMapping();
			string mapped_table;
			
			if (mapping != null)
			{
				mapped_table = mapping.GetTable();
				
				if (mapped_table != "")
				{
					return mapped_table;
				}
			}
			
			return "0";
		}// end of member function GetTable

	}
}
