using System;
using System.Web;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Xml;
using System.Data.OleDb;
using System.Data;

using TapirDotNET.Controls;

	/**
	* configurator.cs 
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


namespace TapirDotNET.admin
{
	/// <summary>
	/// Summary description for configurator.
	/// </summary>
	public partial class configurator : System.Web.UI.Page
	{		
		public object _COOKIES;
		public TpConfigManager config_manager;
		public string revision_regexp;
		public string root_dir;
		public string revision;
		public Utility.OrderedMap matches;
		public string current_include_path;
		public bool tmp;
		public string pth;
		public string msg;
		protected System.Web.UI.WebControls.Label Label1;
		public bool res;

		protected TpPage currentPage = null;

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//

			string js = @"<script language = ""javascript"">
<!--
   function GetCoords()
   {
      var scrollX, scrollY;
      
      if (document.all)
      {
         if (!document.documentElement.scrollLeft)
            scrollX = document.body.scrollLeft;
         else
            scrollX = document.documentElement.scrollLeft;
               
         if (!document.documentElement.scrollTop)
            scrollY = document.body.scrollTop;
         else
            scrollY = document.documentElement.scrollTop;
      }   
      else
      {
         scrollX = window.pageXOffset;
         scrollY = window.pageYOffset;
      }

      document.getElementById(""scroll"").value = scrollX + ""_"" + scrollY;
     
   }
   
   function DoScroll()
   {
      var xy = document.getElementById(""scroll"").value; 
      
	  if ( ! xy ) return;

	  var ar = xy.split(""_"");
	  
      if ( ar.length == 2 ) scrollTo( parseInt(ar[0]), parseInt(ar[1]) );
   }
   
   window.onload = DoScroll;
   window.onscroll = GetCoords;
   window.onkeypress = GetCoords;
   window.onclick = GetCoords;
// -->
</script>";

			Page.RegisterStartupScript("Scroller", js);

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

		public configurator()
		{
		}
	
		protected void Page_Load(object sender, System.EventArgs e)
		{
			Response.AppendHeader("Last-Modified: " + System.DateTime.Now.ToUniversalTime().ToString("D, d M Y H:i:s") + " GMT", "");
			Response.AppendHeader("Expires: Mon, 26 Jul 1997 05:00:00 GMT", "");
			Response.AppendHeader("Cache-Control: no-cache, no-store, post-check=0, pre-check=0", "");
			Response.AppendHeader("Pragma: no-cache", "");

			//TODO Magic quotes??
			//			if (System.Convert.ToBoolean(get_magic_quotes_gpc()))
			//			{
			//		
			//				new TpUtils().StripMagicSlashes(new Utility.OrderedMap(Request.Form, false));
			//				new TpUtils().StripMagicSlashes(new Utility.OrderedMap(Request.QueryString, false));
			//				new TpUtils().StripMagicSlashes(_COOKIES);
			//				new TpUtils().StripMagicSlashes(_REQUEST);
			//			}
			//	

			new TpDiagnostics().Reset();
			
			// Instantiate a manager for configuration
			config_manager = new TpConfigManager();
	
			config_manager.CheckEnvironment();
	
			if (new TpDiagnostics().Count(null) > 0)
			{		
				// Die showing errors in a simple list
				Utility.MiscSupport.End("<ul>" + Environment.NewLine + "<li>" + Utility.StringSupport.Join(Environment.NewLine + "<li>", new TpDiagnostics().GetMessages()) + Environment.NewLine + "</ul>");
			}

	
			currentPage = LoadCurrentPage();
			
			if (currentPage != null)
			{
				if (currentPage is TpWizardForm)
				{
					wizard_header wh = (wizard_header)this.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\wizard_header.ascx");
					wh.Initialise((TpWizardForm)currentPage);
					MainPanel.Controls.Add(wh);

					MainPanel.Controls.Add(currentPage);

					wizard_footer wf = (wizard_footer)this.LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\wizard_footer.ascx");
					wf.Initialise((TpWizardForm)currentPage);
					MainPanel.Controls.Add(wf);
				}
				else
				{					
					MainPanel.Controls.Add(currentPage);
				}
			}

			GetSideMenu();
			GetDebugHtml();
		}
		
		private TpPage LoadCurrentPage()
		{
			// Get resources anyway (need to display them on the main panel)
			TpResources r_resources = new TpResources().GetInstance();
			TpPage page;
			
			TpResource r_resource;
			object error;
			bool is_new;
			int step = -1;
			object resources_list;			
			
			string passed_resource = (string)TpUtils.GetVar("resource", null);
			
			string form = HttpContext.Current.Request.Form["form"];
			if (form == null) form = (string)HttpContext.Current.Request.QueryString["form"];
			if (form == null) form = (string)HttpContext.Current.Session["form"];

			// Clicked on "add resource"
			if (HttpContext.Current.Request.Form["add_resource"] != null)
			{
				page = config_manager.GetWizardPage(this, 1);
				
				((TpWizardForm)page).Initialize(new TpResource());
			}
				// If a resource parameter was specified
			else if (passed_resource != null)
			{					
				// Before going through the first step, resource is empty.
				// Need to instantiate a new object in this case.
				if (passed_resource.Length == 0)
				{
					r_resource = new TpResource();
				}
				// If resource code has content, check it
				else
				{
					r_resource = (TpResource)r_resources.GetResource(passed_resource, true);
				}
					
				// Resource not found!
				if (passed_resource.Length > 0 && r_resource == null)
				{
					error = new TpDiagnostics().PopDiagnostic();
						
					page = (TpPage)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\MessageControl.ascx");
					page.SetMessage(((TpDiagnostic)error).GetDescription());
				}
					// Resource found or empty (new)
				else
				{
					// If a form (step) was specified
					if (form != null && form.Length > 0)
					{							
						int form_id = int.Parse(form);
							
						page = config_manager.GetWizardPage(this, form_id);
							
						((TpWizardForm)page).Initialize(r_resource);
							
						if (Page.IsPostBack)
						{
							// Aborted
							if (HttpContext.Current.Request.Form["abort"] != null)
							{
								if (r_resources.RemoveResource(passed_resource))
								{
									page = (TpPage)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\MessageControl.ascx");
									page.SetMessage("Resource successfully removed!");
								}
							}
							// Did not abort
							else
							{
								// Need to call IsNew before HandleEvents, because
								// it may not be new anymore after that...
								is_new = r_resource.IsNew();
									
								((TpWizardForm)page).HandleEvents();
									
								if (((TpWizardForm)page).Done())
								{
									new TpDiagnostics().Reset();
										
									// New resource
									if (is_new)
									{
										step = form_id;
											
										// Are there any steps left?
										if (((TpWizardForm)page).GetNumSteps() > step)
										{
											HttpContext.Current.Session["resource"] = r_resource.GetCode();
											HttpContext.Current.Session["form"] = ((int)(step + 1)).ToString();
											Response.Redirect(Request.Url.ToString());
										}
										// Last step!
										else
										{
											page = (MessageControl)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\MessageControl.ascx");
											page.SetMessage("New resource successfully saved!");
										}
									}
								}
							}
						}
					}
						// No form specified
					else
					{
						// New resource
						if (r_resource.IsNew())
						{
							// Find the step to continue the wizard
							// No processing required
							if (!r_resource.ConfiguredMetadata())
							{
								// Should never fall here, but anyway...
								page = config_manager.GetWizardPage(this, 1);
							}
							else if (!r_resource.ConfiguredDatasource())
							{
								page = config_manager.GetWizardPage(this, 2);
							}
							else if (!r_resource.ConfiguredTables())
							{
								page = config_manager.GetWizardPage(this, 3);
							}
							else if (!r_resource.ConfiguredLocalFilter())
							{
								page = config_manager.GetWizardPage(this, 4);
							}
							else if (!r_resource.ConfiguredMapping())
							{
								page = config_manager.GetWizardPage(this, 5);
							}
							else if (!r_resource.ConfiguredSettings())
							{
								page = config_manager.GetWizardPage(this, 6);
							}
							else
							{
								// Apparently configured everything!
								// Go to last step....
								page = config_manager.GetWizardPage(this, new TpWizardForm().GetNumSteps()); 
							}
								
							((TpWizardForm)page).Initialize(r_resource);
						}
							// Existing resource
						else
						{
							TpResourceForm ctrl = (TpResourceForm)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\TpResourceForm.ascx");
							ctrl.Initialise(r_resource);
								
							page = (TpPage)ctrl;
								
							if (Page.IsPostBack)
							{
								ctrl.HandleEvents();
									
								if (ctrl.RemovedResource())
								{
									// Overwrite page with a new one not involving any
									// particular resource and display message
									page = (TpPage)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\MessageControl.ascx");
									page.SetMessage("Resource successfully removed!");
								}
							}
						}
					}
				}
			}
			else if (HttpContext.Current.Request.Params["uddi"] != null)
			{
						
				page = (TpUddiForm)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\TpUddiForm.ascx");
						
				// In this case, processing happens inside DisplayHtml because it can  
				// take a long time for several resources, so better flush as much as
				// possible after each resource is processed
			}
			else if (HttpContext.Current.Request.Params["import"] != null)
			{
							
				page = (TpImportForm)LoadControl(TpConfigManager.TP_WEB_CONTROLS_DIR + "\\TpImportForm.ascx");
							
				if (Page.IsPostBack) 
				{
					((TpImportForm)page).HandleEvents();
				}
			}
				// No resource and no action involved
			else
			{
				// Empty page
				page = new TpPage();
			}
			
			resources_list = r_resources.GetAllResources();

			return page;
		
		}// end of member function HandleEvents
			

		protected void GetSideMenu()
		{
			string menu = "<a href=\"" + Request.Path + "?force_reload=1\" class=\"title\">TapirDotNET<br/>configurator</a><br/><br/>";
			menu += "<span class=\"tip\">Resources</span><br/><br/>";
			
			Utility.OrderedMap resources_list = new TpResources().GetInstance().GetAllResources();
			if (Utility.OrderedMap.CountElements(resources_list) > 0)
			{
				menu += "<table border=\"0\" width=\"90%\" cellspacing=\"0\" cellpadding=\"2\">";
				foreach (TpResource res in resources_list.Values)
				{
					menu += "<tr><td class=\"menu\"><a href=\"configurator.aspx?resource=" + res.GetCode() + "\" class=\"menu\">";
					menu += res.GetCode() + "</a></td></tr>" + Environment.NewLine;
				}
				menu += "</table>";				
			}
			else
			{
				menu += "<span class=\"menu\">none</span><br/>";
			}
	      
			menu += "<br/><form name=\"resources\" action=\"" + Request.Path;
			menu += "\" method=\"POST\"><input type = \"submit\" name = \"add_resource\" value = \"add\"/><br/><br/>";
			menu += "<input type = \"submit\" name = \"import\" value = \"import\"/>";
			menu += "<input type = \"hidden\" name = \"first\" value = \"1\"/></form>";
	      
			if (Utility.OrderedMap.CountElements(resources_list) > 0)
			{
				menu += "<br/><span class=\"tip\">Tools</span><br/><br/>";
				menu += "<a href=\"" + Request.Path + "?uddi=1&amp;first=1\" class=\"menu\">UDDI</a>";
			}

			
			System.Web.UI.HtmlControls.HtmlGenericControl ctrl = new System.Web.UI.HtmlControls.HtmlGenericControl();
			ctrl.InnerHtml = menu;
			MenuPanel.Controls.Add(ctrl);
		}

		protected void GetDebugHtml()
		{
			string dbg = "";

			if (TpConfigManager._DEBUG)
			{
				dbg += "<br/>";
				dbg += "<br/>";
				dbg += "<span class=\"tip\">";
				dbg += "SERVER_NAME=" + Utility.TypeSupport.ToString(Request.ServerVariables["SERVER_NAME"]) + "<br/>";
				dbg += "SERVER_PORT=" + Utility.TypeSupport.ToString(Request.ServerVariables["SERVER_PORT"]) + "<br/>";
				dbg += "SCRIPT_NAME=" + Utility.TypeSupport.ToString(Request.CurrentExecutionFilePath) + "<br/>";
				dbg += "QUERY_STRING=" + Utility.TypeSupport.ToString(Request.ServerVariables["QUERY_STRING"]) + "<br/>";
				dbg += "REQUEST_URI=" + Utility.TypeSupport.ToString(Request.RawUrl) + "<br/>";
				dbg += "REQUEST_METHOD=" + Utility.TypeSupport.ToString(Request.HttpMethod) + "<br/>";
				
				if (Request.PhysicalPath != null)
				{
					dbg += "PATH_TRANSLATED=" + Utility.TypeSupport.ToString(Request.PhysicalPath) + "<br/>";
				}
				
				if (Request.UserHostName != null)
				{
					dbg += "REMOTE_HOST=" + Utility.TypeSupport.ToString(Request.UserHostName) + "<br/>";
				}
			
				dbg += "</span>";
			}

			System.Web.UI.HtmlControls.HtmlGenericControl ctrl = new System.Web.UI.HtmlControls.HtmlGenericControl();
			ctrl.InnerHtml = dbg;
			DebugPanel.Controls.Add(ctrl);
		}

	}
}
