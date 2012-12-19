using System;
using System.Xml;

namespace TapirDotNET 
{

	public class TpSettings
	{
		public int mMaxElementRepetitions;
		public int mMaxElementLevels;
		public string mLogOnly;
		public bool mCaseSensitiveInEquals;
		public bool mCaseSensitiveInLike;
		public string mModifier;
		public string mModified;
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public bool mIsLoaded = false;// table.field that will update date last modified value
		
		public TpSettings()
		{
			LoadDefaults(false);	
			mIsLoaded = false;
		}
		
		
		public virtual bool IsLoaded()
		{
			return this.mIsLoaded;
		}// end of member function IsLoaded
		
		public virtual void  LoadDefaults(bool force)
		{
			if (this.mIsLoaded && !force)
			{
				return ;
			}
			
			this.mMaxElementRepetitions = 200;
			this.mMaxElementLevels = 20;
			this.mLogOnly = "accepted";
			this.mCaseSensitiveInEquals = false;
			this.mCaseSensitiveInLike = false;
			this.mModifier = "";
			
			this.mIsLoaded = true;
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			this.mMaxElementRepetitions = System.Convert.ToInt32(TpUtils.GetVar("max_repetitions", "200"));
			this.mMaxElementLevels = System.Convert.ToInt32(TpUtils.GetVar("max_levels", "20"));
			this.mLogOnly = (string)TpUtils.GetVar("log_only", null);
			if (this.mLogOnly == "") this.mLogOnly = null;
			
			string var = TpUtils.GetVar("case_sensitive_equals", "").ToString();
			
			this.mCaseSensitiveInEquals = (var == "true");
			
			var = TpUtils.GetVar("case_sensitive_like", "").ToString();
			
			this.mCaseSensitiveInLike = (var == "true");
			
			this.mModifier = TpUtils.GetVar("modifier", "").ToString();
			this.mModified = TpUtils.GetVar("modified", "").ToString();
			
			this.mIsLoaded = true;
		}// end of member function LoadFromSession
		
