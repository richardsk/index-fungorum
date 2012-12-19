using System;
using System.Web;

namespace TapirDotNET 
{

	public class TpUtils
	{
		
		/** Get value from post/get environment variables or return a default
		*
		* @param string name Parameter name
		* @param mixed defaultVal Default value to be used if parameter was not passed
		*
		* @return mixed Parameter value
		*/
		public static object GetVar(string name, object defaultVal)
		{
			object val = HttpContext.Current.Session[name];
			if (val == null) val = HttpContext.Current.Request.Form[name];
			if (val == null) val = HttpContext.Current.Request.QueryString[name];
			return (val != null) ? val : defaultVal;
		}// end of GetVar

		//Finds a var starting or ending with the likeName
		public static object FindVar(string likeName, object defaultVal)
		{
			object val = null;
			foreach (string key in HttpContext.Current.Request.Params.AllKeys)
			{
				if (key.StartsWith(likeName) || key.EndsWith(likeName))
				{
					val = HttpContext.Current.Request.Params[key];
					break;
				}
			}

			if (val == null)
			{
				foreach (string key in HttpContext.Current.Session.Keys)
				{
					if (key.StartsWith(likeName) || key.EndsWith(likeName))
					{
						val = HttpContext.Current.Session[key];
						break;
					}
				}
			}

			return (val != null) ? val : defaultVal;
		}
		
		 /** Get value from array using case insensitive comparison with a given key
		*
		* @param array targetArray Array to search for key
		* @param string searchKey Key to be searched
		* @param mixed defaultVal Default value to be used if key is not present
		*
		* @return mixed Key value (if found) or default value
		*/
		public static object GetInArray(Utility.OrderedMap targetArray, string searchKey, object defaultVal)
		{
			foreach ( string key in targetArray.Keys ) 
			{
				object value_Renamed = targetArray[key];
				if (Utility.StringSupport.StringCompare(searchKey, key, false) == 0)
				{
					return value_Renamed;
				}
			}
						
			return defaultVal;
		}
		
		 /**
		* Returns the unqualified name from a 'namespace:name' string.
		*/
		public static string GetUnqualifiedName(string fullName)
		{
			int last_colon = fullName.LastIndexOf(":");
			
			if (last_colon == -1)
			{				
				return fullName;
			}
			
			return fullName.Substring(last_colon + 1);
		}// end of GetUnqualifiedName
		
		 /**
		* Simple check to determine if the supplied string is a URL
		*
		* @param string tst String to test
		*
		* returns TRUE or FALSE
		*/
		public static bool IsUrl(string tst)
		{			
			//simple check to see if a string is a URL.
			//just looks at the first few characters to see if the scheme is http or ftp

			if (tst == null) return false;

			int min = tst.Length;
			if (min > 8) min = 8;
			
			tst = tst.ToLower();
			
			if (tst.IndexOf("http://") == 0)
			{
				return true;
			}
			else if (tst.IndexOf("ftp://") == 0)
			{
				return true;
			}
			else if (tst.IndexOf("file://") == 0)
			{
				return true;
			}
			
			return false;
		}// end of IsUrl
		
		 /** Strip slashes from strings and array elements
		*
		* @param string or array reference
		*/
		public static void  StripMagicSlashes(object rVar)
		{
			if (rVar is System.String)
			{
				rVar = Utility.StringSupport.RemoveSlashes(rVar.ToString());
			}
			else if (rVar is Utility.OrderedMap)
			{
				Utility.OrderedMap ar = new Utility.OrderedMap(rVar);
				foreach ( string key in ar.Keys ) 
				{
					object value_Renamed = ar[key];
					StripMagicSlashes(value_Renamed);
				}
				
			}
		}// end of StripMagicSlashes
		
		 /**
		* Escapes XML special chars in a string
		*
		* @param $s string String to be escaped (assumed to be in utf-8)
		* @return string Escaped string
		*/
		public static string EscapeXmlSpecialChars(string s)
		{
			//TODO correct?
			return System.Web.HttpUtility.HtmlEncode(s);					
		}// end of EscapeXmlSpecialChars
		
