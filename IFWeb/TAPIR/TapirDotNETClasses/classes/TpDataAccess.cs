using System;
using System.Data;
using System.Data.OleDb;

namespace TapirDotNET
{
	/// <summary>
	/// Summary description for TpDataAccess.
	/// </summary>
	public class TpDataAccess
	{

		public TpDataAccess()
		{
		}

		public static string GetUppercaseCommand(OleDbConnection cn)
		{
			//TODO ?? DataTable dbinfo = cn.GetOleDbSchemaTable(OleDbSchemaGuid.DbInfoLiterals, new object[]{});			
			if (cn.Provider == "sqloledb") return "upper";
			return "UCASE";
		}

		public static DataSet SelectLimit(OleDbConnection cn, string sql, int count, int start)
		{
			DataSet ds = new DataSet();

			try
			{
				int pos = sql.IndexOf("SELECT TOP");
				if (pos == -1)
				{
					int total = start + count;
					pos = sql.IndexOf("SELECT ");
					sql = sql.Substring(0, pos) + "SELECT TOP " + total.ToString() + sql.Substring(pos + 6);
				}

				OleDbCommand cmd = cn.CreateCommand();
				cmd.CommandText = sql;
			
				OleDbDataAdapter da = new OleDbDataAdapter(cmd);
				da.Fill(ds);

				if (start > 0 && ds.Tables.Count > 0)
				{
					int i = 0;
					while (i < start && i < ds.Tables[0].Rows.Count)
					{
						ds.Tables[0].Rows[i].Delete();
					}
					ds.AcceptChanges();
				}
			}
			catch(Exception ex)
			{
				TpLog.debug(ex.Message + ":" + ex.StackTrace);
				ds = null;
			}

			return ds;
		}
		
		public static DataSet Execute(OleDbConnection cn, string sql)
		{
			DataSet ds = new DataSet();

			try
			{
				OleDbCommand cmd = cn.CreateCommand();
				cmd.CommandText = sql;
			
				OleDbDataAdapter da = new OleDbDataAdapter(cmd);
				da.Fill(ds);
			}
			catch(Exception ex)
			{
				TpLog.debug(ex.Message + ":" + ex.StackTrace);
				ds = null;
			}

			return ds;
		}
	}
}
