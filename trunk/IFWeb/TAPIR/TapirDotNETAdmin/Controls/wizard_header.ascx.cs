using System;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace TapirDotNET.Controls
{
	/// <summary>
	/// Summary description for wizard_header.
	/// </summary>
	public partial class wizard_header : UserControl
	{
		TpResource mResource = null;

		public TpConfigManager config_manager;
		public string mMessage;
		
		protected TpWizardForm form = null;


		protected int selColor = 0xd2e6f8;
		protected int unselColor = 0xf5f5f5;


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

		}
		#endregion

		public void Initialise(TpWizardForm form)
		{
			this.mResource = form.mResource;
			this.form = form;
		}

		protected void Page_Load(object sender, System.EventArgs e)
		{
			ID = "wizard_header";

			if (form.InWizardMode())
			{
				resName.Text = "New resource";
			}
			else
			{
				resName.Text = form.GetResourceId();
			}

			if (form.InWizardMode())
			{
				headerTable.Width = new Unit("60%");

				TableRow tr = new TableRow();

				TableCell cell = new TableCell();
				cell.HorizontalAlign = HorizontalAlign.Center;
				cell.VerticalAlign = VerticalAlign.Middle;
				cell.CssClass = "label";
				cell.BackColor = System.Drawing.Color.FromArgb(unselColor);
				cell.Text = "step " + form.GetStep().ToString() + "    " + form.GetLabel();

				tr.Cells.Add(cell);

				headerTable.Rows.Add(tr);
			}
			else
			{
				headerTable.Width = new Unit("90%");

				config_manager = new TpConfigManager();			
				TableRow tr = new TableRow();

				for (int i = 1; i <= form.GetNumSteps(); ++i)
				{
					TpWizardForm wiz = (TpWizardForm)config_manager.GetWizardPage(this, i);
		
					int bg_color = (form.GetStep() == i) ? selColor : unselColor;			
					string class_Renamed = (form.GetStep() == i)?"label":"text";

					TableCell cell = new TableCell();
					cell.HorizontalAlign = HorizontalAlign.Center;
					cell.VerticalAlign = VerticalAlign.Middle;
					cell.CssClass = "label";
					cell.BackColor = System.Drawing.Color.FromArgb(bg_color);
					cell.Text = "<a href='" + Request.Path + "?form=" + i.ToString() + "&resource=" + form.GetResourceId() + "' class=" + class_Renamed + ">" + wiz.GetLabel() + "</a>";
					cell.Width = new Unit(((int)(100 / form.GetNumSteps())).ToString() + "%");

					tr.Cells.Add(cell);
				}		
				
				headerTable.Rows.Add(tr);
			}
	
			string error_msg;
			if (this.mResource == null)
			{
				error_msg = "Wizard form not properly initialized! (resource is null)";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error_msg, TpConfigManager.DIAG_ERROR);
			}
		
			Utility.OrderedMap errors = new TpDiagnostics().GetMessages();
			
			string html = "";
			if (form.mMessage != null)
			{
				html = string.Format("\n<br/><span class=\"msg\">{0}</span>", Utility.StringSupport.Nl2br(form.mMessage));
			}
	
			if (System.Convert.ToBoolean(Utility.OrderedMap.CountElements(errors)))
			{
				html += string.Format("\n<br/><span class=\"error\">{0}</span>", Utility.StringSupport.Nl2br(Utility.StringSupport.Join("<br/>", errors)));
			}
			errorLabel.Text = html;

			Page.RegisterHiddenField("scroll", System.Web.HttpContext.Current.Request.Params["scroll"]);
			
		}
	}
}
