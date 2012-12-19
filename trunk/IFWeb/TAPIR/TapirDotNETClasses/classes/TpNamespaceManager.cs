using System.Xml;

namespace TapirDotNET 
{

	public class TpNamespaceManager
	{
		public Utility.OrderedMap mNamespaces = new Utility.OrderedMap();
		public Utility.OrderedMap mData = new Utility.OrderedMap();// parser obj => array( sequence => TpNamespace obj )
		

		public static TpNamespaceManager instance = null;

		// No constructor - this class uses the singleton pattern
		// Use GetInstance instead
		
		public virtual TpNamespaceManager GetInstance()
		{			
			if (!(instance != null))
			{
				instance = new TpNamespaceManager();
			}
			
			return instance;
		}// end of member function GetInstance
		
		public virtual void  AddNamespace(int parser, string prefix, string uri, string flag)
		{
			TpNamespace namespace_Renamed;
			if (Utility.VariableSupport.Empty(prefix))
			{
				prefix = "default";
			}
			
			namespace_Renamed = new TpNamespace(prefix, uri, flag);
			
			this.mData[parser] = namespace_Renamed;
		}// end of member function AddNamespace
		
		public virtual string GetNamespace(XmlTextReader reader, string prefix)
		{
			Utility.OrderedMap parser_namespaces;
			int i;
			TpNamespace ns;
			string error;
			parser_namespaces = Utility.TypeSupport.ToArray(this.mData[reader]);
			
			for (i = Utility.OrderedMap.CountElements(parser_namespaces) - 1; i >= 0; --i)
			{
				ns = (TpNamespace)parser_namespaces[i];
				
				if (ns.GetPrefix() == prefix)
				{
					return ns.GetUri();
				}
			}
			
			error = "Could not find namespace declaration for prefix \"" + prefix + "\"";
			new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_ERROR);
			
			return null;
		}// end of member function GetNamespace
		
		public virtual string GetPrefix(XmlTextReader reader, string namespace_Renamed)
		{
			Utility.OrderedMap parser_namespaces;
			TpNamespace ns;
			parser_namespaces = Utility.TypeSupport.ToArray(this.mData[reader]);
			
			for (int i = Utility.OrderedMap.CountElements(parser_namespaces) - 1; i >= 0; --i)
			{
				ns = (TpNamespace)parser_namespaces[i];
				
				if (ns.GetUri() == namespace_Renamed)
				{
					return ns.GetPrefix();
				}
			}
			
			return "";
		}// end of member function GetPrefix
		
		public virtual Utility.OrderedMap GetFlaggedNamespaces(XmlTextReader reader, string flag)
		{
			//TODO ??
			Utility.OrderedMap parser_namespaces = Utility.TypeSupport.ToArray(this.mData[reader]);			
			Utility.OrderedMap namespaces_to_return = new Utility.OrderedMap();
			
			for (int i = 0; i < Utility.OrderedMap.CountElements(parser_namespaces); ++i)
			{
				TpNamespace ns = (TpNamespace)parser_namespaces[i];
				
				if (ns.HasFlag(flag))
				{
					namespaces_to_return.Push(ns);
				}
			}
			
			return namespaces_to_return;
		}// end of member function GetFlaggedNamespaces
		
		public virtual void  RemoveFlag(string parser, string flag)
		{
			Utility.OrderedMap r_parser_namespaces;
			
			r_parser_namespaces = Utility.TypeSupport.ToArray(this.mData[parser]);
			
			for (int i = 0; i < Utility.OrderedMap.CountElements(r_parser_namespaces); ++i)
			{
				((TpNamespace)r_parser_namespaces[i]).RemoveFlag(flag);
			}
		}// end of member function RemoveFlag
	}
}
