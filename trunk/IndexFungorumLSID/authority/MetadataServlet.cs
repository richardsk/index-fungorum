using System;
using System.Web;
using System.IO;
using System.Configuration;

using Microsoft.Web.Services2;
using Microsoft.Web.Services2.Messaging;

using LSIDFramework;
using LSIDClient;

/**
 * 
 * This servlet processes an LSID Meta Data Query Web Service request.
 * 
 * @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
 * 
 */
namespace AuthorityWebService
{
	public class MetadataServlet : BaseServlet 
	{
		/**
		 * Initialize the service by instantiating the registered implementation
		 */
		public override void init() 
		{
			base.init();
			try 
			{
				serviceRegistry = ServiceRegistry.getMetaDataServiceRegistry(serviceConfigLocation);
				LSIDFramework.Global.MetadataRegistry = serviceRegistry;
			} 
			catch (LSIDServerException e) 
			{
				throw new HttpException(e.Message);
			}
		}

		public override void doPost(HttpContext context)
		{			
			try
			{
			SoapEnvelope env = new SoapEnvelope();
			env.LoadXml(getSOAPEnvelope(context.Request.InputStream));

			String opName = env.Body.ChildNodes[0].Name;

			if (opName.IndexOf(SoapConstants.GET_METADATA_OP_NAME) != -1)
			{
					LSIDFramework.MetadataWebService ws = new LSIDFramework.MetadataWebService(context, GetCredentials(context, env));
				ws.getMetadata(env.Body.ChildNodes);				
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
		 * Handle HTTP GET requests on the service.
		 */
		public override void processGet(HttpContext req, LSIDRequestContext rc) 
		{
			/*
			  URLs ending in /metadata parameter "format"
			*/
			LSID lsid = rc.Lsid;
			if (lsid == null)
				throw new LSIDServerException(LSIDException.INVALID_METHOD_CALL,"Must specify HTTP Parameter 'lsid'");
		
			String[] formatsArray = null;
			String format = req.Request.QueryString.Get(WSDLConstants.ACCEPTED_FORMATS_PART);
			if (format != null) 
			{
				formatsArray = format.Split(',');				
			}
			
			Stream result = null;
			MetadataResponse mr = null;
			try 
			{
				LSIDMetadataService service = (LSIDMetadataService)getServiceRegistry(ServiceConfigurationConstants.METADATA_SERVICE_IMPLEMENTATION_REGISTRY).lookupService(lsid);
				if (service == null) 
				{
					throw new LSIDServerException(LSIDException.UNKNOWN_LSID,"LSID Unknown: " + lsid);
				}
				mr = service.getMetadata(rc,formatsArray);
				if (mr != null) 
				{
					DateTime expires = mr.getExpires();
					if (expires != DateTime.MinValue) 
					{
						req.Response.AppendHeader(HTTPConstants.EXPIRES_HEADER, expires.ToString(HTTPConstants.HTTP_DATE_FORMAT));
					}
					req.Response.ContentType = mr.getFormat();
					result = (Stream) mr.getValue();
					if (result != null) 
					{
						StreamReader rdr = new StreamReader(result);
						req.Response.Write(rdr.ReadToEnd());
					}
				}
			} 
			finally 
			{
				try 
				{
					if (result != null)
						result.Close();
				} 
				catch (IOException ex) 
				{
					//LSIDException.PrintStackTrace(ex);
                    LSIDException.WriteError(ex);
				}
			}
		}
	
	}
}
