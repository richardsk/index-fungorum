using System;
using System.IO;

namespace TapirDotNET
{
	/// <summary>
	/// Summary description for TpLog.
	/// </summary>
	public class TpLog
	{
		private static string log_file_name;
		private static string debug_file_name;

		public static void InitialiseLogs()
		{
			// Main log
			log_file_name = TpConfigManager.TP_LOG_DIR + "\\" + TpConfigManager.TP_LOG_NAME;
			
			if (!File.Exists(log_file_name))
			{
				if (Directory.Exists(log_file_name))
				{
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, "Log file name clashes with a directory : " + log_file_name, TpConfigManager.DIAG_ERROR);
				}
				else
				{
					File.CreateText(log_file_name).Close();
				}
			}

			try
			{
				System.IO.File.SetLastWriteTime(log_file_name, System.DateTime.Now);
			}
			catch (Exception ex)
			{
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, "Error with log file " + log_file_name, TpConfigManager.DIAG_ERROR);
			}			
			
			// Separate log for detailed debugging
			debug_file_name = TpConfigManager.TP_DEBUG_DIR + "\\" + TpConfigManager.TP_DEBUG_LOGFILE;
						
			if (TpConfigManager.TP_LOG_DEBUG)
			{				
				try
				{
					if (!File.Exists(debug_file_name))
					{
						File.CreateText(debug_file_name).Close();
					}

					System.IO.File.SetLastWriteTime(debug_file_name, System.DateTime.Now);
				}
				catch(Exception)
				{
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, "Error with log file " + log_file_name, TpConfigManager.DIAG_ERROR);
				}
			}
		}// end of InitializeLogs

		public static void debug(string msg)
		{
			try
			{
				StreamWriter wr = File.AppendText(debug_file_name);
				wr.WriteLine(msg);
				wr.Close();
			}
			catch(Exception ex)
			{
			}
		}
		
		public static void log(string msg)
		{
			try
			{
				StreamWriter wr = File.AppendText(log_file_name);
				wr.WriteLine(msg);
				wr.Close();
			}
			catch(Exception ex)
			{
			}
		}
	}
}
