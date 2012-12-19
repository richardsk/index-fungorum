using System;
using System.Data;
using System.Data.OleDb; 
using System.Xml;

namespace TapirDotNET 
{

	public class TpDataSource
	{
		public string mDriverName;
		public string mEncoding;
		public string mConnectionString;
		public string mUserName;
		public string mPassword;
		public string mDatabaseName;
		public OleDbConnection mConnection;
		public bool mIsLoaded;
		
		public TpDataSource()
		{
			
		}
		
		
		public virtual bool IsLoaded()
		{
			return this.mIsLoaded;
		}// end of member function IsLoaded
		
		public virtual void  LoadDefaults()
		{
			this.mDriverName = "";
			this.mEncoding = "ISO-8859-1";
			this.mConnectionString = "";
			this.mUserName = "";
			this.mPassword = "";
			this.mDatabaseName = "";
			
			this.mIsLoaded = true;
			
			this.ResetConnection();
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			this.mDriverName = TpUtils.GetVar("dbtype", "").ToString();
			this.mEncoding = TpUtils.GetVar("encoding", "").ToString();
			this.mConnectionString = TpUtils.GetVar("constr", "").ToString();
			this.mUserName = TpUtils.GetVar("uid", "").ToString();
			this.mPassword = TpUtils.GetVar("pwd", "").ToString();
			this.mDatabaseName = TpUtils.GetVar("database", "").ToString();
			
			this.mIsLoaded = true;
			
			this.ResetConnection();
		}// end of member function LoadFromSession
		
		public virtual void  LoadFromXml(string file, XmlDocument xpr)
		{
			string error;
			string path_to_datasource;
			Utility.OrderedMap datasource_attrs;
			if (xpr == null)
			{
				xpr = new XmlDocument();
				
				try
				{
					xpr.Load(file);
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file: " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return ;
				}
			}
			
			path_to_datasource = "/configuration/datasource";
			
			XmlNode dsnode = xpr.SelectSingleNode(path_to_datasource);
						
			if (dsnode != null)
			{
				this.mDriverName = dsnode.Attributes["dbtype"].Value;
				this.mEncoding = dsnode.Attributes["encoding"].Value;
				this.mConnectionString = dsnode.Attributes["constr"].Value;
				this.mConnectionString = this.mConnectionString.Replace("&quot;", "\"");
				this.mConnectionString = this.mConnectionString.Replace("&amp;", "&");
				this.mUserName = dsnode.Attributes["uid"].Value;
				this.mPassword = dsnode.Attributes["pwd"].Value;
				this.mDatabaseName = dsnode.Attributes["database"].Value;
			}

			this.mIsLoaded = true;
			
			this.ResetConnection();
		}// end of member function LoadFromXml
		
		public virtual bool Validate(bool raiseErrors)
		{
			bool ret_val = true;
			string error;
			int char_page;
			
			// Try catch block
			do 
			{
				
				if (this.mConnection != null)
				{
					// No need to continue if there is a valid connection
					break;
				}
				
				// Connection property is null here
				
				// First check that all necessary parameters are present
				if (Utility.VariableSupport.Empty(this.mDriverName) || (Utility.VariableSupport.Empty(this.mConnectionString) && Utility.VariableSupport.Empty(this.mDatabaseName)))
				{
					if (raiseErrors)
					{
						error = "Please, provide a minimum set of data to connect to " + "a SQL database!\nIt won't be possible to continue " + "without openning a connection.";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					}
					ret_val = false;
					break;
				}
				
				// Then try connecting to database
				this.mConnection = new OleDbConnection(); 
				
				if (this.mConnection == null)
				{
					if (raiseErrors)
					{
						error = "Could not create connection using database type '" + this.mDriverName + "'!";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					}
					ret_val = false;
					break;
				}
				
				
				try
				{
					this.mConnection.ConnectionString = BuildConnectionString();
					this.mConnection.Open();
									
				}
				catch(Exception ex)
				{
					error = "Could not open a database connection using these settings!\r\nError : " + ex.Message;
					
					if (raiseErrors)
					{
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					}
					
					ret_val = false;

					this.ResetConnection();
					break;
				}

				// Set the charPage attribute of the connection.
				// This only works for OLEDB based connections, but will not hurt
				// other types of connections
				char_page = this._GetCodePage(this.mEncoding);
				
				if (!(char_page == -1))
				{
					//TODO - correct?
					this.mConnection.ConnectionString += ";CODEPAGE=" + char_page.ToString();
				}
				
			}
			while (false);
			
			return ret_val;
		}// end of member function Validate
		
