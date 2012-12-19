namespace TapirDotNET 
{

	 /**
	* Class TpDiagnostic
	*
	* Implements a diagnostic log.
	* A diagnostic is identified by a string constant with further information
	* provided by an optional description element. It has an associated level
	* of severity that can be: debug, info, warn, error, fatal*/
	public class TpDiagnostic
	{
		public string mCode;
		public string mDescription;
		public string mSeverity;
		
		public TpDiagnostic(string code, string descr, string severity)
		{
			this.mCode = code;
			this.mDescription = descr;
			this.mSeverity = severity;
		}
		
		
		 /*
		* Returns the severity.
		*/
		public virtual string GetSeverity()
		{
			return this.mSeverity;
		}// end of GetSeverity
		
		 /*
		* Returns the description.
		*/
		public virtual string GetDescription()
		{
			return this.mDescription;
		}// end of GetDescription
		
		 /*
		* Generates a string representation of the diagnostic object
		*/
		public override string ToString()
		{
			return this.mSeverity + "(" + this.mCode + "):" + this.mDescription;
		}// end of ToString
		
		 /*
		* Generates an XML representation of this object
		*/
		public virtual string GetXml()
		{
			string s;
			s = "\n<diagnostic";
			
			s += " code=\"" + this.mCode + "\" level=\"" + this.mSeverity + "\">";
			s += TpUtils.EscapeXmlSpecialChars(this.mDescription);
			s += "</diagnostic>";
			
			return s;
		}// end of GetXml
	}
}
