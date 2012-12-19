using System.Web;

namespace TapirDotNET 
{

	public class TpExpression
	{
		public int mType = -1;
		public object mReference; // mixed: a value (for literals) or a parameter name or a concept id
								  //        or a TpTransparentConcept object (base concept of local 
								  //        filters)
		public bool mHasWildcard = false;
		public object mBaseConcept; // Type of Expression (see constants defined in TpFilter.cs)
		public bool XmlEncode = true;
		
		public TpExpression(int type, object reference)
		{
			this.mType = type;
			this.mReference = reference;
		}
		
		
		public new int GetType()
		{
			return this.mType;
		}// end of member function GetType
		
		public virtual void  SetReference(object ref_Renamed)
		{
			this.mReference = ref_Renamed;
		}// end of member function SetReference
		
		public virtual object GetReference()
		{
			return this.mReference;
		}// end of member function GetReference
		
		public virtual string GetValue(TpResource rResource, string localType, bool caseSensitive, bool isLike)
		{
			string value_Renamed;
			string msg;
			TpLocalMapping r_local_mapping;
			TpConcept concept;
			TpConceptMapping mapping;
			TpDataSource r_data_source;
			string r_adodb_connection;
			value_Renamed = "";
			
			if (this.mType == TpFilter.EXP_LITERAL)
			{
				value_Renamed = this.mReference.ToString();
				
				if (localType != TpConceptMapping.TYPE_NUMERIC && localType != TpConceptMapping.TYPE_BOOL)
				{
					if (localType == TpConceptMapping.TYPE_TEXT && !caseSensitive)
					{
						value_Renamed = value_Renamed.ToUpper();
					}
					
					value_Renamed = Utility.StringSupport.StringReplace(value_Renamed, TpConfigManager.TP_SQL_QUOTE, TpConfigManager.TP_SQL_QUOTE_ESCAPE);
					
					if (isLike)
					{
						value_Renamed = this.GetLikeTerm(value_Renamed);
					}
					
					value_Renamed = TpConfigManager.TP_SQL_QUOTE + value_Renamed + TpConfigManager.TP_SQL_QUOTE;
				}
			}
			else if (this.mType == TpFilter.EXP_PARAMETER)
			{
				if (HttpContext.Current.Request[this.mReference.ToString()] == null)
				{
					msg = "Parameter \"" + this.mReference + "\" is missing";
						
					new TpDiagnostics().Append(TpConfigManager.DC_MISSING_PARAMETER, msg, TpConfigManager.DIAG_WARN);
					return "";
				}
					
				value_Renamed = HttpContext.Current.Request[this.mReference.ToString()];
					
				if (localType != TpConceptMapping.TYPE_NUMERIC)
				{
					if (localType == TpConceptMapping.TYPE_TEXT && !caseSensitive)
					{
						value_Renamed = value_Renamed.ToUpper();
					}
						
					value_Renamed = value_Renamed.Replace(TpConfigManager.TP_SQL_QUOTE, TpConfigManager.TP_SQL_QUOTE_ESCAPE);
						
					if (isLike)
					{
						value_Renamed = this.GetLikeTerm(value_Renamed);
					}
						
					value_Renamed = TpConfigManager.TP_SQL_QUOTE + value_Renamed + TpConfigManager.TP_SQL_QUOTE;
				}
			}
			else if (this.mType == TpFilter.EXP_CONCEPT)
			{
				r_local_mapping = rResource.GetLocalMapping();
						
				concept = r_local_mapping.GetConcept(this.mReference);
						
				if (concept == null || !concept.IsMapped())
				{
					msg = "Concept \"" + this.mReference + "\" is not mapped";
							
					new TpDiagnostics().Append(TpConfigManager.DC_UNMAPPED_CONCEPT, msg, TpConfigManager.DIAG_WARN);
					return "";
				}
						
				if (!concept.IsSearchable())
				{
					msg = "Concept \"" + this.mReference + "\" is not searchable";
							
					new TpDiagnostics().Append(TpConfigManager.DC_UNSEARCHABLE_CONCEPT, msg, TpConfigManager.DIAG_WARN);
					return "";
				}
						
				mapping = concept.GetMapping();
						
				value_Renamed = mapping.GetSqlTarget();
						
				if (localType == TpConceptMapping.TYPE_TEXT && !caseSensitive)
				{
					r_data_source = rResource.GetDataSource();
							
					r_adodb_connection = r_data_source.GetConnection().ConnectionString;
							
					value_Renamed = r_adodb_connection.ToUpper() + "(" + value_Renamed + ")";
				}
			}
			else if (this.mType == TpFilter.EXP_COLUMN)
				// only for local filters
			{
				value_Renamed = this.mReference.ToString();// table.column
			}
			else if (this.mType == TpFilter.EXP_VARIABLE)
			{
				if (!rResource.HasVariable(this.mReference.ToString()))
				{
					msg = "Unknown variable \"" + this.mReference + "\"";
									
					new TpDiagnostics().Append(TpConfigManager.DC_UNKNOWN_VARIABLE, msg, TpConfigManager.DIAG_WARN);
					return "";
				}
								
				value_Renamed = Utility.TypeSupport.ToString(rResource.GetVariable(this.mReference.ToString()));
			}
			
			if (this.mHasWildcard)
			{
				value_Renamed += " ESCAPE '&'";// SQL92
			}
			
			return value_Renamed;
		}// end of member function GetValue
		
