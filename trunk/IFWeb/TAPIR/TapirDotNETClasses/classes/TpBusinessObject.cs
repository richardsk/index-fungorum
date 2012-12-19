using System.Web;

namespace TapirDotNET 
{

	public class TpBusinessObject
	{
		public TpBusinessObject()
		{
			
		}
		
		
		public virtual void  LoadLangElementFromSession(string id, Utility.OrderedMap rProperty)
		{
			int cnt = 1;
			
			while (TpUtils.FindVar(id + "_" + cnt.ToString(), null) != null && cnt != 31)
			{
				string value_Renamed = TpUtils.FindVar(id + "_" + cnt, "").ToString();
				string lang = TpUtils.FindVar(id + "_lang_" + cnt.ToString(), "").ToString();
				
				if (TpUtils.FindVar("del_" + id + "_" + cnt.ToString(), null) == null)
				{
					rProperty.Push(new TpLangString(value_Renamed, lang));
				}
				++cnt;
			}
			if (HttpContext.Current.Request.Form["add_" + id] != null)
			{
				rProperty.Push(new TpLangString("", ""));
			}
		}// end of member function LoadLangElement
	}
}
