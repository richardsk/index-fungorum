using System;
using System.Xml;

namespace TapirDotNET 
{

	public class TpTables
	{
		public TpTable mRootTable = null;
		public TpTable mCurrentTable = null;
		public Utility.OrderedMap mTables = new Utility.OrderedMap();// TpTable object// Ancilary property when building table structure
		
		public TpTables()
		{
			
		}
		
		
		public virtual bool IsLoaded()
		{
			return (this.mRootTable != null);
		}// end of member function IsLoaded
		
		public virtual void  LoadDefaults()
		{
			this.mRootTable = new TpTable();
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			
		}// end of member function LoadFromSession
		
		public virtual void  LoadFromXml(string file, XmlDocument xpr)
		{
			string error;
			string path_to_table;

			if (xpr == null)
			{
				xpr = new XmlDocument();
				
				try
				{
					xpr.Load(file);
				}
				catch(Exception ex)
				{
					error = "Could not import content from XML file: " + ex.Message;
					new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
					return ;
				}
			}
			
			path_to_table = "/configuration[1]/table[1]";
			
			// Second parameter should be empty (no header) 
			string xml = xpr.SelectSingleNode(path_to_table).OuterXml;
						
			this.LoadTables(xml);
		}// end of member function LoadFromXml
		
		public virtual string GetXml()
		{
			return this.mRootTable.GetXml();
		}// end of member function GetXml
		
		public virtual string GetRoot()
		{
			string table_name;
			string table_key;
			if (this.mRootTable != null)
			{
				table_name = this.mRootTable.GetName();
				table_key = this.mRootTable.GetKey();
				
				if (table_name != null && table_key != null)
				{
					return table_name + "." + table_key;
				}
			}
			
			return "";
		}// end of member function GetRoot
		
		public virtual void  SetRootTable(TpTable rootTable)
		{
			this.mRootTable = rootTable;
		}// end of member function SetRootTable
		
		public virtual TpTable GetRootTable()
		{
			return this.mRootTable;
		}// end of member function GetRootTable
		
		public virtual bool IsEmpty()
		{
			string root_table_name;
			if (this.mRootTable == null)
			{
				return false;
			}
			
			root_table_name = this.mRootTable.GetName();
			
			return (root_table_name != null && root_table_name.Length > 0);
		}// end of member function IsEmpty
		
		public virtual bool LoadTables(string xml)
		{
			string error;

			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
								
			try
			{
				rdr.ReadXmlStr(xml);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}		
			
			return true;
		}// end of member function LoadTables
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			string t_name;
			string key;
			string join;
			TpTable table;

			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "table", false) == 0)
			{
				t_name = attrs["name"].ToString();
				key = attrs["key"].ToString();
				join = attrs["join"].ToString();
				
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
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			TpTable r_current_table;
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "table", false) == 0)
			{
				if (this.mCurrentTable != null)
				{
					r_current_table = (TpTable)this.mTables[this.mCurrentTable.GetName()];
					
					this.mCurrentTable = r_current_table.GetParent();
				}
			}
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			
		}// end of member function CharacterData
		
		public virtual Utility.OrderedMap GetStructure()
		{
			return this.mTables;
		}// end of member function GetStructure
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mRootTable", "mTables");
		}// end of member function __sleep
	}
}
