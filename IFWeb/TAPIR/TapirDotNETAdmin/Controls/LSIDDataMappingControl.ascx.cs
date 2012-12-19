using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace TapirDotNET.Controls
{
	/// <summary>
	/// Summary description for LSIDDataMapping.
	/// </summary>
	partial class LSIDDataMappingControl : UserControl
	{
		public LSIDDataMapping Mapping;

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
			this.Load += new EventHandler(LSIDDataMappingControl_Load);
			this.PreRender += new EventHandler(LSIDDataMappingControl_PreRender);
		}
		#endregion

		public LSIDDataMappingControl()
		{
		}

		public LSIDDataMappingControl(LSIDDataMapping dm)
		{
			Mapping = dm;
		}

		private void LSIDDataMappingControl_Load(object sender, EventArgs e)
		{
			ID = "LSIDDataMappingControl";
		}

		private void LSIDDataMappingControl_PreRender(object sender, EventArgs e)
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
