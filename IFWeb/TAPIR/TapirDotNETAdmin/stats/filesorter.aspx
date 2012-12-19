
	<%@ Page CodeBehind="filesorter.aspx.cs" Language="c#" AutoEventWireup="false" Inherits="TapirDotNETAdmin.stats.filesorter" %>
<script runat="server" language="c#">
	
		public virtual string getFileMonth(string line)
		{
			string returnValue;
			string month;
			returnValue = false?"1":"";
			month = line.Substring(5, 2);
			//$year = substr( $line, 0, 4 );
			if (System.Convert.ToInt32(new System.Text.RegularExpressions.Regex("/^[0-1][0-9]/").Match(month).Success) == 1)
			{
				returnValue = month;
			}
			return returnValue;
		}
		
		public virtual string getFileYear(string line)
		{
			string returnValue;
			string year;
			returnValue = false?"1":"";
			year = line.Substring(0, 4);
			if (System.Convert.ToInt32(new System.Text.RegularExpressions.Regex("/^[0-9]{4}/").Match(year).Success) == 1)
			{
				returnValue = year;
			}
			return returnValue;
		}
		
		public virtual int compareFileNames(int file1, object file2)
		{
			//BUGBUG not perfect. assume file 1 is good
			//could be more effecient
			int returnValue;
			string year1;
			string year2;
			string month1;
			string month2;
			int yearResult;
			int monthResult;
			returnValue = file1;
			year1 = getFileYear(file1.ToString());
			year2 = getFileYear(Utility.TypeSupport.ToString(file2));
			
			month1 = getFileMonth(file1.ToString());
			month2 = getFileMonth(Utility.TypeSupport.ToString(file2));
			
			if (month1 != (false?"1":"") && year1 != (false?"1":"") && month2 != (false?"1":"") && year2 != (false?"1":""))
			{
				yearResult = Utility.StringSupport.StringCompare(year1, year2, true);
				monthResult = Utility.StringSupport.StringCompare(month1, month2, true);
				
				if (yearResult < 0)
				{
					returnValue = - 1;
				}
				else if (yearResult > 0)
				{
					returnValue = 1;
				}
				else
				{
					if (monthResult <= 0)
					{
						returnValue = - 1;
					}
					else
					{
						returnValue = 1;
					}
				}
			}
			return returnValue;
		}
		
		public virtual Utility.OrderedMap getAvailableYears(Utility.OrderedMap logFileNames)
		{
			Utility.OrderedMap availableYears = new Utility.OrderedMap();
			string key;
			availableYears = new Utility.OrderedMap();
			foreach ( object lfn in logFileNames.Values ) {
				// check to see if the filenames is yyyy_mm.tbl format
				if (System.Convert.ToInt32(new System.Text.RegularExpressions.Regex("/^[0-9]{4}_[0-1][0-9]\\.tbl$/").Match(lfn).Success) == 1)
				{
					//make unique. array_unique is error prone so just keep restting value.
					key = Utility.TypeSupport.ToString(lfn).Substring(0, 4);
					availableYears[key] = key;
				}
			}
			
			return availableYears;
		}
		
		public virtual Utility.OrderedMap getAvailableMonthsForYear(Utility.OrderedMap logFileNames, string year)
		{
			Utility.OrderedMap availableMonths = new Utility.OrderedMap();
			int count;
			string regexString;
			availableMonths = new Utility.OrderedMap();
			count = 0;
			regexString = "/^" + year + "_[0-1][0-9]\\.tbl$/";
			foreach ( object lfn in logFileNames.Values ) {
				// check to see if the filenames is yyyy_mm.tbl format
				if (System.Convert.ToInt32(new System.Text.RegularExpressions.Regex(regexString).Match(lfn).Success) == 1)
				{
					availableMonths[count] = lfn;
					count++;
				}
			}
			
			Utility.OrderedMap.Unique(availableMonths);
			return availableMonths;
		}
		
		public virtual void  getLogArray(ref Utility.OrderedMap logFiles, ref Utility.OrderedMap cachedMonthsFiles)
		{
			int i;
			System.IO.DirectoryInfo logDir;
			string file;
			Utility.OrderedMap logNames = new Utility.OrderedMap();
			Utility.OrderedMap statsFiles = new Utility.OrderedMap();
			int j;
			i = 0;
			if (Utility.TypeSupport.ToBoolean(logDir = Utility.DirectorySupport.OpenDirectory(TP_STATISTICS_DIR)))
			{
				// reading the log dir for all files
				while (!((false?"1":"") == (file = Utility.DirectorySupport.ReadDirectory(logDir))) || !(false.GetType() == (file = Utility.DirectorySupport.ReadDirectory(logDir)).GetType()))
				{
					// CHECK NUMBER ONE
					if (file != "." && file != "..")
					{
						//if the file is not . or .. and is 11 chars long
						// stick the filename in the array
						logNames[i] = file;
						i++;
					}
				}
				
				closedir(logDir);
			}
			// END OF CHECK ONE
			
			// CHECK NUMBER TWO
			statsFiles = new Utility.OrderedMap();
			j = 0;
			foreach ( object b in logNames.Values ) {
				// check to see if the filenames is yyyy_mm.tbl format
				if (System.Convert.ToInt32(new System.Text.RegularExpressions.Regex("/^[0-9]{4}_[0-1][0-9]\\.tbl$/").Match(b).Success) == 1)
				{
					statsFiles[j] = b;
					j++;
				}
			}
			
			//END OF CHECK TWO
			//BUGBUG uneeded copy
			logFiles = statsFiles;
			//get the suckers into ascending order
			Utility.OrderedMap.SortValueUser(ref logFiles, "compareFileNames", this);
			
			statsFiles = new Utility.OrderedMap();
			j = 0;
			foreach ( object b in logNames.Values ) {
				// check to see if the filenames is yyyy_mm.tbl format
				if (System.Convert.ToInt32(new System.Text.RegularExpressions.Regex("/^[0-9]{4}_[0-1][0-9]\\.html$/").Match(b).Success) == 1)
				{
					statsFiles[j] = b;
					j++;
				}
			}
			
			//END OF CHECK TWO
			cachedMonthsFiles = statsFiles;
			//get the suckers into ascending order
			Utility.OrderedMap.SortValueUser(ref cachedMonthsFiles, "compareFileNames", this);
		}
	</script>
	
	