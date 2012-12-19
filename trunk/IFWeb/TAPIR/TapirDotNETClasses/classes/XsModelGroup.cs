namespace TapirDotNET 
{

	public class XsModelGroup
	{
		public object mCompositor;
		public Utility.OrderedMap mParticles = new Utility.OrderedMap();
		public int mMinOccurs = 1;
		public int mMaxOccurs = 1; //-1 = unbounded
		
		public XsModelGroup(object compositor)
		{
			this.mCompositor = compositor;
		}
		
		
		public virtual object GetCompositor()
		{
			return this.mCompositor;
		}// end of member function GetCompositor
		
		public virtual void  AddParticle(object rParticle)
		{
			this.mParticles[Utility.OrderedMap.CountElements(this.mParticles)] = rParticle;
		}// end of member function AddParticle
		
		public virtual Utility.OrderedMap GetParticles()
		{
			return this.mParticles;
		}// end of member function GetParticles
		
		public virtual void  SetMinOccurs(int minOccurs)
		{
			this.mMinOccurs = minOccurs;
		}// end of member function SetMinOccurs
		
		public virtual void  SetMaxOccurs(int maxOccurs)
		{
			this.mMaxOccurs = maxOccurs;
		}// end of member function SetMaxOccurs
		
		public virtual int GetMinOccurs()
		{
			return this.mMinOccurs;
		}// end of member function GetMinOccurs
		
		public virtual int GetMaxOccurs()
		{
			return this.mMaxOccurs;
		}// end of member function GetMaxOccurs
		
		public virtual object Accept(object visitor, object path)
		{
			return ((TpSchemaVisitor)visitor).VisitModelGroup(this, path);
		}// end of member function Accept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mCompositor", "mParticles");
		}// end of member function __sleep
	}
}
