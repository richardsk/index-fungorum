using System.Data.OleDb;


namespace TapirDotNET 
{

	public class TpComparisonOperator:TpBooleanOperator
	{
		public int mComparisonType = -1;  // Type of COP (see constants defined in TpFilter.cs)
		public TpExpression mBaseConcept; // Base TpExpression representing a concept or column 
		public Utility.OrderedMap mExpressions = new Utility.OrderedMap();
				
		public TpComparisonOperator(int type) : base(TpFilter.COP_TYPE)
		{
			this.mComparisonType = type;
		}
		
		
		public virtual void  SetComparisonType(int type)
		{
			this.mComparisonType = type;
		}// end of member function SetComparisonType
		
		public virtual int GetComparisonType()
		{
			return this.mComparisonType;
		}// end of member function GetComparisonType
		
		public virtual void  SetExpression(TpExpression expression)
		{
			int size;
			size = Utility.OrderedMap.CountElements(this.mExpressions);
			
			if (size == 0 && expression.GetType() == TpFilter.EXP_CONCEPT || expression.GetType() == TpFilter.EXP_COLUMN)
			{
				this.mBaseConcept = expression;
			}
			else
			{
				this.mExpressions[size] = expression;
			}
		}// end of member function SetConcept
		
		public virtual void  SetBaseConcept(TpExpression expression)
		{
			this.mBaseConcept = expression;
		}// end of member function SetBaseConcept
		
		public virtual TpExpression GetBaseConcept()
		{
			return this.mBaseConcept;
		}// end of member function GetBaseConcept
		
		public virtual Utility.OrderedMap GetExpressions()
		{
			return this.mExpressions;
		}// end of member function GetExpressions
		
		public virtual void  ResetExpressions()
		{
			this.mExpressions = new Utility.OrderedMap();
		}// end of member function ResetExpressions
		
		public override string GetSql(TpResource rResource)
		{
			TpConcept concept = null;
			string concept_id;
			TpLocalMapping r_local_mapping;
			string msg;
			TpConceptMapping mapping;
			string target;
			string sql;
			string local_type;
			bool case_sensitive;
			TpSettings r_settings;
			TpDataSource r_data_source;
			OleDbConnection r_adodb_connection;
			int i;
			bool is_like;
			string term;
						
			if (this.mBaseConcept.GetType() == TpFilter.EXP_CONCEPT)
			{
				concept_id = this.mBaseConcept.GetReference().ToString();
				
				r_local_mapping = rResource.GetLocalMapping();
				
				concept = r_local_mapping.GetConcept(concept_id);
				
				// TODO: avoid error in non mandatory comparisons 
				if (concept == null || !concept.IsMapped())
				{
					msg = "Concept \"" + concept_id + "\" is not mapped";
					
					new TpDiagnostics().Append(TpConfigManager.DC_UNMAPPED_CONCEPT, msg, TpConfigManager.DIAG_WARN);
					return "FALSE";
				}
				
				if (!concept.IsSearchable())
				{
					msg = "Concept \"" + concept_id + "\" is not searchable";
					
					new TpDiagnostics().Append(TpConfigManager.DC_UNSEARCHABLE_CONCEPT, msg, TpConfigManager.DIAG_WARN);
					return "FALSE";
				}
			}
			else
			{
				concept = (TpConcept)this.mBaseConcept.GetReference();// local filters
			}
			
			mapping = (TpConceptMapping)concept.GetMapping();
			
			target = mapping.GetSqlTarget();
			
			if (this.mComparisonType == TpFilter.COP_ISNULL)
			{
				return target + " IS NULL";
			}
			
			sql = target;
			
			local_type = mapping.GetLocalType().ToString();
			
			case_sensitive = true;
			
			if (this.mComparisonType == TpFilter.COP_EQUALS)
			{
				r_settings = rResource.GetSettings();
				
				if (local_type == TpConceptMapping.TYPE_TEXT && !r_settings.GetCaseSensitiveInEquals())
				{
					r_data_source = rResource.GetDataSource();
					
					r_adodb_connection = (OleDbConnection)r_data_source.GetConnection();
					
					case_sensitive = false;
					
					sql = TpDataAccess.GetUppercaseCommand(r_adodb_connection) + "(" + target + ")";
				}
				
				sql += " = ";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHAN)
			{
				sql += " < ";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHANOREQUALS)
			{
				sql += " <= ";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHAN)
			{
				sql += " > ";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHANOREQUALS)
			{
				sql += " >= ";
			}
			else if (this.mComparisonType == TpFilter.COP_LIKE)
			{
				r_settings = rResource.GetSettings();
				
				if (!r_settings.GetCaseSensitiveInLike())
				{
					r_data_source = rResource.GetDataSource();
					
					r_adodb_connection = (OleDbConnection)r_data_source.GetConnection();
					
					case_sensitive = false;
					
					sql = r_adodb_connection.ConnectionString.ToUpper() + "(" + target + ")";
				}
				
				sql += " LIKE ";
			}
			else if (this.mComparisonType == TpFilter.COP_IN)
			{
				r_settings = rResource.GetSettings();
				
				if (!r_settings.GetCaseSensitiveInEquals())
				{
					r_data_source = rResource.GetDataSource();
					
					r_adodb_connection = (OleDbConnection)r_data_source.GetConnection();
					
					case_sensitive = false;
					
					sql = r_adodb_connection.ConnectionString.ToUpper() + "(" + target + ")";
				}
				
				sql += " IN ( ";
			}
			
			for (i = 0; i < Utility.OrderedMap.CountElements(this.mExpressions); ++i)
			{
				if (i > 0)
				{
					sql += ", ";
				}
				
				is_like = false;
				
				if (this.mComparisonType == TpFilter.COP_LIKE)
				{
					is_like = true;
					
					if (local_type != TpConceptMapping.TYPE_TEXT)
					{
						msg = "Concept used in \"Like\" comparison is mapped to a " + "non-textual content";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, msg, TpConfigManager.DIAG_WARN);
						return "FALSE";
					}
				}
				
				term = ((TpExpression)this.mExpressions[i]).GetValue(rResource, local_type, case_sensitive, is_like);
				
				if (term == null)
				{
					return "FALSE";
				}
				
				sql += term;
			}
			
