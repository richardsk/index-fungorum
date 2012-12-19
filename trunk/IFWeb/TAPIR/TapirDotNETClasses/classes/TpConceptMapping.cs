using System.Web;

using TapirDotNET.Controls;

namespace TapirDotNET 
{

	public class TpConceptMapping
	{
		public const string TYPE_TEXT = "text";
		public const string TYPE_NUMERIC = "numeric";
		public const string TYPE_DATE = "date";
		public const string TYPE_DATETIME = "datetime";
		public const string TYPE_BOOL = "boolean";
		public const string TYPE_XML = "xml";


		public string mMappingType = "AbstractMapping";
		public TpConcept mrConcept;
		public object mLocalType;
		
		public TpConceptMapping()
		{
			
		}
		
		
		public virtual string GetMappingType()
		{
			return this.mMappingType;
		}// end of member function GetMappingType
		
		public virtual void  SetConcept(TpConcept rConcept)
		{
			this.mrConcept = rConcept;
		}// end of member function SetConcept
		
		public virtual void  SetLocalType(object localType)
		{
			this.mLocalType = localType;
		}// end of member function SetLocalType
		
		public virtual bool IsMapped()
		{
			// Must be called by subclasses
			
			return !Utility.VariableSupport.Empty(this.mLocalType);
		}// end of member function IsMapped
		
		public virtual void  Refresh(Utility.OrderedMap tablesAndCols)
		{
			// Must be called by subclasses
			string input_name;
			
			input_name = this.GetLocalTypeInputName();
			
			if (HttpContext.Current.Request[input_name] != null)
			{
				this.mLocalType = HttpContext.Current.Request[input_name];
			}
		}// end of member function Refresh
		
		public virtual string GetLocalTypeInputName()
		{
			string error;
			if (this.mrConcept == null)
			{
				error = "Cannot produce an input name for local type without having " + "an associated concept!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return "undefined_concept_value";
			}
			
			return Utility.StringSupport.StringReplace(Utility.TypeSupport.ToString(this.mrConcept.GetId()) + "_type", ".", "_");
		}// end of member function GetLocalTypeInputName
		
		public virtual string  GetHtml()
		{
			return null;
			// Must be called by subclasses after subclass implementaiton
		}// end of member function GetHtml
		
		public virtual string GetXml()
		{
			// Must be overwritten by subclasses
			return "<abstractMapping/>";
		}// end of member function GetXml
		
		public virtual string GetSqlTarget()
		{
			// Must be overwritten by subclasses
			return "";
		}// end of member function GetSqlTarget
		
		public virtual Utility.OrderedMap GetSqlFrom()
		{
			// Usually overwritten by subclasses
			return Utility.TypeSupport.ToArray(new Utility.OrderedMap());
		}// end of member function GetSqlFrom
		
		public virtual object GetLocalType()
		{
			return this.mLocalType;
		}// end of member function GetLocalType
		
		public virtual Utility.OrderedMap GetLocalTypes()
		{
			Utility.OrderedMap types;
			types = new Utility.OrderedMap(new object[]{"", "-- type --"}, new object[]{"text", TYPE_TEXT}, new object[]{"xml", TYPE_XML}, new object[]{"numeric", TYPE_NUMERIC}, new object[]{"boolean", TYPE_BOOL}, new object[]{"date", TYPE_DATE}, new object[]{"datetime", TYPE_DATETIME});
			
			return types;
		}// end of member function GetLocalTypes
	}
}
