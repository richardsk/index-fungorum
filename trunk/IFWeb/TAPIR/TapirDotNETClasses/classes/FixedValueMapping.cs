using System.Web;

using TapirDotNET.Controls;

namespace TapirDotNET 
{

	public class FixedValueMapping:TpConceptMapping
	{
		public string mValue;
		
		public FixedValueMapping()
		{
			mMappingType = "FixedValueMapping";			
		}
		
		
		public virtual void  SetValue(string value_Renamed)
		{
			this.mValue = value_Renamed;
		}// end of member function SetValue
		
		public virtual string GetValue()
		{
			return this.mValue;
		}// end of member function GetValue
		
		public override bool IsMapped()
		{
			if ((!base.IsMapped()) || this.mValue == null)
			{
				return false;
			}
			
			return true;
		}// end of member function IsMapped
		
		public override void  Refresh(Utility.OrderedMap tablesAndCols)
		{
			string input_name;
			base.Refresh(tablesAndCols);
			
			input_name = this.GetInputName();
			
			if (TpUtils.FindVar(input_name, null) != null)
			{
				this.mValue = TpUtils.FindVar(input_name, "").ToString();
			}
		}// end of member function Refresh
		
		public override string GetHtml()
		{
			if (this.mrConcept == null)
			{
				return "Mapping has no associated concept!";
			}
			
			
			return base.GetHtml();
		}// end of member function GetHtml
		
		public virtual string GetInputName()
		{
			string error;
			if (this.mrConcept == null)
			{
				error = "Fixed value mapping cannot give an input name without having " + "an associated concept!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return "undefined_concept_value";
			}
			
			return Utility.StringSupport.StringReplace(Utility.TypeSupport.ToString(this.mrConcept.GetId()) + "_value", ".", "_");
		}// end of member function GetInputName
		
		public override string GetXml()
		{
			string xml;
			xml = "\t\t\t\t";
			
			xml += "<fixedValueMapping type=\"" + this.mLocalType + "\">" + "\n\t\t\t\t\t" + "<value v=\"" + TpUtils.EscapeXmlSpecialChars(this.mValue) + "\"/>" + "\n\t\t\t\t" + "</fixedValueMapping>";
			
			return xml;
		}// end of member function GetXml
		
		public override string GetSqlTarget()
		{
			return "'" + this.mValue + "'";
		}// end of member function GetSqlTarget
		
		public override Utility.OrderedMap GetSqlFrom()
		{
			return Utility.TypeSupport.ToArray(new Utility.OrderedMap());
		}// end of member function GetSqlFrom
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mMappingType", "mValue", "mLocalType");
		}// end of member function __sleep
	}
}
