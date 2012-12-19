using System;
using System.Web;

namespace TapirDotNET 
{

	public class TpPingResponse:TpResponse
	{
		
		public TpPingResponse(TpRequest request) : base(request)
		{
			TP_STATISTICS_TRACKING = true;
			
			this.mCacheable = false;
			
			base.Init();
		}
		
		
		public override void  Body()
		{
			HttpContext.Current.Response.Write("\n<pong/>");
		}// end of member function Body
	}
}
