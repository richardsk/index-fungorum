namespace TapirDotNET 
{

	public class TpConceptMappingFactory
	{
		public TpConceptMappingFactory()
		{
			
		}
		
		
		public virtual TpConceptMapping GetInstance(string id)
		{
			if (id == "SingleColumnMapping")
			{
				return new SingleColumnMapping();
			}
			else if (id == "FixedValueMapping")
			{
				return new FixedValueMapping();
			}
			else if (id == "LSIDDataMapping")
			{
				return new LSIDDataMapping();
			}
			
			return null;
		}// end of member function GetInstance
		
		public virtual Utility.OrderedMap GetOptions()
		{
			return new Utility.OrderedMap(new object[]{"unmapped", "-- unmapped --"}, new object[]{"SingleColumnMapping", "single column"}, new object[]{"LSIDDataMapping", "LSID data"}, new object[]{"FixedValueMapping", "fixed value"});
		}// end of member function GetOptions
	}
}
