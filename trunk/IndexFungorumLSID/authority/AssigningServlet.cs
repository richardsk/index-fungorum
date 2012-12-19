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
	 * This servlet processes an LSID Assigning Service request.
	 * 
	 * @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
	 * 
	 */
	public class AssigningServlet : BaseServlet 
	{
		/**
		 * Initialize the service by instantiating the registered implementation
		 */
		public new void init()
		{
			base.init();
			try 
			{
				serviceRegistry = ServiceRegistry.getAssigningServiceRegistry(serviceConfigLocation);
				LSIDFramework.Global.AssigningRegistry = serviceRegistry;
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
			
			string opName = env.Body.ChildNodes[0].Name;
			if (opName.IndexOf(":") != -1) opName = opName.Substring(opName.IndexOf(":")+1);

			if (opName == SoapConstants.ASSIGN_LSID_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.assignLSID(env.Body.ChildNodes);
			}
			else if (opName == SoapConstants.ASSIGN_LSID_FROM_LIST_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.assignLSIDFromList(env.Body.ChildNodes);
			}
			else if (opName == SoapConstants.ASSIGN_LSID_FOR_NEW_REVISION_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.assignLSIDForNewRevision(env.Body.ChildNodes);
			}
			else if (opName == SoapConstants.GET_LSID_PATTERN_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.getLSIDPattern(env.Body.ChildNodes);
			}
			else if (opName == SoapConstants.GET_LSID_PATTERN_FROM_LIST_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.getLSIDPatternFromList(env.Body.ChildNodes);
			}
			else if (opName == SoapConstants.GET_ALLOWED_PROPERTY_NAMES_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.getAllowedPropertyNames(env.Body.ChildNodes);
			}
			else if (opName == SoapConstants.GET_AUTHORITIES_AND_NAMESPACES_OP_NAME)
			{
					LSIDFramework.AssigningWebService ws = new AssigningWebService(context, GetCredentials(context, env));
				ws.getAuthoritiesAndNamespaces(env.Body.ChildNodes); 
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
			catch(Exception ex)
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
			req.Response.Write("LSID Assigning Service not available over HTTP Get\n");						
		}

	
	}
}
