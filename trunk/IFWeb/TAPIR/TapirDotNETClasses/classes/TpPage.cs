using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TapirDotNET.Controls
{

	public class TpPage : UserControl
	{
		public string mMessage;
					
		public virtual void  SetMessage(string msg)
		{
			this.mMessage = msg;
		}// end of member function SetMessage
		
		
		public virtual string GetScroll()
		{
			return TpUtils.GetVar("scroll", "").ToString();
		}// end of member function GetScroll

	}
}
