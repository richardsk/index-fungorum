using System;
using System.Web;
using Microsoft.Uddi;
using Microsoft.Uddi.Api;
using Microsoft.Uddi.Business;
using Microsoft.Uddi.Service;
using Microsoft.Uddi.Binding;
using Microsoft.Uddi.ServiceType;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using TapirDotNET;

namespace TapirDotNET.Controls
{

	public partial class TpUddiForm : TpPage
	{
		public Utility.OrderedMap mInteractions = new Utility.OrderedMap();
		public Utility.OrderedMap mBusinessCache = new Utility.OrderedMap();
		
		public Utility.OrderedMap active_resources;
		public object main_title;
		public object main_business_name;

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
			this.Load += new System.EventHandler(this.TpUddiForm_Load);
			this.PreRender += new System.EventHandler(this.TpUddiForm_PreRender);

		}
		#endregion

		public TpUddiForm()
		{
			TpResources r_resources = new TpResources().GetInstance();
			active_resources = r_resources.GetActiveResources();

		}
				
		protected void TpUddiForm_Load(object sender, EventArgs e)
		{
		}
		
		protected void TpUddiForm_PreRender(object sender, EventArgs e)
		{
			this.Process();
			this.EchoErrors();

			if (Utility.OrderedMap.CountElements(active_resources) > 0)
			{
				uddiPanel.Visible = true;
			}

			
			if (Utility.OrderedMap.CountElements(active_resources) > 0)
			{			
				string html = "<span class=\"label\">Active Resources:</span><br/>";
				html += "<table width=\"100%\" cellspacing=\"1\" cellpadding=\"1\" bgcolor=\"#999999\">";
		 
				foreach (TpResource res in active_resources.Values)
				{
					TpLangString title = GetServiceMainTitle(res);
					TpLangString name = GetNameOfMainBusiness(res);

					html += "<tr>";
					html += "<td width=\"5%\" align=\"center\" bgcolor=\"#f5f5ff\"><input type=\"checkbox\" class=\"checkbox\" name=\"resourcesList\" value=\"";
					html += res.GetCode() + "\"";

					if ( TpUtils.GetVar("resourcesList", "").ToString().IndexOf(res.GetCode()) != -1)
					{
						html += "checked=\"1\"";
					}
					
					html += "/></td>";
					
					html += "<td width=\"10%\" align=\"left\" bgcolor=\"#f5f5ff\">";
					html += res.GetCode() + "</td>";
					html += "<td width=\"85%\" align=\"left\" bgcolor=\"#f5f5ff\">Service name: ";
					html += title.GetValue() + "<br/>Business name: ";
					html += name.GetValue() + "</td>";					
                    
					html += "</tr>";
				}

				html += "</table><br/><input type = \"submit\" name = \"register\" value = \"Register selected resources\"/>";

				HtmlGenericControl ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = html;
				placeHolder1.Controls.Add(ctrl);
			}
		}

		public virtual void  EchoMessage(string msg)
		{
			HttpContext.Current.Response.Write(string.Format("\r\n<br/><span class=\"msg\">{0}</span>", msg));			
			HttpContext.Current.Response.Flush();
		}// end of member function EchoMessage
		
		public virtual bool EchoErrors()
		{
			Utility.OrderedMap errors = new TpDiagnostics().GetMessages();
			
			if (Utility.OrderedMap.CountElements(errors) > 0)
			{
				HttpContext.Current.Response.Write(string.Format("\r\n<br/><span class=\"error\">{0}</span>", Utility.StringSupport.Join("<br/>", errors)));			
				HttpContext.Current.Response.Flush();
								
				new TpDiagnostics().Reset();
				
				return true;
			}
			
			return false;
		}// end of member function EchoErrors
		
