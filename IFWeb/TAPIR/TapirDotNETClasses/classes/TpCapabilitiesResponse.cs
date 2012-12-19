using System;
using System.Web;

namespace TapirDotNET 
{

	public class TpCapabilitiesResponse:TpResponse
	{
		public TpCapabilitiesResponse(TpRequest request) : base(request)
		{
			TP_STATISTICS_TRACKING = true;
						
			this.mCacheLife = TpConfigManager.TP_CAPABILITIES_CACHE_LIFE_SECS;
			
			base.Init();
		}
		
		
		public override void  Body()
		{
			TpResource resource = this.mRequest.GetResource();
			string file = resource.GetCapabilitiesFile().ToString();
			string error;
			string data = "";

			try
			{
				System.IO.StreamReader rdr = System.IO.File.OpenText(file);
				data = rdr.ReadToEnd();
				rdr.Close();
			}
			catch(Exception )
			{
				error = "Could not open resource capabilities file.";
				this.ReturnError(error);
			}
				
			HttpContext.Current.Response.Write(data);						
			
		}// end of member function Body
	}
}
