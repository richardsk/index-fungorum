using System;
using System.Web;
using System.IO;
using System.Configuration;

using Microsoft.Web.Services2;
using Microsoft.Web.Services2.Messaging;

using LSIDFramework;
using LSIDClient;

namespace AuthorityWebService
{
	/**
 * 
 * This servlet parses a LSID authority Web Service request, invokes the local authority, and builds and returns
 * the Web Service response. 
 * 
 * @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
 * 
 */
	public class AuthorityServlet : BaseServlet 												  
	{	
		public AuthorityServlet()
		{
		}

		/**
		 * Initialize the authority by instantiating the registered implementation
		 */
		public override void init() 
		{
			base.init();
			try 
			{
				serviceRegistry = ServiceRegistry.getAuthorityServiceRegistry(serviceConfigLocation);
			
			} 
			catch (LSIDServerException e) 
			{
				throw new HttpException(e.getErrorCode(), e.getMessage()); 
			}
		}

		public override void doPost(HttpContext context)
		{	
			try
			{
			SoapEnvelope env = new SoapEnvelope();
			env.LoadXml(getSOAPEnvelope(context.Request.InputStream));
			
			String opName = env.Body.ChildNodes[0].Name;

			if (opName.IndexOf(SoapConstants.GET_WSDL_OP_NAME) != -1)
			{
					LSIDFramework.AuthorityWebService ws = new LSIDFramework.AuthorityWebService(context, GetCredentials(context, env));
				ws.getAvailableServices(env.Body.ChildNodes);			
			}
			else if (opName.IndexOf(SoapConstants.NOTIFY_FOREIGN_AUTHORITY_OP_NAME) != -1)
			{
					LSIDFramework.AuthorityWebService ws = new LSIDFramework.AuthorityWebService(context, GetCredentials(context, env));
				ws.notifyForeignAuthority(env.Body.ChildNodes);
			}
			else if (opName.IndexOf(SoapConstants.REVOKE_NOTIFICATION_FOREIGN_AUTHORITY_OP_NAME) != -1)
			{
					LSIDFramework.AuthorityWebService ws = new LSIDFramework.AuthorityWebService(context, GetCredentials(context, env));
				ws.revokeNotificationForeignAuthority(env.Body.ChildNodes);
			}
			else
			{
				context.Response.Write("Method not supported");
			}
		}
			catch(LSIDException ex)
			{
				ConfigureResponseFromError(context, ex.getErrorCode(), ex.getMessage()); 
			}
			catch(Exception)
			{				
				ConfigureResponseFromError(context, LSIDException.INTERNAL_PROCESSING_ERROR, "LSID Internal Processing Error");
			}
		}

		/**
		 * Handle HTTP GET requests on the authority.  All operations should be done via post.
		 */
		public override void processGet(HttpContext req, LSIDRequestContext rc) 
		{
			if (rc.Lsid == null) 
			{ 
				// output WSDL for this endpoint itself				
				StreamWriter os = null;
				try 
				{
					String host = req.Request.Url.Host;
					int port = req.Request.Url.Port;
					LSID s = null;
					LSIDWSDLWrapper wrapper = new LSIDWSDLWrapper(s);
					wrapper.setAuthorityLocation(new HTTPLocation("AuthorityServiceHTTP","HTTPPort",host,port,null));
					wrapper.setAuthorityLocation(new SOAPLocation("AuthorityServiceSOAP","SOAPPort","http://" +  host + ":" + port + "/authority/"));
					
					req.Response.ContentType = HTTPConstants.XML_CONTENT;
					req.Response.Write(wrapper.ToString());					
				}  
				finally 
				{
					if (os != null)
						os.Close();
				}
			} 
			else 
			{
				Stream os = null;
				try 
				{			
					LSID lsid = rc.Lsid;
					if (lsid == null)
						throw new LSIDServerException(LSIDException.INVALID_METHOD_CALL,"Must specify HTTP Parameter 'lsid'");
					LSIDAuthorityService service = (LSIDAuthorityService)getServiceRegistry(ServiceConfigurationConstants.AUTHORITY_SERVICE_IMPLEMENTATION_REGISTRY).lookupService(lsid);
					if (service == null) 
					{
						throw new LSIDServerException(LSIDException.UNKNOWN_LSID,"LSID Unknown: " + lsid);
					}
					String path = Path.GetDirectoryName(req.Request.Url.AbsolutePath); 
					if (path.Equals(HTTPConstants.HTTP_AUTHORITY_SERVICE_NOTIFY_PATH)) 
					{
						service.notifyForeignAuthority(rc,new LSIDAuthority(req.Request.QueryString.Get(WSDLConstants.AUTHORITY_NAME_PART)));
					} 
					else if (path.Equals(HTTPConstants.HTTP_AUTHORITY_SERVICE_REVOKE_PATH)) 
					{
						service.revokeNotificationForeignAuthority(rc,new LSIDAuthority(req.Request.QueryString.Get(WSDLConstants.AUTHORITY_NAME_PART)));
					} 
					else 
					{
						ExpiringResponse er = service.getAvailableServices(rc);
						String wsdl = (String)er.getValue();
						req.Response.ContentType = HTTPConstants.XML_CONTENT;
						req.Response.Write(wsdl);
					}
				} 
				finally 
				{
					try 
					{
						if (os != null)
							os.Close();
					} 
					catch (IOException e) 
					{
						//LSIDException.PrintStackTrace(e);
						LSIDException.WriteError(e);
					}
				}
			}
		}
		

	}
}
