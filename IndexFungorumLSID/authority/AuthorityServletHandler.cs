using System;
using System.Web;
using System.IO;

namespace AuthorityWebService
{
	/**
	 * Handles all HTTP requests arriving at this authority address.
	 * Determines whether to process as an HTTP GET request or HTTP POST (SOAP) request.
	 * 
	 * * @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
	 */
	public class AuthorityServletHandler : IHttpHandler 
	{    
		public void ProcessRequest (HttpContext context) 
		{
			string path = context.Request.Url.AbsolutePath.ToLower(); 
			if (path.EndsWith("/data/") || path.EndsWith("/data"))
			{
				DataServlet ds = new DataServlet();
				ds.ProcessRequest(context);
			}
			else if (path.EndsWith("/metadata/") || path.EndsWith("/metadata"))
			{
				MetadataServlet ds = new MetadataServlet();
				ds.ProcessRequest(context);
			}
			else if (path.EndsWith("/assigning/") || path.EndsWith("/assigning"))
			{
				AssigningServlet ds = new AssigningServlet();
				ds.ProcessRequest(context);
			}
			else
			{
				AuthorityServlet auth = new AuthorityServlet();
				auth.ProcessRequest(context);
			}

		}
	 
		public bool IsReusable 
		{
			get 
			{
				return true;
			}
		}

	}
}
