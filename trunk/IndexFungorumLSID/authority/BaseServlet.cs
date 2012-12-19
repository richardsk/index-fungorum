using System;
using System.Web;
using System.IO;
using System.Configuration;
using System.Xml;

using Microsoft.Web.Services2;
using Microsoft.Web.Services2.Messaging;

using LSIDFramework;
using LSIDClient;

namespace AuthorityWebService
{
/**
 * 
 * This class implements base functionality for LSID services.  This class should be extended to implement services in
 * HTTP.  This servlet contains full SOAP functionality via Microsoft IIS.
 * 
 * @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
 * 
 */
	public abstract class BaseServlet  
	{
		private ServiceRegistry authenticationRegistry;
		protected ServiceRegistry serviceRegistry;
		protected string serviceConfigLocation;

		/**
		 * Initialize the service by instantiating the registered implementation
		 */
		public virtual void init() 
		{
			try 
			{
				String clientHome = ConfigurationSettings.AppSettings.Get(LSIDResolverConfig.LSID_CLIENT_HOME);
				String configLocation = ConfigurationSettings.AppSettings.Get(ServiceConfigurationConstants.RSDL_LOCATION);
				string location = null;
				if (configLocation == null) 
				{
					location = AppDomain.CurrentDomain.BaseDirectory;
				} 
				else 
				{
					location = configLocation;
				}
				this.authenticationRegistry = ServiceRegistry.getAuthenticationServiceRegistry(location);
			} 
			catch (LSIDServerException e) 
			{
				throw new HttpException(e.getErrorCode(), e.getMessage()); 
			}
		}

		public virtual void ProcessRequest(HttpContext context)
		{
			if (context.Request.RequestType == "GET")
			{
				doGet(context);
			}
			else if (context.Request.RequestType == "POST")
			{
				doPost(context);
			}
		}

		public virtual LSIDCredentials GetCredentials(HttpContext context, SoapEnvelope env)
		{
			return BasicAuthenticationModule.RequestCredentials;
		}

		public virtual LSIDRequestContext GetRequestContext(HttpContext ctx)
		{
			LSIDRequestContext rc = BasicAuthenticationModule.LSIDRequest;
			if (rc == null) rc = new LSIDRequestContext();
			rc.ReqUrl = ctx.Request.Url.GetLeftPart(UriPartial.Path);
		
			string hint = ctx.Request.PathInfo;
			if (hint != null && hint.Length > 0 && hint[0] == '/')
			{
			    rc.Hint = hint; 
			}

			return rc;
		}

		/**
		 * @param element
		 * @param req
		 * @param resp
		 * @throws ServletException
		 * @throws IOException
		 */
		public abstract void processGet(HttpContext req, LSIDRequestContext rc); 

		/**
		 * Handle HTTP GET requests on the authority.  All operations should be done via post.
		 *
		 */
		public virtual void doGet(HttpContext req)
		{
			String lsid_str = req.Request.QueryString.Get(WSDLConstants.LSID_PART);
			String hint = req.Request.QueryString.Get(HTTPConstants.HINT);

			LSID lsid = null;
			if (lsid_str != null) 
			{
				try 
				{
					lsid = new LSID(lsid_str);
				} 
				catch (MalformedLSIDException e) 
				{
					req.Response.AppendHeader(HTTPConstants.HEADER_LSID_ERROR_CODE, e.getErrorCode().ToString());
					req.Response.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
					req.Response.StatusDescription = e.getMessage();
					req.Response.ContentType = HTTPConstants.HTML_CONTENT;
					req.Response.Write(req.Response.StatusDescription);
					return;
				}
			}

			LSIDRequestContext rc = BasicAuthenticationModule.LSIDRequest;
			if (rc == null) rc = new LSIDRequestContext();
			rc.ReqUrl = req.Request.Url.GetLeftPart(UriPartial.Path); 
			string[] headerNames = req.Request.Headers.AllKeys;
			foreach (string name in headerNames)
			{			
				rc.addProtocolHeader(name, req.Request.Headers[name]);
			}

			rc.Lsid = lsid;
			rc.Hint = hint;

			try 
			{
				processGet(req, rc);
			} 
			catch (Exception e) 
			{
				//LSIDException.PrintStackTrace(e);
				LSIDException.WriteError(e);
				String desc = e.Message;
				int errorCode = LSIDException.INTERNAL_PROCESSING_ERROR;
				if (e is LSIDException) 
				{
					LSIDException le = (LSIDException) e;
					errorCode = le.getErrorCode();
					desc = le.getDescription();
				}
				Stream os = null;
				try 
				{					
					req.Response.AppendHeader(HTTPConstants.HEADER_LSID_ERROR_CODE, errorCode.ToString());
					req.Response.StatusDescription = desc;
					
					//LSIDException.PrintStackTrace(e);
					LSIDException.WriteError(e);

					req.Response.ContentType = HTTPConstants.HTML_CONTENT;
					req.Response.Write(desc);
					
					req.Response.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
				} 
				catch (IOException ex2) 
				{
					//LSIDException.PrintStackTrace(ex2);
					LSIDException.WriteError(ex2);
				} 
				finally 
				{
					try 
					{
						if (os != null) 
						{
							os.Close();
						}
					} 
					catch (IOException ex) 
					{
						//LSIDException.PrintStackTrace(ex);
						LSIDException.WriteError(ex);
					}
				}
			}
		}

