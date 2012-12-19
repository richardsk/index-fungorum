using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TapirDotNET.Controls
{
	/// <summary>
	/// Summary description for wizard_footer.
	/// </summary>
	public partial class wizard_footer : UserControl
	{
		
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

		private TpWizardForm form = null;


		public void Initialise(TpWizardForm form)
		{
			this.form = form;
		}

		protected void Page_Load(object sender, System.EventArgs e)
		{
			ID = "wizard_footer";

			if (form.mStep != -1)
			{
				if (form.mWizardMode)
				{
					if (form.mStep > 1)
					{
						abortPanel.Visible = true;
					}	
			
					if (form.ReadyToProceed())
					{
						if (form.mStep < form.mNumSteps)
						{
							nextPanel.Visible = true;					      
						}
						else
						{	
							savePanel.Visible = true;
						}
				
					}
				}
				else
				{
					updatePanel.Visible = true;
				}
			}
		}
	}
}
