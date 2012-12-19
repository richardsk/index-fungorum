using System;
using System.Web;
using System.Xml;

namespace TapirDotNET 
{

	public class TpInventoryParameters:TpOperationParameters
	{
		public Utility.OrderedMap mConcepts = new Utility.OrderedMap();
		
		public TpInventoryParameters() : base()
		{
		}
		
		
		public override bool LoadKvpParameters()
		{
			// Concepts
			object concept = null;
			object tag_name = null;
			int i;
			string tag;

			//TODO should this be HttpContext.Current.Request["concept"] for KVP?			
			if (HttpContext.Current.Session["concept"] != null)
			{
				concept = HttpContext.Current.Session["concept"];
			}
			else
			{
				if (HttpContext.Current.Session["c"] != null)
				{
					concept = HttpContext.Current.Session["c"];
				}
			}
			
			if (HttpContext.Current.Session["tagname"] != null)
			{
				tag_name = HttpContext.Current.Session["tagname"];
			}
			else
			{
				if (HttpContext.Current.Session["n"] != null)
				{
					tag_name = HttpContext.Current.Session["n"];
				}
			}
			
			if (concept != null)
			{
				if (concept is Utility.OrderedMap)
				{
					i = 0;
					
					foreach ( object concept_id in Utility.TypeSupport.ToArray(concept).Values ) 
					{
						tag = "value";
						
						if (tag_name is Utility.OrderedMap && ((Utility.OrderedMap)tag_name)[i] != null)
						{
							tag = ((Utility.OrderedMap)tag_name)[i.ToString()].ToString();
						}
						
						this.mConcepts[concept_id] = tag;
						
						++i;
					}
					
				}
				else if (concept is System.String)
				{
					tag = "value";
					
					if (tag_name != null && !(tag_name is Utility.OrderedMap))
					{
						tag = tag_name.ToString();
					}
					
					this.mConcepts[concept] = tag;
				}
			}
			
			return base.LoadKvpParameters();
		}// end of member function LoadKvpParameters
		
		public override void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs) 
		{
			string name;
			int depth;
			string tag;
			name = TpUtils.GetUnqualifiedName(Utility.TypeSupport.ToString(reader.XmlReader.Name));
			
			base.StartElement(reader, attrs);
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			// <concept> element whose parent is <concepts>
			if (depth > 1 && this.mInTags[depth - 2].ToString() == "concepts" && Utility.StringSupport.StringCompare(name, "concept", false) == 0 && attrs["id"].ToString() != "")
			{
				tag = "value";
				
				if (attrs["tagName"] != null && attrs["tagName"].ToString() != "")
				{
					tag = attrs["tagName"].ToString();
				}
				
				this.mConcepts[attrs["id"].ToString()] = tag;
			}
		}// end of member function StartElement
		
		public override void  EndElement(TpXmlReader reader)
		{
			base.EndElement(reader);
		}// end of member function EndElement
		
		public override void  CharacterData(TpXmlReader reader, string data)
		{
			base.CharacterData(reader, data);
		}// end of member function CharacterData
		
		public virtual Utility.OrderedMap GetConcepts()
		{
			return this.mConcepts;
		}// end of member function GetConcepts
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mConcepts"));
		}// end of member function __sleep
	}
}
