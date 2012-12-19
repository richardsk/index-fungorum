namespace TapirDotNET.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for FixedColumnMappingControl.
	/// </summary>
	public partial class FixedValueMappingControl : System.Web.UI.UserControl
	{
		public FixedValueMapping Mapping;


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
			this.PreRender += new EventHandler(FixedColumnMappingControl_PreRender);
		}
		#endregion

		public FixedValueMappingControl()
		{
		}

		public FixedValueMappingControl(FixedValueMapping fcm)
		{
			Mapping = fcm;
		}

		protected void Page_Load(object sender, System.EventArgs e)
		{
			ID = "FixedColumnMappingControl";
		}

		private void FixedColumnMappingControl_PreRender(object sender, EventArgs e)
		{
			TextBox txt = new TextBox();
			txt.Columns = 30;
			if (Mapping != null)
			{
				txt.ID = Mapping.GetInputName();
				txt.Text = Mapping.GetValue();
			}
	
			panel1.Controls.Add(txt);
			
			if (Mapping != null)
			{
				HtmlGenericControl ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = new TpHtmlUtils().GetCombo(Mapping.GetLocalTypeInputName(), Mapping.GetLocalType(), Mapping.GetLocalTypes(), false, 0, "");
				panel1.Controls.Add(ctrl);
			}
		}
	}
}
