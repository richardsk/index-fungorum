using System;
using System.Web;
using System.Xml;

namespace TapirDotNET 
{

	public class TpResources
	{
		public Utility.OrderedMap mResources = new Utility.OrderedMap();// TpResource objects
		
		// No constructor - this class uses the singleton pattern
		// Use GetInstance instead

		private static TpResources instance = null;
		
		public virtual TpResources GetInstance()
		{
			
			if (instance == null)
			{
				if (HttpContext.Current.Session["resources"] != null && HttpContext.Current.Request.QueryString["force_reload"] == null)
				{
					instance = (TpResources)HttpContext.Current.Session["resources"];
				}
				else
				{
					instance = new TpResources();		
					instance.Load();
				}
			}
			else
			{
				if (HttpContext.Current.Request.QueryString["force_reload"] != null)
				{
					instance = new TpResources();					
					instance.Load();
				}
			}
			
			return instance;
		}// end of member function GetInstance
		
		public virtual TpResource GetResource(string code, bool raiseError)
		{
			int i;
			string error;

			for (i = 0; i < Utility.OrderedMap.CountElements(this.mResources); ++i)
			{
				if (Utility.StringSupport.StringCompare(code, ((TpResource)this.mResources[i]).GetCode(), false) == 0)
				{
					return (TpResource)this.mResources[i];
				}
			}
			
			if (raiseError)
			{
				error = "Could not find resource identified by code \"" + code + "\". Please check installation.";
				new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, error, TpConfigManager.DIAG_ERROR);
			}
			
			return null;
		}// end of member function GetResource
		
		public virtual Utility.OrderedMap GetAllResources()
		{
			return this.mResources;
		}// end of member function GetAllResources
		
		public virtual Utility.OrderedMap GetActiveResources()
		{
			Utility.OrderedMap active;
			active = new Utility.OrderedMap();
			
			foreach ( TpResource resource in this.mResources.Values ) 
			{
				if (resource.GetStatus() == "active")
				{
					active.Push(resource);
				}
			}
			
			
			return active;
		}// end of member function GetActiveResources
		
		public virtual void  Load()
		{
			string file = this.GetFile();
			string error;
			
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
								
			try
			{
				rdr.ReadXml(file);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
			}

			this.SaveOnSession();
		}// end of member function Load
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			TpResource resource;
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "resource", false) == 0)
			{
				resource = new TpResource();
				
				if (attrs["code"] != null)
				{
					resource.SetCode(Utility.TypeSupport.ToString(attrs["code"]));
				}
				
				if (attrs["status"] != null)
				{
					resource.SetStatus(Utility.TypeSupport.ToString(attrs["status"]));
				}
			
				if (attrs["accesspoint"] != null)
				{
					resource.SetAccesspoint(Utility.TypeSupport.ToString(attrs["accesspoint"]));
				}
				
				if (attrs["metadataFile"] != null)
				{
					resource.SetMetadataFile(Utility.TypeSupport.ToString(attrs["metadataFile"]));
				}
				
				if (attrs["configFile"] != null)
				{
					resource.SetConfigFile(Utility.TypeSupport.ToString(attrs["configFile"]));
				}
				
				if (attrs["capabilitiesFile"] != null)
				{
					resource.SetCapabilitiesFile(Utility.TypeSupport.ToString(attrs["capabilitiesFile"]));
				}
				
				this.AddResource(resource);
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			
		}// end of member function CharacterData
		
		public virtual void  AddResource(TpResource resource)
		{
			this.mResources.Push(resource);
		}// end of member function AddResource
		
		public virtual bool RemoveResource(string code)
		{
			int index;
			Utility.OrderedMap files;
			string error;
			index = 0;
			
			foreach ( TpResource resource in this.mResources.Values ) 
			{
				if (Utility.StringSupport.StringCompare(code, resource.GetCode(), false) == 0)
				{
					files = Utility.TypeSupport.ToArray(resource.GetAssociatedFiles());
					
					foreach ( string file in files.Values ) 
					{
						if ((System.IO.File.Exists(file) || System.IO.Directory.Exists(file)))
						{
							try
							{
								System.IO.File.Delete(file);
							}
							catch(Exception )
							{
								error = "Could not remove associated file \"" + Utility.TypeSupport.ToString(file) + "\". Please check file system permissions.";
								new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, error, TpConfigManager.DIAG_ERROR);
								return false;
							}
						}
					}
					
					
					Utility.OrderedMap.Splice(ref this.mResources, index, 1, null);
					
					if (!this.Save())
					{
						return false;
					}
					
					return true;
				}
				
				++index;
			}
			
			
			error = "Could not find resource identified by code \"" + code + "\". Please check installation.";
			new TpDiagnostics().Append(TpConfigManager.DC_SERVER_SETUP_ERROR, error, TpConfigManager.DIAG_ERROR);
			
			return false;
		}// end of member function RemoveResource
		
		public virtual string GetFile()
		{
			return TpConfigManager.TP_CONFIG_DIR + "\\" + TpConfigManager.TP_RESOURCES_FILE;		
		}// end of member function GetFile
		
		public virtual string GetXml()
		{
			string xml = "<resources>\r\n";
			
			foreach ( TpResource resource in this.mResources.Values ) 
			{
				xml += "\t" + Utility.TypeSupport.ToString(resource.GetXml()) + "\r\n";
			}
			
			
			xml += "</resources>\r\n";
			
			return xml;
		}// end of member function GetXtml
		
		public virtual bool Save()
		{
			object last_error;
			string new_error;
			
			if (!new TpConfigUtils().WriteToFile(this.GetXml(), this.GetFile()))
			{
				last_error = new TpDiagnostics().PopDiagnostic();
				
				new_error = string.Format("Could not write resources file: {0}", last_error);
				
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, new_error, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
			
			this.SaveOnSession();
			
			return true;
		}// end of member function Save
		
		public virtual void  SaveOnSession()
		{
			HttpContext.Current.Session["resources"] = this;
		}// end of member function SaveOnSession
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mResources");
		}// end of member function __sleep
	}
}
