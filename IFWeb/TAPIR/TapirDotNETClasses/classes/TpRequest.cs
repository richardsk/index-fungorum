using System;
using System.Web;
using System.Xml;

namespace TapirDotNET 
{

	public class TpRequest
	{	
		public string mResourceCode;
		public TpResource mrResource;
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public Utility.OrderedMap mSequence = new Utility.OrderedMap();
		public string mClientAccesspoint;
		public string mOperation;
		public string mXslt;
		public string mXsltApply;
		public bool mLogOnly = false;
		public bool mCount = false;
		public int mStart = 0;
		public int mLimit = -1;
		public bool mEnvelope = true;
		public bool mOmitNamespaces = false;
		public TpOperationParameters mOperationParameters;
		public bool mFoundTemplate = false;
		public bool mLoadedTemplateFromCache = false;
		public string mRequestEncoding = "xml";// element stack (names) during XML parsing
		
		public TpRequest()
		{
			
		}
		
		
		public virtual bool ExtractResourceCode(string uri)
		{
			Utility.OrderedMap matches;
			if (uri == "")
			{
				uri = Utility.TypeSupport.ToString(HttpContext.Current.Request.RawUrl);
			}
			
			matches = new Utility.OrderedMap();
			
			//TODO check regex
			if (Utility.RegExPerlSupport.Match("/^.*\\/tapir.aspx\\/([^\\/\\?]+)[\\/\\?]?.*$/i", uri, ref matches, - 1) != 0)
			{
				if (HttpContext.Current.Request["dsa"] != null)
				{
					this.mResourceCode = HttpContext.Current.Request["dsa"];
					
					return true;
				}
				
				return false;
			}
			
			if (matches[1] == null)
			{
				if (HttpContext.Current.Request["dsa"] != null)
				{
					this.mResourceCode = HttpContext.Current.Request["dsa"];
					
					return true;
				}
				
				return false;
			}
			
			this.mResourceCode = matches[1].ToString();
			
			return true;
		}// end of member function ExtractResourceCode
		
		 /**
		* Initialize the parameter array.  The parameter array is used to control the
		* operation and response of the DiGIR provider. The array is populated by
		* loading key+value pairs from the URL, from POSTed values, or XML
		* request document.
		*/
		public virtual bool InitializeParameters()
		{
			// Load resource object
			string error;
			TpResources r_resources = null;
			bool raise_errors;
			string request;

			if (this.mResourceCode == "" && !this.ExtractResourceCode(""))
			{
				error = "Resource not specified in request URL.";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
				return false;
			}
			
			r_resources = new TpResources().GetInstance();
			
			raise_errors = false;
			this.mrResource = (TpResource)r_resources.GetResource(this.mResourceCode, raise_errors);
			
			if (this.mrResource == null)
			{
				error = "Resource \"" + this.mResourceCode + "\" not found.";
				new TpDiagnostics().Append(TpConfigManager.DC_RESOURCE_NOT_FOUND, error, TpConfigManager.DIAG_FATAL);
				return false;
			}
			
			if (this.mrResource.GetStatus() != "active")
			{
				error = "Resource \"" + this.mResourceCode + "\" is not active.";
				new TpDiagnostics().Append(TpConfigManager.DC_RESOURCE_NOT_FOUND, error, TpConfigManager.DIAG_FATAL);
				return false;
			}
			
			// If there is a 'request' parameter (either with GET or POST)
			// then load it as an XML or as an URL pointing to an XML
			if (HttpContext.Current.Request["request"] != null)
			{
				string u = HttpContext.Current.Request["request"];
				u = u.Replace("\\", "");
				request = System.Web.HttpUtility.UrlDecode(u).Trim(new char[]{' ', '\t', '\n', '\r', '0'});
				
				// request can be an URL encoded XML or a URL pointing to 
				// a remote XML file
				return this.LoadXmlParameters(request);
			}
			
			// If method is GET, or if method is POST with parameters
			if (HttpContext.Current.Request.HttpMethod == "GET" || HttpContext.Current.Request.Form.Count > 0)
			{
				// Load KVP parameters
				return this.LoadKvpParameters();
			}
			
			// Here method is POST without parameters, so try loading
			// the XML from raw POST data
			string data = new System.IO.StreamReader(HttpContext.Current.Request.InputStream).ReadToEnd();
			return this.LoadXmlParameters(data);
		}// end of member function InitializeParameters
		