		/**
		 * Handle HTTP POST requests to the authority using IIS
		 * By default return error
		 */
		public virtual void doPost(HttpContext req) 
		{	
			req.Response.StatusCode = (int)System.Net.HttpStatusCode.InternalServerError;
			req.Response.Write("Error processing request");
		}
		
	
	
		/**
		 * get the instance of the authentication service registry
		 */
		private ServiceRegistry getAuthenticationRegistry() 
		{
			if (authenticationRegistry != null)
				return authenticationRegistry;
			else
				authenticationRegistry = (ServiceRegistry)LSIDFramework.Global.AuthenticationRegistry; // getServletContext().getAttribute(AUTHENTICATION_SERVICE_REGISTRY);	
			return authenticationRegistry;
		}
	
		/**
		 * get the instance of the service implementation registry
		 */
		protected ServiceRegistry getServiceRegistry(String type) 
		{
			if (serviceRegistry != null)
				return serviceRegistry;
			else
				serviceRegistry = (ServiceRegistry)LSIDFramework.Global.TheServiceRegistry; // getServletContext().getAttribute(type);	
			return serviceRegistry;
		}
	
		public string getSOAPEnvelope(Stream input)
		{
			string envelope = "";
			try
			{
				//may not be supported by stream
				input.Position = 0;
			}
			catch(Exception ){}

			StreamReader sr = new StreamReader(input, System.Text.Encoding.Default, true);

			// Find soap:Envelope tag
			bool foundEndOfEnvelope = false;
			String envLine = sr.ReadLine();
			while (envLine != null && !foundEndOfEnvelope)
			{
				envelope = envelope + envLine;
			  
				System.Text.RegularExpressions.Match m = 
					System.Text.RegularExpressions.Regex.Match(envLine, "</\\S+:Envelope>");
				if ( m.Success ) 
				{
					foundEndOfEnvelope = true;
				}
				envLine = sr.ReadLine();
			}

			try
			{
				input.Position = 0;
			}
			catch(Exception){}

			return envelope;
		}

		/**
		 * Extract the SOAPAction header.
		 * if SOAPAction is null then we'll we be forced to scan the body for it.
		 * if SOAPAction is "" then use the URL
		 * @param req incoming request
		 * @return the action
		 * @throws AxisFault
		 */
		protected String getSoapAction(HttpContext req) 
		{
			String soapAction = req.Request.Headers["SOAPAction"]; 

			/**
			 * Technically, if we don't find this header, we should probably fault.
			 * It's required in the SOAP HTTP binding.
			 */
			if (soapAction == null) 
			{
				throw new HttpException(LSIDException.INVALID_MESSAGE_FORMAT, "Invalid message format"); 
			}
			// the SOAP 1.1 spec & WS-I 1.0 says:
			// soapaction    = "SOAPAction" ":" [ <"> URI-reference <"> ]
			// some implementations leave off the quotes
			// we strip them if they are present
			if (soapAction.StartsWith("\"") && soapAction.EndsWith("\"")
				&& soapAction.Length>=2) 
			{
				int end = soapAction.Length - 1;
				soapAction = soapAction.Substring(1, end);
			}
			if (soapAction.Length==0)
				soapAction = req.Request.Path; 
			return soapAction;
		}
	
		public void ConfigureResponseFromError(HttpContext context, int errorCode, string error)
		{
			SoapEnvelope respEnv = new SoapEnvelope();
			XmlNode ret = respEnv.CreateBody().AppendChild(respEnv.CreateElement("Error"));
			ret.InnerText = error;

			context.Response.AppendHeader(HTTPConstants.HEADER_LSID_ERROR_CODE, errorCode.ToString());
			context.Response.Write(respEnv.OuterXml);
		}
		
		protected void addStringValue(XmlNode bodyElt, String partname, String val) 
		{
			try 
			{
				XmlElement elt = bodyElt.OwnerDocument.CreateElement(partname);
				elt.AppendChild(bodyElt.OwnerDocument.CreateTextNode(val));
				bodyElt.AppendChild(elt);
			} 
			catch (Exception e) 
			{
				throw new HttpException("error building response", e);
			}
		}
	}
}