			if (this.mComparisonType == TpFilter.COP_IN)
			{
				sql += ")";
			}
			
			return sql;
		}// end of member function GetSql
		
		public override string GetLogRepresentation()
		{
			string txt = "";
			TpConcept concept;
			int i;
			string term;
			
			if ((int)this.mBaseConcept.GetType() == TpFilter.EXP_CONCEPT)
			{
				txt = this.mBaseConcept.GetReference().ToString();
			}
			else
			{
				// Should never fall here - local filters are not logged
				
				concept = (TpConcept)this.mBaseConcept.GetReference();
				
				txt = concept.GetId().ToString();
			}
			
			if (this.mComparisonType == TpFilter.COP_ISNULL)
			{
				return txt + " IS NULL";
			}
			
			if (this.mComparisonType == TpFilter.COP_EQUALS)
			{
				txt += " = ";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHAN)
			{
				txt += " < ";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHANOREQUALS)
			{
				txt += " <= ";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHAN)
			{
				txt += " > ";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHANOREQUALS)
			{
				txt += " >= ";
			}
			else if (this.mComparisonType == TpFilter.COP_LIKE)
			{
				txt += " LIKE ";
			}
			else if (this.mComparisonType == TpFilter.COP_IN)
			{
				txt += " IN ( ";
			}
			
			for (i = 0; i < Utility.OrderedMap.CountElements(this.mExpressions); ++i)
			{
				if (i > 0)
				{
					txt += ", ";
				}
				
				term = ((TpExpression)this.mExpressions[i]).GetLogRepresentation();
				
				txt += term;
			}
			
			if (this.mComparisonType == TpFilter.COP_IN)
			{
				txt += ")";
			}
			
			return txt;
		}// end of member function GetLogRepresentation
		
