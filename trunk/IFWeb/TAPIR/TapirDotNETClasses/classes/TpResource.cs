using System;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using System.Data;
using System.Data.OleDb;

namespace TapirDotNET 
{

	public class TpResource
	{
		public string mCode;
		public string mMetadataFile = ""; // just the file name (no path)
		public string mConfigFile = ""; // just the file name (no path)
		public string mCapabilitiesFile = ""; // just the file name (no path)
		public string mStatus = "new"; // "new", "pending", "active" or "disabled"
			// "new"     = resource that didn't complete the 
			//             wizard process
			// "pending" = resource that completed the wizard 
			//             process but for some reason has 
			//             pending issues (eg. recently 
			//             imported resources)
		public string mAccesspoint;
		public XmlDocument mConfigXp; 
		public TpResourceMetadata mMetadata; 
		public TpDataSource mDataSource;
		public TpTables mTables;
		public TpLocalFilter mLocalFilter;
		public TpLocalMapping mLocalMapping;
		public TpSettings mSettings;
				
		
		public TpResource()
		{
			
		}
		
		
		public virtual void  SetCode(string code)
		{
			this.mCode = code;
		}// end of member function SetCode
		
		public virtual string GetCode()
		{
			return this.mCode;
		}// end of member function GetCode
		
		public virtual void  SetStatus(string status)
		{
			this.mStatus = status;
		}// end of member function SetStatus
		
		public virtual string GetStatus()
		{
			return this.mStatus;
		}// end of member function GetStatus
		
		public virtual void  SetAccesspoint(string accesspoint)
		{
			this.mAccesspoint = accesspoint;
		}// end of member function SetAccesspoint
		
		public virtual string GetAccesspoint()
		{
			return this.mAccesspoint;
		}// end of member function GetAccesspoint
		
		public virtual void  SetMetadataFile(string file)
		{
			this.mMetadataFile = file;
		}// end of member function SetMetadataFile
		
		public virtual string GetMetadataFile()
		{
			if (this.mMetadataFile == "")
			{
				this.mMetadataFile = this.GetFile("metadata");
			}
			
			return TpConfigManager.TP_CONFIG_DIR + System.IO.Path.DirectorySeparatorChar.ToString() + this.mMetadataFile;
		}// end of member function GetMetadataFile
		
		public virtual void  SetConfigFile(string file)
		{
			this.mConfigFile = file;
		}// end of member function SetConfigFile
		
		public virtual string GetConfigFile()
		{
			if (this.mConfigFile == "")
			{
				this.mConfigFile = this.GetFile("config");
			}
			
			return TpConfigManager.TP_CONFIG_DIR + System.IO.Path.DirectorySeparatorChar.ToString() + this.mConfigFile;
		}// end of member function GetConfigFile
		
		public virtual void  SetCapabilitiesFile(string file)
		{
			this.mCapabilitiesFile = file;
		}// end of member function SetCapabilitiesFile
		
		public virtual string GetCapabilitiesFile()
		{
			if (this.mCapabilitiesFile == "")
			{
				this.mCapabilitiesFile = this.GetFile("capabilities");
			}
			
			return TpConfigManager.TP_CONFIG_DIR + System.IO.Path.DirectorySeparatorChar.ToString() + this.mCapabilitiesFile;
		}// end of member function GetCapabilitiesFile
		
		public virtual string GetFile(string label)
		{
			string suffix;
			string error;
			string file_name;
			string file;
			int attempt;
			suffix = "_" + label + ".xml";
			
			if (this.mCode == "")
			{
				error = "Could not create " + label + " file name without having " + "a resource code!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return "";
			}
			
			file_name = this.mCode + suffix;
			
			file = TpConfigManager.TP_CONFIG_DIR + System.IO.Path.DirectorySeparatorChar.ToString() + file_name;
			
			attempt = 1;
			
			while ((System.IO.File.Exists(file) || System.IO.Directory.Exists(file)) && attempt < 10)
			{
				file_name = this.mCode + "_" + attempt.ToString() + suffix;
				
				file = TpConfigManager.TP_CONFIG_DIR + System.IO.Path.DirectorySeparatorChar.ToString() + file_name;
				
				++attempt;
			}
			
			if (attempt == 10)
			{
				error = "Could not create " + label + " file name - exceeded number " + "of attempts to find a unique name!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return "";
			}
			
			return file_name;
		}// end of member function GetFile
		
		public virtual bool HasMetadata()
		{
			if (this.mMetadataFile == "")
			{
				return false;
			}
			
			return true;
		}// end of member function HasMetadata
		
		public virtual bool ConfiguredMetadata()
		{
			TpResourceMetadata resource_metadata;
			bool raiseErrors;
			if (!this.HasMetadata())
			{
				return false;
			}
			
			// Important: don't use GetMetadata here, since the reference it
			// returns may need to be loaded in a different way later!
			resource_metadata = new TpResourceMetadata();
			
			string xml = "";
			try
			{
				StreamReader rdr = File.OpenText(this.GetMetadataFile());
				xml = rdr.ReadToEnd();
				rdr.Close();

				xml = xml.Replace("[LAST_MODIFIED_DATE]", GetSettings().GetModified());
				xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());
			}
			catch(Exception )
			{
				string error = "Could not open metadata file.";
				new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
			}
				

