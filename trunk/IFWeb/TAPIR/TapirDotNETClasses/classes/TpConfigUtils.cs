using System;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Xml;
using System.Xml.XPath;

namespace TapirDotNET 
{

	public class TpConfigUtils
	// only class methods
	{
		 /**
		* Writes a string into a file.
		*
		* @param $content Content
		* @param $file File name (including path)
		* @return True fr success, false otherwise
		*/
		public virtual bool WriteToFile(string content, string file)
		{
			bool status;
			System.IO.StreamWriter h_file;
			string err_str;
			status = false;
			
			try
			{
				// Did we open the file ok?
				h_file = File.CreateText(file);
			}
			catch(Exception ex)
			{
				err_str = "Failed to open file: '" + file + "'.  " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			
			try
			{
				h_file.Write(content);
			}
			catch(Exception)
			{
				err_str = "Error when writting file: '" + file + "'.";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			// Flush and unlock the file
			try
			{
				h_file.Flush();
			}
			catch (System.Exception )
			{
			}
			status = true;
			
			try
			{
				h_file.Close();
			}
			catch (System.Exception )
			{
			}
			
			// Sanity check the produced file.
			
			if (status && (new System.IO.FileInfo(file).Length < content.Length))
			{
				err_str = "Error when writting file: '" + file + "'.";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, err_str, TpConfigManager.DIAG_ERROR);
				status = false;
			}
			
			return status;
		}// end of WriteToFile
		
		 /**
		* Writes a piece of XML string (related to a single element) into a
		* specific place in a file. Requires a previous sibling element.
		*
		* @param $content Piece of XML content (single element, simple or complex)
		* @param $currentXpath XPath to be element that will be substituted
		* @param $prevSiblingXpath XPath of the previous sibling element
		* @param $file XML file name (including path)
		* @return True on success, false otherwise
		*/
		public virtual bool WriteXmlPiece(string content, string currentXpath, string prevXpath, string file)
		{
			XmlDocument doc = new XmlDocument();
			string error;
			
			// Load existing file			
			try
			{
				doc.Load(file);
			}
			catch(Exception ex)
			{
				error = "Could not load the XML file " + file + ".";
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}


			// Remove tag if there's one
			try
			{				
				XmlNode node = doc.SelectSingleNode(currentXpath);
				if (node != null) node.ParentNode.RemoveChild(node);				
			}
			catch(Exception ex)
			{
				error = string.Format("Could not prepare XML file ({0}) to be updated: {1}", file, ex.Message);
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}

			// Add new tag		
			try
			{		
				XmlNode node = doc.SelectSingleNode(prevXpath);
				if (node == null)
				{
					error = string.Format("Could not update XML content in \"{0}\"", file);
					new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, error, TpConfigManager.DIAG_ERROR);
					return false;
				}
				else
				{	
					string elem = prevXpath.Substring(prevXpath.LastIndexOf("/") + 1);
					if (elem.IndexOf("[") != -1) elem = elem.Substring(0, elem.IndexOf("["));
					XmlQualifiedName qn = new XmlQualifiedName(elem);	
					bool sameLevel = (Utility.StringSupport.SubstringCount(prevXpath, "/") == Utility.StringSupport.SubstringCount(currentXpath, "/"));
					XmlNode cn = node.ParentNode;

					if (sameLevel)
					{
						cn.InnerXml += "\r\n" + content;
					}				
					else
					{
						//create all nodes for the current path
						string path = currentXpath;
						if (path[0] == '/') path = path.Substring(1);

						int pos = 0;
						int endPos = path.IndexOf("/");
						int num = 0;
						while(endPos != -1)
						{			
							num = 0;
							elem = path.Substring(pos, endPos - pos);
							if (elem.IndexOf("[") != -1) 
							{
								string numStr = elem.Substring(elem.IndexOf("[")+1);
								numStr = numStr.Trim(']');
								try
								{
									num = int.Parse(numStr) - 1;								
								}
								catch(Exception ex){}

								elem = elem.Substring(0, elem.IndexOf("["));
							}

							XmlNodeList ns = cn.SelectNodes(elem);
							if (ns.Count <= num)
							{
								cn = cn.AppendChild(doc.CreateElement(elem));
							}
							else
							{
								cn = ns[num];
							}

							pos = endPos + 1;
							endPos = path.IndexOf("/", pos);
						}

						cn.InnerXml += content;


						/*int loc = 0;
						for (int i = 0; i < Utility.StringSupport.SubstringCount(currentXpath, "/"); i++)
						{
							loc = currentXpath.IndexOf("/", loc);
						}
						loc++;

						int pos = currentXpath.IndexOf("/", loc);
						while(pos != -1)
						{							
							elem = currentXpath.Substring(loc, pos - loc);
							if (elem.IndexOf("[") != -1) elem = elem.Substring(0, elem.IndexOf("["));
							cn = cn.AppendChild(doc.CreateElement(elem));

							loc = pos + 1;
							pos = currentXpath.IndexOf("/", loc);
						}
						cn = cn.AppendChild(doc.CreateElement(qn.ToString(), qn.Namespace));
						cn.InnerXml = content;*/
					}
				}
			}
			catch(Exception ex)
			{
				error = string.Format("Could not update XML content in \"{0}\" : {1}", file, ex.Message);
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}

			
			
			// Save
			try
			{
				doc.Save(file);
			}
			catch(Exception ex)
			{
				error = string.Format("Could not update XML content in \"{0}\": {1}", file, ex.Message);
				new TpDiagnostics().Append(TpConfigManager.DC_IO_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}

			return true;
		}// end of WriteXmlPiece
		
		public virtual bool ValidateLangSection(string sectionName, Utility.OrderedMap langStrings, bool raiseErrors, bool mandatoryField, object defaultLang)
		{
			Utility.OrderedMap errors;
			Utility.OrderedMap langs;
			int numStrings;
			string lang;
			string error;
			errors = new Utility.OrderedMap();
			
			langs = new Utility.OrderedMap();
			
			numStrings = Utility.OrderedMap.CountElements(langStrings);
			
			foreach ( object lang_string in langStrings.Values ) {
				// No empty value if it's a mandatory field
				if (mandatoryField && ((TpLangString)lang_string).GetValue().ToString().Length == 0)
				{
					errors.Push("at least one value is empty");
				}
				
				lang = ((TpLangString)lang_string).GetLang().ToString();
				
				// No empty lang if there's no default lang specified
				if (defaultLang == null && lang.Length == 0)
				{
					errors.Push("the language must be specified when " + "\n" + "there is no default language for the " + "entire metadata");
				}
				
				// No multiple values with more than one empty lang
				if (numStrings > 1 && lang.Length == 0)
				{
					errors.Push("the language must be specified when " + "there are multiple values");
				}
				
				// No duplicate langs
				if (langs.Search(lang) != null)
				{
					errors.Push("each value must be associated with a " + "distinct language");
				}
				
				langs.Push(lang);
			}
			
			
			errors = Utility.OrderedMap.Unique(errors);
			
			if (Utility.OrderedMap.CountElements(errors) > 0)
			{
				if (raiseErrors)
				{
					error = "Section \"" + sectionName + "\" is incorrect: " + Utility.StringSupport.Join(",", errors) + ".";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				return false;
			}
			
			return true;
		}// end of ValidateLangSection
		
		public virtual string GetFieldType(string meta_type_id)
		{
			try
			{
				OleDbType meta_type = (OleDbType)int.Parse(meta_type_id);
				
				if (meta_type == OleDbType.BSTR || meta_type == OleDbType.Char ||
					meta_type == OleDbType.LongVarChar || meta_type == OleDbType.LongVarWChar ||
					meta_type == OleDbType.VarChar || meta_type == OleDbType.VarWChar || 
					meta_type == OleDbType.WChar)
				{
					return TpConceptMapping.TYPE_TEXT;
				}
				else if (meta_type == OleDbType.BigInt || meta_type == OleDbType.Decimal ||
					meta_type == OleDbType.Double || meta_type == OleDbType.Integer ||
					meta_type == OleDbType.Numeric || meta_type == OleDbType.Single ||
					meta_type == OleDbType.SmallInt || meta_type == OleDbType.TinyInt ||
					meta_type == OleDbType.UnsignedBigInt || meta_type == OleDbType.UnsignedInt ||
					meta_type == OleDbType.UnsignedSmallInt || meta_type == OleDbType.UnsignedTinyInt ||
					meta_type == OleDbType.VarNumeric)
				{
					return TpConceptMapping.TYPE_NUMERIC;
				}
				else if (meta_type == OleDbType.Boolean)
				{
					return TpConceptMapping.TYPE_BOOL;
				}
				else if (meta_type == OleDbType.Date || meta_type == OleDbType.DBDate)
				{
					return TpConceptMapping.TYPE_DATE;
				}
				else if (meta_type == OleDbType.DBTime || meta_type == OleDbType.DBTimeStamp)
				{
					return TpConceptMapping.TYPE_DATETIME;
				}	
			}
			catch(Exception)
			{
			}		

			return "?";
		}// end of GetFieldType
	}
}
