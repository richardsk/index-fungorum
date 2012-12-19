using System;
using System.IO;
using System.Xml;
using System.Web;
using System.Net;

namespace TapirDotNET 
{

	public class TpOutputModel
	{
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public object mLabel;
		public object mDocumentation;
		public string mLocation;
		public object mIndexingElement;
		public Utility.OrderedMap mMapping = new Utility.OrderedMap();
		public bool mAutomapping = false;
		public object mCurrrentMappingPath;
		public TpResponseStructure mResponseStructure;
		public Utility.OrderedMap mNamespaces = new Utility.OrderedMap();
		public string mCurrentMappingPath;// name element stack during XML parsing
		
		public TpOutputModel()
		{
			
		}
		
		
		public virtual bool Parse(string location)
		{
			string error = "";
			
			// This is a workaround because when browsing the provider 
			// through XSLT, some parameter values are not being escaped.
			// In the future this should be solved in the xsl files.
			location = location.Trim(' ', '+');

			//location is a URL
			this.mLocation = location;
			if (!TpUtils.IsUrl(location)) TpLog.debug("WARNING : Output model location is not a URL.");
						
			string om = "";
			WebRequest wr = HttpWebRequest.Create(location);
			if ( TpConfigManager.TP_WEB_PROXY.Length > 0 )
			{
				wr.Proxy = new WebProxy(TpConfigManager.TP_WEB_PROXY);
			}

			WebResponse resp = wr.GetResponse();
			StreamReader sr = new StreamReader(resp.GetResponseStream());
			om = sr.ReadToEnd();
			sr.Close();


			TpLog.debug("[Parsing Output model]");
			TpLog.debug("Loading from location " + location);
			
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
								
			try
			{
				rdr.ReadXmlStr(om);                
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			return true;
		}// end of member function Parse
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			//global $g_dlog
			string name;
			int depth;
			string error;
			bool automapping = false;
			
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			this.mInTags.Push(name.ToLower());
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			// <outputModel>
			if (Utility.StringSupport.StringCompare(name, "outputmodel", false) == 0)
			{
				// Get possible prefix declarations
				
				this.mNamespaces = reader.GetNamespaces();
			}
			// <structure>
			else
			{
				if (Utility.StringSupport.StringCompare(name, "structure", false) == 0)
				{
					// nothing
				}
				// <indexingElement>
				else
				{
					if (Utility.StringSupport.StringCompare(name, "indexingElement", false) == 0)
					{
						if (attrs["path"].ToString() != "")
						{
							this.mIndexingElement = attrs["path"];
						}
						else
						{
							error = "Missing attribute \"path\" in <indexingElement>";
							new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
						}
					}
					// <mapping>
					else
					{
						if (Utility.StringSupport.StringCompare(name, "mapping", false) == 0)
						{
							string am = TpUtils.GetInArray(attrs, "automapping", "").ToString();
							
							if (am.ToLower() == "true" || am == "1")
							{
								automapping = true;
							}
							else
							{
								automapping = false;
							}
							
							this.mAutomapping = automapping;
						}
						else if (depth > 1)
						{
							// <node> element whose parent is <mapping>
							if (this.mInTags[depth - 2].ToString() == "mapping" && Utility.StringSupport.StringCompare(name, "node", false) == 0)
							{
								if (attrs["path"].ToString() != "")
								{
									this.mMapping[attrs["path"].ToString()] = new Utility.OrderedMap();
									this.mCurrentMappingPath = attrs["path"].ToString();
								}
								else
								{
									error = "Missing attribute \"path\" in <node> element";
									new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
								}
							}
							// parent is <node>
							else if (this.mInTags[depth - 2].ToString() == "node")
							{
								if (Utility.StringSupport.StringCompare(name, "concept", false) == 0)
								{
									if (this.mCurrentMappingPath != null && attrs["id"].ToString() != "")
									{
										((Utility.OrderedMap)this.mMapping[this.mCurrentMappingPath]).Push(new TpExpression(TpFilter.EXP_CONCEPT, attrs["id"]));
									}
								}
								else
								{
									if (Utility.StringSupport.StringCompare(name, "literal", false) == 0)
									{
										if (this.mCurrentMappingPath != null && attrs["value"].ToString() != "")
										{
											((Utility.OrderedMap)this.mMapping[this.mCurrentMappingPath]).Push(new TpExpression(TpFilter.EXP_LITERAL, attrs["value"]));
										}
									}
									else
									{
										if (Utility.StringSupport.StringCompare(name, "variable", false) == 0)
										{
											if (this.mCurrentMappingPath != null && attrs["name"].ToString() != "")
											{
												((Utility.OrderedMap)this.mMapping[this.mCurrentMappingPath]).Push(new TpExpression(TpFilter.EXP_VARIABLE, attrs["name"]));
											}
										}
									}
								}
							}
							// inside <structure>
							else
							{
								if (this.mInTags.Search("structure") != null)
								{
									if (this.mInTags[depth - 2].ToString() == "structure" && Utility.StringSupport.StringCompare(name, "schema", false) == 0 && attrs["location"] != null && attrs["location"].ToString() != "")
									{
										TpLog.debug("[Parsing Response Structure]");
										TpLog.debug("Loading from location " + Utility.TypeSupport.ToString(attrs["location"]));
										
										this.LoadResponseStructure(attrs["location"].ToString());
									}
									else
									{
										// Delegate to response structure parser
										if (this.mResponseStructure == null)
										{
											TpLog.debug("[Parsing Response Structure]");
											TpLog.debug("Delegating parsing events");
											
											this.mResponseStructure = new TpResponseStructure();
										}
										
										this.mResponseStructure.StartElement(reader, attrs);
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
			string name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			int depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			// inside <schema>
			if (this.mInTags.Search("schema") != null && Utility.StringSupport.StringCompare(reader.XmlReader.Name, "schema", false) != 0 && this.mResponseStructure != null)
			{
				this.mResponseStructure.EndElement(reader);
			}
			
			this.mInTags.Pop();
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			
		}// end of member function CharacterData
		
		public virtual bool LoadResponseStructure(string location)
		{
			// Here response structure must be specified as an URL
			// (it's important to check this also for security reasons since
			// "fopen" is used to read templates!)
			string error;
			bool loaded_from_cache;
			object cache;
			object cache_id;
			string cached_data;
			int cache_expires;
			
			if (!TpUtils.IsUrl(location))
			{
				error = "Response schema is not a URL.";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
				
				return false;
			}
			
			loaded_from_cache = false;
			
			// If cache is enabled
			if (TpConfigManager.TP_USE_CACHE)
			{
				//TODO cache correct?								
				this.mResponseStructure = (TpResponseStructure)HttpContext.Current.Cache.Get("structures");
				loaded_from_cache = true;
			}
			
			if (!loaded_from_cache)
			{
				this.mResponseStructure = new TpResponseStructure();
				
				if (this.mResponseStructure.Parse(location, false))
				{
					// Save parameters in cache
					
					if (TpConfigManager.TP_USE_CACHE)
					{						
						cache_expires = TpConfigManager.TP_RESP_STRUCTURE_CACHE_LIFE_SECS;
						
						//TODO check
						HttpContext.Current.Cache.Add("structures", mResponseStructure, null, DateTime.MaxValue, new TimeSpan(0,0,cache_expires), System.Web.Caching.CacheItemPriority.Normal, null);
					}
				}
				else
				{
					return false;
				}
			}
			
			return true;
		}// end of member function LoadResponseStructure
		
		public virtual string GetLocation()
		{
			return this.mLocation;
		}// end of member function GetLocation
		
		public virtual object GetLabel()
		{
			return this.mLabel;
		}// end of member function GetLabel
		
		public virtual object GetDocumentation()
		{
			return this.mDocumentation;
		}// end of member function GetDocumentation
		
		public virtual object GetIndexingElement()
		{
			return this.mIndexingElement;
		}// end of member function GetIndexingElement
		
		public virtual Utility.OrderedMap GetMapping()
		{
			return this.mMapping;
		}// end of member function GetMapping
		
		public virtual object GetMappingForNode(string path)
		{
			if (this.mMapping[path] != null)
			{
				return this.mMapping[path];
			}
			
			return null;
		}// end of member function GetMappingForNode
		
		public virtual bool GetAutomapping()
		{
			return this.mAutomapping;
		}// end of member function GetAutomapping
		
		public virtual TpResponseStructure GetResponseStructure()
		{
			return this.mResponseStructure;
		}// end of member function GetResponseStructure
		    
		public Utility.OrderedMap GetDeclaredNamespaces()
		{
			return this.mNamespaces;
		}

		public string GetPrefix( string ns )
		{
			for ( int i = 0; i < this.mNamespaces.Count; ++i )
			{
				if ( ((TpNamespace)this.mNamespaces.Values[i]).GetUri() == ns )
				{
					return ((TpNamespace)this.mNamespaces.Values[i]).GetPrefix();
				}
			}

			return "";
		} // end of member function GetPrefix

		public virtual bool IsValid()
		{
			string error;
			if (!(this.mIndexingElement != null))
			{
				error = "No indexing element defined in response structure";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			// Note: the checking that the indexing element actually points to an 
			//       element in the structure is performed by TpSchemaInspector
			
			if (Utility.OrderedMap.CountElements(this.mMapping) == 0)
			{
				error = "No mapping section defined in response structure";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			// Note: TapirDotNET does not check if mapped nodes actually point to 
			//       nodes in the structure. It's not its core business to spend
			//       time with these things.
			
			
			// Note: TpSchemaInspector already checks if there is at least one 
			//       concrete global element in the response structure.
			
			// Note: TapirDotNET will ignore errors in the partial parameter (meaning
			//       that it will not check that the partial path coresponds to an 
			//       actual path in the structure). In that case the path will be ignored.
			
			return true;
		}// end of member function IsValid
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mLocation", "mIndexingElement", "mMapping", "mAutomapping", "mResponseStructure");
		}// end of member function __sleep
	}
}
