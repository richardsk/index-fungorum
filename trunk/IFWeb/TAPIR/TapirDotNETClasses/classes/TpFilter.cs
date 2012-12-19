using System;
using System.Web;
using System.Text;
using System.Xml;

namespace TapirDotNET 
{

	public class TpFilter
	{
		public const int COP_TYPE = 0;
		public const int LOP_TYPE = 1;
		public const int COP_EQUALS = 0;
		public const int COP_LESSTHAN = 1;
		public const int COP_LESSTHANOREQUALS = 2;
		public const int COP_GREATERTHAN = 3;
		public const int COP_GREATERTHANOREQUALS = 4;
		public const int COP_LIKE = 5;
		public const int COP_ISNULL = 6;
		public const int COP_IN = 7;
		public const int LOP_AND = 0;
		public const int LOP_OR = 1;
		public const int LOP_NOT = 2;
		public const int EXP_CONCEPT = 0;
		public const int EXP_LITERAL = 1;
		public const int EXP_PARAMETER = 2;
		public const int EXP_COLUMN = 3;
		// for local filters
		public const int EXP_VARIABLE = 4;


		public TpBooleanOperator mRootBooleanOperator;
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public bool mIsValid = true;
		public Utility.OrderedMap mOperatorsStack = new Utility.OrderedMap();
		public char mEscapeChar;
		public Utility.OrderedMap mOperators = new Utility.OrderedMap(new object[]{"isnull", 100}, new object[]{"like", 40}, new object[]{"equals", 50}, new object[]{"greaterthan", 60}, new object[]{"lessthan", 70}, new object[]{"greaterthanorequals", 80}, new object[]{"lessthanorequals", 90}, new object[]{"in", 120}, new object[]{"and", 20}, new object[]{"or", 10}, new object[]{"not", 30});
		public bool mIsLocal = false;// Root COP or LOP// name element stack during XML parsing
		
		
		public TpFilter(bool isLocal)
		{
			this.mIsLocal = isLocal;
			this.mEscapeChar = (char) 92;
		}
		
		
		public virtual void  LoadFromKvp(string filterString)
		{
			//global $g_dlog
			Utility.OrderedMap list;
			TpNestedList nested_list;
			object root_boolean_operator;
			
			TpLog.debug("[KVP filter parsing]");
			TpLog.debug("Filter string: [" + filterString + "]");
			
			// Double quotes are always coming escaped!
			// TODO: how to deal with real escaped double quotes??
			filterString = filterString.Replace("\\\"", "\"");
			
			// Array of strings and TpExpression objects (literals)
			list = this._ResolveLiterals(filterString.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
			
			// Array of strings and TpExpression objects (literals or concepts)
			list = this._ResolveConcepts(list);
			
			// Nested array of strings and TpExpression objects (literals or concepts)
			nested_list = (TpNestedList)this._ResolveBrackets(list);
			
			// Nested array of strings and TpExpression objects (literals or concepts)
			nested_list = (TpNestedList)this._TokenizeData(nested_list);
			
			root_boolean_operator = this._ResolveOperators(nested_list);
			
			if (root_boolean_operator != null && root_boolean_operator.GetType().IsSubclassOf(typeof(TpBooleanOperator)))
			{
				this.mRootBooleanOperator = (TpBooleanOperator)root_boolean_operator;
			}
		}// end of member function LoadFromKvp
		
		public virtual Utility.OrderedMap _ResolveLiterals(string filterString)
		{
			// reads a string and returns a list of strings and literal 
			// objects resolving quoted text into literal objects.
			Utility.OrderedMap tokens;
			bool inside_quote;
			string literal_content;
			bool escaped;
			int i;
			char char_Renamed;
			string error;
			tokens = new Utility.OrderedMap();
			inside_quote = false;
			literal_content = "";
			escaped = false;
			
			for (i = 0; i < filterString.Length; ++i)
			{
				char_Renamed = filterString[i];
				
				if (char_Renamed == '\"' && !escaped)
				{
					if (inside_quote)
					{
						inside_quote = false;
						tokens.Push(new TpExpression(EXP_LITERAL, literal_content));
					}
					else
					{
						inside_quote = true;
						tokens.Push(literal_content.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
					}
					
					literal_content = "";
				}
				else
				{
					if (char_Renamed == this.mEscapeChar)
					{
						if (escaped)
						{
							escaped = false;
							literal_content = literal_content + char_Renamed.ToString();
						}
						else
						{
							escaped = true;
						}
					}
					else
					{
						if (escaped)
						{
							literal_content = literal_content + this.mEscapeChar.ToString();
							escaped = false;
						}
						
						literal_content = literal_content + char_Renamed.ToString();
					}
				}
			}
			
			if (literal_content.Length > 0)
			{
				tokens.Push(literal_content.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
			}
			
			// test if all quotations are closed
			if (inside_quote)
			{
				error = "Incorrect number of double quotes in the filter";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
				
				this.mIsValid = false;
			}
			
			return tokens;
		}// end of member function _ResolveLiterals
		
		public virtual Utility.OrderedMap _ResolveConcepts(Utility.OrderedMap list)
		{
			// Go through a list of strings and literals and replace concepts 
			// found in the string with concept objects.
			Utility.OrderedMap new_list;
			string last_string;
			string add_string;
			int last_start_bracket;
			int first_end_bracket;
			TpExpression concept;
						
			new_list = new Utility.OrderedMap();
			
			foreach ( object part in list.Values ) 
			{
				if (part.GetType() == typeof(string))
				{
					last_string = "";

					//TODO check regex
					foreach ( string token in Utility.RegExPOSIXSupport.Split(" ", part.ToString(), - 1, true).Values ) 
					{
						add_string = "";
						string tok = token;
						
						// Separate possible leading brackets
						last_start_bracket = tok.LastIndexOf("(");
						
						if (last_start_bracket != -1)
						{
							last_string += " " + (new StringBuilder().Insert(0, "(", last_start_bracket + 1)).ToString();
							tok = tok.Substring(last_start_bracket + 1);
						}
						
						// Separate possible ending brackets
						first_end_bracket = tok.IndexOf(")");
						
						if (first_end_bracket != -1)
						{
							add_string = (new StringBuilder().Insert(0, ")", tok.Length - first_end_bracket)).ToString();
							tok = tok.Substring(0, first_end_bracket);
						}
						
						if (tok.Length > 0 && this.mOperators.GetKeysOrderedMap(null).Search(tok.ToLower()) != null)
						{
							// it should be a concept (no literal, no operator).
							
							// add previous string to result
							if (last_string.Length > 0)
							{
								new_list.Push(last_string);
								last_string = "";
							}
							
							// add concept
							concept = new TpExpression(EXP_CONCEPT, tok);
							
							new_list.Push(concept);
						}
						else
						{
							// this is no concept. remember string
							if (last_string.Length > 0 && last_string.Substring(last_string.Length-1) != "(")
							{
								last_string += " ";
							}
							
							last_string = last_string + tok;
						}
						
						last_string += add_string;
					}
					
					
					if (last_string.Length > 0)
					{
						new_list.Push(last_string);
					}
				}
				else
				{
					new_list.Push(part);
				}
			}
			
			
			return new_list;
		}// end of member function _ResolveConcepts
		
		public virtual object _ResolveBrackets(Utility.OrderedMap list)
		{
			// first take the string and create a tree for all brackets.
			int i;
			TpNestedList current_list;
			bool escape;
			int j;
			char char_Renamed;
			
			i = 0;
			
			current_list = new TpNestedList(new Utility.OrderedMap(""));
			
			escape = false;
			
			foreach ( object token in list.Values ) 
			{
				if (!(token is System.String))
				{
					++i;
					
					current_list.Append(token);
					current_list.Append("");
				}
				else
				{
					for (j = 0; j < token.ToString().Length; ++j)
					{
						char_Renamed = token.ToString()[j];
						
						++i;
						
						if (char_Renamed == this.mEscapeChar && escape)
						{
							escape = false;
							current_list.AddString(-1, this.mEscapeChar.ToString());
						}
						else
						{
							if (char_Renamed.ToString() == "(" && !escape)
							{
								current_list.Append(new TpNestedList(new Utility.OrderedMap("")));
								current_list = (TpNestedList)current_list.GetElement(-1);
							}
							else if (char_Renamed == ')' && !escape)
							{
								current_list = current_list.GetParent();								
								current_list.Append("");
							}
							else
							{
								current_list.AddString(-1, char_Renamed.ToString());
							}
							
							escape = false;
						}
					}
				}
			}
			
			
			return current_list;
		}// end of member function _ResolveBrackets
		
		public virtual object _TokenizeData(TpNestedList nestedList)
		{
			// prepare list by concatenating strings first
			string tmp = "";
			Utility.OrderedMap new_list = new Utility.OrderedMap();
			TpNestedList tmp_nested_list;
			
			foreach ( object element in Utility.TypeSupport.ToArray(nestedList.GetElements()).Values)
			{
				if (element is System.String)
				{
					tmp = tmp + element.ToString();
				}
				else
				{
					if (tmp.Length > 0)
					{
						new_list.Push(tmp);
						tmp = "";
					}
					
					if (element != null && element.GetType().Name.ToLower() == "tpnestedlist")
					{
						new_list.Push(this._TokenizeData((TpNestedList)element));
					}
					else
					{
						new_list.Push(element);
					}
				}
			}
			
			
			if (tmp.Length > 0)
			{
				new_list.Push(tmp);
			}
			
			// replace old list with new one
			tmp_nested_list = new TpNestedList(new Utility.OrderedMap());
			
			foreach ( object e in new_list.Values ) 
			{
				tmp_nested_list.Append(e);
			}
			
			
			// now split the strings at whitespace!
			new_list = new Utility.OrderedMap();
			
			foreach ( object e in Utility.TypeSupport.ToArray(tmp_nested_list.GetElements()).Values ) 
			{
				if (e is System.String)
				{
					// string data that needs to be tokenized
					foreach ( object token in new Utility.OrderedMap(e.ToString().Split(" ".ToCharArray())).Values ) 
					{
						if (token.ToString().Length > 0)
						{
							new_list.Push(token);
						}
					}
					
				}
				else
				{
					new_list.Push(e);
				}
			}
			
			
			// replace old list with new one
			TpNestedList nested_list = new TpNestedList(new Utility.OrderedMap());
			
			foreach ( object e in new_list.Values ) 
			{
				nested_list.Append(e);
			}
			
			
			// return changed list
			return nested_list;
		}// end of member function _TokenizeData
		
		public virtual object _ResolveOperators(object nestedList)
		{
			// Takes a list of tokens (operatorString, literalObj, conceptObj, blockObj) 
			// and returns a list of tokens with 3 items maximum.
			// It looks for the operator token with the smallest precedence and creates 
			// a new Block node for all items before that token and after the smallest 
			// token.
			int cnt = 0;
			object first_element;
			Utility.OrderedMap tokens;
			bool has_string;
			int min_precedence;
			string error;
			int seq;
			string op = null;
			
			// only process lists. return other objects
			if (!(nestedList != null && nestedList.GetType().Name.ToLower() == "tpnestedlist"))
			{
				return nestedList;
			}
			
			TpNestedList nl = (TpNestedList)nestedList;
			while (nl.GetSize() == 1)
			{
				++cnt;
				
				first_element = nl.GetElement(0);
				
				if ((nl != null && nl.GetType().Name.ToLower() == "tpnestedlist"))
				{
					nl = (TpNestedList)first_element;
				}
				else
				{
					return first_element;
				}
			}
			
			// first resolve existing sub lists into proper objects
			tokens = new Utility.OrderedMap();
			
			foreach ( object element in Utility.TypeSupport.ToArray(nl.GetElements()).Values ) 
			{
				if (element != null && element.GetType().Name == "tpnestedlist")
				{
					tokens.Push(this._ResolveOperators(element));
				}
				else if ((!(element is System.String)) || element.ToString() != ",")
				{
					// don't append the token "," which has no meaning, 
					// eg in IN operator arg lists. Be aware that sublists still have kommas
					tokens.Push(element);
				}
			}
			
			
			// now reorganize list by operator precedence
			// scan children for lowest operator precedence.
			
			has_string = false;
			min_precedence = 1000;
			
			for ( int index = 0; index < tokens.Count; index++ )
			{
				object token = tokens.GetEntryAt(index).Value;

				if (token is string)
				{
					token = token.ToString().ToLower();
					
					has_string = true;
					
					if (this.mOperators.GetKeysOrderedMap(null).Search(token) != null)
					{
						min_precedence = (int)Utility.MathSupport.Min(min_precedence, this.mOperators[token]);
					}
					else
					{
						error = "Unknown filter element '" + Utility.TypeSupport.ToString(token) + "'.";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
						
						this.mIsValid = false;
						
						return null;
					}
				}
			}
			
			
			if (!has_string)
			{
				// there is no string in this list! 
				// return the original list if there is at least 1 item
				if (nl.GetSize() > 0)
				{
					return nl;
				}
				else
				{
					error = "Runtime error when parsing filter (tried to create " + "operator object from empty list).";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					this.mIsValid = false;
					
					return null;
				}
			}
			
			// find lowest operator token and create a new operator object
			seq = - 1;
			
			foreach ( object token in tokens.Values ) 
			{
				++seq;
				
				if (token is string && (int)this.mOperators[token.ToString().ToLower()] == min_precedence)
				{
					op = token.ToString().ToLower();
					break;
				}
			}
			
			
			return this._CreateOperator(tokens, seq, op);
		}// end of member function _ResolveOperators
		
		public virtual TpBooleanOperator _CreateOperator(Utility.OrderedMap tokens, int idx, string opClass)
		{
			TpBooleanOperator retOp = null;
			string error;
			object arg = null;
			object boolean_operator = null;
			object left_arg = null;
			object left_boolean_operator = null;
			object right_arg = null;
			object right_boolean_operator = null;
			if (opClass == "and" || opClass == "or" || opClass == "not")
			{
				if (opClass == "not")
				{
					if (idx > 0)
					{
						error = "Invalid filter: 'not' operator seems to have left " + "arguments. Wrong filter.";
						new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
						
						this.mIsValid = false;
						
						return null;
					}
										
					TpLogicalOperator op = new TpLogicalOperator(LOP_NOT);
					
					arg = new TpNestedList(Utility.OrderedMap.Slice(tokens, idx + 1));
					
					boolean_operator = this._ResolveOperators(arg);
					
					if (boolean_operator != null)
					{
						op.AddBooleanOperator(boolean_operator);
					}

					retOp = op;
				}
				else
				{					
					TpLogicalOperator op = null;
					if (opClass == "and")
					{
						op = new TpLogicalOperator(LOP_AND);
					}
					else
					{
						op = new TpLogicalOperator(LOP_OR);
					}
					
					left_arg = new TpNestedList(Utility.OrderedMap.Slice(tokens, 0, idx));
					
					left_boolean_operator = this._ResolveOperators(left_arg);
					
					right_arg = new TpNestedList(Utility.OrderedMap.Slice(tokens, idx + 1));
					
					right_boolean_operator = this._ResolveOperators(right_arg);
					
					if (left_boolean_operator != null && right_boolean_operator != null)
					{
						op.AddBooleanOperator(left_boolean_operator);
						op.AddBooleanOperator(right_boolean_operator);
					}
					
					retOp = op;
				}
			}
			else if (opClass == "isnull")
			{
				if (Utility.OrderedMap.CountElements(tokens) != 2)
				{
					error = "Invalid filter: wrong number of arguments to 'isNull' operator";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					this.mIsValid = false;
					
					return null;
				}
								
				TpComparisonOperator op = new TpComparisonOperator(COP_ISNULL);
				
				op.SetExpression((TpExpression)tokens[idx + 1]);
				
				retOp = op;
			}
			else if (opClass == "equals" || opClass == "like" || opClass == "in" || opClass == "greaterthanorequals" || opClass == "greaterthan" || opClass == "lessthanorequals" || opClass == "lessthan")
			{
				if (Utility.OrderedMap.CountElements(tokens) != 3)
				{
					error = "Invalid filter: wrong number of arguments to comparison " + "operator '" + opClass + "'";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
					
					this.mIsValid = false;
					
					return null;
				}
								
				TpComparisonOperator op = null;
				if (opClass == "equals")
				{
					op = new TpComparisonOperator(COP_EQUALS);
				}
				else if (opClass == "lessThan")
				{
					op = new TpComparisonOperator(COP_LESSTHAN);
				}
				else if (opClass == "lessThanOrEquals")
				{
					op = new TpComparisonOperator(COP_LESSTHANOREQUALS);
				}
				else if (opClass == "greaterThan")
				{
					op = new TpComparisonOperator(COP_GREATERTHAN);
				}
				else if (opClass == "greaterThanOrEquals")
				{
					op = new TpComparisonOperator(COP_GREATERTHANOREQUALS);
				}
				else if (opClass == "like")
				{
					op = new TpComparisonOperator(COP_LIKE);
				}
				else if (opClass == "in")
				{
					op = new TpComparisonOperator(COP_IN);
				}
				
				if (tokens[idx - 1] != null && tokens[idx - 1].GetType().Name.ToLower() == "tpexpression")
				{
					op.SetExpression((TpExpression)tokens[idx - 1]);
					
					arg = tokens[idx + 1];
				}
				else if (tokens[idx + 1] != null && tokens[idx + 1].GetType().Name.ToLower() == "tpexpression")
				{
					arg = tokens[idx - 1];
					
					op.SetExpression((TpExpression)tokens[idx + 1]);
				}
				else
				{
					// no need to raise error here - IsValid() can check that
				}
				
				if (arg is Utility.OrderedMap)
				{
					foreach ( object el in Utility.TypeSupport.ToArray(arg).Values ) {
						if (el != null && el.GetType().Name.ToLower() == "tpexpression")
						{
							op.SetExpression((TpExpression)el);
						}
					}
					
				}
				else if (arg != null && arg.GetType().Name.ToLower() == "tpexpression")
				{
					op.SetExpression((TpExpression)arg);
				}
				
				retOp = op;
			}
			
			return retOp;
		}// end of member function _CreateOperator
		
		 /**
		*  XML parsing methods are invoked from TpOperationParameters
		*/
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs) 
		{
			string name;
			int depth;
			int size;
			TpBooleanOperator current_operator = null;
			TpTransparentConcept concept;
			string error;
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			if (!this.mIsValid)
			{
				return ;
			}
			
			this.mInTags.Push(name.ToLower());
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			size = Utility.OrderedMap.CountElements(this.mOperatorsStack);
			
			if (size > 0)
			{
				current_operator = (TpBooleanOperator)this.mOperatorsStack[size - 1];
			}
			
			if (Utility.StringSupport.StringCompare(name, "filter", false) == 0)
			{
				// nothing to do here
			}
			else
			{
				if (Utility.StringSupport.StringCompare(name, "equals", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(COP_EQUALS));
				}
				else
				{
					if (Utility.StringSupport.StringCompare(name, "lessThan", false) == 0)
					{
						this._AddOperator(new TpComparisonOperator(COP_LESSTHAN));
					}
					else
					{
						if (Utility.StringSupport.StringCompare(name, "lessThanOrEquals", false) == 0)
						{
							this._AddOperator(new TpComparisonOperator(COP_LESSTHANOREQUALS));
						}
						else
						{
							if (Utility.StringSupport.StringCompare(name, "greaterThan", false) == 0)
							{
								this._AddOperator(new TpComparisonOperator(COP_GREATERTHAN));
							}
							else
							{
								if (Utility.StringSupport.StringCompare(name, "greaterThanOrEquals", false) == 0)
								{
									this._AddOperator(new TpComparisonOperator(COP_GREATERTHANOREQUALS));
								}
								else
								{
									if (Utility.StringSupport.StringCompare(name, "like", false) == 0)
									{
										this._AddOperator(new TpComparisonOperator(COP_LIKE));
									}
									else
									{
										if (Utility.StringSupport.StringCompare(name, "isNull", false) == 0)
										{
											this._AddOperator(new TpComparisonOperator(COP_ISNULL));
										}
										else
										{
											if (Utility.StringSupport.StringCompare(name, "in", false) == 0)
											{
												this._AddOperator(new TpComparisonOperator(COP_IN));
											}
											else
											{
												if (Utility.StringSupport.StringCompare(name, "concept", false) == 0)
												{
													if (current_operator != null && Utility.TypeSupport.ToInt32(current_operator.GetBooleanType()) == COP_TYPE && attrs["id"].ToString() != "")
													{
														((TpComparisonOperator)current_operator).SetExpression(new TpExpression(EXP_CONCEPT, attrs["id"]));
													}
												}
												else
												{
													if (Utility.StringSupport.StringCompare(name, "t_concept", false) == 0)
													{
														if (this.mIsLocal)
														{
															if (current_operator != null && (int)current_operator.GetBooleanType() == COP_TYPE && attrs["table"] != null)
															{
																concept = new TpTransparentConcept(attrs["table"].ToString(), attrs["field"].ToString(), attrs["type"]);
																
																((TpComparisonOperator)current_operator).SetExpression(new TpExpression(EXP_COLUMN, concept));
															}
														}
														else
														{
															error = "Unknown filter element '" + name + "'.";
															new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
															
															this.mIsValid = false;
														}
													}
													else
													{
														if (Utility.StringSupport.StringCompare(name, "literal", false) == 0)
														{
															if (current_operator != null && (int)current_operator.GetBooleanType() == COP_TYPE && attrs["value"].ToString() != "")
															{
																((TpComparisonOperator)current_operator).SetExpression(new TpExpression(EXP_LITERAL, attrs["value"]));
															}
														}
														else
														{
															if (Utility.StringSupport.StringCompare(name, "parameter", false) == 0)
															{
																if (current_operator != null && (int)current_operator.GetBooleanType() == COP_TYPE && attrs["name"].ToString() != "")
																{
																	((TpComparisonOperator)current_operator).SetExpression(new TpExpression(EXP_PARAMETER, attrs["name"]));
																}
															}
															else
															{
																if (Utility.StringSupport.StringCompare(name, "and", false) == 0)
																{
																	this._AddOperator((TpBooleanOperator) (new TpLogicalOperator(LOP_AND)));
																}
																else
																{
																	if (Utility.StringSupport.StringCompare(name, "or", false) == 0)
																	{
																		this._AddOperator((TpBooleanOperator) (new TpLogicalOperator(LOP_OR)));
																	}
																	else
																	{
																		if (Utility.StringSupport.StringCompare(name, "not", false) == 0)
																		{
																			this._AddOperator((TpBooleanOperator) (new TpLogicalOperator(LOP_NOT)));
																		}
																		else
																		{
																			if (Utility.StringSupport.StringCompare(name, "values", false) == 0)
																			{
																				// nothing to do here ("values" is part of "in")
																			}
																			else
																			{
																				error = "Unknown filter element '" + name + "'.";
																				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_FILTER, error, TpConfigManager.DIAG_ERROR);
																				
																				this.mIsValid = false;
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			string name;
			int depth;
			int size;
			object current_operator;
			if (!this.mIsValid)
			{
				return ;
			}
			
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			if (Utility.StringSupport.StringCompare(name, "equals", false) == 0 || Utility.StringSupport.StringCompare(name, "lessThan", false) == 0 || Utility.StringSupport.StringCompare(name, "lessThanOrEquals", false) == 0 || Utility.StringSupport.StringCompare(name, "greaterThan", false) == 0 || Utility.StringSupport.StringCompare(name, "greaterThanOrEquals", false) == 0 || Utility.StringSupport.StringCompare(name, "like", false) == 0 || Utility.StringSupport.StringCompare(name, "isNull", false) == 0 || Utility.StringSupport.StringCompare(name, "in", false) == 0 || Utility.StringSupport.StringCompare(name, "and", false) == 0 || Utility.StringSupport.StringCompare(name, "or", false) == 0 || Utility.StringSupport.StringCompare(name, "not", false) == 0)
			{
				size = Utility.OrderedMap.CountElements(this.mOperatorsStack);
				
				current_operator = this.mOperatorsStack[size - 1];
				
				if (!((TpBooleanOperator)current_operator).IsValid())
				{
					this.mIsValid = false;
				}
				
				this.mOperatorsStack.Pop();
			}
			
			this.mInTags.Pop();
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			if (!this.mIsValid)
			{
				return ;
			}
		}// end of member function CharacterData
		
		public virtual void  _AddOperator(TpBooleanOperator operator_Renamed)
		{
			int size;
			TpBooleanOperator current_operator;
			size = Utility.OrderedMap.CountElements(this.mOperatorsStack);
			
			if (this.mRootBooleanOperator == null)
			{
				this.mRootBooleanOperator = operator_Renamed;
			}
			else
			{
				current_operator = (TpBooleanOperator)this.mOperatorsStack[size - 1];
				
				if ((int)current_operator.GetBooleanType() == LOP_TYPE)
				{
					((TpLogicalOperator)current_operator).AddBooleanOperator(operator_Renamed);
				}
			}
			
			this.mOperatorsStack[size] = operator_Renamed;
		}// end of member function _AddOperator
		
		public virtual void  SetRootBooleanOperator(TpBooleanOperator rootBooleanOperator)
		{
			this.mRootBooleanOperator = rootBooleanOperator;
		}// end of member function SetRootBooleanOperator
		
		public virtual object GetRootBooleanOperator()
		{
			return this.mRootBooleanOperator;
		}// end of member function GetRootBooleanOperator
		
		public virtual bool Remove(string path)
		{
			Utility.OrderedMap new_ops;
			string error;
			Utility.OrderedMap exploded_path;
			if (this.mRootBooleanOperator == null)
			{
				return false;
			}
			
			if (path == "/0")
			{
				if ((int)this.mRootBooleanOperator.GetBooleanType() == LOP_TYPE)
				{
					TpLogicalOperator lop = (TpLogicalOperator)this.mRootBooleanOperator;
					if (lop.GetLogicalType() == LOP_NOT)
					{
						// Replace the NOT condition by its sub conditions
					
						new_ops = Utility.TypeSupport.ToArray(((TpLogicalOperator)this.mRootBooleanOperator).GetBooleanOperators());
					
						if (Utility.OrderedMap.CountElements(new_ops) > 0)
						{
							// NOT operators have only one condition inside
							this.mRootBooleanOperator = (TpBooleanOperator)new_ops[0];
						}
						else
						{
							this.mRootBooleanOperator = null;
						}
					}
					else this.mRootBooleanOperator = null;
				}
				else
				{
					this.mRootBooleanOperator = null;
				}
				
				return true;
			}
			
			if ((int)this.mRootBooleanOperator.GetBooleanType() == COP_TYPE)
			{
				error = "Cannot remove conditions from comparison operators";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			// Remove leading '/'
			path = path.Substring(1);
			
			exploded_path = new Utility.OrderedMap(path.Split('/'));
			
			// Remove first element
			Utility.OrderedMap.Shift(exploded_path);
			
			TpLogicalOperator op = (TpLogicalOperator)this.mRootBooleanOperator;
			return op.Remove(exploded_path);
		}// end of member function Remove
		
		public virtual bool AddOperator(string path, object booleanType, int specificType)
		{
			TpBooleanOperator op = null;
			string error;
			Utility.OrderedMap exploded_path;
						
			if ((int)booleanType == LOP_TYPE)
			{
				op = new TpLogicalOperator(specificType);
			}
			else
			{
				op = new TpComparisonOperator(specificType);
			}
			
			if (path == "root")
			{
				this.mRootBooleanOperator = (TpBooleanOperator)op;
				
				return true;
			}
			
			if (this.mRootBooleanOperator == null)
			{
				return false;
			}
			
			if ((int)this.mRootBooleanOperator.GetBooleanType() == COP_TYPE)
			{
				error = "Cannot add conditions to comparison operators";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			// Remove leading '/'
			path = path.Substring(1);
			
			exploded_path = new Utility.OrderedMap(path.Split('/'));
			
			// Remove first element
			Utility.OrderedMap.Shift(exploded_path);
			        
			return ((TpLogicalOperator)this.mRootBooleanOperator).AddOperator(exploded_path, op);
		}// end of member function AddOperator
		
		public virtual object Find(string path)
		{
			string error;
			Utility.OrderedMap exploded_path;
			if (path == "/0")
			{
				return this.mRootBooleanOperator;
			}
			
			if (this.mRootBooleanOperator == null)
			{
				return null;
			}
			
			if ((int)this.mRootBooleanOperator.GetBooleanType() == COP_TYPE)
			{
				error = "Cannot search on comparison operators";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				
				return null;
			}
			
			// Remove leading '/'
			path = path.Substring(1);
			
			exploded_path = new Utility.OrderedMap(path.Split('/'));
			
			// Remove first element
			Utility.OrderedMap.Shift(exploded_path);
			
			TpLogicalOperator lop = (TpLogicalOperator)this.mRootBooleanOperator;
			return lop.Find(exploded_path);
		}// end of member function Find
		
		public virtual string GetSql(object rResource)
		{
			if (this.mRootBooleanOperator != null)
			{
				return this.mRootBooleanOperator.GetSql((TpResource)rResource);
			}
			
			return "";
		}// end of member function GetSql
		
		public virtual string GetLogRepresentation()
		{
			if (this.mRootBooleanOperator != null)
			{
				return this.mRootBooleanOperator.GetLogRepresentation();
			}
			
			return "";
		}// end of member function GetLogRepresentation
		
		public virtual string GetXml()
		{
			if (this.mRootBooleanOperator != null)
			{
				return this.mRootBooleanOperator.GetXml();
			}
			
			return "";
		}// end of member function GetXml
		
		public virtual bool IsValid(bool force)
		{
			if (force && this.mRootBooleanOperator != null)
			{
				return mRootBooleanOperator.IsValid();
			}
			
			return this.mIsValid;
		}// end of member function IsValid
		
		public virtual bool IsEmpty()
		{
			return (this.mRootBooleanOperator == null);
		}// end of member function IsEmpty
		
		public virtual void  TestUrlFilterParser(string filterString)
		{
			Utility.OrderedMap list;
			int i;
			string class_Renamed;
			object nested_list;
			object root_boolean_operator;
			filterString = filterString.Replace("\\\"", "\"");
			
			HttpContext.Current.Response.Write("<br/>String is: " + filterString + "<br/>");
			
			list = this._ResolveLiterals(filterString.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
			
			HttpContext.Current.Response.Write("<br/><b>After ResolveLiterals</b><br/>");
			
			i = 0;
			
			foreach ( object el in list.Values ) 
			{
				++i;
				
				HttpContext.Current.Response.Write("<br/><b>" + i + ":</b>&nbsp;");
				
				if (el != null)
				{
					class_Renamed = el.GetType().Name;
					
					HttpContext.Current.Response.Write("class (" + class_Renamed + "): " + ((TpExpression)el).GetReference().ToString());
				}
				else
				{
					HttpContext.Current.Response.Write("string: " + el);
				}
			}
			
			
			list = this._ResolveConcepts(list);
			
			HttpContext.Current.Response.Write("<br/><br/><b>After ResolveConcepts</b><br/>");
			
			i = 0;
			
			foreach ( object el in list.Values ) 
			{
				++i;
				
				HttpContext.Current.Response.Write("<br/><b>" + i + ":</b>&nbsp;");
				
				if (el != null)
				{
					class_Renamed = el.GetType().Name;
					
					HttpContext.Current.Response.Write("class (" + class_Renamed + "): " + ((TpExpression)el).GetReference().ToString());
				}
				else
				{
					HttpContext.Current.Response.Write("string: " + el);
				}
			}
			
			
			nested_list = this._ResolveBrackets(list);
			
			HttpContext.Current.Response.Write("<br/><br/><b>After ResolveBrackets</b><br/>");
			HttpContext.Current.Response.Write("<pre>");
			HttpContext.Current.Response.Write(nested_list.ToString());
			HttpContext.Current.Response.Write("</pre>");
			
			nested_list = this._TokenizeData((TpNestedList)nested_list);
			
			HttpContext.Current.Response.Write("<br/><br/><b>After TokenizeData</b><br/>");
			HttpContext.Current.Response.Write("<pre>");
			HttpContext.Current.Response.Write(nested_list.ToString());
			HttpContext.Current.Response.Write("</pre>");
			
			root_boolean_operator = this._ResolveOperators(nested_list);
			
			HttpContext.Current.Response.Write("<br/><br/><b>Log representation</b><br/>");
			HttpContext.Current.Response.Write(((TpBooleanOperator)root_boolean_operator).GetLogRepresentation());
			
			HttpContext.Current.Response.End();
		}// end of member function TestUrlFilterParser
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			// Note: the other properties are being ommited since serialization
			//       is only used to generate an id for the request parameters.
			//       Unserialised objects will not work!
			
			return new Utility.OrderedMap("mRootBooleanOperator", "mEscapeChar", "mIsLocal");
		}// end of member function __sleep
	}
}