		private string BuildConnectionString()
		{
			string cnnStr = "Provider=" + mDriverName + ";" + mConnectionString;
			cnnStr = cnnStr.Replace("&quot;", "&amp;");
			cnnStr = cnnStr.Replace("\"", "&");
			//TODO user, password etc? - was mConncetion.PConnect(clean_constr, this.mUserName, this.mPassword, this.mDatabaseName));
			//TODO - this.mConnection.fmtDate = this.mConnection.fmtTimeStamp;

			return cnnStr;
		}

		public virtual void  ResetConnection()
		{
			if (this.mConnection != null)
			{
				this.mConnection.Close();
			}
			
			this.mConnection = null;
		}// end of member function ResetConnection
		
		public virtual string GetXml()
		{
			string xml;
			xml = "<datasource";
			
			xml += " constr=\"" + TpUtils.EscapeXmlSpecialChars(this.mConnectionString) + "\"";
			xml += " uid=\"" + TpUtils.EscapeXmlSpecialChars(this.mUserName) + "\"";
			xml += " pwd=\"" + TpUtils.EscapeXmlSpecialChars(this.mPassword) + "\"";
			xml += " database=\"" + TpUtils.EscapeXmlSpecialChars(this.mDatabaseName) + "\"";
			xml += " dbtype=\"" + this.mDriverName + "\"";
			xml += " encoding=\"" + this.mEncoding + "\"/>";
			
			return xml;
		}// end of member function GetXml
		
		public virtual void  SetDriverName(string driverName)
		{
			this.mDriverName = driverName;
		}// end of member function SetDriverName
		
		public virtual string GetDriverName()
		{
			return this.mDriverName;
		}// end of member function GetDriverName
		
		public virtual void  SetEncoding(string encoding)
		{
			this.mEncoding = encoding;
		}// end of member function SetEncoding
		
		public virtual string GetEncoding()
		{
			return this.mEncoding;
		}// end of member function GetEncoding
		
		public virtual void  SetConnectionString(string connectionString)
		{
			this.mConnectionString = connectionString;
		}// end of member function SetConnectionString
		
		public virtual string GetConnectionString()
		{
			return this.mConnectionString;
		}// end of member function GetConnectionString
		
		public virtual void  SetDatabase(string databaseName)
		{
			this.mDatabaseName = databaseName;
		}// end of member function SetDatabase
		
		public virtual string GetDatabase()
		{
			return this.mDatabaseName;
		}// end of member function GetDatabase
		
		public virtual void  SetUsername(string userName)
		{
			this.mUserName = userName;
		}// end of member function SetUsername
		
		public virtual string GetUsername()
		{
			return this.mUserName;
		}// end of member function GetUsername
		
		public virtual void  SetPassword(string password)
		{
			this.mPassword = password;
		}// end of member function SetPassword
		
		public virtual string GetPassword()
		{
			return this.mPassword;
		}// end of member function GetPassword
		
		public virtual OleDbConnection GetConnection()
		{
			// Validate should always be called before this method
			// to catch possible errors. But just in case, we call it
			// here too (but ignoring possible errors).
			this.Validate(true);
			
			return this.mConnection;
		}// end of member function GetConnection
		
		 /**
		* Returns a windows code page for the specified encoding parameter.
		* This is used to set the code page for connection to COM objects, such as
		* database connections using OLEDB.
		*/
		public virtual int _GetCodePage(string encoding)
		{
			if ((Utility.StringSupport.StringCompare(encoding, "UTF-8", false) == 0) && (Utility.StringSupport.StringCompare(encoding, "UTF-8", false).GetType() == 0.GetType()))
			{
				return 65001;
			}
			
			return -1;
		}// end of _GetCodePage
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			this.ResetConnection();
			
			return new Utility.OrderedMap("mDriverName", "mEncoding", "mConnectionString", "mUserName", "mPassword", "mDatabaseName", "mIsLoaded");
		}// end of member function __sleep
	}
}
