using System;
using System.Collections;

namespace TapirDotNET
{
	/// <summary>
	/// Summary description for TpOptions.
	/// </summary>
	public class TpOptions
	{
		private static Hashtable settings = new Hashtable();

		public static object GetSetting(object setting)
		{
			if (settings.ContainsKey(setting.ToString())) return settings[setting.ToString()];
			return null;
		}

		public static void SetSetting(object setting, object val)
		{
			if (settings.ContainsKey(setting.ToString())) settings[setting.ToString()] = val;
			else settings.Add(setting.ToString(), val);
		}
	}
}
