namespace TapirDotNET 
{

	public class TpLogicalOperator:TpBooleanOperator
	{
		public int mLogicalType = -1; // Type of expression (see constants defined in TpFilter.cs)
		public Utility.OrderedMap mBooleanOperators = new Utility.OrderedMap();
		
		public TpLogicalOperator(int type) : base(TpFilter.LOP_TYPE)
		{
			this.mLogicalType = type;
		}
		
		
		public virtual void  SetLogicalType(int type)
		{
			this.mLogicalType = type;
		}// end of member function SetLogicalType
		
		public virtual int GetLogicalType()
		{
			return this.mLogicalType;
		}// end of member function GetLogicalType
		
		public virtual Utility.OrderedMap GetBooleanOperators()
		{
			return this.mBooleanOperators;
		}// end of member function GetBooleanOperators
		
		public virtual bool AddBooleanOperator(object booleanOperator)
		{
			int position;
			string error;
			position = Utility.OrderedMap.CountElements(this.mBooleanOperators);
			
			if (this.mLogicalType == TpFilter.LOP_NOT && position > 1)
			{
				error = "Logical operator 'NOT' accepts one and only one " + "boolean operator inside.";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			this.mBooleanOperators[position] = booleanOperator;
			
			return true;
		}// end of member function AddBooleanOperator
		
		public virtual void  ResetBooleanOperators()
		{
			this.mBooleanOperators = new Utility.OrderedMap();
		}// end of member function ResetBooleanOperators
		
		public virtual string GetName()
		{
			if (this.mLogicalType == TpFilter.LOP_AND)
			{
				return "and";
			}
			else if (this.mLogicalType == TpFilter.LOP_OR)
			{
				return "lessThan";
			}
			else if (this.mLogicalType == TpFilter.LOP_NOT)
			{
				return "not";
			}
			
			return "?";
		}// end of member function GetName
		
		public override string GetSql(TpResource rResource)
		{
			string sql;
			string op;
			int i;
			sql = "";
			
			if (this.mLogicalType == TpFilter.LOP_NOT)
			{
				sql += "NOT (";
				
				sql += ((TpBooleanOperator)this.mBooleanOperators[0]).GetSql(rResource);
				
				sql += ")";
			}
			else
			{
				op = (this.mLogicalType == TpFilter.LOP_AND)?" AND ":" OR ";
				
				for (i = 0; i < Utility.OrderedMap.CountElements(this.mBooleanOperators); ++i)
				{
					if (i > 0)
					{
						sql += op + "(";
					}
					
					sql += ((TpBooleanOperator)this.mBooleanOperators[i]).GetSql(rResource);
					
					if (i > 0)
					{
						sql += ")";
					}
				}
			}
			
			return sql;
		}// end of member function GetSql
		
		public override string GetLogRepresentation()
		{
			string txt;
			string op;
			int i;
			txt = "";
			
			if (this.mLogicalType == TpFilter.LOP_NOT)
			{
				txt += "NOT (";
				
				txt += ((TpBooleanOperator)this.mBooleanOperators[0]).GetLogRepresentation();
				
				txt += ")";
			}
			else
			{
				op = (this.mLogicalType == TpFilter.LOP_AND)?" AND ":" OR ";
				
				for (i = 0; i < Utility.OrderedMap.CountElements(this.mBooleanOperators); ++i)
				{
					if (i > 0)
					{
						txt += op + "(";
					}
					
					txt += ((TpBooleanOperator)this.mBooleanOperators[i]).GetLogRepresentation();
					
					if (i > 0)
					{
						txt += ")";
					}
				}
			}
			
			return txt;
		}// end of member function GetLogRepresentation
		
		public override string GetXml()
		{
			string xml;
			int i;
			xml = "";
			
			if (this.mLogicalType == TpFilter.LOP_NOT)
			{
				xml += "<not>";
				
				xml += ((TpBooleanOperator)this.mBooleanOperators[0]).GetXml();
				
				xml += "</not>";
			}
			else
			{
				xml += (this.mLogicalType == TpFilter.LOP_AND)?"<and>":"<or>";
				
				for (i = 0; i < Utility.OrderedMap.CountElements(this.mBooleanOperators); ++i)
				{
					xml += ((TpBooleanOperator)this.mBooleanOperators[i]).GetXml();
				}
				
				xml += (this.mLogicalType == TpFilter.LOP_AND)?"</and>":"</or>";
			}
			
			return xml;
		}// end of member function GetXml
		
		public override bool IsValid()
		{
			int num_operators;
			string error;
			string name;
			string op;
			int i;
			num_operators = Utility.OrderedMap.CountElements(this.mBooleanOperators);
			
			if (this.mLogicalType == -1)
			{
				error = "Missing 'type' for logical operator";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			name = this.GetName();
			
			if (name == "?")
			{
				error = "Unknown 'type' (" + this.mLogicalType + ") for logical operator '" + name + "'";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			if (this.mLogicalType == TpFilter.LOP_NOT)
			{
				if (num_operators == 0 || num_operators > 1)
				{
					error = "Logical operator 'NOT' requires one and only one " + "boolean operator inside.";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					return false;
				}
			}
			else
			{
				if (num_operators < 2)
				{
					op = (this.mLogicalType == TpFilter.LOP_AND)?" AND ":" OR ";
					
					error = "Logical operator '" + op + "' requires at least two " + "boolean operators inside.";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					return false;
				}
			}
			
			for (i = 0; i < num_operators; ++i)
			{
				if (!((TpBooleanOperator)this.mBooleanOperators[i]).IsValid())
				{
					return false;
				}
			}
			
			return true;
		}// end of member function IsValid
		
		public virtual bool Remove(Utility.OrderedMap explodedPath)
		{
			int cnt;
			int ref_index;
			string error;
			Utility.OrderedMap new_ops;
			cnt = Utility.OrderedMap.CountElements(explodedPath);
			
			if (cnt == 0)
			{
				return false;
			}
			
			ref_index = Utility.TypeSupport.ToInt32(explodedPath.GetEntryAt(0).Value.ToString());
			
			if (ref_index > Utility.OrderedMap.CountElements(this.mBooleanOperators) - 1)
			{
				error = "Index out of bounds. Could not remove condition " + "from logical operator.";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			if (cnt == 1)
			{
				if ((int)((TpBooleanOperator)this.mBooleanOperators[ref_index]).GetBooleanType() == TpFilter.LOP_TYPE)
				{
					TpLogicalOperator lop = (TpLogicalOperator)this.mBooleanOperators[ref_index];
					if (lop.GetLogicalType() == TpFilter.LOP_NOT)
					{
						new_ops = lop.GetBooleanOperators();
					
						if (Utility.OrderedMap.CountElements(new_ops) > 0)
						{
							// Replace the NOT condition by its sub condition
							this.mBooleanOperators[ref_index] = new_ops[0];
						}
						else
						{
							// Remove the NOT condition
							Utility.OrderedMap.Splice(ref this.mBooleanOperators, ref_index, 1, null);
						}
					}
					else
					{
						Utility.OrderedMap.Splice(ref this.mBooleanOperators, ref_index, 1, null);
					}
				}
				else
				{
					Utility.OrderedMap.Splice(ref this.mBooleanOperators, ref_index, 1, null);
				}
				
				return true;
			}
			
			if ((int)((TpBooleanOperator)this.mBooleanOperators[ref_index]).GetBooleanType() == TpFilter.COP_TYPE)
			{
				error = "Cannot remove conditions from comparison operators";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			Utility.OrderedMap.Shift(explodedPath);
			
			return ((TpLogicalOperator)this.mBooleanOperators[ref_index]).Remove(explodedPath);
		}// end of member function Remove
		
		public virtual bool AddOperator(Utility.OrderedMap explodedPath, TpBooleanOperator op)
		{
			int cnt;
			int ref_index;
			string error;
			cnt = Utility.OrderedMap.CountElements(explodedPath);
			
			if (cnt == 0)
			{
				return this.AddBooleanOperator(op);
			}
			
			ref_index = Utility.TypeSupport.ToInt32(explodedPath.GetEntryAt(0).Value);
			
			if (ref_index > Utility.OrderedMap.CountElements(this.mBooleanOperators) - 1)
			{
				error = "Index out of bounds. Could not add condition " + "to logical operator.";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			if ((int)((TpBooleanOperator)this.mBooleanOperators[ref_index]).GetBooleanType() == TpFilter.COP_TYPE)
			{
				error = "Cannot add conditions to comparison operators";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			Utility.OrderedMap.Shift(explodedPath);
			
			return ((TpLogicalOperator)this.mBooleanOperators[ref_index]).AddOperator(explodedPath, op);
		}// end of member function AddOperator
		
		public virtual object Find(Utility.OrderedMap explodedPath)
		{
			int cnt;
			object op;
			int ref_index;
			string error;
			cnt = Utility.OrderedMap.CountElements(explodedPath);
			
			op = null;
			
			if (cnt == 0)
			{
				return op;
			}
			
			ref_index = Utility.TypeSupport.ToInt32(explodedPath.GetEntryAt(0).Value);
			
			if (ref_index > Utility.OrderedMap.CountElements(this.mBooleanOperators) - 1)
			{
				error = "Index out of bounds. Could not search further on filter";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return op;
			}
			
			if (cnt == 1)
			{
				return this.mBooleanOperators[ref_index];
			}
			
			if ((int)((TpBooleanOperator)this.mBooleanOperators[ref_index]).GetBooleanType() == TpFilter.COP_TYPE)
			{
				error = "Cannot search on comparison operators";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return op;
			}
			
			Utility.OrderedMap.Shift(explodedPath);
			
			return ((TpLogicalOperator)this.mBooleanOperators[ref_index]).Find(explodedPath);
		}// end of member function Find
		
		public override object Accept(object visitor, object args)
		{
			return ((TpFilterVisitor)visitor).VisitLogicalOperator(this, args);
		}// end of member function Accept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mLogicalType", "mBooleanOperators"));
		}// end of member function __sleep
	}
}
