namespace TapirDotNET 
{

	public class TpTable
	{
		public string mName;
		public string mKey;
		public string mJoin;
		public TpTable mrParent = null;
		public Utility.OrderedMap mChildren = new Utility.OrderedMap();// table name// primary key name// foreign key name in parent table// reference to parent table
		
		public TpTable()
		{
			
		}
		
		
		public virtual void  SetName(string name)
		{
			this.mName = name;
		}// end of member function SetName
		
		public virtual string GetName()
		{
			return this.mName;
		}// end of member function GetName
		
		public virtual void  SetKey(string key)
		{
			this.mKey = key;
		}// end of member function SetKey
		
		public virtual string GetKey()
		{
			return this.mKey;
		}// end of member function GetKey
		
		public virtual void  SetJoin(string key)
		{
			this.mJoin = key;
		}// end of member function SetParentKey
		
		public virtual string GetJoin()
		{
			return this.mJoin;
		}// end of member function GetJoin
		
		public virtual void  SetParent(TpTable rTable)
		{
			this.mrParent = rTable;
		}// end of member function SetParent
		
		public virtual TpTable GetParent()
		{
			return this.mrParent;
		}// end of member function GetParent
		
		public virtual string GetParentName()
		{
			if (this.mrParent != null)
			{
				return this.mrParent.GetName();
			}
			
			return "";
		}// end of member function GetParentName
		
		public virtual void  AddChild(TpTable rTable)
		{
			rTable.SetParent(this);
			
			this.mChildren[rTable.GetName()] = rTable;
		}// end of member function AddChild
		
		public virtual bool RemoveChild(string tableName)
		{
			string msg;
			if (this.mChildren[tableName] != null)
			{
				this.mChildren.Remove(tableName);
				
				return true;
			}
			else
			{
				msg = "Could not find relationship between \"" + this.mName + "\" and \"" + tableName + "\". Failed to remove it.";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
				
				return false;
			}
		}// end of member function AddChild
		
		public virtual Utility.OrderedMap GetChildren()
		{
			return this.mChildren;
		}// end of member function GetChildren
		
		public virtual object GetChild(string tableName)
		{
			string msg;
			object ref_Renamed;
			if (this.mChildren[tableName] != null)
			{
				return this.mChildren[tableName];
			}
			
			msg = "Could not find relationship between \"" + tableName + "\" and \"" + this.mName + "\"";
			new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, msg, TpConfigManager.DIAG_ERROR);
			
			ref_Renamed = null;
			
			return ref_Renamed;
		}// end of member function GetChild
		
		public virtual double GetLevel()
		{
			if (this.mrParent != null)
			{
				return this.mrParent.GetLevel() + 1;
			}
			
			return 1;
		}// end of member function GetLevel
		
		public virtual string GetPath()
		{
			if (this.mrParent != null)
			{
				return this.mrParent.GetPath() + "/" + this.mName;
			}
			
			return this.mName;
		}// end of member function GetPath
		
		public virtual Utility.OrderedMap GetAllTables()
		{
			Utility.OrderedMap tables;
			tables = new Utility.OrderedMap(this.mName);
			
			foreach ( string name in this.mChildren.Keys ) 
			{
				TpTable table = (TpTable)this.mChildren[name];
				tables = Utility.OrderedMap.Merge(tables, table.GetAllTables());
			}
			
			
			return tables;
		}// end of member function GetPath
		
		public virtual TpTable Find(string tableName)
		{
			TpTable ref_Renamed;
			if (tableName == this.mName)
			{
				return this;
			}
			
			ref_Renamed = null;
			
			foreach ( string name in this.mChildren.Keys ) 
			{
				object table = this.mChildren[name];
				ref_Renamed = ((TpTable)this.mChildren[name]).Find(tableName);
				
				if (ref_Renamed != null)
				{
					break;
				}
			}
			
			
			return ref_Renamed;
		}// end of member function GetPath
		
		public virtual string GetXml()
		{
			string join;
			string xml;
			join = "";
			
			if (this.mJoin != "")
			{
				join = " join=\"" + this.mJoin + "\"";
			}
			
			xml = "<table name=\"" + this.mName + "\" key=\"" + this.mKey + "\"" + join + ">";
			
			foreach ( string name in this.mChildren.Keys ) 
			{
				TpTable table = (TpTable)this.mChildren[name];
				xml = xml + table.GetXml();
			}
			
			
			xml += "</table>";
			
			return xml;
		}// end of member function GetXml
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mName", "mKey", "mJoin", "mrParent", "mChildren");
		}// end of member function __sleep
	}
}