		public virtual string GetLogRepresentation()
		{
			string txt;
			string value_Renamed;
			txt = "";
			
			if (this.mType == TpFilter.EXP_LITERAL)
			{
				txt = "\"" + this.mReference.ToString().Replace("\"", "\\\"") + "\"";
			}
			else
			{
				if (this.mType == TpFilter.EXP_PARAMETER)
				{
					value_Renamed = "";
					
					if (HttpContext.Current.Request[this.mReference.ToString()] != null)
					{
						value_Renamed = Utility.TypeSupport.ToString(HttpContext.Current.Request[this.mReference.ToString()]);
					}
					
					txt = "Parameter(" + this.mReference + "=>" + value_Renamed + ")";
				}
				else
				{
					if (this.mType == TpFilter.EXP_CONCEPT)
					{
						txt = this.mReference.ToString();
					}
					else
					{
						if (this.mType == TpFilter.EXP_VARIABLE)
						{
							txt = "Variable(" + this.mReference + ")";
						}
					}
				}
			}
			
			return txt;
		}// end of member function GetLogRepresentation
		
		
		public virtual string GetLikeTerm(string value_Renamed)
		{
			bool no_wildcard;
			int i;
			no_wildcard = false;
			
			if (value_Renamed.IndexOf("*") == -1)
			{
				no_wildcard = true;
			}
			
			if (no_wildcard)
			{
				// No wildcard means adding one in the beginning and 
				// another in the end
				value_Renamed = "*" + value_Renamed + "*";
			}
			
			// Escape DB wildcard character in term
			if (value_Renamed.IndexOf(TpConfigManager.TP_SQL_WILDCARD) != -1)
			{
				this.mHasWildcard = true;
				value_Renamed = value_Renamed.Replace(TpConfigManager.TP_SQL_WILDCARD, "&" + TpConfigManager.TP_SQL_WILDCARD);
			}
						
			// Replace wildcards if DB uses a different character
			// Note: don't replace escaped wildcards!!
			string[] parts = value_Renamed.Split("*".ToCharArray());
				
			if (parts.Length > 1)
			{
				value_Renamed = "";
				
				for (i = 0; i < parts.Length; ++i)
				{
					if (i > 0)
					{
						//If last character of last piece is "_"
						if (parts[i - 1].Length > 0 && parts[i - 1].Substring(parts[i - 1].Length - 1, 1) == "_")
						{
							value_Renamed = value_Renamed.Substring(0, value_Renamed.Length - 1) + "*";
						}
						else
						{
							value_Renamed += TpConfigManager.TP_SQL_WILDCARD;
						}
					}
					
					value_Renamed = value_Renamed + parts[i];
				}				
			}
			
			return value_Renamed;
		}// end of member function GetLikeTerm
		
		public override string ToString()
		{
			string ret;
			ret = "";
			
			if (this.mType == TpFilter.EXP_LITERAL)
			{
				ret += "literal";
			}
			else
			{
				if (this.mType == TpFilter.EXP_CONCEPT)
				{
					ret += "concept";
				}
				else
				{
					if (this.mType == TpFilter.EXP_PARAMETER)
					{
						ret += "parameter";
					}
					else
					{
						if (this.mType == TpFilter.EXP_VARIABLE)
						{
							ret += "variable";
						}
						else
						{
							ret += "expression?";
						}
					}
				}
			}
			
			return ret + "[" + this.mReference + "]";
		}// end of member function ToString
		
		public virtual string GetXml()
		{
			string xml;
			TpConcept concept;
			xml = "";
			
			if (this.mType == TpFilter.EXP_LITERAL)
			{
				xml = "<literal value=\"" + this.mReference.ToString() + "\"/>";
			}
			else if (this.mType == TpFilter.EXP_PARAMETER)
			{
				xml = "<parameter name=\"" + this.mReference.ToString() + "\"/>";
			}
			else if (this.mType == TpFilter.EXP_CONCEPT)
			{
				xml = "<concept id=\"" + this.mReference.ToString() + "\"/>";
			}
			else if (this.mType == TpFilter.EXP_COLUMN) // only for local filters
			{
				// local filters
				concept = (TpConcept)this.mBaseConcept;
							
				SingleColumnMapping scm = (SingleColumnMapping)concept.GetMapping();
							
				xml = "<t_concept table=\"" + scm.GetTable() + "\" " + "field=\"" + scm.GetField() + "\" " + "type=\"" + scm.GetLocalType() + "\"/>";
			}
			else if (this.mType == TpFilter.EXP_VARIABLE)
			{
				xml = "<variable name=\"" + this.mReference.ToString() + "\"/>";
			}
			
			return xml;
		}// end of member function GetXml
		
		public virtual object Accept(object visitor, object args)
		{
			return ((TpFilterVisitor)visitor).VisitExpression(this, args);
		}// end of member function Accept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mType", "mReference");
		}// end of member function __sleep
	}
}