		 /**
		* Returns current time measured in the number of seconds since the Unix
		* Epoch (0:00:00 January 1, 1970 GMT) including microseconds.
		*
		* @return float number of seconds with microseconds since the Unix Epoch
		*/
		public static double MicrotimeFloat()
		{
			object usec;
			object sec;
			Utility.OrderedMap generatedAux;
			generatedAux = new Utility.OrderedMap(Utility.DateTimeSupport.Microtime().Split(" ".ToCharArray()));
			usec = generatedAux[0];
			sec = generatedAux[1];
			
			return (Utility.TypeSupport.ToDouble(usec) + Utility.TypeSupport.ToDouble(sec));
		}// end of MicrotimeFloat
		
		 /**
		* Returns an xsd:dateTime value from a timestamp.
		* xsd:dateTime values follow this rule: [-]CCYY-MM-DDThh:mm:ss[Z|(+|-)hh:mm]
		*
		* @return string xsd:dateTime
		*/
		public static string TimestampToXsdDateTime(DateTime timestamp)
		{
			string date;
			string time;
			string time_zone;
			
			return timestamp.ToString("yyyy-MM-ddThh:mm:ss"); 

				//Utility.DateTimeSupport.NewDateTime(timestamp).ToString("yyyy-MM-ddThh:mm:ss"); //EEE, d MMM yyyy HH:mm:ss:SSS");

			//TODO ??
			/*

			date = Utility.DateTimeSupport.NewDateTime(timestamp).ToString("%Y-%m-%d");
						
			if (System.Environment.OSVersion.ToString().Substring(0, 3).ToUpper() == "WIN")
			{
				time = Utility.DateTimeSupport.NewDateTime(timestamp).ToString("%X");
			}
			else
			{
				time = Utility.DateTimeSupport.NewDateTime(timestamp).ToString("%T");
			}
			
			time_zone = Utility.DateTimeSupport.NewDateTime(timestamp).ToString("%z");
			
			if (new System.Text.RegularExpressions.Regex("/^[+-]{1}\\d{4}$/").Match(time_zone).Success)
			{
				time_zone = time_zone.Substring(0, 3) + ":" + time_zone.Substring(3);
			}
			else
			{
				time_zone = "";
			}
			
			return date + "T" + time + time_zone;*/
		}// end of TimestampToXsdDateTime
		
		 /**
		* Returns this script URL
		*/
		public static string GetServiceId()
		{
			string sn;
			string sp;
			string ss;
			string s;
			
			sn = (HttpContext.Current.Request.ServerVariables["SERVER_NAME"] != null)?Utility.TypeSupport.ToString(HttpContext.Current.Request.ServerVariables["SERVER_NAME"]):"localhost";
			
			sp = (HttpContext.Current.Request.ServerVariables["SERVER_PORT"] != null)?Utility.TypeSupport.ToString(HttpContext.Current.Request.ServerVariables["SERVER_PORT"]):"80";
			
			ss = (HttpContext.Current.Request.CurrentExecutionFilePath != null)?Utility.TypeSupport.ToString(HttpContext.Current.Request.CurrentExecutionFilePath):"/tapir.aspx";
			
			s = "http://" + sn + ":" + sp + ss;
			
			return s;
		}
		
		 /** Simple function that returns a hash out of a simple array
		*  using each array value as both the key and the value of the hash.
		*
		* @param array elements
		*
		* @return hash
		*/
		public static Utility.OrderedMap GetHash(Utility.OrderedMap elements)
		{
			Utility.OrderedMap ret_array = new Utility.OrderedMap();
						
			foreach ( object value_Renamed in elements.Values ) 
			{
				ret_array[value_Renamed] = value_Renamed;
			}
			
			
			return ret_array;
		}// end of GetHash
		
		 /**
		* Returns an opening XML tag for the specified element.
		*
		* @param string $nsPrefix Namespace prefix.
		* @param string $elementName Element name.
		* @param string $indent Optional indentation characters.
		* @param array $attrs Optional array with key value pairs to be added as attributes.
		* @return string An opening tag for the specified element
		*/
		public static string OpenTag(string nsPrefix, object elementName, string indent, Utility.OrderedMap attrs)
		{
			string ns_sep;
			string xml_attrs;
			ns_sep = (Utility.VariableSupport.Empty(nsPrefix))? "" : ":";
			
			xml_attrs = "";
			
			if (Utility.OrderedMap.CountElements(attrs) > 0)
			{
				foreach ( string attr_key in attrs.Keys ) 
				{
					object attr_value = attrs[attr_key];
					xml_attrs += " " + attr_key + "=\"" + attr_value.ToString() + "\"";
				}
				
			}
			
			return string.Format("{0}<{1}{2}{3}{4}>\r\n", indent, nsPrefix, ns_sep, elementName, xml_attrs);
		}// end of OpenTag
		