		public virtual bool LoadKvpParameters()
		{
			string fnam;
			string msg;
			string log_only = null;
			string count = null;
			string envelope = null;
			string omit_ns = null;
			object template = null;
			this.mRequestEncoding = "kvp";
			
			// Stash request to a file
			
			if (TpConfigManager.TP_STASH_REQUEST)
			{
				fnam = TpConfigManager.TP_DEBUG_DIR + "\\" + TpConfigManager.TP_STASH_FILE;
				
				try
				{
					System.IO.StreamWriter wr = System.IO.File.CreateText(fnam);
				
					wr.Write(string.Format("REMOTE ADDRESS: {0}\n", HttpContext.Current.Request.UserHostAddress));
					wr.Write(string.Format("REQUEST URI: {0}\n", HttpContext.Current.Request.RawUrl));
					wr.Write(string.Format("AGENT: {0}\n", HttpContext.Current.Request.UserAgent));
					wr.Write(string.Format("VARS: {0}\n", TpUtils.DumpArray(new Utility.OrderedMap(HttpContext.Current.Session))));
					wr.Close();
				}
				catch(Exception ex)
				{
					msg = "Could not stash request in " + fnam;
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_WARN);
				}
			}
			
			// Load params
			
			this.mClientAccesspoint = TpUtils.GetVar("source-ip", HttpContext.Current.Request.UserHostAddress).ToString();
			
			this.mOperation = TpUtils.GetVar("op", "metadata").ToString().ToLower();
			
			// Operations can be abbreviated - in this case, standardise
			switch (this.mOperation)
			{
				
				case "p": 
					this.mOperation = "ping";
					break;
				
				case "m": 
					this.mOperation = "metadata";
					break;
				
				case "c": 
					this.mOperation = "capabilities";
					break;
				
				case "s": 
					this.mOperation = "search";
					break;
				
				case "i": 
					this.mOperation = "inventory";
					break;
				
			}
			
			log_only = TpUtils.GetVar("log-only", "").ToString();
			
			if (log_only == "true" || log_only == "1")
			{
				this.mLogOnly = true;
			}
			
			if (this.mLogOnly)
			{
				return true;
			}
			
			this.mXslt = (string)TpUtils.GetVar("xslt", null);
			this.mXsltApply = (string)TpUtils.GetVar("xslt-apply", "");
			
			if (this.mOperation == "search" || this.mOperation == "inventory")
			{
				// Global Parameters
				
				// Count
				if (HttpContext.Current.Request["count"] != null)
				{
					count = HttpContext.Current.Request["count"];
				}
				else
				{
					if (HttpContext.Current.Request["cnt"] != null)
					{
						count = HttpContext.Current.Request["cnt"];
					}
				}
				
				if (count != null && (count == "true" || count == "1"))
				{
					this.mCount = true;
				}
				else
				{
					this.mCount = false;
				}
				
				// Start
				if (HttpContext.Current.Request["start"] != null && Utility.TypeSupport.ToInt32(HttpContext.Current.Request["start"]) >= 1)
				{
					this.mStart = Utility.TypeSupport.ToInt32(HttpContext.Current.Request["start"]);
				}
				else
				{
					if (HttpContext.Current.Request["s"] != null && Utility.TypeSupport.ToInt32(HttpContext.Current.Request["s"]) >= 1)
					{
						this.mStart = Utility.TypeSupport.ToInt32(HttpContext.Current.Request["s"]);
					}
				}
				
				// Limit
				if (HttpContext.Current.Request["limit"] != null && Utility.TypeSupport.ToInt32(HttpContext.Current.Request["limit"]) >= 0)
				{
					this.mLimit = Utility.TypeSupport.ToInt32(HttpContext.Current.Request["limit"]);
				}
				else
				{
					if (HttpContext.Current.Request["l"] != null && Utility.TypeSupport.ToInt32(HttpContext.Current.Request["l"]) >= 0)
					{
						this.mLimit = Utility.TypeSupport.ToInt32(HttpContext.Current.Request["l"]);
					}
				}
				
				if (this.mOperation == "search")
				{
					// Envelope
					if (HttpContext.Current.Request["envelope"] != null)
					{
						envelope = Utility.TypeSupport.ToString(HttpContext.Current.Request["envelope"]);
					}
					else
					{
						if (HttpContext.Current.Request["e"] != null)
						{
							envelope = Utility.TypeSupport.ToString(HttpContext.Current.Request["e"]);
						}
					}
					
					if (envelope != null && (envelope == "false" || envelope == "0"))
					{
						this.mEnvelope = false;
					}
					
					// Omit namespaces
					omit_ns = TpUtils.GetVar("omit-ns", "").ToString();
					
					if (omit_ns == "true" || omit_ns == "1")
					{
						this.mOmitNamespaces = true;
					}
				}
				
				// Template
				if (HttpContext.Current.Request["template"] != null)
				{
					template = HttpContext.Current.Request["template"];
					
					this.mFoundTemplate = true;
				}
				else
				{
					if (HttpContext.Current.Request["t"] != null)
					{
						template = HttpContext.Current.Request["t"];
						
						this.mFoundTemplate = true;
					}
				}
				
				if (this.mFoundTemplate)
				{
					return this.LoadTemplate(template);
				}
				else
				{
					// No template provided - delegate further parameter loading
					if (this.mOperation == "search")
					{
						
						this.mOperationParameters = new TpSearchParameters();
					}
					else
					{
						
						this.mOperationParameters = new TpInventoryParameters();
					}
					
					return this.mOperationParameters.LoadKvpParameters();
				}
			}
			
