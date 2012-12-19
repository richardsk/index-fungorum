using System;
using System.Web;
using System.IO;

namespace TapirDotNET 
{

	public class TpResponse
	{
		public static bool TP_STATISTICS_TRACKING = false;

		public TpRequest mRequest;
		public Utility.OrderedMap mXmlNamespaces = new Utility.OrderedMap();
		public string mXslt;
		public string mDefaultXslt;
		public bool mCacheable = true;
		public int mCacheLife = 86400;
		
		public virtual int _CmpNamespaces(object ns1, object ns2)
		{
			TpXmlNamespace n1 = (TpXmlNamespace)ns1;
			TpXmlNamespace n2 = (TpXmlNamespace)ns2;
			return string.Compare(n1.GetPrefix().ToString(), n2.GetPrefix().ToString(), false);
		}// TpXmlNamespace objects// once a day (in seconds)
		
		public TpResponse(TpRequest request)
		{
			this.mRequest = request;
		}

		public void Init()
		{
			TpXmlNamespace schema_instance_ns;
			string xslt;
			string accesspoint;
			int main_script_position;
			string base_url;

			schema_instance_ns = new TpXmlNamespace(TpConfigManager.XMLSCHEMAINST, TpConfigManager.TP_XSI_PREFIX, "");
			this.AddXmlNamespace(schema_instance_ns);
			
			xslt = mRequest.GetXslt();
			
			if (xslt != null && xslt.Length > 0)
			{
				this.mXslt = xslt;
			}
			else if (Utility.TypeSupport.ToBoolean(this.mDefaultXslt))
			{
				accesspoint = this.mRequest.GetResourceAccessPoint().ToString();
				
				main_script_position = accesspoint.IndexOf("tapir.aspx");
				
				if (main_script_position != -1)
				{
					base_url = accesspoint.Substring(0, main_script_position);
					
					this.mXslt = base_url + this.mDefaultXslt;
				}
			}
		}
		
		
		public virtual void  Process()
		{
			TpResource r_resource;
			string config_file;
			string capabilities_file;
			TpSettings r_settings;
			object params_Renamed;
			Utility.OrderedMap cache_params;
			object cache;
			string current_month;
			string current_year;
			string stats_db;
			string stats_file_name;
			object stats_log;
			string log_data;
			
			if (this.mRequest.GetLogOnly())
			{
				r_resource = this.mRequest.GetResource();
				
				config_file = r_resource.GetConfigFile();
				capabilities_file = r_resource.GetCapabilitiesFile();
				
				r_settings = r_resource.GetSettings();
				
				r_settings.LoadFromXml(config_file, capabilities_file, false);
				
				if (r_settings.GetLogOnly() == "denied")
				{
					this.ReturnError("Log-only requests are denied on this service");
				}
				
				this.Header();
				
				log_data = this._GetLogData().ToStringContents();
				
				this.Log(log_data);
				
				HttpContext.Current.Response.Write("\n<logged />");
				
				this.Footer();
			}
			else
			{
				// Header should be always dynamic, leave it out from cache
				this.Header();
				
				if (this.mCacheable && TpConfigManager.TP_USE_CACHE)
				{
					params_Renamed = this.GetParams();
					
					cache_params = new Utility.OrderedMap(new object[]{"cache_dir", TpOptions.GetSetting("TP_CACHE_DIRECTORY")}, new object[]{"filename_prefix", "req_"});
					
					//TODO cache call
					//cache = new Cache_Function("file", cache_params, this.mCacheLife);
					
					//cache.call("this->CacheResponse", params_Renamed);
				}
				else
				{
					this.Body();
					
					// Note: better to place logging after Body() so that the SQL can 
					//       also be logged. 
					log_data = this._GetLogData().ToStringContents();
					
					this.Log(log_data);
					
					this.Footer();
				}
			}
			
			if (TP_STATISTICS_TRACKING)
			{				
				//TODO stats
//				current_month = System.DateTime.Now.ToString("MM");
//				current_year = System.DateTime.Now.ToString("yyyy");
//				
//				stats_db = TpConfigManager.TP_STATISTICS_DIR;
//				
//				stats_file_name = TpConfigManager.TP_STATISTICS_DIR + "/" + current_year + "_" + current_month + ".tbl";
//				
//				if (!File.Exists(stats_file_name))
//				{
//					StreamWriter wr = System.IO.File.CreateText(stats_file_name);
//					new TpStatistics().LogResourceInfo();
//					wr.Close();
//					File.SetLastWriteTime(stats_file_name, System.DateTime.Now);
//				}
				
				//TODO log
				//stats_log = new Log().singleton(TpConfigManager.TP_LOG_TYPE, System.IO.Path.GetFullPath(stats_file_name), HttpContext.Current.Request.UserHostAddress, unserialize(Utility.TypeSupport.ToString(TpConfigManager.TP_LOG_OPTIONS)), TpConfigManager.TP_LOG_LEVEL);
				
				//new TpStatistics().LogResourceInfo(ref stats_log, ref Utility.TypeSupport.ToBoolean(stats_db), ref (new Utility.OrderedMap(log_data))[0], current_month, current_year);
				//new TpStatistics().LogSchemaInfo(stats_db, new Utility.OrderedMap(log_data)[0], current_month, current_year);
			}
		}// end of member function Process
		
