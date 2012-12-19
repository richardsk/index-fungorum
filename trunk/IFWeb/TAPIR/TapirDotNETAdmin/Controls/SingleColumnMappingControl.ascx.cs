using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace TapirDotNET.Controls
{
	/// <summary>
	/// Summary description for SingleColumnMapping.
	/// </summary>
	public partial class SingleColumnMappingControl : UserControl
	{
		public SingleColumnMapping Mapping;


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
			this.Load += new EventHandler(SingleColumnMappingControl_Load);
			this.PreRender += new EventHandler(SingleColumnMappingControl_PreRender);
		}
		#endregion

		public SingleColumnMappingControl()
		{
		}

		public SingleColumnMappingControl(SingleColumnMapping scm)
		{
			Mapping = scm;
		}

		private void SingleColumnMappingControl_Load(object sender, EventArgs e)
		{
			ID = "SingleColumnMappingControl";
		}

		private void SingleColumnMappingControl_PreRender(object sender, EventArgs e)
		{
			LoadMapping();
		}

		private void LoadMapping()
		{
			if (Mapping != null)
			{
				HtmlGenericControl ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = new TapirDotNET.TpHtmlUtils().GetCombo(Mapping.GetInputName("table"), Mapping.GetTable(), Mapping.GetOptions("tables"), false, false, string.Format("document.forms[1].refresh.value='{0}';window.saveScroll();document.forms[1].submit();", Mapping.GetInputName("table"))) + "&nbsp";
				panel1.Controls.Add(ctrl);
		
				if (Mapping.GetTable() != null)
				{
					ctrl = new HtmlGenericControl();
					ctrl.InnerHtml = new TpHtmlUtils().GetCombo(Mapping.GetInputName("field"), Mapping.GetField(), Mapping.GetOptions("fields"), false, false, string.Format("document.forms[1].refresh.value='{0}';window.saveScroll();document.forms[1].submit();", Mapping.GetInputName("field")));		
					panel1.Controls.Add(ctrl);
				}
			
				ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = new TpHtmlUtils().GetCombo(Mapping.GetLocalTypeInputName(), Mapping.GetLocalType(), Mapping.GetLocalTypes(), false, 0, "");
				panel1.Controls.Add(ctrl);
			}
		}

	}
}