			return true;
		}// end of member function LoadKvpParameters
		
		public virtual bool LoadXmlParameters(string request)
		{
			// Stash request to a file
			string fnam;
			string msg;
			string error;
			int code;
			System.IO.StreamWriter wr = null;
			
			if (TpConfigManager.TP_STASH_REQUEST)
			{
				fnam = TpConfigManager.TP_DEBUG_DIR + "\\" + TpConfigManager.TP_STASH_FILE;
				
				try
				{
					wr = System.IO.File.CreateText(fnam);
					wr.Write(string.Format("REMOTE ADDRESS: {0}\n", HttpContext.Current.Request.UserHostAddress));
					wr.Write(string.Format("REQUEST URI: {0}\n", HttpContext.Current.Request.RawUrl));
					wr.Write(string.Format("AGENT: {0}\n", HttpContext.Current.Request.UserAgent));
					wr.Write(string.Format("XML SOURCE: {0}\n", request));
					wr.Write("XML CONTENT: \n");
				}
				catch(Exception ex)
				{
					msg = "Could not stash request in " + fnam;
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_WARN);
				}
			}
			
			try
			{				
				if (TpUtils.IsUrl(request))
				{
					TpXmlReader rdr = new TpXmlReader();
					rdr.StartElementHandler = new StartElement(this.StartElement);
					rdr.EndElementHandler = new EndElement(this.EndElement);
					rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
				
					rdr.ReadXml(request);
					
					if (TpConfigManager.TP_STASH_REQUEST && wr != null)
					{
						wr.Write(rdr.XmlData);
					}
				}
				else
				{
					request = System.Web.HttpUtility.UrlDecode(request);
						
					TpXmlReader rdr = new TpXmlReader();
					rdr.StartElementHandler = new StartElement(this.StartElement);
					rdr.EndElementHandler = new EndElement(this.EndElement);
					rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
				
					rdr.ReadXmlStr(request);
					
					if (TpConfigManager.TP_STASH_REQUEST && wr != null)
					{
						wr.Write(rdr.XmlData);
					}
				}
			}
			catch(Exception ex)
			{
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, ex.Message, TpConfigManager.DIAG_ERROR);
				return false;
			}

			
			if (wr != null) wr.Close();
			
			return true;
		}// end of member function LoadXmlParameters
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			string name;
			int depth;
			string path;
			double sequence;
			string log_only;
			string count;
			string envelope;
			string omit_ns;
			object msg = null;
			string error = "";
			
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			this.mInTags.Push(name.ToLower());
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			if (depth > Utility.OrderedMap.CountElements(this.mSequence))
			{
				this.mSequence.Push(1);
			}
			else
			{
				this.mSequence[depth - 1] = Utility.TypeSupport.ToDouble(this.mSequence[depth - 1]) + 1;
			}
			
			path = Utility.StringSupport.Join("/", this.mInTags);
			
			sequence = Utility.TypeSupport.ToDouble(this.mSequence[depth - 1]);
			
			// First <source> inside <header>
			if (Utility.StringSupport.StringCompare(path, "request/header/source", false) == 0 && sequence == 1)
			{
				// Note: accesspoint is mandatory for all <source> except the last
				if (attrs["accesspoint"] != null && attrs["accesspoint"].ToString() != "")
				{
					// Should only fall here when there's more than one <source>
					this.mClientAccesspoint = attrs["accesspoint"].ToString();
				}
				else
				{
					// Only one source (first == last)
					this.mClientAccesspoint = HttpContext.Current.Request.UserHostAddress;
				}
			}
			// Second element (after <header>) in the second level
			else if (depth == 2 && sequence == 2)
			{
				this.mOperation = name.ToLower();// no need to perform check here
				
				log_only = TpUtils.GetInArray(attrs, "log-only", "").ToString();
				
				if (Utility.StringSupport.StringCompare(log_only, "true", true) == 0 || log_only == "1")
				{
					this.mLogOnly = true;
				}
				
				this.mXslt = (string)TpUtils.GetInArray(attrs, "xslt", "");
				this.mXsltApply = (string)TpUtils.GetInArray(attrs, "xslt-apply", "false");
				
				if (this.mOperation == "search" || this.mOperation == "inventory")
				{
					count = TpUtils.GetInArray(attrs, "count", "").ToString();
					
					if (Utility.StringSupport.StringCompare(count, "true", true) == 0 || count == "1")
					{
						this.mCount = true;
					}
					else
					{
						this.mCount = false;
					}
					
					this.mStart = System.Convert.ToInt32(TpUtils.GetInArray(attrs, "start", 0));
					this.mLimit = System.Convert.ToInt32(TpUtils.GetInArray(attrs, "limit", 0));
					
					if (this.mOperation == "search")
					{
						envelope = TpUtils.GetInArray(attrs, "envelope", "").ToString();
						
						if (Utility.StringSupport.StringCompare(envelope, "false", true) == 0 || envelope == "0")
						{
							this.mEnvelope = false;
						}
						
						omit_ns = TpUtils.GetInArray(attrs, "omit-ns", "").ToString();
						
						if (Utility.StringSupport.StringCompare(omit_ns, "true", true) == 0 || omit_ns == "1")
						{
							this.mOmitNamespaces = true;
						}
					}
				}
			}
			else if (this.mOperation == "search" || this.mOperation == "inventory")
			{
				// First subelement of the operation
				if (depth == 3 && sequence == 1)
				{
					if (Utility.StringSupport.StringCompare(name, "template", false) == 0)
					{
						this.mFoundTemplate = true;
						
						if (attrs["location"] != null && attrs["location"].ToString() != "")
						{
							// Remove possible namespaces that were flagged as being
							// part of the output model element
							if (this.mOperation == "search")
							{								
								//TODO reader.RemoveFlag("m");
							}
							
							this.LoadTemplate(attrs["location"]);
						}
						else
						{
							error = "Missing attribute \"location\" in <template> element";
							new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, msg.ToString(), TpConfigManager.DIAG_ERROR);
						}
					}
					else
					{
						// Just instantiate a new parameters object and let the
						// rest of the parsing take care of loading parameters
						if (this.mOperation == "search")
						{
							// Remove possible namespaces that were flagged as being
							// part of the output model element
							if (Utility.StringSupport.StringCompare(name, "searchtemplate", false) == 0)
							{
								//TODO reader.RemoveFlag("m");
							}
							
							
							this.mOperationParameters = new TpSearchParameters();
						}
						else
						{
							
							this.mOperationParameters = new TpInventoryParameters();
						}
					}
				}
				
				if (!this.mFoundTemplate)
				{
					// Delegate parsing
					this.mOperationParameters.StartElement(reader, attrs);
				}
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			object name;
			int depth;
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			this.mInTags.Pop();
			
			if (depth < Utility.OrderedMap.CountElements(this.mSequence))
			{
				this.mSequence[depth] = 0;
			}
			
			if (this.mOperation == "search" || this.mOperation == "inventory")
			{
				if (this.mOperationParameters != null && !this.mFoundTemplate)
				{
					this.mOperationParameters.EndElement(reader);
				}
			}
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			int depth;
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			if (this.mOperation == "search" || this.mOperation == "inventory")
			{
				if (this.mOperationParameters != null && !this.mFoundTemplate)
				{
					this.mOperationParameters.CharacterData(reader, data);
				}
			}
		}// end of member function CharacterData
		
		public virtual bool LoadTemplate(object template)
		{
			//global $g_dlog
			string error;
			bool loaded_from_cache;
			string cached_data = null;
			int cache_expires;
			
			TpLog.debug("[Loading template]");
			TpLog.debug("Location " + Utility.TypeSupport.ToString(template));
			
			// Templates must be specified as URLs
			if (!TpUtils.IsUrl(template.ToString()))
			{
				error = "Template is not a URL.";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
				
				return false;
			}
			
			loaded_from_cache = false;
			
			// If cache is enabled
			if (TpConfigManager.TP_USE_CACHE)
			{				
				this.mOperationParameters = (TpOperationParameters)HttpContext.Current.Cache.Get("templates");
				this.mLoadedTemplateFromCache = true;
			}
			
			if (!this.mLoadedTemplateFromCache)
			{
				if (this.mOperation == "search")
				{					
					this.mOperationParameters = new TpSearchParameters();
				}
				else
				{
					
					this.mOperationParameters = new TpInventoryParameters();
				}
				
				if (this.mOperationParameters.ParseTemplate(template.ToString()))
				{
					// Save parameters in cache
					
					if (TpConfigManager.TP_USE_CACHE)
					{						
						cache_expires = TpConfigManager.TP_TEMPLATE_CACHE_LIFE_SECS;
						
						HttpContext.Current.Cache.Add("templates", mOperationParameters, null, DateTime.MaxValue, new TimeSpan(0,0,cache_expires), System.Web.Caching.CacheItemPriority.Normal, null);
					}
				}
				else
				{
					return false;
				}
			}
			
			return true;
		}// end of member function LoadTemplate
		
		public virtual string GetOperation()
		{
			return this.mOperation.ToLower();
		}// end of member function GetOperation
		
		public virtual string GetResourceCode()
		{
			return this.mResourceCode;
		}// end of member function GetResourceCode
		
		public virtual string GetResourceAccessPoint()
		{
			string accesspoint = "?";
			
			if (this.mrResource != null)
			{
				accesspoint = this.mrResource.GetAccesspoint();
			}
			
			return accesspoint;
		}// end of member function GetResourceAccesspoint
		
		public virtual TpResource GetResource()
		{
			return this.mrResource;
		}// end of member function GetResource
		
		public virtual string GetClientAccesspoint()
		{
			return this.mClientAccesspoint;
		}// end of member function GetClientAccesspoint
		
		public virtual bool GetLogOnly()
		{
			return this.mLogOnly;
		}// end of member function GetLogOnly
		
		public virtual string GetXslt()
		{
			return this.mXslt;
		}// end of member function GetXslt
		
		public virtual string GetXsltApply()
		{
			return this.mXsltApply;
		}// end of member function GetXsltApply
		
		public virtual bool GetCount()
		{
			return this.mCount;
		}// end of member function GetCount
		
		public virtual int GetStart()
		{
			return this.mStart;
		}// end of member function GetStart
		
		public virtual int GetLimit()
		{
			return this.mLimit;
		}// end of member function GetLimit
		
		public virtual bool GetEnvelope()
		{
			return this.mEnvelope;
		}// end of member function GetEnvelope
		
		public virtual bool GetOmitNamespaces()
		{
			return this.mOmitNamespaces;
		}// end of member function GetOmitNamespaces
		
		public virtual TpOperationParameters GetOperationParameters()
		{
			return this.mOperationParameters;
		}// end of member function GetOperationParameters
		
		public virtual string GetRequestEncoding()
		{
			return this.mRequestEncoding;
		}// end of member function GetRequestEncoding
		
		public virtual bool FoundTemplate()
		{
			return this.mFoundTemplate;
		}// end of member function FoundTemplate
		
		public virtual bool LoadedTemplateFromCache()
		{
			return this.mLoadedTemplateFromCache;
		}// end of member function LoadedTemplateFromCache
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			Utility.OrderedMap basic_parameters;
			Utility.OrderedMap query_parameters;
			basic_parameters = new Utility.OrderedMap("mResourceCode", "mOperation", "mXslt", "mXsltApply", "mLogonly");
			
			if (this.mOperation == "ping" || this.mOperation == "metadata" || this.mOperation == "capabilities")
			{
				return basic_parameters;
			}
			
			query_parameters = new Utility.OrderedMap("mCount", "mStart", "mLimit", "mEnvelope", "mOperationParameters", "mFoundTemplate", "mLoadedTemplateFromCache");
			
			return Utility.OrderedMap.Merge(basic_parameters, query_parameters);
		}// end of member function __sleep
	}
}
