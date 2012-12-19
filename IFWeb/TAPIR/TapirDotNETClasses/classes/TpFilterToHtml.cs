using System;
using System.Data;

namespace TapirDotNET 
{

	public class TpFilterToHtml:TpFilterVisitor
	{
		public Utility.OrderedMap mBinaryCops = new Utility.OrderedMap(new object[]{TpFilter.COP_EQUALS, "equals"}, new object[]{TpFilter.COP_LIKE, "contains (* for wildcard)"}, new object[]{TpFilter.COP_LESSTHAN, "less than"}, new object[]{TpFilter.COP_LESSTHANOREQUALS, "less than or equal to"}, new object[]{TpFilter.COP_GREATERTHAN, "greater than"}, new object[]{TpFilter.COP_GREATERTHANOREQUALS, "greater than or equal to"}, new object[]{TpFilter.COP_IN, "in list (comma-delimited)"});
		public Utility.OrderedMap mUnaryCops = new Utility.OrderedMap();
		public Utility.OrderedMap mMultiLops = new Utility.OrderedMap(new object[]{TpFilter.LOP_AND, "and"}, new object[]{TpFilter.LOP_OR, "or"});
		public Utility.OrderedMap mUnaryLops = new Utility.OrderedMap();
		public Utility.OrderedMap mTablesAndColumns = new Utility.OrderedMap();
		// comparative operators
		
		
		// logical operators
		
		// array (table_name => array(column obj) )
		
		public TpFilterToHtml()
		{
			
		}
		
		
		public virtual void  SetTablesAndColumns(Utility.OrderedMap tablesAndColumns)
		{
			this.mTablesAndColumns = tablesAndColumns;
		}// end of member function SetTablesAndColumns
		
		public virtual string GetHtml(TpFilter rFilter)
		{
			Utility.OrderedMap args = new Utility.OrderedMap();
			string html;
			TpBooleanOperator root_boolean_operator = (TpBooleanOperator)rFilter.GetRootBooleanOperator();
			
			if (root_boolean_operator != null)
			{
				args = new Utility.OrderedMap();
				
				args["path"] = "/0";
				
				html = root_boolean_operator.Accept(this, args).ToString();
				
				if ((int)root_boolean_operator.GetBooleanType() == TpFilter.COP_TYPE)
				{
					html += "<br/>";
				}
				
				return html;
			}
			
			return this._GetAddButtons("root") + "<br/>";
		}// end of member function GetHtml
		
		public override object VisitLogicalOperator(TpLogicalOperator lop, object args) //args = Utility.OrderedMap 
		{
			string html;
			string path;
			string lop_id;
			double level;
			string css_class;
			string lop_name;
			int logical_type;
			Utility.OrderedMap boolean_operators;
			int total;
			bool add_line;
			string lop_connection_id;
			string js;
			html = "";
			
			path = ((Utility.OrderedMap)args)["path"].ToString();
			
			lop_id = path;
			
			level = Utility.StringSupport.SubstringCount(path, "/") - 1;
			
			css_class = (Utility.MathSupport.FMod(level, 2) != 0)?"box1":"box2";
			
			lop_name = "?";
			
			logical_type = lop.GetLogicalType();
			
			if (logical_type == TpFilter.LOP_AND)
			{
				lop_name = "and";
			}
			else
			{
				if (logical_type == TpFilter.LOP_OR)
				{
					lop_name = "or";
				}
				else
				{
					if (logical_type == TpFilter.LOP_NOT)
					{
						lop_name = "not";
					}
				}
			}
			
			html += "\n" + string.Format("<div class=\"{0}\" nowrap=\"1\">", css_class) + "\n";
			
			if (logical_type == TpFilter.LOP_NOT)
			{
				html += "<b>" + lop_name.ToUpper() + "</b>&nbsp;&nbsp;";
				
				html += this._GetRemoveButton(lop_id, "remove negation");
				html += "<br/>";
			}
			else
			{
				html += this._GetRemoveButton(lop_id, "remove logical operator box");
				html += "<br/>";
			}
			
			boolean_operators = lop.GetBooleanOperators();
			
			total = Utility.OrderedMap.CountElements(boolean_operators);
			
			add_line = false;
			
			for (int i = 0; i < total; ++i)
			{
				((Utility.OrderedMap)args)["path"] = path + "/" + i;
				
				if ((int)((TpBooleanOperator)boolean_operators[i]).GetBooleanType() == TpFilter.COP_TYPE)
				{
					add_line = true;
					
					html += "<br/>";
				}
				else
				{
					add_line = false;
				}
				
				html = html + ((TpBooleanOperator)boolean_operators[i]).Accept(this, args).ToString();
				
				if (logical_type != TpFilter.LOP_NOT && total > 1 && i < total - 1)
				{
					if (add_line)
					{
						html += "<br/><br/>";
					}
					
					lop_connection_id = lop_id + "_" + i;
					
					js = string.Format("document.forms[1].refresh.value='{0}';window.saveScroll();document.forms[1].submit();", lop_connection_id + "_lopchange");
					
					html += new TpHtmlUtils().GetCombo(lop_connection_id, logical_type, this._GetOptions("lops"), false, "", js);
					html += "<br/>";
				}
			}
			
			if (logical_type != TpFilter.LOP_NOT || total == 0)
			{
				if (add_line)
				{
					html += "<br/>";
				}
				
				html += "<br/>" + this._GetAddButtons(lop_id);
			}
			
			html += "</div>" + "\n";
			
			return html;
		}// end of member function VisitLogicalOperatior
		