		public virtual void  Process()
		{
			TpResources r_resources;
			string uddi_name;
			string tmodel_name;
			string inquiry_url;
			int inquiry_port;
			string publish_url;
			int publish_port;
			string msg;
			Utility.OrderedMap selected_resources;
			string tmodel_key;
			TpResource r_resource;
			
			r_resources = new TpResources().GetInstance();
			
			active_resources = r_resources.GetActiveResources();
			
			if (!this.EchoErrors())
			{
				if (Utility.OrderedMap.CountElements(active_resources) == 0)
				{
					this.EchoMessage("There are no active resources");
				}
				else
				{
					if (HttpContext.Current.Request["first"] != null)
					{
						this.EchoMessage("Please note that only UDDI v2 is supported.");
					}
				}
			}
			
			if (HttpContext.Current.Request["register"] != null)
			{
				uddi_name = TpUtils.GetVar("uddi_name", "").ToString().Trim(new char[]{' ', '\t', '\n', '\r', '0'});
				
				tmodel_name = TpUtils.GetVar("tmodel_name", "").ToString().Trim(new char[]{' ', '\t', '\n', '\r'});
				
				inquiry_url = TpUtils.GetVar("inquiry_url", "").ToString().Trim(new char[]{' ', '\t', '\n', '\r', '0'});
				
				inquiry_port = Utility.TypeSupport.ToInt32(TpUtils.GetVar("inquiry_port", "0").ToString().Trim(new char[]{' ', '\t', '\n', '\r'}));
				
				publish_url = TpUtils.GetVar("publish_url", "").ToString().Trim(new char[]{' ', '\t', '\n', '\r', '0'});
				
				publish_port = Utility.TypeSupport.ToInt32(TpUtils.GetVar("publish_port", "0").ToString().Trim(new char[]{' ', '\t', '\n', '\r'}));
				
				if (Utility.VariableSupport.Empty(uddi_name))
				{
					msg = "No UDDI name (operator) specified";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				if (Utility.VariableSupport.Empty(tmodel_name))
				{
					msg = "No Tmodel name specified";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				if (Utility.VariableSupport.Empty(inquiry_url) || Utility.VariableSupport.Empty(inquiry_port) || Utility.VariableSupport.Empty(publish_url) || Utility.VariableSupport.Empty(publish_port))
				{
					msg = "Please specify all URLs and ports";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				selected_resources = new Utility.OrderedMap(TpUtils.GetVar("resourcesList", ""));
				
				if (Utility.OrderedMap.CountElements(selected_resources) == 0)
				{
					msg = "No resources selected";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
								
				Inquire.Url = inquiry_url; 
				Publish.Url = publish_url;
								
				// Find tModel key
				FindTModel fm = new FindTModel();
				fm.Name = tmodel_name;
				TModelList models = fm.Send();
				
				if (models.TModelInfos.Count == 0)
				{
					msg = "Registration failed: ";
					msg += "no tModels found for \"" + tmodel_name + "\"";
					new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				else if (models.TModelInfos.Count > 1)
				{
					msg = "Registration failed: ";
					msg += "found more than one tModel found for \"" + tmodel_name + "\"";
					new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
								
				tmodel_key = models.TModelInfos[0].TModelKey.Substring(5); // substr removes leading uuid:
				
				int i = 0;
				
				foreach ( string resource_code in selected_resources.Values ) 
				{
					this.EchoErrors();
					
					++i;
					
					r_resource = r_resources.GetResource(resource_code, true);
					
					if (this._Register(r_resource, tmodel_key))
					{
						this.EchoMessage("\n" + "Resource \"" + resource_code + "\" " + "successfully registered");
					}
				}
				
			}
		}// end of member function Process
		
		public virtual bool _Register(TpResource rResource, string tmodelKey)
		{
			// Find business with the same name
			object business_key;
			object service_key;
			
			business_key = this._GetBusinessKey(rResource);
			
			if (business_key == null)
			{
				return false;
			}
			
			// Find service with the same title
			
			service_key = this._GetServiceKey(rResource, business_key.ToString());
			
			if (service_key == null)
			{
				return false;
			}
			
			// Register binding
			
			if (!this._RegisterBinding(rResource, service_key, tmodelKey))
			{
				return false;
			}
			
			return true;
		}// end of member function _Register
		
		public virtual object _GetBusinessKey(TpResource rResource)
		{
			object business_key = null;
			string resource_code;
			TpResourceMetadata r_metadata;
			string default_language;
			TpEntity entity;
			string msg;
			TpLangString entity_name;
			string business_name;
			string label;
			Utility.OrderedMap business_keys = new Utility.OrderedMap();;
			Utility.OrderedMap business_entity = new Utility.OrderedMap();
			Utility.OrderedMap name = new Utility.OrderedMap();
			object lang;
			Utility.OrderedMap descriptions;
			TpLangString entity_description;
			Utility.OrderedMap description_array = new Utility.OrderedMap();
			Utility.OrderedMap contacts;
			Utility.OrderedMap covered_roles;
			TpContact contact = new TpContact();
			Utility.OrderedMap contact_array = new Utility.OrderedMap();
			object phone = null;
			
			resource_code = rResource.GetCode();
			
			r_metadata = (TpResourceMetadata)this._GetResourceMetadata(rResource);
			
			default_language = r_metadata.GetDefaultLanguage();
			
			entity = (TpEntity)this._GetMainEntity(r_metadata.GetRelatedEntities());
			
			if (entity == null)
			{
				msg = "Resource \"" + resource_code + "\" has no business entity";
				new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, msg, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			entity_name = this._GetMainLangString(entity.GetNames(), default_language);
			
			business_name = entity_name.GetValue().ToString();
			
			if (this.mBusinessCache[business_name] != null)
			{
				business_key = this.mBusinessCache[business_name];
			}
			else
			{
				FindBusiness fb = new FindBusiness();
				fb.Names.Add(business_name);
				fb.FindQualifiers.Add(new FindQualifier("exactNameMatch"));
				BusinessList bl = fb.Send();
				
				if (TpConfigManager._DEBUG)
				{
					label = "find_business (" + resource_code + ")";
										
					//this.mInteractions.SetValue(ob_get_contents(), label, "req");
					//this.mInteractions.SetValue(System.Web.HttpUtility.HtmlEncode(result), label, "resp");
				}
				
				if (bl.BusinessInfos.Count == 0)
				{
					// Register new business
					lang = entity_name.GetLang();

					BusinessEntity be = new BusinessEntity();
					be.Names.Add(lang.ToString(), business_name);
					
					descriptions = Utility.TypeSupport.ToArray(entity.GetDescriptions());
					
					if (Utility.OrderedMap.CountElements(descriptions) > 0)
					{
						entity_description = this._GetMainLangString(descriptions, r_metadata.GetDefaultLanguage());
						
						be.Descriptions.Add(entity_description.GetLang(), entity_description.GetValue());
					}
					
					contacts = new Utility.OrderedMap();
					
					covered_roles = new Utility.OrderedMap();
					
					foreach ( TpRelatedContact related_contact in entity.GetRelatedContacts().Values ) 
					{
						contact = related_contact.GetContact();
						
						// One contact for each role!
						foreach ( object role in related_contact.GetRoles().Values ) 
						{
							if (covered_roles.Search(role) == null)
							{
								covered_roles.Push(role);
								Contact c = new Contact();
								c.Emails.Add(contact.GetEmail(), role.ToString());
								
								if (!Utility.VariableSupport.Empty(phone))
								{
									c.Phones.Add(contact.GetTelephone().ToString(), role.ToString());
								}

								be.Contacts.Add(c);								
							}
						}
						
					}
					
					SaveBusiness sb = new SaveBusiness();
					sb.AuthInfo = null;
					sb.BusinessEntities.Add(be);
					BusinessDetail bd = sb.Send();

					if (TpConfigManager._DEBUG)
					{
						label = "save_business (" + resource_code + ")";
						
						// this.mInteractions.SetValue(ob_get_contents(), label, "req");
						// this.mInteractions.SetValue(System.Web.HttpUtility.HtmlEncode(result), label, "resp");
					}

					foreach (BusinessEntity bent in bd.BusinessEntities)
					{
						business_keys.Push(bent.BusinessKey);
					}
					
					if (Utility.OrderedMap.CountElements(business_keys) != 1)
					{
						msg = "Registration failed for resource \"" + resource_code + "\": " + "more than one business key returned for business \"" + business_name + "\"";
						new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
						return false;
					}
				}
				else if (Utility.OrderedMap.CountElements(business_keys) > 1)
				{
					msg = "Registration failed for resource \"" + resource_code + "\": " + "found more than one business for \"" + business_name + "\"";
					new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				business_key = business_keys[0];
				
				this.mBusinessCache[business_name] = business_key;
			}
			
			return business_key;
		}// end of member function _GetBusinessKey
		
		public virtual object _GetServiceKey(TpResource rResource, string businessKey)
		{
			string service_key = null;
			string resource_code;
			TpResourceMetadata r_metadata;
			string default_language;
			TpLangString service_lang_string;
			string service_name;
			Utility.OrderedMap params_Renamed;
			string label;
			string msg;
			Utility.OrderedMap name = new Utility.OrderedMap();
			string lang;
			
			resource_code = rResource.GetCode();
			
			r_metadata = (TpResourceMetadata)this._GetResourceMetadata(rResource);
			
			default_language = r_metadata.GetDefaultLanguage();
			
			service_lang_string = this.GetServiceMainTitle(rResource);
			
			service_name = service_lang_string.GetValue().ToString();
			
			params_Renamed = new Utility.OrderedMap(new object[]{"name", service_name}, new object[]{"findQualifiers", "exactNameMatch"});
			

			FindService fs = new FindService();
			fs.BusinessKey = businessKey;
			fs.Names.Add(service_lang_string.GetLang());
			fs.FindQualifiers.Add(new FindQualifier("exactNameMatch"));
			ServiceList sl = fs.Send();

			if (TpConfigManager._DEBUG)
			{
				label = "find_service (" + resource_code + ")";
				
				// this.mInteractions.SetValue(ob_get_contents(), label, "req");
				// this.mInteractions.SetValue(System.Web.HttpUtility.HtmlEncode(result), label, "resp");
			}
			
			bool isSet = false;
			
			foreach ( ServiceInfo si in sl.ServiceInfos ) 
			{
				if (si.BusinessKey == businessKey)
				{
					if (!isSet)
					{
						service_key = si.ServiceKey;
						isSet = true;
					}
					else
					{
						msg = "Registration failed for resource \"" + resource_code + "\": " + "found more than one service associated with the same " + "business and registered as \"" + service_name + "\"";
						new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
						return false;
					}
				}
			}
			
			
			if (!isSet)
			{
				// Register new service
				lang = service_lang_string.GetLang();
				
				if (Utility.VariableSupport.Empty(lang))
				{
					lang = default_language;
				}
				
				SaveService ss = new SaveService();
				BusinessService bs = new BusinessService();
				bs.Names.Add(lang, service_name);
				ServiceDetail sd = ss.Send();
				
				if (TpConfigManager._DEBUG)
				{
					label = "save_service (" + resource_code + ")";
					
					// this.mInteractions.SetValue(ob_get_contents(), label, "req");
					// this.mInteractions.SetValue(System.Web.HttpUtility.HtmlEncode(result), label, "resp");
				}
				
				foreach ( BusinessService bus in sd.BusinessServices ) 
				{
					if (bus.BusinessKey == businessKey)
					{
						if (!isSet)
						{
							service_key = bus.ServiceKey;
							isSet = true;
						}
						else
						{
							msg = "Registration failed for resource \"" + resource_code + "\": " + "more than one service key returned for the same " + "business after trying to save the service";
							new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
							return false;
						}
					}
				}
				
				
				if (service_key == null)
				{
					msg = "Registration failed for resource \"" + resource_code + "\": " + "no service key returned after attempt to save the service";
					new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			return service_key;
		}// end of member function _GetServiceKey
		
		public virtual bool _RegisterBinding(TpResource rResource, object serviceKey, string tmodelKey)
		{
			string resource_code;
			string label;
			string accesspoint;
			string msg;
			Utility.OrderedMap parsed_url;
			Utility.OrderedMap tmodel_instance_infos;
			Utility.OrderedMap tmodel_instance_info = new Utility.OrderedMap();
			string generatedAux;

			resource_code = Utility.TypeSupport.ToString(rResource.GetCode());
			
			FindBinding fb = new FindBinding();
			fb.TModelKeys.Add(tmodelKey);
			fb.ServiceKey = serviceKey.ToString();
			BindingDetail bd = fb.Send();
			
			if (TpConfigManager._DEBUG)
			{
				label = "find_binding (" + resource_code + ")";
				
				// this.mInteractions.SetValue(ob_get_contents(), label, "req");
				// this.mInteractions.SetValue(System.Web.HttpUtility.HtmlEncode(result), label, "resp");
			}
			
			bool found = false;
			accesspoint = rResource.GetAccesspoint();

			foreach (BindingTemplate bt in bd.BindingTemplates)
			{
				if (bt.AccessPoint.Text == accesspoint) 
				{
					found = true;
					break;
				}
			}

			if (!found)
			{
				msg = "Resource \"" + resource_code + "\" is already registered with ";
				new TpDiagnostics().Append(TpConfigManager.CFG_UDDI_ERROR, msg, TpConfigManager.DIAG_ERROR);
				generatedAux = "the same accesspoint. No need to re-register." + new TpDiagnostics()._GetStack().ToStringContents();
				return false;
			}
			
			// Save new binding
			
			parsed_url = Utility.URLSupport.ParseURI(accesspoint);
			
			tmodel_instance_infos = new Utility.OrderedMap();
			
			tmodel_instance_info = new Utility.OrderedMap();
			
			tmodel_instance_info["tModelKey"] = tmodelKey;
			
			tmodel_instance_infos.Push(tmodel_instance_info);
			

			SaveBinding sb = new SaveBinding();
			BindingTemplate templ = new BindingTemplate();
			templ.AccessPoint = new AccessPoint(URLType.Http, accesspoint); //TODO should url type be - parsed_url["scheme"]
			templ.ServiceKey = serviceKey.ToString();
			TModelInstanceInfo tmii = new TModelInstanceInfo();
			tmii.TModelKey = tmodelKey;
			templ.TModelInstanceDetail.TModelInstanceInfos.Add(tmii);			
			sb.BindingTemplates.Add(templ);
			sb.Send();
			
			if (TpConfigManager._DEBUG)
			{
				label = "save_binding (" + resource_code + ")";
				
				// this.mInteractions.SetValue(ob_get_contents(), label, "req");
				// this.mInteractions.SetValue(System.Web.HttpUtility.HtmlEncode(result), label, "resp");
			}
			
			return true;
		}// end of member function _RegisterBinding
		
		public virtual TpResourceMetadata _GetResourceMetadata(TpResource rResource)
		{
			TpResourceMetadata r_metadata = rResource.GetMetadata();
			
			if (!r_metadata.IsLoaded())
			{
				StreamReader rdr = File.OpenText(rResource.GetMetadataFile());
				string xml = rdr.ReadToEnd();
				rdr.Close();
				
				xml = xml.Replace("[LAST_MODIFIED_DATE]", rResource.GetSettings().GetModified());
				xml = xml.Replace("[ACCESS_POINT]", rResource.GetAccesspoint());

				r_metadata.LoadFromXml(rResource.GetCode(), xml);
			}
			
			return r_metadata;
		}// end of member function _GetResourceMetadata
		
		public virtual TpLangString GetServiceMainTitle(TpResource rResource)
		{
			TpResourceMetadata r_metadata = this._GetResourceMetadata(rResource);
			
			return this._GetMainLangString(r_metadata.GetTitles(), r_metadata.GetDefaultLanguage());
		}// end of member function GetServiceMainTitle
		
		public virtual TpLangString GetNameOfMainBusiness(TpResource rResource)
		{
			TpResourceMetadata r_metadata = this._GetResourceMetadata(rResource);
			TpEntity entity = this._GetMainEntity(r_metadata.GetRelatedEntities());
			
			if (entity == null)
			{
				// What happened??
				return new TpLangString("?", "");
			}
			
			return this._GetMainLangString(entity.GetNames(), r_metadata.GetDefaultLanguage());
		}// end of member function GetServiceMainTitle
		
		 /**
		* Returns the "main" TpLangString object from an array of TpLangString objects.
		* Criteria: Name in english or first existing name.
		*
		* @param $options array Array of TpLangString objects
		* @return object Main TpLangString object
		*/
		public virtual TpLangString _GetMainLangString(Utility.OrderedMap options, string default_lang)
		{
			TpLangString main_lang_string = null;
			int i;
			string current_lang;
			string lang;
			int num_options = Utility.OrderedMap.CountElements(options);
			
			if (num_options == 0)
			{
				// No options??
				main_lang_string = new TpLangString("?", "");
			}
			else if (num_options == 1)
			{
				main_lang_string = (TpLangString)options[0];
			}
			else
			{
				for (i = 0; i < num_options; ++i)
				{
					current_lang = ((TpLangString)options[i]).GetLang();
					
					lang = Utility.VariableSupport.Empty(current_lang) ? default_lang : current_lang;
					
					// Default to first english option
					if (lang.Substring(0, 2) == "en")
					{
						main_lang_string = (TpLangString)options[i];
						break;
					}
					// Otherwise it will default to the first option
					else if (i == 0)
					{
						main_lang_string = (TpLangString)options[i];
					}
				}
			}
			
			return main_lang_string;
		}// end of member function _GetMainLangString
				
		public virtual TpEntity _GetMainEntity(Utility.OrderedMap relatedEntities)
		{
			TpEntity entity = null;
			int num_entities;
			int i;
			Utility.OrderedMap roles;
						
			num_entities = Utility.OrderedMap.CountElements(relatedEntities);
			
			if (num_entities == 0)
			{
				// No entities??
			}
			else if (num_entities == 1)
			{
				entity = ((TpRelatedEntity)relatedEntities[0]).GetEntity();
			}
			else
			{
				for (i = 0; i < num_entities; ++i)
				{
					roles = Utility.TypeSupport.ToArray(((TpRelatedEntity)relatedEntities[i]).GetRoles());
					
					// Default to technical host
					if (roles.Search("technical host") != null)
					{
						entity = ((TpRelatedEntity)relatedEntities[i]).GetEntity();
						break;
					}
					// Otherwise it will default to the first entity
					else if (i == 0)
					{
						entity = ((TpRelatedEntity)relatedEntities[i]).GetEntity();
					}
				}
			}
			
			return entity;
		}// end of member function _GetMainEntity

	}
}
