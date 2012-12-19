using System;
using System.Web;
using System.Data;
 
using TapirDotNET.Controls;

namespace TapirDotNET 
{

	public class SingleColumnMapping:TpConceptMapping
	{
		public Utility.OrderedMap mTablesAndColumns = new Utility.OrderedMap();
		public string mTable = "";
		public string mField = "";
		
		public SingleColumnMapping()
		{
			mMappingType = "SingleColumnMapping";			
		}
		
		
		public virtual void  SetTablesAndColumns(Utility.OrderedMap tablesAndColumns)
		{
			string adodb_field;
			this.mTablesAndColumns = tablesAndColumns;
			
			if (this.mTable != null)
			{
				if (this.mTablesAndColumns[this.mTable] == null)
				{
					this.mTable = "";
					this.mField = "";
				}
				else
				{
					if (this.mField != null)
					{
						adodb_field = this.mField.ToUpper();
												
						if (((DataTable)this.mTablesAndColumns[mTable]).Select("COLUMN_NAME='" + adodb_field + "'").Length == 0)
						{
							this.mField = "";
						}
					}
				}
			}
		}// end of member function SetTablesAndColumns
		
		public virtual void  SetTable(string table)
		{
			this.mTable = table;
		}// end of member function SetTable
		
		public virtual string GetTable()
		{
			return this.mTable;
		}// end of member function GetTable
		
		public virtual void  SetField(string field)
		{
			this.mField = field;
		}// end of member function SetField
		
		public virtual string GetField()
		{
			return this.mField;
		}// end of member function GetField
		
		public override bool IsMapped()
		{
			if ((!base.IsMapped()) || Utility.VariableSupport.Empty(this.mTable) || Utility.VariableSupport.Empty(this.mField))
			{
				return false;
			}
			
			return true;
		}// end of member function IsMapped
		
		public override void Refresh(Utility.OrderedMap tablesAndCols)
		{
			base.Refresh(tablesAndCols);
			
			this.SetTablesAndColumns(tablesAndCols);
			
			string table_input_name = this.GetInputName("table");
			string field_input_name = this.GetInputName("field");
			
			if (TpUtils.FindVar(table_input_name, null) != null)
			{
				// TODO: check if table belongs to database
				this.mTable = TpUtils.FindVar(table_input_name, "").ToString();
			}
			
			if (TpUtils.FindVar(field_input_name, null) != null)
			{
				// TODO: check if field belongs to table
				this.mField = TpUtils.FindVar(field_input_name, "").ToString();
				
				if (HttpContext.Current.Request.Form["refresh"] == field_input_name)
				{
					// If changed this field or chose this field for the first time
					// then try to figure out the type
					
					string oledb_field = this.mField.ToUpper();
					
					DataTable dt = (DataTable)this.mTablesAndColumns[mTable];
					DataRow[] rows = dt.Select("COLUMN_NAME = '" + oledb_field + "'");
					if (rows.Length > 0)
					{
						string type = rows[0]["DATA_TYPE"].ToString();
						this.SetLocalType(new TpConfigUtils().GetFieldType(type));
					}
				}
			}
		}// end of member function Refresh
		
		public override string GetHtml()
		{
			if (this.mrConcept == null)
			{
				return "Mapping has no associated concept!";
			}
			
			if (Utility.OrderedMap.CountElements(this.mTablesAndColumns) == 0)
			{
				return "Mapping has no associated db metadata!";
			}
			
			
			return base.GetHtml();
		}// end of member function GetHtml
		
		public override string GetXml()
		{
			string xml;
			xml = "\t\t\t\t";
			
			xml += "<singleColumnMapping type=\"" + this.mLocalType + "\">" + "\n\t\t\t\t\t" + "<column table=\"" + TpUtils.EscapeXmlSpecialChars(this.mTable) + "\" " + "field=\"" + TpUtils.EscapeXmlSpecialChars(this.mField) + "\"/>" + "\n\t\t\t\t" + "</singleColumnMapping>";
			
			return xml;
		}// end of member function GetXtml
		
		public virtual string GetInputName(string suffix)
		{
			string error;
			if (this.mrConcept == null)
			{
				error = "Single column mapping cannot give an input name without having " + "an associated concept!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return "undefined_concept_" + suffix;
			}
			
			return Utility.StringSupport.StringReplace(Utility.TypeSupport.ToString(this.mrConcept.GetId()) + "_" + suffix, ".", "_");
		}// end of member function GetInputName
		
		public virtual Utility.OrderedMap GetOptions(string id)
		{
			Utility.OrderedMap options = new Utility.OrderedMap();
			
			if (id == "tables")
			{
				if (this.mTablesAndColumns != null)
				{
					options = this.mTablesAndColumns.GetKeysOrderedMap(null);
					
					options = TpUtils.GetHash(options);
				}
				
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
				Utility.OrderedMap.Unshift(ref options, "-- table --");
			}
			else if (id == "fields")
			{
				if (this.mTablesAndColumns != null && this.mTable != null && this.mTable != "0")
				{
					if (this.mTablesAndColumns[this.mTable] is DataTable)
					{
						DataTable columns = (DataTable)this.mTablesAndColumns[this.mTable];
						
						foreach ( DataRow col in columns.Rows ) 
						{
							options.Push(col["COLUMN_NAME"]); 
						}
						
						
						options = TpUtils.GetHash(options);
					}
				}
				
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
				Utility.OrderedMap.Unshift(ref options, "-- column --");
			}
			
			return options;
		}// end of member function GetOptions
		
		public override string GetSqlTarget()
		{
			return this.mTable + "." + this.mField;
		}// end of member function GetSqlTarget
		
		public override Utility.OrderedMap GetSqlFrom()
		{
			TpOptions.SetSetting(this.mTable, this.mTable);
			return new Utility.OrderedMap();
		}// end of member function GetSqlFrom
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mMappingType", "mTable", "mField", "mLocalType");
		}// end of member function __sleep
	}
}
