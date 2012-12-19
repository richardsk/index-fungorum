using System;
using System.Text;

namespace TapirDotNET 
{

	public class TpServiceUtils
	{
		 /**
		* Converts an associative array into a string to be used in the log.
		*
		* @param $data array Data to be logged.
		* @return string Log formatted string.
		*/
		public static string GetLogString(Utility.OrderedMap data)
		{
			string spacer;
			string log_str;
			string log_value;
			spacer = "\t";
			
			log_str = "";
			
			foreach ( string key in data.Keys ) 
			{
				object value_Renamed = data[key];
				if (Utility.VariableSupport.IsNumeric(value_Renamed))
				{
					log_value = value_Renamed.ToString();
				}
				else if (value_Renamed is System.Boolean)
				{
					log_value = (Utility.TypeSupport.ToBoolean(value_Renamed) == false)?"false":"true";
				}
				else if (value_Renamed == null)
				{
					log_value = "NULL";
				}
				else
				{
					log_value = value_Renamed.ToString().Replace("\t", "").Replace("\n", "");
				}
				
				log_str += spacer + key + "=" + log_value;
			}
			
			
			return log_str;
		}// end of GetLogString
		
		 /**
		* Converts a SQL statement to the current database charset encoding
		* (if different from UTF-8).
		*
		* @param $sql string SQL statement.
		* @param $encoding string Database charset encoding.
		* @return string SQL statement to be sent to database
		*/
		public static string EncodeSql(string sql, string encoding)
		{
			if (string.Compare(encoding, "UTF-8", true) == 0)
			{
				sql = Encoding.GetEncoding(encoding).GetString(UTF8Encoding.UTF8.GetBytes(sql));				
			}
			
			return sql;
		}// end of EncodeSql
		
		public static string EncodeData(string data, string encoding)
		{
			if (data == "")
			{
				return null;
			}
			
			// If data encoding is different from UTF-8 convert values to UTF-8
			if (Utility.StringSupport.StringCompare(encoding, "UTF-8", false) != 0)
			{
				data = UTF8Encoding.UTF8.GetString(Encoding.GetEncoding(encoding).GetBytes(data));
			}
			
			return TpUtils.EscapeXmlSpecialChars(data);
		}// end of member function EncodeData
		
		 /**
		*
		* @param $path1 string haystack.
		* @param $path2 string needle.
		* @return boolean True if haystack contains needle
		*/
		public static bool Contains(string rPath1, string rPath2)
		{
			int size;
			size = rPath2.Length;
			
			if (rPath1.Length >= size)
			{
				if (rPath1.Substring(0, size) == rPath2)
				{
					return true;
				}
			}
			
			return false;
		}// end of member function Contains
	}
}
