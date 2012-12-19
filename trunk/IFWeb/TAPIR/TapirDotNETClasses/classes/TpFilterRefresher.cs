using System;
using System.Data;
using System.Data.OleDb;

namespace TapirDotNET 
{

	public class TpFilterRefresher:TpFilterVisitor
	{
		public Utility.OrderedMap mTablesAndColumns = new Utility.OrderedMap();// array (table_name => array(column obj) )
		
		public TpFilterRefresher()
		{
			
		}
		
		
		public virtual void  SetTablesAndColumns(Utility.OrderedMap tablesAndColumns)
		{
			this.mTablesAndColumns = tablesAndColumns;
		}// end of member function SetTablesAndColumns
		
		public virtual bool Refresh(TpFilter rFilter)
		{
			TpBooleanOperator r_root_boolean_operator = (TpBooleanOperator)rFilter.GetRootBooleanOperator();
			Utility.OrderedMap args = new Utility.OrderedMap();
						
			if (r_root_boolean_operator != null)
			{
				args = new Utility.OrderedMap();
				
				args["path"] = "/0";
				
				return (r_root_boolean_operator.Accept(this, args) != null);
			}
			
			return true;
		}// end of member function Refresh
		
		public override object VisitLogicalOperator(TpLogicalOperator rLop, object args) //args = Utility.OrderedMap 
		{
			string path = ((Utility.OrderedMap)args)["path"].ToString();
			string lop_id = path;
			Utility.OrderedMap refresh;
			string changed_op_id;
			string cut_point;
			string lop_connection_id;
			int env_type;
			Utility.OrderedMap r_boolean_operators;
			int i;
						
			// Only change type if necessary
			if (TpUtils.GetVar("refresh", "").ToString().EndsWith("_lopchange"))
			{
				refresh = new Utility.OrderedMap(TpUtils.GetVar("refresh", "").ToString().Split("_".ToCharArray()));
				
				changed_op_id = refresh[0].ToString();
				
				if (changed_op_id == lop_id)
				{
					cut_point = refresh[1].ToString();
					
					lop_connection_id = lop_id + "_" + cut_point;
					
					env_type = int.Parse(TpUtils.GetVar(lop_connection_id, -1).ToString());
					
					if (env_type != - 1)
					{
						rLop.SetLogicalType(env_type);
					}
				}
			}
			
			r_boolean_operators = rLop.GetBooleanOperators();
			
			for (i = 0; i < Utility.OrderedMap.CountElements(r_boolean_operators); ++i)
			{
				((Utility.OrderedMap)args)["path"] = path + "/" + i.ToString();
				((Utility.OrderedMap)args)["seq"] = i;
				
				if (((TpBooleanOperator)r_boolean_operators[i]).Accept(this, args) == null)
				{
					return false;
				}
			}
			
			return true;
		}// end of member function VisitLogicalOperatior
		
		public override object VisitComparisonOperator(TpComparisonOperator rCop, object args)
		{
			string path;
			string cop_id;
			int current_type;
			int env_type;
			string column_id;
			string column;
			Utility.OrderedMap parts;
			string table;
			string field;
			string new_reference;
			string current_reference;
			TpExpression base_concept;
			object type;
			TpTransparentConcept concept;
			string error;
			string value_id;
			object r_expressions;
			string env_value;
			Utility.OrderedMap values;
			int i;
			path = ((Utility.OrderedMap)args)["path"].ToString();
			
			cop_id = path;
			
			current_type = (int)rCop.GetComparisonType();
			
			env_type = int.Parse(TpUtils.GetVar(cop_id, -1).ToString());
			
			if (env_type != - 1 && env_type != current_type)
			{
				rCop.SetComparisonType(env_type);
			}
			
			column_id = path + "@col";
			
			column = TpUtils.GetVar(column_id, "").ToString();
			
			if (Utility.VariableSupport.Empty(column))
			{
				rCop.SetBaseConcept(null);
			}
			else
			{
				parts = new Utility.OrderedMap(column.Split(".".ToCharArray()));
				
				if (Utility.OrderedMap.CountElements(parts) == 2)
				{
					table = parts[0].ToString();
					field = parts[1].ToString();
					
					new_reference = table + "." + field;
					
					current_reference = "";
					
					base_concept = rCop.GetBaseConcept();
					
					if (base_concept != null)
					{
						current_reference = ((TpConcept)base_concept.GetReference()).GetMapping().GetSqlTarget();
					}
					
					if (base_concept != null || current_reference != new_reference)
					{
						string oledb_field = field.ToUpper();
						
						DataTable dt = (DataTable)this.mTablesAndColumns[table];
						DataRow[] rows = dt.Select("COLUMN_NAME = '" + oledb_field + "'");
						if (rows.Length > 0)
						{
							string dtype = rows[0]["DATA_TYPE"].ToString();							
							type = new TpConfigUtils().GetFieldType(dtype);
							
							concept = new TpTransparentConcept(table, field, type);
							
							rCop.SetBaseConcept(new TpExpression(TpFilter.EXP_COLUMN, concept));
						}
						else
						{
							error = "Could not find data type for field: \"" + table + "." + field + "\"";
							new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
							return false;
						}
					}
				}
				else
				{
					error = "Unexpected column format: \"" + column + "\"";
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			value_id = cop_id + "@val";
			
			r_expressions = rCop.GetExpressions();
			
			env_value = TpUtils.GetVar(value_id, "").ToString();
			
			rCop.ResetExpressions();
			
			if (rCop.GetComparisonType() == TpFilter.COP_IN)
			{
				values = new Utility.OrderedMap(env_value.Split(",".ToCharArray()));
				
				for (i = 0; i < Utility.OrderedMap.CountElements(values); ++i)
				{
					rCop.SetExpression(new TpExpression(TpFilter.EXP_LITERAL, Utility.TypeSupport.ToString(values[i])));
				}
			}
			else
			{
				if (rCop.GetComparisonType() == TpFilter.COP_ISNULL)
				{
					if (!Utility.VariableSupport.Empty(env_value))
					{
						error = "\"isNull\" conditions should have no associated value";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
						return false;
					}
				}
				else
				{
					rCop.SetExpression(new TpExpression(TpFilter.EXP_LITERAL, env_value));
				}
			}
			
			return true;
		}// end of member function VisitComparisonOperator
		
		public override object VisitExpression(TpExpression expression, object args)
		{
			return null;
			// never called
		}// end of member function VisitExpression
	}
}
