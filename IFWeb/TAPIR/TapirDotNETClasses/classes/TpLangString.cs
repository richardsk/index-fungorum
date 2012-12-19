namespace TapirDotNET 
{

	public class TpLangString
	{
		public string mValue;
		public string mLang;
		
		public TpLangString(string value_Renamed, string lang)
		{
			this.mValue = value_Renamed;
			this.mLang = lang;
		}
		
		
		public virtual string GetValue()
		{
			return this.mValue;
		}// end of member function GetValue
		
		public virtual string GetLang()
		{
			return this.mLang;
		}// end of member function GetLang
	}
}
