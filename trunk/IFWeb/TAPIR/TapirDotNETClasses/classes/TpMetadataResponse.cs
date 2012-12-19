using System;
using System.IO;
using System.Web;

namespace TapirDotNET 
{

	public class TpMetadataResponse : TpResponse
	{
		
		public TpMetadataResponse(TpRequest request) : base(request)
		{
			TP_STATISTICS_TRACKING = true;

			TpXmlNamespace dc_ns;
			TpXmlNamespace dct_ns;
			TpXmlNamespace vcard_ns;
			TpXmlNamespace geo_ns;
			if (TpConfigManager.TP_SKIN != null)
			{
				this.mDefaultXslt = "skins/" + TpConfigManager.TP_SKIN + "/metadata.xsl";
			}
						
			this.mCacheLife = TpConfigManager.TP_METADATA_CACHE_LIFE_SECS;
			
			dc_ns = new TpXmlNamespace("http://purl.org/dc/elements/1.1/", TpConfigManager.TP_DC_PREFIX, "");
			this.AddXmlNamespace(dc_ns);
			
			dct_ns = new TpXmlNamespace("http://purl.org/dc/terms/", TpConfigManager.TP_DCT_PREFIX, "");
			this.AddXmlNamespace(dct_ns);
			
			vcard_ns = new TpXmlNamespace("http://www.w3.org/2001/vcard-rdf/3.0#", TpConfigManager.TP_VCARD_PREFIX, "");
			this.AddXmlNamespace(vcard_ns);
			
			geo_ns = new TpXmlNamespace("http://www.w3.org/2003/01/geo/wgs84_pos#", TpConfigManager.TP_GEO_PREFIX, "");
			this.AddXmlNamespace(geo_ns);
			
			base.Init();
		}
		
		
		public override void  Body()
		{
			// Note: don't change this to $r_resource because this variable is used 
			//       in the automatically generated metadata templates! 
			TpResource resource = this.mRequest.GetResource();
			TpSettings r_settings = resource.GetSettings();
			string config_file = resource.GetConfigFile();
			string date_last_modified;
			string error;
									
			r_settings.LoadFromXml(config_file, "", false);
			
			date_last_modified = resource.GetDateLastModified();
	        
			HttpContext.Current.Response.Write("\n");
			
			try
			{
				StreamReader rdr = File.OpenText(resource.GetMetadataFile());
				string md = rdr.ReadToEnd();
				rdr.Close();

				md = md.Replace("[LAST_MODIFIED_DATE]", date_last_modified);
				md = md.Replace("[ACCESS_POINT]", resource.GetAccesspoint());

				HttpContext.Current.Response.Write(md);
			}
			catch(Exception)
			{
				error = "Could not open resource metadata file.";
				this.ReturnError(error);
			}
		}// end of member function Body
	}
}
