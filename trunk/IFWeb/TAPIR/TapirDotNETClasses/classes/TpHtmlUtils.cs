namespace TapirDotNET 
{

	public class TpHtmlUtils
	// only class methods
	{
		public virtual string GetCombo(object name, object value_Renamed, Utility.OrderedMap options, bool multiple, object size, string onChange)
		{
			string str_size;
			string str_on_change;
			string str_multiple;
			string html;
			string selected;

			str_size = (size.GetType().ToString().ToLower().StartsWith("int"))?" size=\"" + size + "\"":"";
			
			str_on_change = onChange.Length>0 ? string.Format(" onchange=\"{0}\"", onChange):"";
			
			str_multiple = (multiple)?" multiple=\"1\"":"";
			
			html = string.Format("<select name=\"{0}\"{1}{2}{3}>", name, str_multiple, str_size, str_on_change);
			
			foreach ( string option_id in options.Keys ) 
			{
				object option_value = options[option_id];
				selected = (Utility.TypeSupport.ToString(value_Renamed) == option_id)?"selected=\"selected\"":"";
				
				html += string.Format("<option value=\"{0}\" {1}>{2}", option_id, selected, option_value);
			}
			
			
			html += "</select>";
			
			return html;
		}// end of member function GetCombo
		
		public virtual string GetCheckboxes(string prefix, Utility.OrderedMap values, Utility.OrderedMap options)
		{
			string html;
			int cnt;
			string checked_Renamed;
			string name;
			html = "";
			
			cnt = 1;
			
			foreach ( string option_id in options.Keys ) 
			{
				object option_value = options[option_id];
				checked_Renamed = (values.Search(option_id) != null) ? " checked" : "";
				
				name = prefix + "_" + cnt.ToString();
				
				html += string.Format("&nbsp;<input type=\"checkbox\" class=\"checkbox\" name=\"{0}\" value=\"{1}\"{2}>&nbsp;<span class=\"label\">{3}</span>", name, option_id, checked_Renamed, option_value);
				
				++cnt;
			}
			
			
			return html;
		}// end of member function GetCheckboxes
	}
}
