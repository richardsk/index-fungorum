using System;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

using TapirDotNET;

namespace TapirDotNET.Controls
{

	public partial class TpImportForm : TpPage
	{
		public Utility.OrderedMap mResources = new Utility.OrderedMap();
		public TpRelatedEntity mHostRelatedEntity;
		public Utility.OrderedMap mInTags;
		public TpResource mCurrentResource;
		public TpTable mRootTable;
		public TpTable mCurrentTable;
		public Utility.OrderedMap mSchemas = new Utility.OrderedMap();
		public string mLastSchemaLocation;
		public TpBooleanOperator mRootBooleanOperator;
		public Utility.OrderedMap mOperatorsStack = new Utility.OrderedMap();
		public Utility.OrderedMap mTables = new Utility.OrderedMap();
		public bool mNewContact;
		
		public Utility.OrderedMap errors;
		public Utility.OrderedMap available_resources;


		public TpImportForm()
		{
			if (HttpContext.Current.Request.Form["first"] != null)
			{
				this.mMessage = "Here you can import the configuration from a DiGIR provider. Please type the location\nof the DiGIR &quot;config&quot; directory on the server as well as the names of the &quot;resources&quot; and\n&quot;metadata&quot; configuration files. These files reside in the &quot;config&quot; directory with the\ndefault names indicated below.\n\nIMPORTANT: all imported resources will not be active, you will still need to click on\neach one to complete the configuration process.";
			}
			
			object errors = new TpDiagnostics().GetMessages();
			
			Utility.OrderedMap available_resources = this.mResources;

			this.Load+=new EventHandler(TpImportForm_Load);
		}
		
		private void TpImportForm_Load(object sender, EventArgs e)
		{			
			string html = "";
			if (Utility.OrderedMap.CountElements(errors) > 0)
			{
				html = string.Format("\n<br/><span class=\"error\">{0}</span>", Utility.StringSupport.Join("<br/>", errors));
			}

			if (this.mMessage != null && this.mMessage.Length > 0)
			{
				html = string.Format("\n<br/><span class=\"msg\">{0}</span>", this.mMessage);
			}

			HtmlGenericControl ctrl = new HtmlGenericControl();
			ctrl.InnerHtml = html;

			placeHolder1.Controls.Add(ctrl);

		           
			if (Utility.OrderedMap.CountElements(available_resources) > 0)
			{			
				html = "<span class=\"label\">Available Resources</span><br/><table width=\"60%\" cellspacing=\"1\" cellpadding=\"1\" bgcolor=\"#999999\">";
		 
				foreach (TpResource res in available_resources)
				{
					html += "<tr><td width=\"20%\" align=\"center\" bgcolor=\"#f5f5ff\"><input type=\"checkbox\" class=\"checkbox\" name=\"resources[]\" value=\"";
					html += res + "\"";
					

					if ( TpUtils.GetVar("resources", "").ToString().IndexOf(res.GetCode()) != -1)
					{
						html += "checked=\"1\"";
					}
                    
					html += "/></td>";
				
					html += "<td width=\"80%\" align=\"left\" bgcolor=\"#f5f5ff\">&nbsp;&nbsp;";
					html += res.GetCode() + "</td></tr>";
				}

				html += "</table><br/><input type = \"submit\" name = \"process\" value = \"import selected resources\"/>";

				ctrl = new HtmlGenericControl();
				ctrl.InnerHtml = html;
				placeHolder2.Controls.Add(ctrl);
			}
		}
		
