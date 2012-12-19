using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;


namespace TapirDotNET.Controls
{
	/// <summary>
	/// Summary description for TpMetadataForm.
	/// </summary>
	public partial class TpMetadataForm : TpWizardForm
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
			this.Load += new System.EventHandler(this.TpMetadataForm_Load);
			this.PreRender += new System.EventHandler(this.TpMetadataForm_PreRender);
                        
		}
		#endregion

		public int textarea_cols;
		public TpResourceMetadata r_metadata;
		public TpIndexingPreferences indexingPreferences;
		public TpRelatedEntity related_entity;
		public TpContact contact;

		
		public TpMetadataForm()
		{
			mStep = 1;
			mLabel = "Metadata";	
			
			textarea_cols = 50;
		}
		
		protected void TpMetadataForm_Load(object sender, EventArgs e)
		{
			this.ID = "TpMetadataForm_Control";

		}
		
		protected void TpMetadataForm_PreRender(object sender, System.EventArgs e)
        {
			DisplayMetadata();		
		}

        protected override void Render(HtmlTextWriter writer)
        {
            base.Render(writer);
        }

		private void DisplayMetadata()
		{
			string cmb;
			HtmlGenericControl genCmb;
			TextBox txtBox;
			string cbox;

			mid.Text = r_metadata.GetId();
			accesspoint.Text = r_metadata.GetAccesspoint();

			Page.RegisterHiddenField("mtype", r_metadata.GetType());
			Page.RegisterHiddenField("mcreated", HttpUtility.UrlEncode(r_metadata.GetCreated()));

			//titles
			titlesPanel.Controls.Clear();
			
			HtmlGenericControl c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("title", true);
			titlesPanel.Controls.Add(c);

			HtmlGenericControl lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			titlesPanel.Controls.Add(lineBreak);		

			int cnt = 0;
			int total = r_metadata.GetTitles().Count;

			foreach (object t in r_metadata.GetTitles().Values)
			{
				TpLangString title = (TpLangString)t;

				++cnt; 

				txtBox = new TextBox();
				txtBox.ID = "title_" + cnt.ToString();
				txtBox.EnableViewState = false;
				txtBox.Text = title.GetValue();
				txtBox.Columns = 65;
				titlesPanel.Controls.Add(txtBox);

				cmb = new TapirDotNET.TpHtmlUtils().GetCombo("title_lang_" + cnt.ToString(), title.GetLang(), GetOptions("lang"), false, 0, "");
				genCmb = new HtmlGenericControl();
				genCmb.InnerHtml = cmb;
				titlesPanel.Controls.Add(genCmb);

				if (total > 1)
				{
					Button but = new Button();
					but.ID = "del_title_" + cnt.ToString();
					but.Text = "remove";
					titlesPanel.Controls.Add(but);
				}

				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				titlesPanel.Controls.Add(lineBreak);		
							
			}

			HtmlGenericControl at = new HtmlGenericControl();
			at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add title\" name=\"add_title\">";
			titlesPanel.Controls.Add(at);

			//descriptions
			descPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("description", true);
			descPanel.Controls.Add(c);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			descPanel.Controls.Add(lineBreak);		

			cnt = 0;
			total = r_metadata.GetDescriptions().Count;

			foreach (object t in r_metadata.GetDescriptions().Values)
			{
				TpLangString desc = (TpLangString)t;

				++cnt; 

				txtBox = new TextBox();
				txtBox.TextMode = TextBoxMode.MultiLine;
				txtBox.Rows = 5;
				txtBox.ID = "description_" + cnt.ToString();
				txtBox.Text = desc.GetValue();
				txtBox.Columns = 65;
				descPanel.Controls.Add(txtBox);

				cmb = new TapirDotNET.TpHtmlUtils().GetCombo("description_lang_" + cnt.ToString(), desc.GetLang(), GetOptions("lang"), false, 0, "");
				genCmb = new HtmlGenericControl();
				genCmb.InnerHtml = cmb;
				descPanel.Controls.Add(genCmb);

				if (total > 1)
				{
					Button but = new Button();
					but.ID = "del_description_" + cnt.ToString();
					but.Text = "remove";
					descPanel.Controls.Add(but);
				}

				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				descPanel.Controls.Add(lineBreak);		
							
			}

			at = new HtmlGenericControl();
			at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add description\" name=\"add_description\">";
			descPanel.Controls.Add(at);
			
			
			//subjects
			subjPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("subjects", false);
			subjPanel.Controls.Add(c);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			subjPanel.Controls.Add(lineBreak);		

			cnt = 0;

			foreach (object t in r_metadata.GetSubjects().Values)
			{
				TpLangString subj = (TpLangString)t;

				++cnt; 

				txtBox = new TextBox();
				txtBox.ID = "subjects_" + cnt.ToString();
				txtBox.Text = subj.GetValue();
				txtBox.Columns = 65;
				subjPanel.Controls.Add(txtBox);

				cmb = new TapirDotNET.TpHtmlUtils().GetCombo("subjects_lang_" + cnt.ToString(), subj.GetLang(), GetOptions("lang"), false, 0, "");
				genCmb = new HtmlGenericControl();
				genCmb.InnerHtml = cmb;
				subjPanel.Controls.Add(genCmb);

                Button but = new Button();
				but.ID = "del_subjects_" + cnt.ToString();
				but.Text = "remove";
				subjPanel.Controls.Add(but);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				subjPanel.Controls.Add(lineBreak);		
							
			}

			at = new HtmlGenericControl();
			at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add subjects\" name=\"add_subjects\">";
			subjPanel.Controls.Add(at);

			
			//citations
			bibPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("bibliographicCitation", false);
			bibPanel.Controls.Add(c);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			bibPanel.Controls.Add(lineBreak);		

			cnt = 0;

			foreach (object t in r_metadata.GetBibliographicCitations().Values)
			{
				TpLangString bib = (TpLangString)t;

				++cnt; 

				txtBox = new TextBox();
				txtBox.ID = "bibliographicCitation_" + cnt.ToString();
				txtBox.Text = bib.GetValue();
				txtBox.TextMode = TextBoxMode.MultiLine;
				txtBox.Rows = 5;
				txtBox.Columns = 65;
				bibPanel.Controls.Add(txtBox);

				cmb = new TapirDotNET.TpHtmlUtils().GetCombo("bibliographicCitation_lang_" + cnt.ToString(), bib.GetLang(), GetOptions("lang"), false, 0, "");
				genCmb = new HtmlGenericControl();
				genCmb.InnerHtml = cmb;
				bibPanel.Controls.Add(genCmb);

				Button but = new Button();
				but.ID = "del_bibliographicCitation_" + cnt.ToString();
				but.Text = "remove";
				bibPanel.Controls.Add(but);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				bibPanel.Controls.Add(lineBreak);		
							
			}

			at = new HtmlGenericControl();
			at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add citation\" name=\"add_bibliographicCitation\">";
			bibPanel.Controls.Add(at);

			
			//rights
			rightsPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("rights", false);
			rightsPanel.Controls.Add(c);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			rightsPanel.Controls.Add(lineBreak);		

			cnt = 0;

			foreach (object t in r_metadata.GetRights().Values)
			{
				TpLangString right = (TpLangString)t;

				++cnt; 

				txtBox = new TextBox();
				txtBox.ID = "rights_" + cnt.ToString();
				txtBox.Text = right.GetValue();
				txtBox.TextMode = TextBoxMode.MultiLine;
				txtBox.Rows = 5;
				txtBox.Columns = 65;
				rightsPanel.Controls.Add(txtBox);

				cmb = new TapirDotNET.TpHtmlUtils().GetCombo("rights_lang_" + cnt.ToString(), right.GetLang(), GetOptions("lang"), false, 0, "");
				genCmb = new HtmlGenericControl();
				genCmb.InnerHtml = cmb;
				rightsPanel.Controls.Add(genCmb);

				Button but = new Button();
				but.ID = "del_rights_" + cnt.ToString();
				but.Text = "remove";
				rightsPanel.Controls.Add(but);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				rightsPanel.Controls.Add(lineBreak);		
							
			}

			at = new HtmlGenericControl();
			at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add rights\" name=\"add_rights\">";
			rightsPanel.Controls.Add(at);


			//db language
			
			dbLangPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("language", true);
			dbLangPanel.Controls.Add(c);
			
			cmb = new TapirDotNET.TpHtmlUtils().GetCombo("language", r_metadata.GetLanguage(), GetOptions("lang"), false, 0, "");
			genCmb = new HtmlGenericControl();
			genCmb.InnerHtml = cmb;
			dbLangPanel.Controls.Add(genCmb);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			dbLangPanel.Controls.Add(lineBreak);	
	
			//indexing preferences

			prefsPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("indexingPreferences", false);
			prefsPanel.Controls.Add(c);
			
			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/><br/>";
			prefsPanel.Controls.Add(lineBreak);	
			
			indexingPreferences = r_metadata.GetIndexingPreferences();

			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("startTime", false);
			prefsPanel.Controls.Add(c);

			cmb = new TapirDotNET.TpHtmlUtils().GetCombo("hour", indexingPreferences.GetHour(), this.GetOptions("hour"), false, 0, "");
			genCmb = new HtmlGenericControl();
			genCmb.InnerHtml = cmb;
			prefsPanel.Controls.Add(genCmb);
			
			cmb = new TapirDotNET.TpHtmlUtils().GetCombo("ampm", indexingPreferences.GetAmPm(), this.GetOptions("ampm"), false, 0, "");
			genCmb = new HtmlGenericControl();
			genCmb.InnerHtml = cmb;
			prefsPanel.Controls.Add(genCmb);
			
			cmb = new TapirDotNET.TpHtmlUtils().GetCombo("timezone", indexingPreferences.GetTimezone(), this.GetOptions("timezone"), false, 0, "");
			genCmb = new HtmlGenericControl();
			genCmb.InnerHtml = cmb;
			prefsPanel.Controls.Add(genCmb);

			c = new HtmlGenericControl();
			c.InnerHtml = "&nbsp;" + GetHtmlLabel("maxDuration", false);
			prefsPanel.Controls.Add(c);

			cmb = new TapirDotNET.TpHtmlUtils().GetCombo("maxDuration", indexingPreferences.GetMaxDuration(), this.GetOptions("maxDuration"), false, 0, "");
			genCmb = new HtmlGenericControl();
			genCmb.InnerHtml = cmb;
			prefsPanel.Controls.Add(genCmb);
			
			c = new HtmlGenericControl();
			c.InnerHtml = "&nbsp;" + GetHtmlLabel("frequency", false);
			prefsPanel.Controls.Add(c);

			cmb = new TapirDotNET.TpHtmlUtils().GetCombo("frequency", indexingPreferences.GetFrequency(), this.GetOptions("frequency"), false, 0, "");
			genCmb = new HtmlGenericControl();
			genCmb.InnerHtml = cmb;
			prefsPanel.Controls.Add(genCmb);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			prefsPanel.Controls.Add(lineBreak);	

			//related entities
			relEntPanel.Controls.Clear();
			
			c = new HtmlGenericControl();
			c.InnerHtml = GetHtmlLabel("relatedEntities", true);
			relEntPanel.Controls.Add(c);

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			relEntPanel.Controls.Add(lineBreak);		

			cnt = 0;

			foreach (object t in r_metadata.GetRelatedEntities().Values)
			{
				TpRelatedEntity relEnt = (TpRelatedEntity)t;

				++cnt; 

				TpEntity ent = relEnt.GetEntity();
				string entPrefix = "entity_" + cnt.ToString();

				Panel entPanel = new Panel();
				entPanel.CssClass = "box1";
				entPanel.HorizontalAlign = HorizontalAlign.Left;
				relEntPanel.Controls.Add(entPanel);
				
				HtmlGenericControl hidden = new HtmlGenericControl();
				hidden.InnerHtml = "<input type=\"hidden\" name=\"" + entPrefix + "\" value=\"\"/>";
				entPanel.Controls.Add(hidden);

				//entity identifier 
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("entityId", true);
				entPanel.Controls.Add(c);

				txtBox = new TextBox();
				txtBox.ID = entPrefix + "_id";
				txtBox.Text = ent.GetIdentifier();
				txtBox.Columns = 60;
				entPanel.Controls.Add(txtBox);

				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/><br/>";
				entPanel.Controls.Add(lineBreak);	

				//entity names 
				Panel entNamePanel = new Panel();
				entNamePanel.CssClass = "box2";
				entNamePanel.HorizontalAlign = HorizontalAlign.Left;
				entPanel.Controls.Add(entNamePanel);
				
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("entityName", true);
				entNamePanel.Controls.Add(c);

				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				entNamePanel.Controls.Add(lineBreak);

				int cnt2 = 0;
				int total2 = ent.GetNames().Count;

				foreach (TpLangString n in ent.GetNames().Values)
				{
					cnt2++;
					
					txtBox = new TextBox();
					txtBox.ID = entPrefix + "_name_" + cnt2.ToString();
					txtBox.Text = n.GetValue();
					txtBox.Columns = 45;
					entNamePanel.Controls.Add(txtBox);

					cmb = new TapirDotNET.TpHtmlUtils().GetCombo(entPrefix + "_name_lang_" + cnt2.ToString(), n.GetLang(), GetOptions("lang"), false, 0, "");
					genCmb = new HtmlGenericControl();
					genCmb.InnerHtml = cmb;
					entNamePanel.Controls.Add(genCmb);

					if (total2 > 1)
					{
						Button but = new Button();
						but.ID = "del_" + entPrefix + "_name_" + cnt2.ToString();
						but.Text = "remove";
						entNamePanel.Controls.Add(but);
					}

					lineBreak = new HtmlGenericControl();
					lineBreak.InnerHtml = "<br/>";
					entNamePanel.Controls.Add(lineBreak);							
				}

				at = new HtmlGenericControl();
				at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add name\" name=\"add_" + entPrefix + "_name\">";
				entNamePanel.Controls.Add(at);
				
				//entity roles 
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("entityRoles", true);
				entPanel.Controls.Add(c);
			
				cbox = new TpHtmlUtils().GetCheckboxes(entPrefix + "_role", relEnt.GetRoles(), GetOptions("entityRoles"));
				c = new HtmlGenericControl ();
				c.InnerHtml = cbox;
				entPanel.Controls.Add(c);

				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/><br/>";
				entPanel.Controls.Add(lineBreak);	

				//entity acronym 
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("acronym", true);
				entPanel.Controls.Add(c);
				
				txtBox = new TextBox();
				txtBox.ID = entPrefix + "_acronym";
				txtBox.Text = ent.GetAcronym();
				txtBox.Columns = 20;
				entPanel.Controls.Add(txtBox);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				entPanel.Controls.Add(lineBreak);

				//entity description
				Panel dPanel = new Panel();
				dPanel.CssClass = "box2";
				dPanel.HorizontalAlign = HorizontalAlign.Left;
				entPanel.Controls.Add(dPanel);
				
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("entityDescription", false);
				dPanel.Controls.Add(c);

				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				dPanel.Controls.Add(lineBreak);	

				cnt2 = 0;
				total2 = ent.GetDescriptions().Count;

				foreach (TpLangString ed in ent.GetDescriptions().Values)
				{
					++cnt2;
					
					txtBox = new TextBox();
					txtBox.ID = entPrefix + "_description_" + cnt2.ToString();
					txtBox.Text = ed.GetValue();
					txtBox.TextMode = TextBoxMode.MultiLine;
					txtBox.Rows = 3;
					txtBox.Columns = 45;
					dPanel.Controls.Add(txtBox);

					cmb = new TapirDotNET.TpHtmlUtils().GetCombo(entPrefix + "_description_lang_" + cnt2.ToString(), ed.GetLang(), GetOptions("lang"), false, 0, "");
					genCmb = new HtmlGenericControl();
					genCmb.InnerHtml = cmb;
					dPanel.Controls.Add(genCmb);

					if (total2 > 1)
					{
						Button but = new Button();
						but.ID = "del_" + entPrefix + "_description_" + cnt2.ToString();
						but.Text = "remove";
						dPanel.Controls.Add(but);
					}

					lineBreak = new HtmlGenericControl();
					lineBreak.InnerHtml = "<br/>";
					dPanel.Controls.Add(lineBreak);							
				}

				at = new HtmlGenericControl();
				at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add description\" name=\"add_" + entPrefix + "_description\">";
				dPanel.Controls.Add(at);
				
				//entity address
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("address", true);
				entPanel.Controls.Add(c);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				entPanel.Controls.Add(lineBreak);	
				
				txtBox = new TextBox();
				txtBox.ID = entPrefix + "_address";
				txtBox.Text = ent.GetAddress();
				txtBox.TextMode = TextBoxMode.MultiLine;
				txtBox.Rows = 2;
				txtBox.Columns = textarea_cols;
				entPanel.Controls.Add(txtBox);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				entPanel.Controls.Add(lineBreak);	

				//entity coordinates 
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("longitude", false);
				entPanel.Controls.Add(c);
				
				txtBox = new TextBox();
				txtBox.ID = entPrefix + "_longitude";
				txtBox.Text = ent.GetLongitude().ToString();
				txtBox.Columns = 12;
				entPanel.Controls.Add(txtBox);
				
				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("latitude", false);
				entPanel.Controls.Add(c);
				
				txtBox = new TextBox();
				txtBox.ID = entPrefix + "_latitude";
				txtBox.Text = ent.GetLatitude().ToString();
				txtBox.Columns = 12;
				entPanel.Controls.Add(txtBox);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/><br/>";
				entPanel.Controls.Add(lineBreak);

				//entity logoURL
				string html = "<table width=\"100%\">" + 
					"<tr>" + 
					"<td width=\"35%\">" + 
					GetHtmlLabel("logoURL", false) +
					"</td>" + 
					"<td width=\"65%\"> " +
					"<input type=\"text\" name=\"" + entPrefix + "_logoURL\" value=\"" + ent.GetLogoUrl() + "\" size=\"50\"/>" +
					"<br/>" + 
					"</td>" + 
					"</tr>" + 
					"<tr>" +
					"<td>" +
					GetHtmlLabel("relatedInformation", false) +
					"</td>" +
					"<td>" +
					"<input type=\"text\" name=\"" + entPrefix + "_relatedInformation\" value=\"" + ent.GetRelatedInformation() + "\" size=\"50\"/>" +
					"<br/>" +
					"</td>" +
					"</tr>" +
					"</table>";
				c = new HtmlGenericControl();
				c.InnerHtml = html;
				entPanel.Controls.Add(c);

				//related contacts 
				Panel rcPanel = new Panel();
				rcPanel.HorizontalAlign = HorizontalAlign.Left;
				rcPanel.CssClass = "box2";
				entPanel.Controls.Add(rcPanel);

				c = new HtmlGenericControl();
				c.InnerHtml = GetHtmlLabel("relatedContacts", true);
				rcPanel.Controls.Add(c);
				
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/>";
				rcPanel.Controls.Add(lineBreak);

				int cnt3 = 0;
				int total3 = ent.GetRelatedContacts().Count;

				foreach (TpRelatedContact rc in ent.GetRelatedContacts().Values)
				{
					++cnt3;

					TpContact contact = rc.GetContact();
					string contPrefix = entPrefix + "_contact_" + cnt3.ToString();

					Panel contPanel = new Panel();
					contPanel.CssClass = "box1";
					contPanel.HorizontalAlign = HorizontalAlign.Left;
					rcPanel.Controls.Add(contPanel);

					c = new HtmlGenericControl();
					c.InnerHtml = "<input type=\"hidden\" name=\"" + contPrefix + "\" value=\"\"/>";
					contPanel.Controls.Add(c);

					//contact full name
					c = new HtmlGenericControl();
					c.InnerHtml = GetHtmlLabel("fullName", true);
					contPanel.Controls.Add(c);
					
					txtBox = new TextBox();
					txtBox.ID = contPrefix + "_fullname";
					txtBox.Text = contact.GetFullName();
					txtBox.Columns = 60;
					contPanel.Controls.Add(txtBox);
					
					lineBreak = new HtmlGenericControl();
					lineBreak.InnerHtml = "<br/><br/>";
					contPanel.Controls.Add(lineBreak);
					
					//contact roles 
					c = new HtmlGenericControl();
					c.InnerHtml = GetHtmlLabel("contactRoles", true);
					contPanel.Controls.Add(c);

					cbox = new TpHtmlUtils().GetCheckboxes(contPrefix + "_role", rc.GetRoles(), GetOptions("contactRoles"));
					c = new HtmlGenericControl ();
					c.InnerHtml = cbox;
					contPanel.Controls.Add(c);
					
					lineBreak = new HtmlGenericControl();
					lineBreak.InnerHtml = "<br/>";
					contPanel.Controls.Add(lineBreak);
					
					//contact titles
					Panel ctPanel = new Panel();
					ctPanel.CssClass = "box2";
					ctPanel.HorizontalAlign = HorizontalAlign.Left;
					contPanel.Controls.Add(ctPanel);

					c = new HtmlGenericControl();
					c.InnerHtml = GetHtmlLabel("contactTitle", false);
					ctPanel.Controls.Add(c);
					
					lineBreak = new HtmlGenericControl();
					lineBreak.InnerHtml = "<br/>";
					ctPanel.Controls.Add(lineBreak);

					int cnt4 = 0;
					foreach (TpLangString ctitle in contact.GetTitles().Values)
					{
						++cnt4;

						txtBox = new TextBox();
						txtBox.ID = contPrefix + "_title_" + cnt4.ToString();
						txtBox.Text = ctitle.GetValue();
						txtBox.Columns = 30;
						ctPanel.Controls.Add(txtBox);
						
						cmb = new TapirDotNET.TpHtmlUtils().GetCombo(contPrefix + "_title_lang_" + cnt4.ToString(), ctitle.GetLang(), GetOptions("lang"), false, 0, "");
						genCmb = new HtmlGenericControl();
						genCmb.InnerHtml = cmb;
						ctPanel.Controls.Add(genCmb);
						
						Button but = new Button();
						but.ID = "del_" + contPrefix + "_title_" + cnt4.ToString();
						but.Text = "remove";
						ctPanel.Controls.Add(but);
						
						lineBreak = new HtmlGenericControl();
						lineBreak.InnerHtml = "<br/>";
						ctPanel.Controls.Add(lineBreak);
					}
					
					at = new HtmlGenericControl();
					at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add title\" name=\"add_" + contPrefix + "_title\">";
					ctPanel.Controls.Add(at);

					//contact e-mail 
					c = new HtmlGenericControl();
					c.InnerHtml = "<table width=\"100%\">" + 
						"<tr>" + 
						"<td width=\"20%\">" +
						GetHtmlLabel("email", true) +
						"</td>" +
						"<td width=\"80%\">" +
						"<input type=\"text\" name=\"" + contPrefix + "_email\" value=\"" + contact.GetEmail() + "\" size=\"40\"/>" +
						"<br/>" +
						"</td>" +
						"</tr>" +
						"<tr>" +
						"<td>" +
						GetHtmlLabel("telephone", false) +
						"</td>" +
						"<td>" +
						"<input type=\"text\" name=\"" + contPrefix + "_telephone\" value=\"" + contact.GetTelephone() + "\" size=\"40\"/>" +
						"</td>" +
						"</tr>" +
						"</table>";
					contPanel.Controls.Add(c);

					if (total3 > 1)
					{					
						Button but = new Button();
						but.ID = "del_" + contPrefix;
						but.Text = "remove contact";
						rcPanel.Controls.Add(but);						
					}
				}
			
				lineBreak = new HtmlGenericControl();
				lineBreak.InnerHtml = "<br/><br/>";
				rcPanel.Controls.Add(lineBreak);

				at = new HtmlGenericControl();
				at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add related contact\" name=\"add_" + entPrefix + "_contact\">";
				rcPanel.Controls.Add(at);

				if (total > 1)
				{
					lineBreak = new HtmlGenericControl();
					lineBreak.InnerHtml = "<br/>";
					entPanel.Controls.Add(lineBreak);
						
					Button but = new Button();
					but.ID = "del_" + entPrefix;
					but.Text = "remove entity";
					entPanel.Controls.Add(but);
				}
			}

			lineBreak = new HtmlGenericControl();
			lineBreak.InnerHtml = "<br/>";
			relEntPanel.Controls.Add(lineBreak);

			at = new HtmlGenericControl();
			at.InnerHtml = "<INPUT onclick=\"saveScroll()\" type=\"submit\" value=\"add related entity\" name=\"add_entity\">";
			relEntPanel.Controls.Add(at);


		}
		
		protected void mid_TextChanged(object sender, System.EventArgs e)
		{
			string currentAccesspoint = r_metadata.GetAccesspoint();
			string currentLocalId = r_metadata.GetId();
			string[] parts = currentAccesspoint.Split('/');
		
			if ( parts.Length > 2 && ( parts[parts.Length-3] == "tapir.aspx" || parts[parts.Length-2] == "tapir.aspx" ) )
			{
				string newAccessPoint = "";
				for (int i = 0; i < parts.Length; i++ )
				{
					if ( i > 0 )
					{
						newAccessPoint += "/";
						if ( parts[i-1] == "tapir.aspx" )
						{
							newAccessPoint += currentLocalId;
						}
						else
						{
							newAccessPoint += parts[i];
						}
					}
					else
					{
						newAccessPoint += parts[i];
					}
				}
				r_metadata.SetAccesspoint(newAccessPoint);
			}			
		}

		public override void  LoadDefaults()
		{
			string msg;
			string metadata_file;

			r_metadata = this.mResource.GetMetadata();
			
			if (this.mResource.HasMetadata())
			{
				msg = "If you have just imported this resource, please complete at least the mandatory fields below\n(with a " + TpConfigManager.TP_MANDATORY_FIELD_FLAG + "before the label) and revise the next forms to finish the configuration process.";
				
				metadata_file = this.mResource.GetMetadataFile();
				
				try
				{
					StreamReader rdr = File.OpenText(metadata_file);
					string xml = rdr.ReadToEnd();
					rdr.Close();

					xml = xml.Replace("[LAST_MODIFIED_DATE]", mResource.GetSettings().GetModified());
					xml = xml.Replace("[ACCESS_POINT]", mResource.GetAccesspoint());

					r_metadata.LoadFromXml(this.mResource.GetCode(), xml);
				}
				catch(Exception )
				{
					string error = "Could not open metadata file.";
					new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
					return;
				}
				
				
				r_metadata.SetAccesspoint(this.mResource.GetAccesspoint());
				
				// Show possible errors
				r_metadata.Validate(true);
				
				if (new TpDiagnostics().Count(new Utility.OrderedMap(TpConfigManager.DIAG_ERROR, TpConfigManager.DIAG_FATAL)) > 0)
				{
					msg += "\nThe errors below may also give you more information.";
				}
				
				this.SetMessage(msg);
			}
			else
			{
				this.SetMessage("Configuring new resources involves six steps.\nFirst you should fill in this form with metadata about the resource.\nYou can find more information about each field by clicking over the label.\nMandatory fields have " + TpConfigManager.TP_MANDATORY_FIELD_FLAG + "before the label.");
				
				r_metadata.LoadDefaults();
			}
		}// end of member function LoadDefaults
		
		public override void  LoadFromSession()
		{
			r_metadata = this.mResource.GetMetadata();
			r_metadata.LoadFromSession();
		}// end of member function LoadFromSession
		
		public override void  LoadFromXml()
		{
			r_metadata = this.mResource.GetMetadata();
			string metadata_file;
			string accesspoint;
			string err_str;

			
			if (this.mResource.HasMetadata())
			{
				metadata_file = this.mResource.GetMetadataFile();
				
				StreamReader rdr = File.OpenText(metadata_file);
				string xml = rdr.ReadToEnd();
				rdr.Close();
				
				xml = xml.Replace("[LAST_MODIFIED_DATE]", mResource.GetSettings().GetModified());
				xml = xml.Replace("[ACCESS_POINT]", mResource.GetAccesspoint());

				r_metadata.LoadFromXml(this.mResource.GetCode(), xml);
				
				accesspoint = this.mResource.GetAccesspoint();
				
				if (!Utility.VariableSupport.Empty(accesspoint))
				{
					r_metadata.SetAccesspoint(accesspoint);
				}
				
				// Call this method just to show possible errors
				this.mResource.ConfiguredMetadata();
			}
			else
			{
				err_str = "There is no metadata XML configuration to be loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return ;
			}
		}// end of member function LoadFromXml
		
		public override void  HandleEvents()
		{					
			// Clicked next?	
			
			TpResources r_resources = null;
			if (HttpContext.Current.Request.Form["next"] != null || HttpContext.Current.Request.Form["update"] != null)
			{				
				r_metadata = this.mResource.GetMetadata();
				
				if (!r_metadata.Validate(true))
				{
					return ;
				}
				
				if (HttpContext.Current.Request.Form["next"] != null)
				{
					// Set code so that GetMetadataFile (called next) can determine
					// the name of the file for new resources. 
					this.mResource.SetCode(r_metadata.GetId());
				}
				
				if (!this.mResource.SaveMetadata(true))
				{
					return ;
				}
				
				if (HttpContext.Current.Request.Form["update"] != null)
				{
					this.SetMessage("Changes successfully saved!");
				}
				else
				{
					r_resources = new TpResources().GetInstance();
					
					if (r_resources.GetResource(r_metadata.GetId(), true) == null)
					{
						r_resources.AddResource(this.mResource);
						
						if (!r_resources.Save())
						{
							return ;
						}
					}
				}
				
				// Update resource code
				HttpContext.Current.Session["resource"] = r_metadata.GetId();
				
				this.mDone = true;
			}
		}// end of member function HandleEvents
		
		public virtual string GetHtmlLabel(string labelId, bool required)
		{
			string label = "?";
			string doc = "";
			string css = (required)?"label_required":"label";
			string js;
			string form_label;
			string note;
			string html;
						
			if (labelId == "id")
			{
				label = "Local ID";
				doc = "A local identifier for the resource. This should be a short " + "sequence of characters that can be used directly in URLs. It " + "will be part of the default accesspoint.";
			}
			else if (labelId == "accesspoint")
			{
				label = "Accesspoint";
				doc = "URL of the service. The default URL has this form:" + "\nhttp://hostname/tapirdotnet/tapir.aspx/local_id/\n" + "Replace &quot;hostname&quot; with the correct value, " + "&quot;local_id&quot; with the resource local id, and " + "&quot;tapirdotnet&quot; with the corresponding " + "path that points to the &quot;tapirdotnet/www&quot; directory. " + "You may also consider creating a PURL (see: http://purl.org/) " + "to wrap your accesspoint.";
			}
			else if (labelId == "default_language")
			{
				label = "Default language for the metadata fields below";
				doc = "Default language to be considered for all " + "language aware metadata fields in this form " + "(when not already specified at the field level).";
			}
			else if (labelId == "title")
			{
				label = "Title";
				doc = "A title (name) for the resource.";
			}
			else if (labelId == "description")
			{
				label = "Description";
				doc = "Description may include but is not limited to: an abstract, table of contents, reference to a graphical representation of content or a free-text account of the content.";
			}
			else if (labelId == "subjects")
			{
				label = "Subjects";
				doc = "Subject and Keywords. Typically, a Subject will be expressed as keywords, key phrases or classification codes that describe a topic	of the resource. Recommended best practice is to select a value from a controlled vocabulary or formal classification scheme.";
			}
			else if (labelId == "bibliographicCitation")
			{
				label = "Citation";
				doc = "Recommended practice is to include sufficient bibliographic detail to identify the resource as unambiguously as possible, whether or not the citation is in a standard form.";
			}
			else if (labelId == "rights")
			{
				label = "Rights";
				doc = "Information about who can access the resource or an indication of its security status.";
			}
			else if (labelId == "relatedEntities")
			{
				label = "Related entities";
				doc = "Entities (companies, organisations, institutions) related to this service with their respective roles, e.g. publisher, data supplier.";
			}
			else if (labelId == "entityId")
			{
				label = "Entity identifier";
				doc = "A global unique identifier for the entity. It allows " + "the same entity to be recognized across different " + "providers. This is necessary because at a global level " + "different entities can have the same name or acronym. " + "There is no particular format for identifiers. Communities " + "and networks are encouraged to define a standard way " + "of assigning global unique identifiers for entities. " + "It can be for instance the uuid of the corresponding " + "business entity in a UDDI registry, the domain of the " + "organization on the web, an LSID, etc. In the absence " + "of a standard, just put the name or acronym or create " + "some identifier.";
			}
			else if (labelId == "acronym")
			{
				label = "Acronym";
				doc = "An acronym (code or short word) for the entity.";
			}
			else if (labelId == "entityName")
			{
				label = "Name";
				doc = "Entity name.";
			}
			else if (labelId == "entityDescription")
			{
				label = "Description";
				doc = "Entity description.";
			}
			else if (labelId == "logoURL")
			{
				label = "Logo (URL)";
				doc = "A URL to a small logo of the entity.";
			}
			else if (labelId == "address")
			{
				label = "Address";
				doc = "Entity physical address.";
			}
			else if (labelId == "relatedInformation")
			{
				label = "Related information (URL)";
				doc = "A URL where more information about this entity can found.";
			}
			else if (labelId == "longitude")
			{
				label = "Longitude";
				doc = "Longitude where the entity is located (in decimal degrees using datum WGS84).";
			}
			else if (labelId == "latitude")
			{
				label = "Latitude";
				doc = "Latitude where the entity is located (in decimal degrees using datum WGS84).";
			}
			else if (labelId == "fullName")
			{
				label = "Full name";
				doc = "Full name.";
			}
			else if (labelId == "contactTitle")
			{
				label = "Job Title";
				doc = "Job title (Curator, Director, etc.).";
			}
			else if (labelId == "telephone")
			{
				label = "Telephone";
				doc = "Telephone number.";
			}
			else if (labelId == "email")
			{
				label = "E-mail";
				doc = "E-mail address.";
			}
			else if (labelId == "language")
			{
				label = "Main language of the data provided by this resource";
				doc = "Main language of the content in the underlying database.";
			}
			else if (labelId == "indexingPreferences")
			{
				label = "Indexing preferences";
				doc = "Preferences related to external indexing.";
			}
			else if (labelId == "startTime")
			{
				label = "Start time";
				doc = "Prefered starting time for an external indexing procedure. " + "(note: 12AM means midnight, 12PM means midday)";
			}
			else if (labelId == "maxDuration")
			{
				label = "Max. duration";
				doc = "Maximum acceptable duration of an external indexing procedure.";
			}
			else if (labelId == "frequency")
			{
				label = "Frequency";
				doc = "Maximum acceptable frequency for external indexing procedures.";
			}
			else if (labelId == "entityRoles")
			{
				label = "Roles";
				doc = "Roles of the entity for this resource.";
			}
			else if (labelId == "relatedContacts")
			{
				label = "Related contacts";
				doc = "Contacts (people) related to the entity.";
			}
			else if (labelId == "contactRoles")
			{
				label = "Roles";
				doc = "Roles of the contact for this resource.";
			}
			
			js = string.Format("onClick=\"javascript:window.open('help.aspx?name={0}&amp;doc={1}','help','width=400,height=250,menubar=no,toolbar=no,scrollbars=yes,resizable=yes,personalbar=no,locationbar=no,statusbar=no').focus(); return false;\" onMouseOver=\"javascript:window.status='{2}'; return true;\" onMouseOut=\"window.status=''; return true;\"", label, System.Web.HttpUtility.UrlEncode(doc), doc);
			
			form_label = label;
			
			note = (required) ? TpConfigManager.TP_MANDATORY_FIELD_FLAG : "";
			
			html = string.Format("<span class=\"{0}\">{1}<a href=\"help.aspx?name={2}&amp;doc={3}\" {4}>{5}:</a>&nbsp;</span>", css, note, label, System.Web.HttpUtility.UrlEncode(doc), js, form_label);
			
			return html;
		}// end of member function GetHtmlLabel
		
		public virtual Utility.OrderedMap GetOptions(string id)
		{
			Utility.OrderedMap options;
			options = new Utility.OrderedMap();
			
			if (id == "lang")
			{
				if (TpConfigManager.TP_LANG_OPTIONS == null)
				{
					options = new Utility.OrderedMap(new object[]{"en", "English"}, new object[]{"fr", "French"}, new object[]{"de", "German"}, new object[]{"pt", "Portuguese"}, new object[]{"es", "Spanish"});
				}
				else
				{
					options = TpConfigManager.TP_LANG_OPTIONS;
				}
				
				options = Utility.OrderedMap.Merge(new Utility.OrderedMap(), options);
				options[""] = "-- language --";
			}
			else if (id == "entityRoles")
			{
				options = new Utility.OrderedMap(new object[]{"data supplier", "Data Supplier"}, new object[]{"technical host", "Technical Host"});
			}
			else if (id == "contactRoles")
			{
				options = new Utility.OrderedMap(new object[]{"data administrator", "Data Administrator"}, new object[]{"system administrator", "System Administrator"});
			}
			else if (id == "hour")
			{
				options = new Utility.OrderedMap(new object[]{"", "--"}, new object[]{"01", "1"}, new object[]{"02", "2"}, new object[]{"03", "3"}, new object[]{"04", "4"}, new object[]{"05", "5"}, new object[]{"06", "6"}, new object[]{"07", "7"}, new object[]{"08", "8"}, new object[]{"09", "9"}, new object[]{"10", "10"}, new object[]{"11", "11"}, new object[]{"12", "12"});
			}
			else if (id == "ampm")
			{
				options = new Utility.OrderedMap(new object[]{"", "--"}, new object[]{"AM", "AM"}, new object[]{"PM", "PM"});
			}
			else if (id == "timezone")
			{
				options = new Utility.OrderedMap(new object[]{"", "---"}, new object[]{"GMT0", "GMT0"}, new object[]{"GMT+1", "GMT+1"}, new object[]{"GMT+2", "GMT+2"}, new object[]{"GMT+3", "GMT+3"}, new object[]{"GMT+4", "GMT+4"}, new object[]{"GMT+5", "GMT+5"}, new object[]{"GMT+6", "GMT+6"}, new object[]{"GMT+7", "GMT+7"}, new object[]{"GMT+8", "GMT+8"}, new object[]{"GMT+9", "GMT+9"}, new object[]{"GMT+10", "GMT+10"}, new object[]{"GMT+11", "GMT+11"}, new object[]{"GMT+12", "GMT+12"}, new object[]{"GMT-1", "GMT-1"}, new object[]{"GMT-2", "GMT-2"}, new object[]{"GMT-3", "GMT-3"}, new object[]{"GMT-4", "GMT-4"}, new object[]{"GMT-5", "GMT-5"}, new object[]{"GMT-6", "GMT-6"}, new object[]{"GMT-7", "GMT-7"}, new object[]{"GMT-8", "GMT-8"}, new object[]{"GMT-9", "GMT-9"}, new object[]{"GMT-10", "GMT-10"}, new object[]{"GMT-11", "GMT-11"}, new object[]{"GMT-12", "GMT-12"}, new object[]{"GMT-13", "GMT-13"}, new object[]{"GMT-14", "GMT-14"});
			}
			else if (id == "frequency")
			{
				options = new Utility.OrderedMap(new object[]{"", "----"}, new object[]{"P1D", "daily"}, new object[]{"P7D", "weekly"}, new object[]{"P1M", "monthly"}, new object[]{"P2M", "every 2 months"}, new object[]{"P3M", "every 3 months"}, new object[]{"P6M", "every 6 months"});
			}
			else if (id == "maxDuration")
			{
				options = new Utility.OrderedMap(new object[]{"", "---"}, new object[]{"PT1H", "1 hour"}, new object[]{"PT2H", "2 hours"}, new object[]{"PT5H", "5 hours"}, new object[]{"PT10H", "10 hours"});
			}
			
			return options;
		}



// end of member function GetOptions

	}
}