		public virtual bool LoadFromXml(string configFile, string capabilitiesFile, bool force)
		{
			string error;
			string path_to_modifier;
			Utility.OrderedMap attrs;
			if (this.mIsLoaded && !force)
			{
				return true;
			}
			
			// Load from capabilities file, if specified
			if (!Utility.VariableSupport.Empty(capabilitiesFile))
			{
					
				TpXmlReader rdr = new TpXmlReader();
				rdr.StartElementHandler = new StartElement(this.StartElement);
				rdr.EndElementHandler = new EndElement(this.EndElement);
				rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
									
				try
				{
					rdr.ReadXml(capabilitiesFile);
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file (" + capabilitiesFile + ") : " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return false;
				}
			}
				
			// Then load from config file
			XmlDocument xpr = new XmlDocument();
			try
			{				
				xpr.Load(configFile);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			path_to_modifier = "/configuration[1]/settings[1]/dateLastModified[1]";
			
			XmlNode node = xpr.SelectSingleNode(path_to_modifier);
			if (node != null)
			{			
				if (node.Attributes.Count > 0)
				{
					if (node.Attributes["fromField"] != null)
					{
						this.mModifier = node.Attributes["fromField"].Value;
					}
					if (node.Attributes["fixedValue"] != null)
					{
						this.mModified = node.Attributes["fixedValue"].Value;
					}
				}
			}
			
			this.mIsLoaded = true;
			
			return true;
		}// end of member function LoadFromXml
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			bool value_Renamed;
			this.mInTags.Push(reader.XmlReader.Name);
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "equals", false) == 0)
			{
				if (attrs.GetValue("caseSensitive").ToString() != "")
				{
					value_Renamed = (attrs.GetValue("caseSensitive").ToString() == "true");
					
					this.mCaseSensitiveInEquals = value_Renamed;
				}
			}
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "like", false) == 0)
				{
					if (attrs["caseSensitive"].ToString() != "")
					{
						value_Renamed = (attrs["caseSensitive"].ToString() == "true");
						
						this.mCaseSensitiveInLike = value_Renamed;
					}
				}
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			this.mInTags.Pop();
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			int depth;
			string inTag;
			if (data.Trim(new char[]{' ', '\t', '\n', '\r', '0'}).Length > 0)
			{
				depth = Utility.OrderedMap.CountElements(this.mInTags);
				inTag = this.mInTags[depth - 1].ToString();
				
				if (Utility.StringSupport.StringCompare(inTag, "logOnly", false) == 0)
				{
					this.mLogOnly = data.Trim(new char[]{' ', '\t', '\n', '\r', '0'});
				}
				else
				{
					if (Utility.StringSupport.StringCompare(inTag, "maxElementRepetitions", false) == 0)
					{
						this.mMaxElementRepetitions = Utility.TypeSupport.ToInt32(data.Trim(new char[]{' ', '\t', '\n', '\r'}));
					}
					else
					{
						if (Utility.StringSupport.StringCompare(inTag, "maxElementLevels", false) == 0)
						{
							this.mMaxElementLevels = Utility.TypeSupport.ToInt32(data.Trim(new char[]{' ', '\t', '\n', '\r'}));
						}
					}
				}
			}
		}// end of member function CharacterData
		
		public virtual bool Validate(bool raiseErrors)
		{
			bool ret_val;
			string error;
			string pattern;
			ret_val = true;
			
			// Max element repetitions
			if (Utility.VariableSupport.Empty(this.mMaxElementRepetitions))
			{
				if (raiseErrors)
				{
					error = "Please specifiy the maximum element repetitions.";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Max element levels
			if (Utility.VariableSupport.Empty(this.mMaxElementLevels))
			{
				if (raiseErrors)
				{
					error = "Please specifiy the maximum element levels.";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Log only
			if (this.mLogOnly == null)
			{
				if (raiseErrors)
				{
					error = "Please specifiy the log only setting.";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			if (Utility.VariableSupport.Empty(this.mModifier) && Utility.VariableSupport.Empty(this.mModified))
			{
				if (raiseErrors)
				{
					error = "Please specify one of the options for date last modified.";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			else if (!Utility.VariableSupport.Empty(this.mModifier) && !Utility.VariableSupport.Empty(this.mModified))
			{
				if (raiseErrors)
				{
					error = "Please specify only one of the options for date last modified.";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate modified
			pattern = "[\\-]?\\d{4}\\-\\d{2}\\-\\d{2}T\\d{2}:\\d{2}:\\d{2}([Z|(+|\\-)]\\d{2}\\:\\d{2})?";
			
			if (this.mModified != null && this.mModified.Length > 0 && !new System.Text.RegularExpressions.Regex("^" + pattern + "$").Match(this.mModified).Success)
			{
				if (raiseErrors)
				{
					error = "Fixed value for \"Date last modified\" does not match the " + "xsd:dateTime format: [-]CCYY-MM-DDThh:mm:ss[Z|(+|-)hh:mm]";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			return ret_val;
		}// end of member function Validate
		
		public virtual string GetConfigXml()
		{
			string xml;
			xml = "\t<settings>\r\n";
			
			xml += "\t\t<dateLastModified";
			
			if (!Utility.VariableSupport.Empty(this.mModifier))
			{
				xml += " fromField=\"" + this.mModifier + "\"";
			}
			else
			{
				xml += " fixedValue=\"" + this.mModified + "\"";
			}
			
			xml += "/>\r\n";
			
			xml += "\t\t<maxElementRepetitions>" + mMaxElementRepetitions.ToString() + "</maxElementRepetitions>\r\n";
			xml += "\t\t<maxElementLevels>" + mMaxElementLevels.ToString() + "</maxElementLevels>\r\n";

			xml += "\t</settings>\r\n";
			
			return xml;
		}// end of member function GetConfigXml
		
		public virtual void  SetMaxElementRepetitions(int max)
		{
			this.mMaxElementRepetitions = max;
		}// end of member function SetMaxElementRepetitions
		
		public virtual int GetMaxElementRepetitions()
		{
			return this.mMaxElementRepetitions;
		}// end of member function GetMaxElementRepetitions
		
		public virtual int GetMaxElementLevels()
		{
			return this.mMaxElementLevels;
		}// end of member function GetMaxElementLevels
		
		public virtual string GetLogOnly()
		{
			return this.mLogOnly;
		}// end of member function GetLogOnly
		
		public virtual bool GetCaseSensitiveInEquals()
		{
			return this.mCaseSensitiveInEquals;
		}// end of member function GetCaseSensitiveInEquals
		
		public virtual bool GetCaseSensitiveInLike()
		{
			return this.mCaseSensitiveInLike;
		}// end of member function GetCaseSensitiveInLike
		
		public virtual string GetModifier()
		{
			return this.mModifier;
		}// end of member function GetModifier
		
		public virtual string GetModified()
		{
			return this.mModified;
		}// end of member function GetModified
		
		public virtual void  SetModified(string modified)
		{
			this.mModified = modified;
		}// end of member function SetModified
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{			
			return new Utility.OrderedMap("mMaxElementRepetitions", "mMaxElementLevels", "mLogOnly", "mCaseSensitiveInEquals", "mCaseSensitiveInLike", "mModifier", "mModified", "mIsLoaded");
		}// end of member function __sleep
	}
}
