namespace TapirDotNET.Controls
{
	using System;
	using System.Data;
	using System.Drawing;
	using System.Web;
	using System.Web.UI.WebControls;
	using System.Web.UI.HtmlControls;

	/// <summary>
	///		Summary description for MessageControl.
	/// </summary>
	public partial class MessageControl : TpPage
	{

		protected void Page_Load(object sender, System.EventArgs e)
		{
			this.PreRender += new EventHandler(MessageControl_PreRender);
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
		///		Required method for Designer support - do not modify
		///		the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{

		}
		#endregion

		private void MessageControl_PreRender(object sender, EventArgs e)
		{
			if (mMessage != null && mMessage.Length > 0)
			{
				Label1.Text = mMessage;
			}
		}
	}
}