		public override object VisitComparisonOperator(TpComparisonOperator cop, object args) //args = Utility.OrderedMap 
		{
			string html;
			string path;
			string cop_id;
			TpExpression base_concept;
			string column_id;
			string value_id;
			Utility.OrderedMap expressions;
			string value_Renamed;
			int i;
			html = "\n";
			
			path = ((Utility.OrderedMap)args)["path"].ToString();
			
			cop_id = path;
			
			base_concept = cop.GetBaseConcept();
			
			if (base_concept != null)
			{
				html = html + base_concept.Accept(this, args).ToString();
			}
			else
			{
				column_id = path + "@col";
				
				html += new TpHtmlUtils().GetCombo(column_id, "", this._GetOptions("columns"), false, "", "");
			}
			
			html += "&nbsp;" + new TpHtmlUtils().GetCombo(cop_id, cop.GetComparisonType(), this._GetOptions("cops"), false, false?"1":"", "") + "&nbsp;";
			
			value_id = cop_id + "@val";
			
			expressions = cop.GetExpressions();
			
			value_Renamed = "";
			
			for (i = 0; i < Utility.OrderedMap.CountElements(expressions); ++i)
			{
				if (i > 0)
				{
					value_Renamed += ",";
				}
				
				value_Renamed = value_Renamed + ((TpExpression)expressions[i]).GetReference();
			}
			
			html += "<input type=\"text\" name=\"" + value_id + "\" " + "value=\"" + value_Renamed + "\" " + "size=\"10\">" + "\n" + "&nbsp;";
			
			
			html += this._GetRemoveButton(cop_id, "remove");
			
			return html;
		}// end of member function VisitComparisonOperator
		
		public override object VisitExpression(TpExpression expression, object args) //args = Utility.OrderedMap 
		{
			string path;
			string column_id;
			TpConcept concept;
			SingleColumnMapping mapping;
			string table;
			string field;
			string column;
			string msg;
			if (expression.GetType() == TpFilter.EXP_COLUMN)
			{
				path = ((Utility.OrderedMap)args)["path"].ToString();
				
				column_id = path + "@col";
				
				concept = (TpConcept)expression.GetReference();
				
				mapping = (SingleColumnMapping)concept.GetMapping();
				
				table = mapping.GetTable();
				
				field = mapping.GetField();
				
				column = table + "." + field;
				
				string oledb_field = field.ToUpper();
				
				if (this.mTablesAndColumns[table] == null)
				{
					msg = "Table \"" + table + "\" is referenced by the current filter but " + "does not exist in the database.";
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
				}
				else
				{
					DataTable dt = (DataTable)this.mTablesAndColumns[table];
					DataRow[] rows = dt.Select("COLUMN_NAME = '" + oledb_field + "'");
					if (rows.Length == 0)
					{
						msg = "Column \"" + field + "\" is referenced by the current filter but " + "does not exist in the database.";
						new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
					}
				}
				
				return new TpHtmlUtils().GetCombo(column_id, column, this._GetOptions("columns"), false, false?"1":"", "");
			}
			
			return expression.GetReference();
		}// end of member function VisitExpression
		
		public virtual Utility.OrderedMap _GetOptions(string id)
		{
			Utility.OrderedMap options;
			options = new Utility.OrderedMap();
			
			if (id == "cops")
			{
				// It's important to preserve keys, so don't use array_merge!
				options = Utility.OrderedMap.Append(this.mBinaryCops, this.mUnaryCops);
				
				//array_unshift( $options, '-- comparator --' );
			}
			else if (id == "lops")
			{
				options = this.mMultiLops;
				
				//array_unshift( $options, '-- operator --' );
			}
			else if (id == "columns")
			{
				foreach ( string table in this.mTablesAndColumns.Keys ) 
				{
					DataTable columns = (DataTable)this.mTablesAndColumns[table];
					foreach ( DataRow column in columns.Rows ) 
					{
						options.Push(table + "." + column["COLUMN_NAME"].ToString());
					}
							
				}
					
					
				options = TpUtils.GetHash(options);
				Utility.OrderedMap.SortValuePreserve(ref options, 0);
					
				Utility.OrderedMap.Unshift(ref options, "-- column --");
			}
			
			return options;
		}// end of member function _GetOptions
		
		public virtual string _GetRemoveButton(string id, string label)
		{
			return "<input type=\"submit\" name=\"remove\" value=\"" + label + "\" " + "onClick=\"document.forms[1].refresh.value=\'" + id + "\';" + "document.forms[1].submit();\"/>";
		}// end of member function _GetRemoveButton
		
		public virtual string _GetAddButtons(string id)
		{
			string add_cop_button;
			string add_multi_lop_button;
			string add_not_lop_button;
			add_cop_button = "<input type=\"submit\" name=\"add_cop\" value=\"add simple comparison\" onClick=\"document.forms[1].refresh.value=\'" + id + "\';document.forms[1].submit();\">";
			add_multi_lop_button = "<input type=\"submit\" name=\"add_multi_lop\" value=\"add logical operator box\" onClick=\"document.forms[1].refresh.value=\'" + id + "\';document.forms[1].submit();\">";
			add_not_lop_button = "<input type=\"submit\" name=\"add_not_lop\" value=\"add NOT condition\" onClick=\"document.forms[1].refresh.value=\'" + id + "\';document.forms[1].submit();\">";
			
			return "\n" + add_cop_button + "&nbsp;" + add_multi_lop_button + "&nbsp;" + add_not_lop_button;
		}// end of member function _GetAddButtons
	}
}
