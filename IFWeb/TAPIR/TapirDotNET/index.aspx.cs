using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using TapirDotNET;

namespace TapirDotNET
{
	/// <summary>
	/// Summary description for index.
	/// </summary>
	public partial class index : System.Web.UI.Page
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// Instantiate a manager for configuration
			TpConfigManager config_manager = new TpConfigManager();
	
			// Put user code to initialize the page here
			TpResources resources = new TpResources().GetInstance();
	
			string html = "";
			if (Utility.OrderedMap.CountElements(resources.GetActiveResources()) > 0)
			{
				foreach (TpResource res in resources.GetActiveResources().Values)
				{
					html += "<a href=" + res.GetAccesspoint() + ">" + res.GetCode() + "</a><br />";
				}
			}
		
			else
			{
				html = "<p>No active resources available.</p>";
			}

			HtmlGenericControl ctrl = new HtmlGenericControl();
			ctrl.InnerHtml = html;
			label1.Controls.Add(ctrl);
		}

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
		}
		#endregion
	}
}