		public override string GetXml()
		{
			string xml;
			string start_tag;
			string end_tag;
			TpConcept concept;
			int i;
			xml = "";
			
			if (this.mComparisonType == TpFilter.COP_ISNULL)
			{
				start_tag = "<isNull>";
				end_tag = "</isNull>";
			}
			else if (this.mComparisonType == TpFilter.COP_EQUALS)
			{
				start_tag = "<equals>";
				end_tag = "</equals>";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHAN)
			{
				start_tag = "<lessThan>";
				end_tag = "</lessThan>";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHANOREQUALS)
			{
				start_tag = "<lessThanOrEquals>";
				end_tag = "</lessThanOrEquals>";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHAN)
			{
				start_tag = "<greaterThan>";
				end_tag = "</greaterThan>";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHANOREQUALS)
			{
				start_tag = "<greaterThanOrEquals>";
				end_tag = "</greaterThanOrEquals>";
			}
			else if (this.mComparisonType == TpFilter.COP_LIKE)
			{
				start_tag = "<like>";
				end_tag = "</like>";
			}
			else if (this.mComparisonType == TpFilter.COP_IN)
			{
				start_tag = "<in>";
				end_tag = "</in>";
			}
			else
			{
				start_tag = "<unknown type=\"" + this.mComparisonType + "\">";
				end_tag = "</unknown>";
			}
			
			xml += start_tag;
			
			if (this.mBaseConcept.GetType() == TpFilter.EXP_CONCEPT)
			{
				xml += "<concept id=\"" + this.mBaseConcept.GetReference().ToString() + "\"/>";
			}
			else
			{
				// local filters
				concept = (TpConcept)this.mBaseConcept.GetReference();
				
				SingleColumnMapping scm = (SingleColumnMapping)concept.GetMapping();
				
				xml += "<t_concept table=\"" + scm.GetTable() + "\" " + "field=\"" + scm.GetField() + "\" " + "type=\"" + scm.GetLocalType() + "\"/>";
			}
			
			if (this.mComparisonType == TpFilter.COP_IN)
			{
				xml += "<values>";
			}
			
			for (i = 0; i < Utility.OrderedMap.CountElements(this.mExpressions); ++i)
			{
				xml += ((TpExpression)this.mExpressions[i]).GetXml();
			}
			
			if (this.mComparisonType == TpFilter.COP_IN)
			{
				xml += "</values>";
			}
			
			xml += end_tag;
			
			return xml;
		}// end of member function GetXml
		
		public virtual string GetName()
		{
			if (this.mComparisonType == TpFilter.COP_EQUALS)
			{
				return "equals";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHAN)
			{
				return "lessThan";
			}
			else if (this.mComparisonType == TpFilter.COP_LESSTHANOREQUALS)
			{
				return "lessThanOrEquals";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHAN)
			{
				return "greaterThan";
			}
			else if (this.mComparisonType == TpFilter.COP_GREATERTHANOREQUALS)
			{
				return "greaterThanOrEquals";
			}
			else if (this.mComparisonType == TpFilter.COP_LIKE)
			{
				return "like";
			}
			else if (this.mComparisonType == TpFilter.COP_ISNULL)
			{
				return "isNull";
			}
			else if (this.mComparisonType == TpFilter.COP_IN)
			{
				return "in";
			}
			
			return "?";
		}// end of member function GetName
		
		public override bool IsValid()
		{
			string error;
			string name;
			int num_expressions;
			if (this.mComparisonType == -1)
			{
				error = "Missing 'type' for comparison operator";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			name = this.GetName();
			
			if (!(this.mBaseConcept != null))
			{
				error = "Missing 'concept' term for comparison operator '" + name + "'";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			if (name == "?")
			{
				error = "Unknown 'type' (" + this.mComparisonType + ") for comparison operator '" + name + "'";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			num_expressions = Utility.OrderedMap.CountElements(this.mExpressions);
			
			if (this.mComparisonType == TpFilter.COP_ISNULL)
			{
				if (num_expressions > 0)
				{
					error = "Operator '" + name + "' requires no additional terms " + "besides a concept";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					return false;
				}
			}
			else if (this.mComparisonType == TpFilter.COP_IN)
			{
				if (num_expressions == 0)
				{
					error = "Operator '" + name + "' requires at least one term " + "besides a concept";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					return false;
				}
			}
			else
			{
				if (num_expressions != 1)
				{
					error = "Operator '" + name + "' requires one and only one term " + "besides a concept";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					return false;
				}
			}
			
			return true;
		}// end of member function IsValid
		
		public override object Accept(object visitor, object args)
		{
			return ((TpFilterVisitor)visitor).VisitComparisonOperator(this, args);
		}// end of member function Accept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mComparisonType", "mBaseConcept", "mExpressions"));
		}// end of member function __sleep
	}
}
