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
 * This servlet processes an LSID Data Service request.
 * 
 * @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
 * 
 */
namespace AuthorityWebService
{
	public class DataServlet : BaseServlet 
	{	
		/**
		 * Initialize the service by instantiating the registered implementation
		 */
		public override void init() 
		{
			base.init();
			try 
			{
				serviceRegistry = ServiceRegistry.getDataServiceRegistry(serviceConfigLocation);
				LSIDFramework.Global.DataRegistry = serviceRegistry;
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

			if (opName.IndexOf(SoapConstants.GET_DATA_OP_NAME) != -1)
			{
					LSIDFramework.DataWebService ws = new LSIDFramework.DataWebService(context, GetCredentials(context, env));
				ws.getData(env.Body.ChildNodes);								
			}
			else if (opName.IndexOf(SoapConstants.GET_DATA_BY_RANGE_OP_NAME) != -1)
			{
					LSIDFramework.DataWebService ws = new DataWebService(context, GetCredentials(context, env));
				ws.getDataByRange(env.Body.ChildNodes);
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
		 * Handle HTTP GET requests for data
		 *
		 */
		public override void processGet(HttpContext req, LSIDRequestContext rc) 
		{
			Stream data = null;
			try 
			{
				LSID lsid = rc.Lsid;
				if (lsid == null)
					throw new LSIDServerException(LSIDException.INVALID_METHOD_CALL,"Must specify HTTP Parameter 'lsid'");
				LSIDDataService service = (LSIDDataService)getServiceRegistry(ServiceConfigurationConstants.DATA_SERVICE_IMPLEMENTATION_REGISTRY).lookupService(lsid);
				if (service == null) 
				{
					throw new LSIDServerException(LSIDException.UNKNOWN_LSID,"LSID Unknown: " + lsid);
				}
				// we support app level chunked transfer through HTTP GET, though in practice, this functionality should be 
				// achieved through protocol level support in the appserver.
				String startStr = req.Request.QueryString.Get(WSDLConstants.START_PART);
				String lengthStr = req.Request.QueryString.Get(WSDLConstants.LENGTH_PART); 
				if (startStr != null && lengthStr != null) 
				{
					int start = int.Parse(startStr);
					int length = int.Parse(lengthStr);
					data = service.getDataByRange(rc,start,length);
				} 
				else data = service.getData(rc);
			
				req.Response.ContentType = "application/octet-stream";
			
				StreamReader rdr = new StreamReader(data);
				char[] b = new char[1];
				while (rdr.Read(b, 0, 1) != 0)
				{
					req.Response.Write(b, 0, 1);	
				}
			
			} 
			finally 
			{
				try
				{
					if (data != null) data.Close();
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