		public virtual void  Header()
		{
			TpXmlNamespace tapir_ns;
			string send_time;
			string accesspoint;
			string destination;
			string version;
			string h;
			tapir_ns = new TpXmlNamespace(TpConfigManager.TP_NAMESPACE, "", TpConfigManager.TP_SCHEMA_LOCATION);
			this.AddXmlNamespace(tapir_ns);
			
			this.XmlHeader();
			
			// Open response element adding the namespaces
			HttpContext.Current.Response.Write("\n<response");
			
			this.NamespaceDeclarations();
			
			HttpContext.Current.Response.Write(">\n");
			
			// TAPIR header
			send_time = TpUtils.TimestampToXsdDateTime(DateTime.Now);
			
			accesspoint = this.mRequest.GetResourceAccessPoint();
			
			destination = this.mRequest.GetClientAccesspoint();
			
			version = TpConfigManager.TP_VERSION + " (revision " + TpConfigManager.TP_REVISION + ")";
			
			h = "<header>";
			h += "\n" + "<source accesspoint=\"" + accesspoint + "\" sendtime=\"" + send_time + "\">";
			h += "\n\t" + "<software name=\"TapirDotNET\" version=\"" + version + "\"/>";
			h += "\n" + "</source>";
			h += "\n<destination>" + destination + "</destination>";
			
			if (TpConfigManager.TP_SKIN != null)
				//System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("TP_SKIN".ToUpper()) != null)?1:0))
			{
				h += "\n<custom><skin>" + TpConfigManager.TP_SKIN + "</skin></custom>";
			}
			
			h += "\n</header>";
			
			HttpContext.Current.Response.Write(h);
		}// end of member function Header
		
		public virtual void  NamespaceDeclarations()
		{
			string locations;
			string prefix;
			string uri;
			string location;
			string ns_declarations = "";
			// end of inline function _CmpNamespaces
			
			Utility.OrderedMap.SortValueUser(ref this.mXmlNamespaces, "_CmpNamespaces", this);
			
			locations = "";
			
			foreach ( TpXmlNamespace xml_namespace in this.mXmlNamespaces.Values ) 
			{
				ns_declarations += " xmlns";
				
				prefix = Utility.TypeSupport.ToString(xml_namespace.GetPrefix());
				
				if (!Utility.VariableSupport.Empty(prefix))
				{
					ns_declarations += ":" + prefix;
				}
				
				uri = Utility.TypeSupport.ToString(xml_namespace.GetNamespace());
				
				ns_declarations += "=\"" + uri + "\"";
				
				location = Utility.TypeSupport.ToString(xml_namespace.GetSchemaLocation());
				
				if (!Utility.VariableSupport.Empty(location))
				{
					locations += " " + uri + " " + location;
				}
			}
			
			
			HttpContext.Current.Response.Write(ns_declarations);
			
			if (!Utility.VariableSupport.Empty(locations))
			{
				HttpContext.Current.Response.Write(" " + TpConfigManager.TP_XSI_PREFIX + ":schemaLocation=\"" + locations.Trim(new char[]{' ', '\t', '\n', '\r', '0'}) + "\"");
			}
		}// end of member function NamespaceDeclarations
		
