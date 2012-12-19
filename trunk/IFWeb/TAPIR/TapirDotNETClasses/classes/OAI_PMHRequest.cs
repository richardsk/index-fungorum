using System;
using System.Web;
using System.IO;
using System.Net;

namespace TapirDotNET
{
	/// <summary>
	/// Summary description for OAI_PMHRequest.
	/// </summary>
	public class OAI_PMHRequest
	{
		public static void HandleOAIPMHRequest()
		{
			string verb = HttpContext.Current.Request["verb"];

			string id = HttpContext.Current.Request["identifier"];
			string body = "";

			if (verb == "GetRecord")
			{
				StreamReader rdr = new StreamReader(TpConfigManager.TP_OAIPMH_DIR + "\\oai_GetRecord_call.tmpl");
				body = rdr.ReadToEnd();
				rdr.Close();

				body = body.Replace("[OAIPMH_IDENTIFIER]", id);
			}
			else if (verb == "ListIdentifiers")
			{
				StreamReader rdr = new StreamReader(TpConfigManager.TP_OAIPMH_DIR + "\\oai_ListIdentifiers_call.tmpl");
				body = rdr.ReadToEnd();
				rdr.Close();				
			}
			else if (verb == "ListMetadataFormats")
			{
				StreamReader rdr = new StreamReader(TpConfigManager.TP_OAIPMH_DIR + "\\oai_ListMetadataFormats_call.tmpl");
				body = rdr.ReadToEnd();
				rdr.Close();
			}

			string dsa = HttpContext.Current.Request.Params["dsa"];
			
			string url = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + HttpContext.Current.Request.Path + "/" + dsa;

			WebRequest http_request = WebRequest.Create(url);
			http_request.Method = "POST";
			http_request.ContentType = "text/xml";					
			Byte[] b = System.Text.Encoding.UTF8.GetBytes(body);
			http_request.ContentLength = b.Length;

			Stream s = http_request.GetRequestStream();
			s.Write(b, 0, b.Length);	
			s.Close();
			s.Flush();

			WebResponse res = http_request.GetResponse();
			
			StreamReader respRdr = new StreamReader(res.GetResponseStream());

			string result = respRdr.ReadToEnd();
			respRdr.Close();
			
			HttpContext.Current.Response.ContentType = "text/xml";
			HttpContext.Current.Response.Write(result);	
			HttpContext.Current.Response.Flush();
		}
	}

}