			if (resource_metadata.LoadFromXml(this.mCode, xml))
			{
				// Set access point to pass validation
				resource_metadata.SetAccesspoint(this.GetAccesspoint());
				
				raiseErrors = true;
				
				if (!resource_metadata.Validate(raiseErrors))
				{
					return false;
				}
			}
			
			return true;
		}// end of member function ConfiguredMetadata
		
		public virtual bool ConfiguredDatasource()
		{
			if (this.mCode == "" || this.mConfigFile == "")
			{
				return false;
			}
			
			if (this.LoadConfigXp() && this.mConfigXp.SelectNodes("/configuration[1]/datasource[1]").Count > 0)
			{
				return true;
			}
			
			return false;
		}// end of member function ConfiguredDatasource
		
		public virtual bool ConfiguredTables()
		{
			if (this.mCode == "" || this.mConfigFile == "")
			{
				return false;
			}
			
			if (this.LoadConfigXp() && this.mConfigXp.SelectNodes("/configuration[1]/table[1]").Count > 0)
			{
				return true;
			}
			
			return false;
		}// end of member function ConfiguredTables
		
		public virtual bool ConfiguredLocalFilter()
		{
			if (this.mCode == "" || this.mConfigFile == "")
			{
				return false;
			}
			
			if (this.LoadConfigXp() && this.mConfigXp.SelectNodes("/configuration[1]/filter[1]").Count > 0)
			{
				return true;
			}
			
			return false;
		}// end of member function ConfiguredLocalMapping
		
		public virtual bool ConfiguredMapping()
		{
			if (this.mCode == "" || this.mConfigFile == "" || this.mCapabilitiesFile == "")
			{
				return false;
			}
			
			if (this.LoadConfigXp() && this.mConfigXp.SelectNodes("/configuration[1]/mapping[1]").Count > 0)
			{
				// Assuming that capabilities also has the <concepts> section present
				return true;
			}
			
			return false;
		}// end of member function ConfiguredMapping
		
		public virtual bool ConfiguredSettings()
		{
			if (this.mCode == "" || this.mConfigFile == "" || this.mCapabilitiesFile == "")
			{
				return false;
			}
			
			if (this.LoadConfigXp() && this.mConfigXp.SelectNodes("/configuration[1]/settings[1]").Count > 0)
			{
				// Assuming that capabilities is valid
				return true;
			}
			
			return false;
		}// end of member function ConfiguredSettings
		
		public virtual Utility.OrderedMap GetAssociatedFiles()
		{
			Utility.OrderedMap files;
			files = new Utility.OrderedMap();
			
			if (this.mMetadataFile != "")
			{
				files.Push(this.GetMetadataFile());
			}
			
			if (this.mConfigFile != "")
			{
				files.Push(this.GetConfigFile());
			}
			
			if (this.mCapabilitiesFile != "")
			{
				files.Push(this.GetCapabilitiesFile());
			}
			
			return files;
		}// end of member function GetAssociatedFiles
		
		public virtual bool IsValid()
		{
			if (this.ConfiguredMetadata() && this.ConfiguredDatasource() && this.ConfiguredTables() && this.ConfiguredMapping() && this.ConfiguredSettings())
			{
				return true;
			}
			
			return false;
		}// end of member function IsValid
		
		public virtual bool IsNew()
		{
			if (this.mStatus == "new")
			{
				return true;
			}
			
			return false;
		}// end of member function IsNew
		
