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
using TapirDotNET.Controls;

namespace TapirDotNETAdmin
{
	/// <summary>
	/// Summary description for help.
	/// </summary>
	public partial class help : System.Web.UI.Page
	{
		
		/**
	   * help.aspx
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
	   */
	

		protected Panel helpPanel;


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
		
		protected void Page_Load(object sender, System.EventArgs e)
		{
			string name = (Request["name"] != null) ? System.Web.HttpUtility.UrlDecode(Request["name"]) : "";
			string doc = (Request["doc"] != null) ? System.Web.HttpUtility.UrlDecode(Request["doc"]) : "";

			HelpForm ctrl = (HelpForm)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\helpform.ascx");
			ctrl.Doc = doc;
			ctrl.Name = name;
            helpPanel.Controls.Add(ctrl);
			
	
			//TODO
			/*if (magic quotes)
			{
				name = Utility.StringSupport.RemoveSlashes(name);
				doc = Utility.StringSupport.RemoveSlashes(doc);
			}*/
		}
	}
}
