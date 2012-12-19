using System;
using System.Collections;
using System.ComponentModel;
using System.Web;
using System.Web.SessionState;

using Microsoft.Web.Services2.Messaging;

using LSIDFramework;

namespace AuthorityWebService 
{
	/// <summary>
	/// Summary description for Global.
	/// </summary>
	public class Global : System.Web.HttpApplication 
	{
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		public Global()
		{
			InitializeComponent();
		}	
		
		protected void Application_Start(Object sender, EventArgs e)
		{
			LSIDClient.Global.BinDirectory = System.IO.Path.GetDirectoryName(Context.Request.PhysicalApplicationPath) + "\\bin"; //.PhysicalPath

			LSIDClient.LSIDLog.LogMessage("Web App Path : " + LSIDClient.Global.BinDirectory);

			String configLocation = System.Configuration.ConfigurationSettings.AppSettings[LSIDFramework.ServiceConfigurationConstants.RSDL_LOCATION];
			String location = null;
			if (configLocation == null) 
			{
				location = Context.Request.PhysicalApplicationPath + "services"; 
			} 
			else 
			{
				location = configLocation;
			}
			LSIDFramework.Global.ServiceConfigLocation = location;
			LSIDClient.LSIDLog.LogMessage("Services location : " + location);
			LSIDFramework.Global.AuthenticationRegistry = LSIDFramework.ServiceRegistry.getAuthenticationServiceRegistry(location);
			LSIDClient.LSIDLog.LogMessage("Loaded Authentication");
			LSIDFramework.Global.TheServiceRegistry = LSIDFramework.ServiceRegistry.getAuthorityServiceRegistry(location);
			LSIDClient.LSIDLog.LogMessage("Loaded Services");
			LSIDFramework.Global.AssigningRegistry = LSIDFramework.ServiceRegistry.getAssigningServiceRegistry(location);
			LSIDClient.LSIDLog.LogMessage("Loaded Assigining");
			LSIDFramework.Global.DataRegistry = LSIDFramework.ServiceRegistry.getDataServiceRegistry(location);
			LSIDClient.LSIDLog.LogMessage("Loaded Data Registry");
			LSIDFramework.Global.MetadataRegistry = LSIDFramework.ServiceRegistry.getMetaDataServiceRegistry(location);
			LSIDClient.LSIDLog.LogMessage("Loaded Metadata Registry");
			
		}
 
		protected void Session_Start(Object sender, EventArgs e)
		{

		}

		protected void Application_BeginRequest(Object sender, EventArgs e)
		{
		}

		protected void Application_EndRequest(Object sender, EventArgs e)
		{

		}

		protected void Application_AuthenticateRequest(Object sender, EventArgs e)
		{
		}

		protected void Application_Error(Object sender, EventArgs e)
		{

		}

		protected void Session_End(Object sender, EventArgs e)
		{

		}

		protected void Application_End(Object sender, EventArgs e)
		{

		}
			
		#region Web Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.components = new System.ComponentModel.Container();
		}
		#endregion
	}
}

