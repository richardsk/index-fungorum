<script runat="server" language="c#">

	// Custom error handler function
	public virtual void  TapirErrorHandler(int errNo, object errStr, object errFile, object errLine)
	{
		Utility.OrderedMap error_type;
		string label;
		switch (errNo)
		{
			
			case DIAG_FATAL: 
				
				// The error is causing termination of the script. Try and bail
				// by pushing the existing diagnostics and terminating the xml stream.
				
				new TpDiagnostics().Append("Fatal Error [" + errNo + "]", errStr + " (" + errFile + ":" + errLine + ")", DIAG_FATAL);
				Utility.MiscSupport.End();
				break;
			
			
			case DIAG_ERROR: 
				
				new TpDiagnostics().Append("Error [" + errNo + "]", errStr, DIAG_ERROR);
				break;
			
			
			case DIAG_WARN: 
				
				new TpDiagnostics().Append("Warning [" + errNo + "]", errStr, DIAG_WARN);
				break;
			
			
			default: 
				if (errNo != 2048)
				// ignore compatibility warnings
				{
					error_type = new Utility.OrderedMap(new object[]{E_ERROR, "Error"}, new object[]{E_WARNING, "Warning"}, new object[]{E_PARSE, "Parsing Error"}, new object[]{E_NOTICE, "Notice"}, new object[]{E_CORE_ERROR, "Core Error"}, new object[]{E_CORE_WARNING, "Core Warning"}, new object[]{E_COMPILE_ERROR, "Compile Error"}, new object[]{E_COMPILE_WARNING, "Compile Warning"}, new object[]{E_USER_ERROR, "User Error"}, new object[]{E_USER_WARNING, "User Warning"}, new object[]{E_USER_NOTICE, "User Notice"});
					
					label = "ASP.NET ";
					
					if (error_type[errNo] != null)
					{
						label = label + Utility.TypeSupport.ToString(error_type[errNo]);
					}
					else
					{
						label += "Unknown error[" + errNo.ToString() + "]";
					}
					
					new TpDiagnostics().Append(label, errStr + " (" + errFile + ":" + errLine + ")", DIAG_WARN);
				}
				
				break;
			
		}
	}
</script>


<%
	 /**
	* tapir_errors.aspx 
	*
	* LICENSE INFORMATION
	*
	* This program is free software; you can redistribute it and/or
	* modify it under the terms of the GNU General Public License
	* as published by the Free Software Foundation; either version 2
	* of the License, or (at your option) any later version.
	*
	* This program is distributed in the hope that it will be useful,
	* but WITHOUT ANY WARRANTY; without even the implied warranty of
	* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	* GNU General Public License for more details:
	*
	* http://www.gnu.org/copyleft/gpl.html
	*
	*
	* @author Kevin Richards <richardsk [at] landcareresearch . co . nz>
	*
	*
	* NOTES
	*
	* Implements the Errors module for the TapirDotNET provider.
	*/
	
%>
<!-- #include file = "TpDiagnostics.aspx" -->
<%
	
	// set the error reporting level
	
	if (System.Convert.ToBoolean((System.Reflection.MethodBase.GetCurrentMethod().DeclaringType.GetField("_DEBUG".ToUpper()) != null)?1:0))
	{
		error_reporting(E_ALL);
	}
	else
	{
		error_reporting(E_USER_ERROR | E_USER_WARNING | E_USER_NOTICE);
	}
	
	
%>