		public virtual bool LoadConfigXp()
		{
			string error;
			if (this.mConfigXp == null)
			{
				try
				{
					this.mConfigXp = new XmlDocument();
					mConfigXp.Load(GetConfigFile());
				}
				catch(Exception ex)
				{
					error = "Could not load the XML file (" + this.mConfigFile + ") associated with resource \"" + this.mCode + "\". " + "Please check provider installation.";
					new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			return true;
		}// end of member function GetConfigXp
		
		public virtual string GetXml()
		{
			string configAttr;
			string capabilitiesAttr;
			string metadataAttr = configAttr = capabilitiesAttr = "";
			
			if (this.mMetadataFile != "")
			{
				metadataAttr = " metadataFile=\"" + System.IO.Path.GetFileName(this.mMetadataFile) + "\"";
			}
			
			if (this.mConfigFile != "")
			{
				configAttr = " configFile=\"" + System.IO.Path.GetFileName(this.mConfigFile) + "\"";
			}
			
			if (this.mCapabilitiesFile != "")
			{
				capabilitiesAttr = " capabilitiesFile=\"" + System.IO.Path.GetFileName(this.mCapabilitiesFile) + "\"";
			}
			
			return string.Format("<resource code=\"{0}\" status=\"{1}\" accesspoint=\"{2}\"{3}{4}{5}/>", this.mCode, this.mStatus, this.mAccesspoint, metadataAttr, configAttr, capabilitiesAttr);
		}// end of member function GetXtml
		
		public virtual TpResourceMetadata GetMetadata()
		{
			if (this.mMetadata == null)
			{
				this.mMetadata = new TpResourceMetadata();
			}
			
			return this.mMetadata;
		}// end of member function GetMetadata
		
		public virtual TpDataSource GetDataSource()
		{
			if (this.mDataSource == null)
			{
				this.mDataSource = new TpDataSource();
			}
			
			return this.mDataSource;
		}// end of member function GetDataSource
		
		public virtual TpTables GetTables()
		{
			if (this.mTables == null)
			{
				this.mTables = new TpTables();
			}
			
			return this.mTables;
		}// end of member function GetTables
		
		public virtual TpLocalFilter GetLocalFilter()
		{
			if (this.mLocalFilter == null)
			{
				this.mLocalFilter = new TpLocalFilter();
			}
			
			return this.mLocalFilter;
		}// end of member function GetLocalFilter
		
		public virtual TpLocalMapping GetLocalMapping()
		{
			if (this.mLocalMapping == null)
			{
				this.mLocalMapping = new TpLocalMapping();
			}
			
			return this.mLocalMapping;
		}// end of member function GetLocalMapping
		
		public virtual TpSettings GetSettings()
		{
			if (this.mSettings == null)
			{
				this.mSettings = new TpSettings();
			}
			
			return this.mSettings;
		}// end of member function GetSettings
		
		public virtual bool LoadConfig()
		{
			TpDataSource r_data_source;
			TpTables r_tables;
			TpLocalFilter r_local_filter;
			TpLocalMapping r_local_mapping;
			TpSettings r_settings;

			if (!this.LoadConfigXp())
			{
				return false;
			}
			
			// Data source
			r_data_source = this.GetDataSource();
			
			r_data_source.LoadFromXml(this.GetConfigFile(), this.mConfigXp);
			
			// Tables
			r_tables = this.GetTables();
			
			r_tables.LoadFromXml(this.GetConfigFile(), this.mConfigXp);
			
			// Local Filter
			r_local_filter = this.GetLocalFilter();
			
			r_local_filter.LoadFromXml(this.GetConfigFile(), this.mConfigXp);
			
			// Local Mapping
			r_local_mapping = this.GetLocalMapping();
			
			r_local_mapping.LoadFromXml(this.GetConfigFile());
			
			// Settings
			r_settings = this.GetSettings();
			
			r_settings.LoadFromXml(this.GetConfigFile(), this.GetCapabilitiesFile(), false);
			
			return true;
		}// end of member function LoadConfig
		
		public virtual bool SaveMetadata(bool updateResources)
		{
			string error;
			string offset;
			string indent_with;
			string xml;
			object last_error;
			string new_error;
			bool force_update;

			if (this.mMetadata == null)
			{
				error = "Cannot save metadata when the corresponding " + "property is not loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			// Save in metadata file
			
			if (this.mMetadataFile == "")
			{
				// Create metadata file
				
				if (this.GetMetadataFile() == "")
				{
					return false;
				}
			}
			
			offset = "";
			indent_with = "\t";
			
			xml = this.mMetadata.GetXml(offset, indent_with);
			
			if (!new TpConfigUtils().WriteToFile(xml, this.GetMetadataFile()))
			{
				last_error = new TpDiagnostics().PopDiagnostic();
				
				new_error = string.Format("Could not write metadata file: {0}", last_error);
				
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			// Always update resources because code and accesspoint can change
			force_update = true;
			
			this.SetAccesspoint(this.mMetadata.GetAccesspoint());
			
			this.SetCode(this.mMetadata.GetId());
			
			if (updateResources)
			{
				this.UpdateResources(force_update);
			}
			
			return true;
		}// end of member function SaveMetadata
		
		public virtual bool SaveDataSource(bool updateResources)
		{
			string error;
			bool force_update;
			string content;
			TpDiagnostic last_error;
			string new_error;
			string position;
			string prev_position;

			if (this.mDataSource == null)
			{
				error = "Cannot save data source when the corresponding " + "property is not loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			// Save in config file
			
			force_update = false;
			
			if (this.mConfigFile == "")
			{
				// Create config file
				if (this.GetConfigFile() == "")
				{
					return false;
				}
				
				content = TpConfigManager.XML_HEADER + "\n" + "<configuration>" + "\n" + "\t" + this.mDataSource.GetXml() + "\n" + "</configuration>";
				
				if (!new TpConfigUtils().WriteToFile(content, this.GetConfigFile()))
				{
					last_error = (TpDiagnostic)new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not write config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				// After this, TpResources must be saved
				force_update = true;
			}
			else
			{
				position = "/configuration[1]/datasource[1]";
				
				prev_position = "/configuration[1]";
				
				if (!new TpConfigUtils().WriteXmlPiece(this.mDataSource.GetXml(), position, prev_position, this.GetConfigFile()))
				{
					last_error = (TpDiagnostic)new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not update config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			if (updateResources)
			{
				this.UpdateResources(force_update);
			}
			
			return true;
		}// end of member function SaveDataSource
		
		public virtual bool SaveTables(bool updateResources)
		{
			string error;
			bool force_update;
			string content;
			TpDiagnostic last_error;
			string new_error;
			string position;
			string prev_position;
			TpTable root_table;
			Utility.OrderedMap valid_tables;
			bool updated_mapping;
			TpConceptMapping mapping;
			object table;

			if (this.mTables == null)
			{
				error = "Cannot save tables when the corresponding " + "property is not loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			// Save in config file
			
			force_update = false;
			
			if (this.mConfigFile == "")
			{
				// Create config file
				
				if (this.GetConfigFile() == "")
				{
					return false;
				}
				
				content = TpConfigManager.XML_HEADER + "\n" + "<configuration>" + "\n" + "\t" + this.mTables.GetXml() + "\n" + "</configuration>";
				
				if (!new TpConfigUtils().WriteToFile(content, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not write config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				// After this, TpResources must be saved
				force_update = true;
			}
			else
			{
				position = "/configuration[1]/table[1]";
				
				prev_position = "/configuration[1]/datasource[1]";
				
				if (!new TpConfigUtils().WriteXmlPiece(this.mTables.GetXml(), position, prev_position, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not update config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				// If any table was removed, it is necessary to remove possible 
				// related mappings
				
				root_table = this.mTables.GetRootTable();
				
				valid_tables = root_table.GetAllTables();
				
				if (this.ConfiguredMapping())
				{
					if (this.mLocalMapping == null)
					{
						this.GetLocalMapping();// no need to get result (property ref)
						
						this.mLocalMapping.LoadFromXml(this.GetConfigFile());
					}
					
					updated_mapping = false;
					
					foreach ( string ns in Utility.TypeSupport.ToArray(this.mLocalMapping.GetMappedSchemas()).Keys ) 
					{
						TpConceptualSchema schema = (TpConceptualSchema)this.mLocalMapping.GetMappedSchemas()[ns];
						foreach ( string concept_id in schema.GetConcepts().Keys ) 
						{
							TpConcept concept = (TpConcept)schema.GetConcepts()[concept_id];
							if (concept.GetMappingType() == "SingleColumnMapping")
							{
								mapping = concept.GetMapping();
								SingleColumnMapping scm = (SingleColumnMapping)mapping;

								table = scm.GetTable();
								
								// Unmap concepts that are not related to "valid" tables
								if (valid_tables.Search(table) != null)
								{
									concept.SetMapping(null);
									
									updated_mapping = true;
								}
							}
							else if (concept.GetMappingType() == "LSIDDataMapping")
							{
								mapping = concept.GetMapping();
								LSIDDataMapping dm = (LSIDDataMapping)mapping;

								table = dm.GetTable();
								
								// Unmap concepts that are not related to "valid" tables
								if (valid_tables.Search(table) != null)
								{
									concept.SetMapping(null);
									
									updated_mapping = true;
								}
							}
						}
						
					}
					
					
					if (updated_mapping)
					{
						if (!this.SaveLocalMapping(true))
						{
							last_error = new TpDiagnostics().PopDiagnostic();
							
							new_error = string.Format("Could not remove mappings that are " + "referencing removed tables: {0}", last_error);
							
							new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
							return false;
						}
					}
				}
			}
			
			if (updateResources)
			{
				this.UpdateResources(force_update);
			}
			
			return true;
		}// end of member function SaveTables
		
		public virtual bool SaveLocalFilter(bool updateResources)
		{
			string error;
			bool force_update;
			string content;
			TpDiagnostic last_error;
			string new_error;
			string position;
			string prev_position;

			if (this.mLocalFilter == null)
			{
				error = "Cannot save local filter when the corresponding " + "property is not loaded!";
				
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			// Save in config file
			
			force_update = false;
			
			if (this.mConfigFile == "")
			{
				// Create config file
				
				if (this.GetConfigFile() == "")
				{
					return false;
				}
				
				content = TpConfigManager.XML_HEADER + "\n" + "<configuration>" + "\n" + "\t<filter>" + this.mLocalFilter.GetXml() + "</filter>\n" + "</configuration>";
				
				if (!new TpConfigUtils().WriteToFile(content, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not write config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				// After this, TpResources must be saved
				force_update = true;
			}
			else
			{
				position = "/configuration[1]/filter[1]";
				
				prev_position = "/configuration[1]/table[1]";
				
				content = "<filter>" + this.mLocalFilter.GetXml() + "</filter>";
				
				if (!new TpConfigUtils().WriteXmlPiece(content, position, prev_position, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not update config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			if (updateResources)
			{
				this.UpdateResources(force_update);
			}
			
			return true;
		}// end of member function SaveLocalFilter
		
		public virtual bool SaveLocalMapping(bool updateResources)
		{
			string error;
			bool update_resources;
			TpLocalMapping r_local_mapping;
			string content;
			TpDiagnostic last_error;
			string new_error;
			string position;
			string prev_position;
			TpSettings r_settings;

			if (this.mLocalMapping == null)
			{
				error = "Cannot save local mapping when the corresponding " + "resource property is not loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			update_resources = false;
			
			// Need to use this variable name because of the capabilities template!
			r_local_mapping = this.GetLocalMapping();
			
			// Save in config file
			if (this.mConfigFile == "")
			{
				// Should never fall here, but in any case, create the file
				
				if (this.GetConfigFile() == "")
				{
					return false;
				}
				
				content = TpConfigManager.XML_HEADER + "\n" + "<configuration>" + "\n" + "\t" + r_local_mapping.GetConfigXml() + "\n" + "</configuration>";
				
				if (!new TpConfigUtils().WriteToFile(content, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not write config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				// After this, TpResources must be saved
				update_resources = true;
			}
			else
			{
				position = "/configuration[1]/mapping[1]";
				
				prev_position = "/configuration[1]/filter[1]";
				
				if (!new TpConfigUtils().WriteXmlPiece(r_local_mapping.GetConfigXml(), position, prev_position, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not update config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			// Save in capabilities file
			
			if (this.mCapabilitiesFile == "")
			{
				// Create the capabilities file
				if (this.GetCapabilitiesFile() == "")
				{
					return false;
				}
				
				// After defining the file, TpResources must be saved
				update_resources = true;
			}
			
			// Load settings for new resources
			
			r_settings = this.GetSettings();
			
			if (this.IsNew())
			{
				r_settings.LoadDefaults(false);
			}
			else
			{
				// Otherwise always load them from XML
				r_settings.LoadFromXml(this.GetConfigFile(), this.GetCapabilitiesFile(), false);
			}
			
			//capabilities file			
			content = GetCapabilitiesXml();
			
			if (!new TpConfigUtils().WriteToFile(content, this.GetCapabilitiesFile()))
			{
				last_error = new TpDiagnostics().PopDiagnostic();
				
				new_error = string.Format("Could not write capabilities file: {0}", last_error.GetDescription());
				
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			if (updateResources)
			{
				this.UpdateResources(update_resources);
			}
			
			return true;
		}// end of member function SaveLocalMapping
		
		public virtual bool SaveSettings(bool updateResources)
		{
			string error;
			bool update_resources;
			TpSettings r_settings;
			string content = null;
			TpDiagnostic last_error;
			string new_error;
			string position;
			string prev_position;
			TpLocalMapping r_local_mapping = null;

			if (this.mSettings == null)
			{
				error = "Cannot save settings when the corresponding " + "resource property is not loaded!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			update_resources = false;
			
			// Need to use this variable name because of the capabilities template!
			r_settings = this.GetSettings();
			
			// Save in config file
			if (this.mConfigFile == "")
			{
				// Should never fall here, but in any case, create the file
				
				if (this.GetConfigFile() == "")
				{
					return false;
				}
				
				content = TpConfigManager.XML_HEADER + "\n" + "<configuration>" + "\n" + "\t" + r_settings.GetConfigXml() + "\n" + "</configuration>";
				
				if (!new TpConfigUtils().WriteToFile(content, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not write config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				
				// After this, TpResources must be saved
				update_resources = true;
			}
			else
			{
				position = "/configuration[1]/settings[1]";
				
				prev_position = "/configuration[1]/mapping[1]";
				
				if (!new TpConfigUtils().WriteXmlPiece(r_settings.GetConfigXml(), position, prev_position, this.GetConfigFile()))
				{
					last_error = new TpDiagnostics().PopDiagnostic();
					
					new_error = string.Format("Could not update config file: {0}", last_error.GetDescription());
					
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
			
			// Always load local mapping from XML to avoid saving unchanged things
			r_local_mapping = this.GetLocalMapping();
			
			r_local_mapping.LoadFromXml(this.GetConfigFile());
			
			// Save in capabilities file
			
			if (this.mCapabilitiesFile == "")
			{
				// Create the capabilities file
				if (this.GetCapabilitiesFile() == "")
				{
					return false;
				}
				
				// After defining the file, TpResources must be saved
				update_resources = true;
			}
			

			content = GetCapabilitiesXml();
			
			if (!new TpConfigUtils().WriteToFile(content, this.GetCapabilitiesFile()))
			{
				last_error = new TpDiagnostics().PopDiagnostic();
				
				new_error = string.Format("Could not write capabilities file: {0}", last_error.GetDescription());
				
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			// Reset mConfigXp (otherwise ConfiguredSettings will use the existing
			// xparser object and report false)
			this.mConfigXp = null;
			
			if (updateResources)
			{
				this.UpdateResources(update_resources);
			}
			
			return true;
		}// end of member function SaveSettings
		
		private string GetCapabilitiesXml()
		{
			string xml = "";
			try
			{
				StreamReader rdr = File.OpenText( TpConfigManager.TP_CONFIG_DIR + "\\capabilities.xml");
				xml = rdr.ReadToEnd();
				rdr.Close();				
			}
			catch(Exception ex)
			{
				string error = "Could not open resource capabilities file.";
				new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
			}

			xml = xml.Replace("[LOG_ONLY]", mSettings.GetLogOnly());
			xml = xml.Replace("[CASE_SENSITIVE_EQUALS]", mSettings.GetCaseSensitiveInEquals() ? "true" : "false");
			xml = xml.Replace("[CASE_SENSITIVE_LIKE]", mSettings.GetCaseSensitiveInLike() ? "true" : "false");
			xml = xml.Replace("[MAPPING_XML]", mLocalMapping.GetCapabilitiesXml());
			xml = xml.Replace("[MAX_ELEMENT_REPETITIONS]", mSettings.GetMaxElementRepetitions().ToString());
			xml = xml.Replace("[MAX_ELEMENT_LEVELS]", mSettings.GetMaxElementLevels().ToString());
			
			return xml;
		}

		public virtual void  UpdateResources(bool force)
		{
			TpResources r_resources;
			if ((this.mStatus == "new" || this.mStatus == "pending") && this.IsValid())
			{
				this.mStatus = "active";
				
				force = true;
			}
			
			if (force)
			{
				r_resources = new TpResources().GetInstance();
				
				if (!r_resources.Save())
				{
					// What should we do here?
					return ;
				}
			}
		}// end of member function UpdateResources
		
		public virtual bool HasVariable(string var)
		{
			Utility.OrderedMap vars;
			vars = new Utility.OrderedMap("date", "timestamp", "datasourcename", "accesspoint", "lastupdated", "datecreated", "metadatalanguage", "datasourcelanguage", "datasourcedescription", "rights");
			
			return (vars.Search(var.ToLower()) != null);
		}// end of member function HasVariable
		
		public virtual string GetVariable(string var)
		{
			string metadata_file;
			string default_lang;
			Utility.OrderedMap titles;
			object lang;
			Utility.OrderedMap descriptions;
			Utility.OrderedMap rights;
			if (this.HasVariable(var))
			{
				if (Utility.StringSupport.StringCompare(var, "date", false) == 0)
				{
					return DateTime.Now.ToString("yyyy-MM-ddThh:mm:ssZ"); 
				}
				else
				{
					if (Utility.StringSupport.StringCompare(var, "timestamp", false) == 0)
					{
						return TpUtils.TimestampToXsdDateTime(DateTime.Now);
					}
					else
					{
						if (Utility.StringSupport.StringCompare(var, "dataSourceName", false) == 0)
						{
							if (this.mMetadata == null)
							{
								this.mMetadata = new TpResourceMetadata();
								
								metadata_file = this.GetMetadataFile();
								
								try
								{
									StreamReader rdr = File.OpenText(metadata_file);
									string xml = rdr.ReadToEnd();
									rdr.Close();			
			
									xml = xml.Replace("[LAST_MODIFIED_DATE]", mSettings.GetModified());
									xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());

									this.mMetadata.LoadFromXml(this.mCode, xml);			
								}
								catch(Exception )
								{
									string error = "Could not open metadata file.";
									new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
								}
				
							}
							
							default_lang = this.mMetadata.GetDefaultLanguage();
							
							titles = Utility.TypeSupport.ToArray(this.mMetadata.GetTitles());
							
							foreach ( TpLangString title in titles.Values ) 
							{
								if (Utility.VariableSupport.Empty(default_lang))
								{
									// Return first title if there's no default language
									return title.GetValue().ToString();
								}
								else
								{
									lang = title.GetLang();
									
									if (Utility.VariableSupport.Empty(lang))
									{
										// Return title with empty lang if there's a default language
										return title.GetValue().ToString();
									}
								}
							}
							
							
							return ((TpLangString)titles[0]).GetValue().ToString();
						}
						else
						{
							if (Utility.StringSupport.StringCompare(var, "accessPoint", false) == 0)
							{
								return this.mAccesspoint;
							}
							else
							{
								if (Utility.StringSupport.StringCompare(var, "lastUpdated", false) == 0)
								{
									return this.GetDateLastModified();
								}
								else
								{
									if (Utility.StringSupport.StringCompare(var, "dateCreated", false) == 0)
									{
										if (this.mMetadata == null)
										{
											this.mMetadata = new TpResourceMetadata();
											
											metadata_file = this.GetMetadataFile();
											
											try
											{
												StreamReader rdr = File.OpenText(metadata_file);
												string xml = rdr.ReadToEnd();
												rdr.Close();
					
												xml = xml.Replace("[LAST_MODIFIED_DATE]", mSettings.GetModified());
												xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());

												this.mMetadata.LoadFromXml(this.mCode, xml);
											}
											catch(Exception )
											{
												string error = "Could not open metadata file.";
												new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
											}
										}
										
										return Utility.TypeSupport.ToString(this.mMetadata.GetCreated());
									}
									else
									{
										if (Utility.StringSupport.StringCompare(var, "metadataLanguage", false) == 0)
										{
											if (this.mMetadata == null)
											{
												this.mMetadata = new TpResourceMetadata();
												
												metadata_file = this.GetMetadataFile();
												
												try
												{
													StreamReader rdr = File.OpenText(metadata_file);
													string xml = rdr.ReadToEnd();
													rdr.Close();
					
													xml = xml.Replace("[LAST_MODIFIED_DATE]", mSettings.GetModified());
													xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());

													this.mMetadata.LoadFromXml(this.mCode, xml);
												}
												catch(Exception )
												{
													string error = "Could not open metadata file.";
													new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
												}
											}
											
											default_lang = Utility.TypeSupport.ToString(this.mMetadata.GetDefaultLanguage());
											
											titles = Utility.TypeSupport.ToArray(this.mMetadata.GetTitles());
											
											foreach ( TpLangString title in titles.Values ) 
											{
												if (Utility.VariableSupport.Empty(default_lang))
												{
													// Return language of first title if there's no default language
													return title.GetLang().ToString();
												}
												else
												{
													lang = title.GetLang();
													
													if (Utility.VariableSupport.Empty(lang))
													{
														// Return default language if there's a title with no lang
														return default_lang;
													}
												}
											}
											
											
											return ((TpLangString)titles[0]).GetLang().ToString();
										}
										else
										{
											if (Utility.StringSupport.StringCompare(var, "datasourcelanguage", false) == 0)
											{
												if (this.mMetadata == null)
												{
													this.mMetadata = new TpResourceMetadata();
													
													metadata_file = this.GetMetadataFile();
													
													try
													{
														StreamReader rdr = File.OpenText(metadata_file);
														string xml = rdr.ReadToEnd();
														rdr.Close();

														xml = xml.Replace("[LAST_MODIFIED_DATE]", mSettings.GetModified());
														xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());

														this.mMetadata.LoadFromXml(this.mCode, xml);
													}
													catch(Exception )
													{
														string error = "Could not open metadata file.";
														new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
													}
				
												}
												
												return Utility.TypeSupport.ToString(this.mMetadata.GetLanguage());
											}
											else
											{
												if (Utility.StringSupport.StringCompare(var, "dataSourceDescription", false) == 0)
												{
													if (this.mMetadata == null)
													{
														this.mMetadata = new TpResourceMetadata();
														
														metadata_file = this.GetMetadataFile();
														
														try
														{
															StreamReader rdr = File.OpenText(metadata_file);
															string xml = rdr.ReadToEnd();
															rdr.Close();

															xml = xml.Replace("[LAST_MODIFIED_DATE]", mSettings.GetModified());
															xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());

															this.mMetadata.LoadFromXml(this.mCode, xml);
														}
														catch(Exception )
														{
															string error = "Could not open metadata file.";
															new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
														}
				
													}
													
													default_lang = Utility.TypeSupport.ToString(this.mMetadata.GetDefaultLanguage());
													
													descriptions = Utility.TypeSupport.ToArray(this.mMetadata.GetDescriptions());
													
													foreach ( TpLangString description in descriptions.Values ) 
													{
														if (Utility.VariableSupport.Empty(default_lang))
														{
															// Return first description if there's no default language
															return description.GetValue().ToString();
														}
														else
														{
															lang = description.GetLang();
															
															if (Utility.VariableSupport.Empty(lang))
															{
																// Return description with empty lang if there's a default language
																return description.GetValue().ToString();
															}
														}
													}
													
													
													return ((TpLangString)descriptions[0]).GetValue().ToString();
												}
												else
												{
													if (Utility.StringSupport.StringCompare(var, "rights", false) == 0)
													{
														if (this.mMetadata == null)
														{
															this.mMetadata = new TpResourceMetadata();
															
															metadata_file = this.GetMetadataFile();
															
															try
															{
																StreamReader rdr = File.OpenText(metadata_file);
																string xml = rdr.ReadToEnd();
																rdr.Close();

																xml = xml.Replace("[LAST_MODIFIED_DATE]", mSettings.GetModified());
																xml = xml.Replace("[ACCESS_POINT]", GetAccesspoint());

																this.mMetadata.LoadFromXml(this.mCode, xml);
															}
															catch(Exception )
															{
																string error = "Could not open metadata file.";
																new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_FATAL);
															}
				
														}
														
														default_lang = Utility.TypeSupport.ToString(this.mMetadata.GetDefaultLanguage());
														
														rights = Utility.TypeSupport.ToArray(this.mMetadata.GetRights());
														
														foreach ( TpLangString rights_in_lang in rights.Values ) 
														{
															if (Utility.VariableSupport.Empty(default_lang))
															{
																// Return first rights if there's no default language
																return rights_in_lang.GetValue().ToString();
															}
															else
															{
																lang = rights_in_lang.GetLang();
																
																if (Utility.VariableSupport.Empty(lang))
																{
																	// Return rights with empty lang if there's a default language
																	return rights_in_lang.GetValue().ToString();
																}
															}
														}
														
														
														return ((TpLangString)rights[0]).GetValue().ToString();
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			return "";
		}// end of member function GetVariable
		
		public virtual string GetDateLastModified()
		{
			string config_file = this.GetConfigFile();
			string date_last_modified;
			string modifier;
			string error;
			bool raise_errors;
			OleDbConnection cn = null;
			string err_str;
			TpSqlBuilder sql_builder;
			string local_filter_sql;
			bool descend;
			string sql;
			DataSet rs = null;
			string err = "";

			
			if (this.mSettings == null)
			{
				this.mSettings = new TpSettings();
				
				this.mSettings.LoadFromXml(config_file, "", false);
			}
			
			// First try the fixed value
			date_last_modified = this.mSettings.GetModified();
			
			// If empty then there should be a field
			if (date_last_modified != null && date_last_modified.Length > 0)
			{
				return date_last_modified;
			}
			
			modifier = this.mSettings.GetModifier();
			
			if (modifier == null || modifier.Length == 0)
			{
				error = "Date Last Modified setting was not configured.";
				new TpDiagnostics().Append(TpConfigManager.DC_CONFIG_FAILURE, error, TpConfigManager.DIAG_WARN);
				
				return "";
			}
			
			if (this.mDataSource == null)
			{
				if (!this.LoadConfigXp())
				{
					return "";
				}
				
				this.mDataSource = new TpDataSource();
				
				this.mDataSource.LoadFromXml(config_file, this.mConfigXp);
			}
			
			raise_errors = false;
			
			if (this.mDataSource.Validate(raise_errors))
			{
				cn = this.mDataSource.GetConnection();
				
				if (cn == null) 
				{
					err_str = "Could not establish a connection with the database!";
					new TpDiagnostics().Append(TpConfigManager.DC_DB_CONNECTION_ERROR, err_str, TpConfigManager.DIAG_ERROR);
					return "";
				}
				
				sql_builder = new TpSqlBuilder();
				
				sql_builder.AddTargetColumn(modifier);
				
				// Tables
				if (this.mTables == null)
				{
					if (!this.LoadConfigXp())
					{
						return "";
					}
					
					this.mTables = new TpTables();
					
					this.mTables.LoadFromXml(config_file, this.mConfigXp);
				}
				
				// Local Filter
				if (this.mLocalFilter == null)
				{
					if (!this.LoadConfigXp())
					{
						return "";
					}
					
					this.mLocalFilter = new TpLocalFilter();
					
					this.mLocalFilter.LoadFromXml(config_file, this.mConfigXp);
				}
				
				// Local Mapping
				if (this.mLocalMapping == null)
				{
					if (!this.LoadConfigXp())
					{
						return "";
					}
					
					this.mLocalMapping = new TpLocalMapping();
					
					this.mLocalMapping.LoadFromXml(config_file);
				}
				
				sql_builder.AddRecordSource(this.mTables.GetStructure());
				
				if (!this.mLocalFilter.IsEmpty())
				{
					local_filter_sql = this.mLocalFilter.GetSql(this);
					
					sql_builder.AddCondition(local_filter_sql);
				}
				
				descend = true;
				
				Utility.OrderedMap ob = new Utility.OrderedMap();
				ob.Add(modifier, descend);
				sql_builder.OrderBy(ob);
				
				sql = sql_builder.GetSql();
				
				new TpDiagnostics().Append(TpConfigManager.DC_DEBUG_MSG, "SQL: " + sql, TpConfigManager.DIAG_DEBUG);
				
				rs = TpDataAccess.SelectLimit(cn, sql, 1, 0);
				
				if (rs == null)
				{
					new TpDiagnostics().Append(TpConfigManager.DC_DATABASE_ERROR, System.Web.HttpUtility.HtmlEncode(err), TpConfigManager.DIAG_ERROR);
					new TpDiagnostics().Append(TpConfigManager.DC_DEBUG_SQL, System.Web.HttpUtility.HtmlEncode(sql), TpConfigManager.DIAG_DEBUG);
					cn.Close();
					return "";
				}
				
				if (rs.Tables.Count > 0 && rs.Tables[0].Rows.Count > 0)
				{
					try
					{
						DateTime date_time_parsed = DateTime.Parse(rs.Tables[0].Rows[0][0].ToString());
						return TpUtils.TimestampToXsdDateTime(date_time_parsed);
					}
					catch(Exception ex)
					{
						// could not parse value returned from db!
						// return current timestamp, but warn users
						err = "Could not parse datetime provided by local database: " + Utility.TypeSupport.ToString(rs.Tables[0].Rows[0][0].ToString());
						new TpDiagnostics().Append(TpConfigManager.DC_GENERAL_ERROR, System.Web.HttpUtility.HtmlEncode(err), TpConfigManager.DIAG_WARN);
					}
				}
								
				this.mDataSource.ResetConnection();
			}
			
			return "";
		}// end of member function GetDateLastModified
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mCode", "mMetadataFile", "mConfigFile", "mCapabilitiesFile", "mDataSource", "mTables", "mLocalFilter", "mLocalMapping", "mStatus", "mAccesspoint");
		}// end of member function __sleep
	}
}
