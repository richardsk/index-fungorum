using System;
using System.Text;

namespace TapirDotNET 
{

	public class TpNestedList
	{
		public Utility.OrderedMap mList;
		public TpNestedList mParent;
		
		public TpNestedList(Utility.OrderedMap list)
		{
			this.mList = list;
		}
		
		
		public override string ToString()
		{
			string pre;
			Utility.OrderedMap tree;
			pre = "\n" + (new StringBuilder().Insert(0, "  ", this.GetDepth())).ToString();
			
			tree = new Utility.OrderedMap(string.Format("{0}+--", pre));
			
			foreach ( object element in Utility.TypeSupport.ToArray(this.mList).Values ) 
			{
				if (element != null && element.GetType().Name.ToLower() == "tpnestedlist")
				{
					tree.Push(element.ToString());
				}
				else
				{
					if (element != null)
					{
						tree.Push(string.Format("{0}  {1}", pre, element.ToString()));
					}
					else
					{
						tree.Push(string.Format("{0}  [{1}]", pre, element.ToString()));
					}
				}
			}
			
			
			return Utility.StringSupport.Join("", tree);
		}// end of member function ToString
		
		public virtual void  Append(object element)
		{
			if (element is Utility.OrderedMap)
			{
				element = new TpNestedList(new Utility.OrderedMap(element));
			}
			
			if (element != null && element.GetType().Name.ToLower() == "tpnestedlist")
			{
				((TpNestedList)element).SetParent(this);
			}
			
			this.mList[Utility.OrderedMap.CountElements(this.mList)] = element;
		}// end of member function GetParent
		
		public virtual void  SetParent(TpNestedList rParent)
		{
			this.mParent = rParent;
		}// end of member function SetParent
		
		public virtual TpNestedList GetParent()
		{
			return this.mParent;
		}// end of member function GetParent
		
		public virtual object GetElement(int index)
		{
			if (index == - 1)
			{
				index = Utility.OrderedMap.CountElements(this.mList) - 1;
			}
			
			return this.mList[index];
		}// end of member function GetElement
		
		public virtual object GetElements()
		{
			return this.mList;
		}// end of member function GetElments
		
		public virtual void  AddString(int index, string string_Renamed)
		{
			if (index == - 1)
			{
				index = Utility.OrderedMap.CountElements(this.mList) - 1;
			}
			
			this.mList[index] = Utility.TypeSupport.ToString(this.mList[index]) + string_Renamed;
		}// end of member function AddString
		
		public virtual int GetDepth()
		{
			if (this.mParent == null)
			{
				return 0;
			}
			
			return this.mParent.GetDepth() + 1;
		}// end of member function GetDepth
		
		public virtual int GetSize()
		{
			return Utility.OrderedMap.CountElements(this.mList);
		}// end of member function GetSize
	}
}
