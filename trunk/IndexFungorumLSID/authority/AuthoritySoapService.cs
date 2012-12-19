using System;
using System.Xml;
using System.Web;
using System.IO;

using Microsoft.Web.Services2;

using LSIDFramework;

namespace AuthorityWebService
{
	/// <summary>
	/// Summary description for AuthoritySoapService.
	/// </summary>
	/// 

	
//	public class AuthoritySoapService : LSIDFramework.AuthorityWebService
//	{			
//		[MIMEExtension()]
//		[Microsoft.Web.Services2.Messaging.SoapMethod("http://www.omg.org/LSID/2003/AuthorityServiceSOAPBindings/getAvailableServices")]			
//		public SoapEnvelope getAvailableServices(SoapEnvelope message)
//		{
//			CurrentSOAPContext = message.Context;
//
//			SoapEnvelope resp = new SoapEnvelope();
//			try
//			{
//				resp.CreateBody();
//				//base.getAvailableServices(message.Body.ChildNodes, resp);
//				
//			}
//			catch (Exception ex)
//			{
//				//todo log error
//				string m = ex.Message;
//			}
//			return resp;
//		}
//		
//		public override void ProcessRequest (HttpContext context) 
//		{
//			CurrentHTTPContext = context;
//			//base.ProcessRequest(context);
//
//			SoapEnvelope env = new SoapEnvelope();
//			env.LoadXml(getSOAPEnvelope(context.Request.InputStream));
//			
//			if (env.Body.InnerXml.IndexOf(SoapConstants.GET_WSDL_OP_NAME) != -1)
//			{
//				base.getAvailableServices(env.Body.ChildNodes);				
//			}
//			else if (env.Body.InnerXml.IndexOf(SoapConstants.GET_METADATA_OP_NAME) != -1)
//			{
//				
//			}
//            		
//		}

		
		
	//}
}
