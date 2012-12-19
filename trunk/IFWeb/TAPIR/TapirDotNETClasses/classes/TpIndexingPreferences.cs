namespace TapirDotNET 
{

	public class TpIndexingPreferences
	{
		public string mStartTime;
		public string mMaxDuration;
		public string mFrequency;
		
		public virtual void  IndexingPreferences()
		{
			
		}// end of member function IndexingPreferences
		
		public virtual void  LoadDefaults()
		{
			this.mStartTime = "";
			this.mMaxDuration = "";
			this.mFrequency = "";
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			string hour = TpUtils.GetVar("hour", "").ToString();
			string ampm = TpUtils.GetVar("ampm", "").ToString();
			
			if (hour.Length == 0 || ampm.Length == 0)
			{
				this.mStartTime = "";
			}
			else
			{
				if (ampm == "AM")
				{
					if (Utility.TypeSupport.ToInt32(hour) == 12)
					{
						hour = "24";
					}
				}
				else if (ampm == "PM")
				{
					if (Utility.TypeSupport.ToInt32(hour) > 12)
					{
						hour = (Utility.TypeSupport.ToDouble(hour) + 12).ToString();
					}
				}
				
				this.mStartTime = hour + ":00:00" + (TpUtils.GetVar("timezone", ""));
			}
			
			this.mMaxDuration = TpUtils.GetVar("maxDuration", "").ToString();
			this.mFrequency = TpUtils.GetVar("frequency", "").ToString();
		}// end of member function LoadFromSession
		
		public virtual string GetStartTime()
		{
			return this.mStartTime;
		}// end of member function GetStartTime
		
		public virtual void  SetStartTime(string startTime)
		{
			this.mStartTime = startTime;
		}// end of member function SetStartTime
		
		public virtual Utility.OrderedMap ParseTime()
		{
			Utility.OrderedMap matches;
			matches = new Utility.OrderedMap();
			
			Utility.RegExPerlSupport.Match("^(\\d{2}):(\\d{2}):(\\d{2})(GMT[\\+\\-]?\\d{1,2})$", this.mStartTime, ref matches, -1);
			//"/^(\\d{2}):\\d{2}:\\d{2}(GMT[\\+\\-]?\\d{1,2})$/i", this.mStartTime, ref matches, - 1);
			
			return matches;
		}// end of member function ParseTime
		
		public virtual string GetHour()
		{
			Utility.OrderedMap matches;
			string hour;
			matches = this.ParseTime();
			
			hour = "";
			
			if (Utility.OrderedMap.CountElements(matches) > 0)
			{
				if (matches[1].ToString().Substring(1, 1) == "0")
				{
					hour = matches[1].ToString().Substring(1, 2);
				}
				else
				{
					hour = matches[1].ToString().Substring(0, 2);
				}
				
				if (Utility.TypeSupport.ToInt32(hour) > 12)
				{
					hour = (Utility.TypeSupport.ToInt32(hour) - 12).ToString();
				}
			}
			
			return hour;
		}// end of member function GetHour
		
		public virtual string GetAmPm()
		{
			Utility.OrderedMap matches;
			matches = this.ParseTime();
			
			if (Utility.OrderedMap.CountElements(matches) > 0)
			{
				if (Utility.TypeSupport.ToInt32(matches[1]) >= 12 && Utility.TypeSupport.ToInt32(matches[1]) < 24)
				{
					return "PM";
				}
				else
				{
					return "AM";
				}
			}
			
			return "";
		}// end of member function GetAmPm
		
		public virtual string GetTimezone()
		{
			Utility.OrderedMap matches;
			matches = this.ParseTime();
			
			if (Utility.OrderedMap.CountElements(matches) > 0)
			{
				return matches[4].ToString();
			}
			
			return "";
		}// end of member function GetTimezone
		
		public virtual string GetMaxDuration()
		{
			return this.mMaxDuration;
		}// end of member function GetMaxDuration
		
		public virtual void  SetMaxDuration(string maxDuration)
		{
			this.mMaxDuration = maxDuration;
		}// end of member function SetMaxDuration
		
		public virtual string GetFrequency()
		{
			return this.mFrequency;
		}// end of member function GetFrequency
		
		public virtual void  SetFrequency(string frequency)
		{
			this.mFrequency = frequency;
		}// end of member function SetFrequency
		
		public virtual string GetXml(string offset, string indentWith)
		{
			string xml;
			xml = "";
			
			if (this.GetStartTime().Length > 0 || this.GetMaxDuration().Length > 0 || this.GetFrequency().Length > 0)
			{
				xml += string.Format("{0}<indexingPreferences startTime=\"{1}\" maxDuration=\"{2}\" frequency=\"{3}\"/>", offset, TpUtils.EscapeXmlSpecialChars(this.GetStartTime()), TpUtils.EscapeXmlSpecialChars(this.GetMaxDuration()), TpUtils.EscapeXmlSpecialChars(this.GetFrequency()));
				xml += "\n";
			}
			
			return xml;
		}// end of member function GetXml
	}
}
