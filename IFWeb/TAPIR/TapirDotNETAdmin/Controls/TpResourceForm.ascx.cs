
namespace TapirDotNET.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for TpResourceForm.
	/// </summary>
	public partial class TpResourceForm : TpPage
	{
		public TpResource mrResource;
		public bool mRemoved = false;
	

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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.PreRender += new EventHandler(TpResourceForm_PreRender);
		}
		#endregion
	
		public TpResourceForm()
		{
		}

		protected void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
		}
		
		private void TpResourceForm_PreRender(object sender, EventArgs e)
		{
			Utility.OrderedMap errors = new TpDiagnostics().GetMessages();

			TpConfigManager config_manager = new TpConfigManager();
			int num_steps = config_manager.GetNumSteps(); 

			string html = "<table align=\"center\" width=\"90%\" cellspacing=\"1\" cellpadding=\"1\" bgcolor=\"#999999\"> " +
				"<tr>";

			for (int i = 1; i <= num_steps; ++i)
			{
				TpWizardForm wiz = (TpWizardForm)config_manager.GetWizardPage(this, i);
				
				html += "<td align=\"center\" valign=\"middle\" width=\"" + ((int)(100 / num_steps)).ToString() + 
					"%\" bgcolor=\"#f5f5ff\"><a href=\"" + Request.Path + 
					"?form=" + i.ToString() + "&resource=" + mrResource.GetCode() + 
					"\" class=\"text\">" + wiz.GetLabel() + 
					"</a></td>";
			}
			
			html += "</tr></table>";

			if (Utility.OrderedMap.CountElements(errors) > 0)
			{
				html += string.Format("\n<br/><span class=\"error\">{0}</span>", Utility.StringSupport.Nl2br(Utility.StringSupport.Join("<br/>", errors)));
			}
	
			if (this.mMessage != null && this.mMessage.Length > 0)
			{
				html += string.Format("\n<br/><span class=\"msg\">{0}</span>", Utility.StringSupport.Nl2br(this.mMessage));
			}
																							
			HtmlGenericControl ctrl = new HtmlGenericControl();
			ctrl.InnerHtml = html;
            panel1.Controls.Add(ctrl);
		}

		public void Initialise(TpResource rResource)
		{
			this.mrResource = rResource;
		}
		
		
		public virtual void  HandleEvents()
		{
			TpResources r_resources = new TpResources().GetInstance();
			
			if (HttpContext.Current.Request["remove"] != null)
			{
				if (Utility.TypeSupport.ToBoolean(r_resources.RemoveResource(this.mrResource.GetCode())))
				{
					this.mRemoved = true;
				}
			}
		}// end of member function HandleEvents
		
		public virtual bool RemovedResource()
		{
			return this.mRemoved;
		}// end of member function RemovedResource
		

	}
}