		public virtual void  HandleEvents()
		{
			// Validate parameters
			string digir_config_directory;
			string msg;
			string digir_resource_file;
			string digir_metadata_file;
			Utility.OrderedMap selected_resources;
			string config_file;
			TpResources r_resources;
			string new_code;
			
			digir_config_directory = TpUtils.GetVar("config_dir", "").ToString();
			
			if (Utility.VariableSupport.Empty(digir_config_directory))
			{
				msg = "Please type the location of the DiGIR &quot;config&quot; " + "directory on the server";
				new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			digir_resource_file = TpUtils.GetVar("resource_file", "").ToString();
			
			if (Utility.VariableSupport.Empty(digir_resource_file))
			{
				msg = "Please type the name of the DiGIR resource configuration file";
				new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			digir_metadata_file = TpUtils.GetVar("metadata_file", "").ToString();
			
			if (Utility.VariableSupport.Empty(digir_metadata_file))
			{
				msg = "Please type the name of the DiGIR metadata configuration file";
				new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			if (!(System.IO.File.Exists(digir_config_directory) || System.IO.Directory.Exists(digir_config_directory)))
			{
				msg = "Could not find the DiGIR \"config\" directory (" + digir_config_directory + ")";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			digir_resource_file = digir_config_directory + "\\" + digir_resource_file;
			
			if (!(System.IO.File.Exists(digir_resource_file) || System.IO.Directory.Exists(digir_resource_file)))
			{
				msg = "Could not find the DiGIR resource file (" + digir_resource_file + ")";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			if (!System.IO.File.Exists(digir_resource_file))
			{
				msg = "Could not read the DiGIR resource file (" + digir_resource_file + "). Please check permissions.";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			digir_metadata_file = digir_config_directory + "\\" + digir_metadata_file;
			
			if (!(System.IO.File.Exists(digir_metadata_file) || System.IO.Directory.Exists(digir_metadata_file)))
			{
				msg = "Could not find the DiGIR metadata file (" + digir_metadata_file + ")";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			if (!System.IO.File.Exists(digir_metadata_file))
			{
				msg = "Could not read the DiGIR metadata file (" + digir_metadata_file + "). Please check permissions.";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			// Get resources
			
			if (!this._LoadResources(digir_resource_file))
			{
				msg = "Could not load DiGIR resources from (" + digir_resource_file + ")";
				new TpDiagnostics().Append(TpConfigManager.DC_XML_PARSE_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			if (Utility.OrderedMap.CountElements(this.mResources) == 0)
			{
				msg = "Could not find any DiGIR resource in (" + digir_resource_file + ")";
				new TpDiagnostics().Append(TpConfigManager.DC_GENERAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			if (HttpContext.Current.Request.Form["process"] != null)
			{
				selected_resources = new Utility.OrderedMap(TpUtils.GetVar("resources", ""));
				
				if (Utility.OrderedMap.CountElements(selected_resources) == 0)
				{
					msg = "No resources selected";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				// Load provider metadata (common to all resources)
				
				if (!this._LoadProviderMetadata(digir_metadata_file))
				{
					msg = "Could not load DiGIR metadata from (" + digir_metadata_file + ")";
					new TpDiagnostics().Append(TpConfigManager.DC_GENERAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
					return ;
				}
				
				// Load each resource configuration
				
				foreach ( object resource_code in selected_resources.Values ) 
				{
					if (!this.mResources.KeyExists(resource_code))
					{
						msg = "Inconsistent resource code!";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, msg, TpConfigManager.DIAG_ERROR);
						continue;
					}
					
					config_file = digir_config_directory + "\\" + Utility.TypeSupport.ToString(this.mResources[resource_code]);
					
					if (!(System.IO.File.Exists(config_file) || System.IO.Directory.Exists(config_file)))
					{
						msg = "Could not find resource configuration file (" + config_file + ")";
						new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
						continue;
					}
					
					if (!System.IO.File.Exists(config_file))
					{
						msg = "Could not read resource configuration file (" + config_file + "). Please check permissions.";
						new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, msg, TpConfigManager.DIAG_ERROR);
						continue;
					}
					
					// Force code to be lower case (better since since now it 
					// is going to be part of the service accesspoint)
					if (!this._LoadResource(Utility.TypeSupport.ToString(resource_code).ToLower(), config_file))
					{
						msg = "Could not load \"" + resource_code.ToString() + "\" resource";
						new TpDiagnostics().Append(TpConfigManager.DC_GENERAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
					}
					else
					{
						r_resources = new TpResources().GetInstance();
						
						if (this.mCurrentResource.SaveMetadata(false) && this.mCurrentResource.SaveDataSource(false) 
							&& this.mCurrentResource.SaveTables(false) && this.mCurrentResource.SaveLocalFilter(false) 
							&& this.mCurrentResource.SaveLocalMapping(false) && this.mCurrentResource.SaveSettings(false))
						{
							this.mCurrentResource.SetStatus("pending");
							
							r_resources.AddResource(this.mCurrentResource);
							
							if (!r_resources.Save())
							{
								continue;
							}
						}
						else
						{
							continue;
						}
						
						new_code = this.mCurrentResource.GetCode();
						
						this.mMessage += "\nImported resource '" + resource_code.ToString() + "'";
						
						if (new_code != resource_code.ToString())
						{
							this.mMessage += " with code '" + new_code + "'";
						}
					}
				}
				
			}
		}// end of member function HandleEvents
				
		public virtual bool _LoadResources(string digirResourcesFile)
		{	
			string error = "";
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this._StartResourceElement);
			rdr.EndElementHandler = new EndElement(this._EndResourceElement);
							
			try
			{
				rdr.ReadXml(digirResourcesFile);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
						
			return true;
		}// end of member function _LoadResources
		
		public virtual void  _StartResourceElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "resource", false) == 0)
			{
				if (attrs["name"].ToString() != "" && attrs["configFile"].ToString() != "")
				{
					this.mResources[attrs["name"].ToString()] = attrs["configFile"];
				}
			}
		}// end of _StartResourceElement
		
		public virtual void  _EndResourceElement(TpXmlReader reader)
		{
			
		}// end of _EndResourceElement
		
		public virtual bool _LoadProviderMetadata(string digirMetadataFile)
		{
			string error = "";
			TpEntity entity = new TpEntity();
			this.mInTags = new Utility.OrderedMap();

			this.mHostRelatedEntity = new TpRelatedEntity();
			this.mHostRelatedEntity.AddRole("technical host");
			this.mHostRelatedEntity.SetEntity(entity);

			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this._StartMetadataElement);
			rdr.EndElementHandler = new EndElement(this._EndMetadataElement);
			rdr.CharacterDataHandler = new CharacterData(this._MetadataCharacterData);
								
			try
			{
				rdr.ReadXml(digirMetadataFile);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}

			return true;
		}// end of member function _LoadProviderMetadata
		
		public virtual void  _StartMetadataElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			TpContact contact;
			TpRelatedContact related_contact;
			TpEntity r_entity;
			this.mInTags.Push(reader.XmlReader.Name);
			
			// <contact>
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "contact", false) == 0)
			{
				contact = new TpContact();
				
				related_contact = new TpRelatedContact();
				
				related_contact.SetContact(contact);
				
				r_entity = this.mHostRelatedEntity.GetEntity();
				
				r_entity.AddRelatedContact(related_contact);
			}
		}// end of _StartMetadataElement
		
		public virtual void  _EndMetadataElement(TpXmlReader reader)
		{
			this.mInTags.Pop();
		}// end of _EndMetadataElement
		
		public virtual void  _MetadataCharacterData(TpXmlReader reader, string data)
		{
			int depth;
			string in_tag;
			TpEntity r_entity;
			TpRelatedContact r_related_contact;
			TpContact r_contact;
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			if (data.Trim(new char[]{' ', '\t', '\n', '\r', '0'}).Length > 0)
			{
				depth = Utility.OrderedMap.CountElements(this.mInTags);
				
				in_tag = Utility.TypeSupport.ToString(this.mInTags[depth - 1]);
				
				// Sub elements of <host>
				if (depth > 1 && Utility.StringSupport.StringCompare(this.mInTags[depth - 2].ToString(), "host", false) == 0)
				{
					r_entity = this.mHostRelatedEntity.GetEntity();
					
					// host/name => entity name (role = technical host)
					if (Utility.StringSupport.StringCompare(in_tag, "name", false) == 0)
					{
						r_entity.AddName(data, null);
					}
						// host/code => entity code
					else if (Utility.StringSupport.StringCompare(in_tag, "code", false) == 0)
					{
						r_entity.SetAcronym(data);
					}
						// host/relatedInformation => entity related information
					else if (Utility.StringSupport.StringCompare(in_tag, "relatedInformation", false) == 0)
					{
						r_entity.SetRelatedInformation(data);
					}
						// host/abstract => entity description
					else if (Utility.StringSupport.StringCompare(in_tag, "abstract", false) == 0)
					{
						r_entity.AddDescription(data, null);
					}
				}
				// Sub elements of <contact>
				else
				{
					if (depth > 1 && Utility.StringSupport.StringCompare(this.mInTags[depth - 2].ToString(), "contact", false) == 0)
					{
						r_entity = this.mHostRelatedEntity.GetEntity();
						
						r_related_contact = r_entity.GetLastRelatedContact();
						
						r_contact = r_related_contact.GetContact();
						
						// contact/name => contact full name
						if (Utility.StringSupport.StringCompare(in_tag, "name", false) == 0)
						{
							r_contact.SetFullName(data);
						}
							// contact/email => contact email
						else if (Utility.StringSupport.StringCompare(in_tag, "emailAddress", false) == 0)
						{
							r_contact.SetEmail(data);
						}
							// contact/phone => contact telephone
						else if (Utility.StringSupport.StringCompare(in_tag, "phone", false) == 0)
						{
							r_contact.SetTelephone(data);
						}
							// contact/title => contact title
						else if (Utility.StringSupport.StringCompare(in_tag, "title", false) == 0)
						{
							r_contact.AddTitle(data, null);
						}
					}
				}
			}
		}// end of _MetadataCharacterData
		
		public virtual bool _LoadResource(string resourceCode, string configFile)
		{
			TpResources r_resources;
			bool raise_error;
			int i;
			string resource_code;
			string error = "";
			TpTables r_tables;
			TpSettings r_settings;
			object timestamp;
			TpLocalFilter r_local_filter;

			this.mInTags = new Utility.OrderedMap();
			this.mRootTable = null;
			this.mCurrentTable = null;
			this.mRootBooleanOperator = null;
			this.mOperatorsStack = new Utility.OrderedMap();
			
			r_resources = new TpResources().GetInstance();
			
			raise_error = false;
			
			i = 0;
			
			resource_code = resourceCode;
			
			// Assign new code if this one already exists
			while (r_resources.GetResource(resource_code, raise_error) != null)
			{
				++i;
				
				if (i == 20)
				{
					error = "Exceeded number of attempts to generate a new resource " + "code to \"" + resourceCode + "\"";
					new TpDiagnostics().Append(TpConfigManager.DC_GENERAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					
					return false;
				}
				
				resource_code = resourceCode + "_" + i;
			}
			
			this.mCurrentResource = new TpResource();
			this.mCurrentResource.SetCode(resource_code);

			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this._StartConfigElement);
			rdr.EndElementHandler = new EndElement(this._EndConfigElement);
			rdr.CharacterDataHandler = new CharacterData(this._ConfigCharacterData);
								
			try
			{
				rdr.ReadXml(configFile);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}

			r_tables = this.mCurrentResource.GetTables();
			
			r_tables.SetRootTable(this.mRootTable);
			
			r_settings = this.mCurrentResource.GetSettings();
			
			timestamp = TpUtils.TimestampToXsdDateTime(DateTime.Now);
			
			r_settings.SetModified(timestamp.ToString());
			
			// Just instantiate the local filter obj because old configuration
			// files may not have it. In this case an empty local filter should be saved.
			r_local_filter = this.mCurrentResource.GetLocalFilter();
			
			return true;
		}// end of member function _LoadResource
		
		public virtual void  _StartConfigElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			int depth;
			TpDataSource r_datasource;
			string constr;
			string t_name;
			string key;
			string join;
			TpTable table = null;
			int size;
			TpBooleanOperator current_operator = null;
			string last_tag;
			TpConcept concept = null;
			string prefix;
			TpConceptualSchema schema = null;
			Utility.OrderedMap parts;
			string id;
			SingleColumnMapping mapping;
			this.mInTags.Push(reader.XmlReader.Name);
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "datasource", false) == 0)
			{
				r_datasource = this.mCurrentResource.GetDataSource();
				
				r_datasource.LoadDefaults();
				
				if (attrs["dbtype"].ToString() != "")
				{
					r_datasource.SetDriverName(attrs["dbtype"].ToString());
				}
				if (attrs["encoding"].ToString() != "")
				{
					r_datasource.SetEncoding(attrs["encoding"].ToString());
				}
				if (attrs["constr"].ToString() != "")
				{
					// This is probably not necessary, but it was used with the XPath class
					constr = attrs["constr"].ToString().Replace("&quot;", "\"");
					constr = constr.Replace("&amp;", "&");
					
					r_datasource.SetConnectionString(constr);
				}
				if (attrs["uid"].ToString() != "")
				{
					r_datasource.SetUsername(attrs["uid"].ToString());
				}
				if (attrs["pwd"].ToString() != "")
				{
					r_datasource.SetPassword(attrs["pwd"].ToString());
				}
				if (attrs["database"].ToString() != "")
				{
					r_datasource.SetDatabase(attrs["database"].ToString());
				}
			}
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "table", false) == 0)
				{
					t_name = (attrs["name"].ToString() != "") ? attrs["name"].ToString() : "";
					key = (attrs["key"].ToString() != "") ? attrs["key"].ToString() : "";
					join = (attrs["join"].ToString() != "") ? attrs["join"].ToString() : "";
					
					if (t_name.Length > 0)
					{
						table = new TpTable();
						
						table.SetName(t_name);
						table.SetKey(key);
						
						if (this.mCurrentTable != null)
						{
							table.SetJoin(join);
							
							this.mCurrentTable.AddChild(table);
						}
						else
						{
							this.mRootTable = table;
						}
						
						this.mTables[t_name] = table;
						this.mCurrentTable = table;
					}
				}
			}
			// Sub elements of <filter>
			if (depth > 1 && this.mInTags.Search("filter") != null)
			{
				size = Utility.OrderedMap.CountElements(this.mOperatorsStack);
				
				if (size > 0)
				{
					current_operator = (TpBooleanOperator)this.mOperatorsStack[size - 1];
				}
				
				last_tag = Utility.TypeSupport.ToString(this.mInTags[depth - 2]);
				
				if (Utility.StringSupport.StringCompare(last_tag, "andNot", false) == 0 || Utility.StringSupport.StringCompare(last_tag, "orNot", false) == 0)
				{
					// In these conditions, we should be able to assume that 
					// $current_operator is set and is a LOP!
					
					// Include NOT only for the second term
					if (Utility.OrderedMap.CountElements(((TpLogicalOperator)current_operator).GetBooleanOperators()) > 0)
					{
						this._AddOperator(new TpLogicalOperator(TpFilter.LOP_NOT));
					}
				}
				
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "equals", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_EQUALS));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "notEquals", false) == 0)
				{
					this._AddOperator(new TpLogicalOperator(TpFilter.LOP_NOT));
						
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_EQUALS));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "lessThan", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_LESSTHAN));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "lessThanOrEquals", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_LESSTHANOREQUALS));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "greaterThan", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_GREATERTHAN));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "greaterThanOrEquals", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_GREATERTHANOREQUALS));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "like", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_LIKE));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "in", false) == 0)
				{
					this._AddOperator(new TpComparisonOperator(TpFilter.COP_IN));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "term", false) == 0)
				{
					if (current_operator != null && (int)current_operator.GetBooleanType() == TpFilter.COP_TYPE && attrs["table"].ToString() != "")
					{
						// Only add t_concept for the first term
						// (concept expressions inside DiGIR "in" operators are redundant)
						if (((TpComparisonOperator)current_operator).GetComparisonType() != TpFilter.COP_IN || ((TpComparisonOperator)current_operator).GetBaseConcept() == null)
						{
							concept = (TpConcept) (new TpTransparentConcept(attrs["table"].ToString(), attrs["field"].ToString(), attrs["type"]));
															
							((TpComparisonOperator)current_operator).SetExpression(new TpExpression(TpFilter.EXP_COLUMN, concept.ToString()));
						}
					}
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "and", false) == 0)
				{
					this._AddOperator(new TpLogicalOperator(TpFilter.LOP_AND));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "or", false) == 0)
				{
					this._AddOperator(new TpLogicalOperator(TpFilter.LOP_OR));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "andNot", false) == 0)
				{
					this._AddOperator(new TpLogicalOperator(TpFilter.LOP_AND));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "orNot", false) == 0)
				{
					this._AddOperator(new TpLogicalOperator(TpFilter.LOP_OR));
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "list", false) == 0)
				{
					// nothing to do here ("list" is part of "in")
				}
			}
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "concepts", false) == 0)
				{
					for ( int i = 0; i < attrs.Count; i++ )
					{
						string n = attrs.GetValueAt(i).ToString();
						string value_Renamed = attrs[n].ToString();
						if (n.Substring(0, 6) == "xmlns:")
						{
							prefix = n.Substring(6);
							
							schema = new TpConceptualSchema();
							
							schema.SetNamespace(value_Renamed);
							
							schema.SetHandler("DarwinSchemaHandler_v1");
							
							this.mSchemas[prefix] = schema;
						}
					}
					
				}
				else
				{
					if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "concept", false) == 0)
					{
						if (attrs["name"].ToString() == "")
						{
							return ;
						}
						
						parts = new Utility.OrderedMap(attrs["name"].ToString().Split(":".ToCharArray()));
						
						if (Utility.OrderedMap.CountElements(parts) != 2)
						{
							return ;
						}
						
						prefix = parts[0].ToString();
						
						if (!(this.mSchemas[prefix] != null))
						{
							return ;
						}
						
						if (attrs["returnable"].ToString() != "" && Utility.TypeSupport.ToBoolean(attrs["returnable"].ToString() == bool.TrueString))
						{
							// ignore non returnable concepts
							return ;
						}
						
						concept = new TpConcept();
						
						concept.SetName(parts[1].ToString());
						
						id = ((TpConceptualSchema)this.mSchemas[prefix]).GetNamespace() + "/" + parts[1].ToString();
						
						concept.SetId(id);
						
						if (attrs["searchable"].ToString() != "")
						{
							concept.SetSearchable(Utility.TypeSupport.ToBoolean(attrs["searchable"].ToString()));
						}
						if (attrs["table"].ToString() != "" && attrs["field"].ToString() != "" && attrs["type"].ToString() != "")
						{
							if (!(attrs["field"].ToString().IndexOf(",") == -1) || !(attrs["field"].ToString().IndexOf(",") == -1))
							{
								// ignore multi mapping
								return ;
							}
							
							if (attrs["type"].ToString() != "text" && attrs["type"].ToString() != "numeric" && attrs["type"].ToString() != "date" 
								&& attrs["type"].ToString() != "datetime" && attrs["type"].ToString() != "xml" )
							{
								// ignore unknown types
								return ;
							}
							
							mapping = new SingleColumnMapping();
							
							mapping.SetTable(attrs["table"].ToString());
							mapping.SetField(attrs["field"].ToString());
							mapping.SetLocalType(attrs["type"]);
							
							concept.SetMapping(mapping);
						}
						
						((TpConceptualSchema)this.mSchemas[prefix]).AddConcept(concept);
					}
					else
					{
						if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "conceptualSchema", false) == 0 && attrs["schemaLocation"].ToString() != "")
						{
							this.mLastSchemaLocation = attrs["schemaLocation"].ToString();
						}
					}
				}
			}
		}// end of _StartConfigElement
		
		public virtual void  _EndConfigElement(TpXmlReader reader)
		{
			TpTable r_current_table;
			TpLocalFilter r_local_filter;
			TpFilter filter;
			TpLocalMapping r_local_mapping;
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "table", false) == 0)
			{
				if (this.mCurrentTable != null)
				{
					r_current_table = (TpTable)this.mTables[this.mCurrentTable.GetName()];
					
					this.mCurrentTable = (TpTable)r_current_table.GetParent();
				}
			}
			else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "filter", false) == 0)
			{
				r_local_filter = this.mCurrentResource.GetLocalFilter();
					
				filter = new TpFilter(false);
					
				filter.SetRootBooleanOperator(this.mRootBooleanOperator);
					
				r_local_filter.SetFilter(filter);
			}
			else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "concepts", false) == 0)
			{
				r_local_mapping = this.mCurrentResource.GetLocalMapping();
						
				foreach ( string prefix in this.mSchemas.Keys ) 
				{
					TpConceptualSchema schema = (TpConceptualSchema)this.mSchemas[prefix];
					r_local_mapping.AddMappedSchema(schema);
				}
						
			}
			else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "equals", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "lessThan", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "lessThanOrEquals", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "greaterThan", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "greaterThanOrEquals", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "like", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "in", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "and", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "or", false) == 0)
			{
				this.mOperatorsStack.Pop();
			}
			else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "notEquals", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "andNot", false) == 0 || 
				Utility.StringSupport.StringCompare(reader.XmlReader.Name, "orNot", false) == 0)
			{
				this.mOperatorsStack.Pop();
				this.mOperatorsStack.Pop();
			}
			
			this.mInTags.Pop();
		}// end of _EndConfigElement
		
		public virtual void  _ConfigCharacterData(TpXmlReader reader, string data)
		{
			int depth = Utility.OrderedMap.CountElements(this.mInTags);
			string in_tag;
			int size;
			TpBooleanOperator current_operator = null;
			TpResourceMetadata r_metadata = null;
			object timestamp;
			TpEntity host_entity = null;
			Utility.OrderedMap host_names = null;
			string host_name;
			TpEntity entity = null;
			TpRelatedEntity related_entity = null;
			TpSettings r_settings = null;
			string ns;
			TpRelatedEntity r_last_related_entity = null;
			TpEntity r_entity = null;
			TpRelatedContact r_related_contact = null;
			TpContact r_contact = null;
			Utility.OrderedMap related_contacts = null;
			TpContact contact = null;
			TpRelatedContact related_contact = null;
						
			in_tag = Utility.TypeSupport.ToString(this.mInTags[depth - 1]);
			
			if (depth > 1 && Utility.StringSupport.StringCompare(in_tag, "term", false) == 0)
			{
				size = Utility.OrderedMap.CountElements(this.mOperatorsStack);
				
				if (size > 0)
				{
					current_operator = (TpBooleanOperator)this.mOperatorsStack[size - 1];
				}
				
				if (current_operator != null && (int)current_operator.GetBooleanType() == TpFilter.COP_TYPE)
				{
					((TpComparisonOperator)current_operator).SetExpression(new TpExpression(TpFilter.EXP_LITERAL, data));
				}
			}
			else if (data.Trim(new char[]{' ', '\t', '\n', '\r', '0'}).Length > 0)
			{
				// Sub elements of <metadata>
				if (depth > 1 && Utility.StringSupport.StringCompare(this.mInTags[depth - 2].ToString(), "metadata", false) == 0)
				{
					r_metadata = this.mCurrentResource.GetMetadata();
					
					r_metadata.SetType("http://purl.org/dc/dcmitype/Service");
					
					r_metadata.SetId(this.mCurrentResource.GetCode());
					
					timestamp = TpUtils.TimestampToXsdDateTime(DateTime.Now);
					
					r_metadata.SetCreated(timestamp.ToString());
					
					// metadata/name => resource title
					if (Utility.StringSupport.StringCompare(in_tag, "name", false) == 0)
					{
						r_metadata.AddTitle(data, null);
						
						// Maybe here is not the best place to add the host entity, anyway
						r_metadata.AddRelatedEntity(this.mHostRelatedEntity);
						
						// If resource name is different from host name
						// then create a new related entity
						
						host_entity = this.mHostRelatedEntity.GetEntity();
						
						host_names = host_entity.GetNames();
						host_name = ((TpLangString)host_names[0]).GetValue().ToString();// only one name
						
						if (Utility.StringSupport.StringCompare(host_name, data, false) != 0)
						{
							entity = new TpEntity();
							
							related_entity = new TpRelatedEntity();
							related_entity.AddRole("data supplier");
							related_entity.SetEntity(entity);
						}
					}
						// metadata/abstract => resource description
					else if (Utility.StringSupport.StringCompare(in_tag, "abstract", false) == 0)
					{
						r_metadata.AddDescription(data, null);
					}
						// metadata/citation => resource biblioraphic citation
					else if (Utility.StringSupport.StringCompare(in_tag, "citation", false) == 0)
					{
						r_metadata.AddBibliographicCitation(data, null);
					}
						// metadata/keywords => resource subject
					else if (Utility.StringSupport.StringCompare(in_tag, "keywords", false) == 0)
					{
						r_metadata.AddSubjects(data, null);
					}
						// metadata/useRestrictions => resource rights
					else if (Utility.StringSupport.StringCompare(in_tag, "useRestrictions", false) == 0)
					{
						r_metadata.AddRights(data, null);
					}
						// metadata/maxSearchResponseRecords => settings maxElementRepetitions
					else if (Utility.StringSupport.StringCompare(in_tag, "maxSearchResponseRecords", false) == 0)
					{
						r_settings = this.mCurrentResource.GetSettings();
											
						r_settings.SetMaxElementRepetitions(Utility.TypeSupport.ToInt32(data));
					}
						// metadata/conceptualSchema
					else if (Utility.StringSupport.StringCompare(in_tag, "conceptualSchema", false) == 0)
					{
						foreach ( string prefix in this.mSchemas.Keys ) 
						{
							TpConceptualSchema schema = (TpConceptualSchema)this.mSchemas[prefix];
							ns = schema.GetNamespace().ToString();
													
							if (ns == data && this.mLastSchemaLocation != "")
							{
								((TpConceptualSchema)this.mSchemas[prefix]).SetLocation(this.mLastSchemaLocation);
							}
						}
												
					}
				}
				// Sub elements of <contact>
				else
				{
					if (depth > 1 && Utility.StringSupport.StringCompare(this.mInTags[depth - 2].ToString(), "contact", false) == 0)
					{
						// These references may be needed below (for new contacts)
						r_metadata = this.mCurrentResource.GetMetadata();
						
						r_last_related_entity = r_metadata.GetLastRelatedEntity();
						
						r_entity = r_last_related_entity.GetEntity();
						
						r_related_contact = r_entity.GetLastRelatedContact();
						
						r_contact = r_related_contact.GetContact();
						
						// contact/name => contact full name
						if (Utility.StringSupport.StringCompare(in_tag, "name", false) == 0)
						{
							related_contacts = Utility.TypeSupport.ToArray(r_entity.GetRelatedContacts());
							
							this.mNewContact = true;
							
							foreach ( TpRelatedContact relContact in related_contacts.Values ) 
							{
								contact = relContact.GetContact();
								
								if (Utility.StringSupport.StringCompare(contact.GetFullName(), data, false) == 0)
								{
									this.mNewContact = false;
								}
							}
							
							
							// Only add contact if it is a new name
							if (this.mNewContact)
							{
								contact = new TpContact();
								
								contact.SetFullName(data);
								
								related_contact = new TpRelatedContact();
								
								related_contact.SetContact(contact);
								
								r_entity = r_last_related_entity.GetEntity();
								
								r_entity.AddRelatedContact(related_contact);
							}
						}
						// contact/email => contact email
						else
						{
							if (Utility.StringSupport.StringCompare(in_tag, "emailAddress", false) == 0)
							{
								if (this.mNewContact)
								{
									r_contact.SetEmail(data);
								}
							}
								// contact/phone => contact telephone
							else if (Utility.StringSupport.StringCompare(in_tag, "phone", false) == 0)
							{
								if (this.mNewContact)
								{
									r_contact.SetTelephone(data);
								}
							}
								// contact/title => contact title
							else if (Utility.StringSupport.StringCompare(in_tag, "title", false) == 0)
							{
								if (this.mNewContact)
								{
									r_contact.AddTitle(data, null);
								}
							}
						}
					}
				}
			}
		}// end of _ConfigCharacterData
		
		public virtual void  _AddOperator(TpBooleanOperator operator_Renamed)
		{
			int size;
			TpBooleanOperator current_operator;
			size = Utility.OrderedMap.CountElements(this.mOperatorsStack);
			
			if (!(this.mRootBooleanOperator != null))
			{
				this.mRootBooleanOperator = operator_Renamed;
			}
			else
			{
				current_operator = (TpBooleanOperator)this.mOperatorsStack[size - 1];
				
				if ((int)current_operator.GetBooleanType() == TpFilter.LOP_TYPE)
				{
				 	((TpLogicalOperator)current_operator).AddBooleanOperator(operator_Renamed);
				}
			}
			
			this.mOperatorsStack[size] = operator_Renamed;
		}// end of member function _AddOperator

	}
}