		 /**
		* Returns a closing XML tag for the specified element.
		*
		* @param string $nsPrefix Namespace prefix.
		* @param string $elementName Element name.
		* @param string $indent Optional indentation characters.
		* @return string A closing tag for the specified element
		*/
		public static string CloseTag(string nsPrefix, object elementName, string indent)
		{
			string ns_sep;
			ns_sep = (Utility.VariableSupport.Empty(nsPrefix))? "" : ":";
			
			return string.Format("{0}</{1}{2}{3}>\r\n", indent, nsPrefix, ns_sep, elementName);
		}// end of CloseTag
		
		 /**
		* Returns an XML tag enclosing the specified value.
		*
		* @param string $nsPrefix Namespace prefix.
		* @param string $elementName Element name.
		* @param string $value Element value.
		* @param string $indent Optional indentation characters.
		* @param array $attrs Optional array with key value pairs to be added as attributes.
		* @return string Value (with XML characters escaped) enclosed by the element
		*/
		public static string MakeTag(string nsPrefix, object elementName, string value_Renamed, string indent, Utility.OrderedMap attrs)
		{
			string ns_sep;
			string xml_attrs;
			string s;
			ns_sep = (Utility.VariableSupport.Empty(nsPrefix))? "" : ":";
			
			xml_attrs = "";
			
			if (Utility.OrderedMap.CountElements(attrs) > 0)
			{
				foreach ( string attr_key in attrs.Keys ) 
				{
					object attr_value = attrs[attr_key];
					xml_attrs = " " + attr_key + "=\"" + attr_value.ToString() + "\"";
				}
				
			}
			
			s = string.Format("{0}<{1}{2}{3}{4}>", indent, nsPrefix, ns_sep, elementName, xml_attrs);
			s += EscapeXmlSpecialChars(value_Renamed);
			s += string.Format("</{0}{1}{2}>\r\n", nsPrefix, ns_sep, elementName);
			
			return s;
		}// end of MakeTag
		
		 /**
		* Returns an XML tag enclosing the specified value and having an xml:lang attribute.
		*
		* @param string $nsPrefix Namespace prefix.
		* @param string $elementName Element name.
		* @param string $value Element value.
		* @param string $lang Language code.
		* @param string $indent Optional indentation characters.
		* @return string Value (with XML characters escaped) enclosed by the specified
		*                element with a lang attribute
		*/
		public static string MakeLangTag(string nsPrefix, string elementName, string value_Renamed, string lang, string indent)
		{
			string ns_sep;
			string s;
			ns_sep = (Utility.VariableSupport.Empty(nsPrefix))? "" : ":";
			
			if (lang != null && lang.Length > 0)
			{
				s = string.Format("{0}<{1}{2}{3} {4}:lang=\"{5}\">", indent, nsPrefix, ns_sep, elementName, TpConfigManager.TP_XML_PREFIX, lang);
			}
			else
			{
				s = string.Format("{0}<{1}{2}{3}>", indent, nsPrefix, ns_sep, elementName);
			}
			
			s += EscapeXmlSpecialChars(value_Renamed);
			s += string.Format("</{0}{1}{2}>\n", nsPrefix, ns_sep, elementName);
			
			return s;
		}// end of MakeLangTag
		
		 /** Returns a default XML header
		*
		* @return Default XML header
		*/
		public static string GetXmlHeader()
		{
			return "<?xml version=\"1.0\" encoding=\"utf-8\" ?>";
		}// end of GetXmlHeader
		
		
		 /**
		* Simple array dumper. For debugging stuff.
		*/
		public static string DumpArray(object a)
		{
			if (!(a is Utility.OrderedMap))
			{
				return null;
			}
			
			string s = "";
			
			foreach ( string key in ((Utility.OrderedMap)a).Keys ) 
			{
				object val = ((Utility.OrderedMap)a)[key];
				s += "\n[" + key + "]=" + Utility.TypeSupport.ToString(val);
			}			
			
			return s;
		}// end of DumpArray
	}
}