		public virtual void  XmlHeader()
		{
			// Send the XML content type header
			string msg;
			HttpContext.Current.Response.ContentType = "text/xml";
			
			// Start the response
			HttpContext.Current.Response.Write(TpUtils.GetXmlHeader());
			
			if (this.mXslt != null)
			{
				if (Utility.TypeSupport.ToBoolean(this.mRequest.GetXsltApply()))
				{
					msg = "Parameter \"xslt-apply\" is not supported";
					new TpDiagnostics().Append(Utility.TypeSupport.ToString(TpConfigManager.DC_UNSUPPORTED_CAPABILITY), msg, Utility.TypeSupport.ToString(TpConfigManager.DIAG_WARN));
				}
				
				HttpContext.Current.Response.Write("\n");
				HttpContext.Current.Response.Write("<?xml-stylesheet type=\"text/xsl\" href=\"" + this.mXslt + "\"?>");
			}
		}// end of member function XmlHeader
		
		public virtual void  Footer()
		{
			HttpContext.Current.Response.Write(new TpDiagnostics().GetXml());
			
			// Close response tag
			HttpContext.Current.Response.Write("\n</response>");
		}// end of member function Footer
		
		public virtual void  Error(string msg)
		{
			// Error tag
			HttpContext.Current.Response.Write("<error level=\"error\">" + TpUtils.EscapeXmlSpecialChars(msg) + "</error>");
			
			TpLog.debug(">> Returned Error: " + msg);			
		}// end of member function Error
		
		public virtual void  Body()
		{
			this.Error("Internal error: TpResponse \"Body\" method must be " + "overwritten by the subclass related to this operation.");
		}// end of member function Body
		
		public virtual void  ReturnError(string msg)
		{
			this.Header();
			
			this.Error(msg);
			
			this.Footer();
						
			TpLog.log(msg);
			
			//throw new Exception(msg);
			HttpContext.Current.Response.End();
		}// end of member function ReturnError
		
		public virtual void  AddXmlNamespace(TpXmlNamespace xmlNamespace)
		{
			this.mXmlNamespaces.Push(xmlNamespace);
		}// end of member function AddXmlNamespace
		
		public virtual object GetParams()
		{
			// This function is used to return all parameters that determine
			// the contents of a response. This is usually represented by a
			// TpRequest object. But this method can also be overwritten by 
			// subclasses to include other things that can influence responses 
			// (like local settings).
			
			return this.mRequest;
		}// end of member function GetParams
		
		public virtual void  CacheResponse(object params_Renamed)
		{
			// This method is just a wrapper for caching results. $params don't
			// need to be used here since they mainly come from mRequest, which
			// is used by methods Body() and Footer(). $params only serve to 
			// generate the cache id.
			
			this.Body();
			
			this.Footer();
		}// end of member function CacheResponse
		
		public virtual void  Log(string logData)
		{
			string str;
			
			str = TpServiceUtils.GetLogString(new Utility.OrderedMap(logData));
			
			TpLog.log(str);
		}// end of member function Log
		
		public virtual Utility.OrderedMap _GetLogData()
		{
			// Log data which is common to all operations
			Utility.OrderedMap data;
			long long_Renamed = -1;
			string source_host;
			
			data = new Utility.OrderedMap();
			
			data["resource"] = this.mRequest.GetResourceCode();
			data["operation"] = this.mRequest.GetOperation();
			data["encoding"] = this.mRequest.GetRequestEncoding();
			data["logonly"] = this.mRequest.GetLogOnly();
			data["xslt"] = this.mRequest.GetXslt();
			data["source_ip"] = this.mRequest.GetClientAccesspoint();
			data["source_host"] = null;
			
			try
			{
				System.Net.IPAddress addr = System.Net.IPAddress.Parse(data["source_ip"].ToString());

				// Valid IP
				
				// Note: gethostbyaddr can be time expensive! Use cache here.
				
				source_host = (string)HttpContext.Current.Cache.Get("HostByAddress");

				if (source_host == null)
				{
					source_host = System.Net.Dns.GetHostByAddress(addr).HostName;
				}
				
				if (source_host != null)
				{
					data["source_host"] = source_host;
				}
			}
			catch(Exception)
			{
			}
			
			return data;
		}// end of member function _GetLogData
	}
}
