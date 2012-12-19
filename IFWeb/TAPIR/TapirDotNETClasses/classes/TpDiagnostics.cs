namespace TapirDotNET 
{

	 /**
	* Class TpDiagnostics
	**/
	public class TpDiagnostics
	{
		private static Utility.OrderedMap stack;

		 /**
		* Returns the current diagnostics array
		*/
		public virtual Utility.OrderedMap _GetStack()
		{			
			if (stack == null)
			{
				stack = new Utility.OrderedMap();
			}
			
			return stack;
		}// end of member function _GetStack
		
		 /**
		* Adds a diagnostic to the end of the session's list of diagnostics
		* @param cd = the diagnostic code
		* @param msg = the message associated with the diagnostic
		* @param severity = severity level for the diagnostic
		*/
		public virtual void  Append(string cd, string msg, string severity)
		{
			Utility.OrderedMap stack = this._GetStack();
			
			stack.Push(new TpDiagnostic(cd, msg, severity));
			
			TpLog.debug(">> System message: " + msg);
			
		}// end of Append
		
		 /**
		* Returns the number of diagnostics in the list
		* @param severity = array of error levels.
		*/
		public virtual int Count(Utility.OrderedMap severity)
		{
			Utility.OrderedMap stack = this._GetStack();
			int ntot = 0;
			
			for (int i = 0; i < Utility.OrderedMap.CountElements(stack); i++)
			{
				if (severity == null || severity.Search(((TpDiagnostic)stack[i]).GetSeverity()) != null)
				{
					ntot++;
				}
			}
			
			return ntot;
		}// end of Count
		
		 /**
		* Prints out the errors
		*/
		public virtual string Dump()
		{
			Utility.OrderedMap stack = this._GetStack();
			int n = Utility.OrderedMap.CountElements(stack);
			
			string str = "Diagnostics [" + n + "]: ";
			
			for (int i = 0; i < n; i++)
			{
				str += "\n" + Utility.TypeSupport.ToString(stack[i].ToString());
			}
			
			return str;
		}// end of Dump
		
		 /**
		* Returns an XML representation of the current diagnostics.
		*/
		public virtual string GetXml()
		{
			Utility.OrderedMap stack = this._GetStack();
						
			if (TpConfigManager._DEBUG)
			{
				string duration = string.Format("{0:F}", TpUtils.MicrotimeFloat() - TpConfigManager.INITIAL_TIMESTAMP);
				this.Append(TpConfigManager.DC_DURATION, duration, TpConfigManager.DIAG_INFO);
			}
			
			string s = "";
			
			if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(stack)))
			{
				for (int i = 0; i < Utility.OrderedMap.CountElements(stack); i++)
				{
					TpDiagnostic diag = (TpDiagnostic)stack[i];
					if (diag.GetSeverity() != TpConfigManager.DIAG_DEBUG || TpConfigManager._DEBUG)
					{
						s = s + diag.GetXml();
					}
				}
				
				if (System.Convert.ToBoolean(s.Length))
				{
					s = "\n<diagnostics>" + s + "\n</diagnostics>";
				}
			}
			
			return s;
		}// end of GetXml
		
		 /**
		* Returns an aray of error messages
		*/
		public virtual Utility.OrderedMap GetMessages()
		{
			Utility.OrderedMap stack = this._GetStack();
			int n = Utility.OrderedMap.CountElements(stack);
			
			Utility.OrderedMap ret = new Utility.OrderedMap();
			
			for (int i = 0; i < n; i++)
			{
				ret.Push(((TpDiagnostic)stack[i]).GetDescription());
			}
			
			return Utility.OrderedMap.Unique(ret);
		}// end of GetMessages
		
		 /**
		* Returns the last error, or NULL if none.
		*/
		public virtual TpDiagnostic PopDiagnostic()
		{
			Utility.OrderedMap stack = this._GetStack();
			
			return (TpDiagnostic)stack.Pop();
		}// end of PopDiagnostic
		
		 /**
		* Resets the error stack.
		*/
		public virtual void  Reset()
		{			
			stack = new Utility.OrderedMap();
		}// end of Reset
	}
}
