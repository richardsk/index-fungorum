using System;
using System.Collections;
using System.ComponentModel;
using System.Web;
using System.Web.SessionState;
using System.Text.RegularExpressions;

namespace TapirDotNET 
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
			
			
		}
 
		protected void Session_Start(Object sender, EventArgs e)
		{

		}

		protected void Application_BeginRequest(Object sender, EventArgs e)
		{
			Regex rex = new Regex(@"^(.+\/)tapir\.aspx\/(.+)[\?\/](.+){0,}", RegexOptions.IgnoreCase);
			Match m = rex.Match(Request.RawUrl);
			if (!m.Success)
			{
				rex = new Regex(@"^(.+\/)tapir\.aspx\/(.+)", RegexOptions.IgnoreCase);
				m = rex.Match(Request.RawUrl);
			}
			if (m.Success)
			{
				string dsa = m.Groups[2].Value.Replace("/", "");
				string end = "";
				if (m.Groups.Count > 3) end = m.Groups[3].Value.Replace("?", "");

				Context.RewritePath(m.Groups[1].Value + "tapir.aspx?dsa=" + dsa + "&" + end);
			}
			
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

