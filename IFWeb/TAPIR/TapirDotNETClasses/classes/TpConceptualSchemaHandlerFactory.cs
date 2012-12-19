namespace TapirDotNET 
{

	public class TpConceptualSchemaHandlerFactory
	{
		public TpConceptualSchemaHandlerFactory()
		{
			
		}
		
		
		public virtual TpConceptualSchemaHandler GetInstance(string id)
		{
			if (id == "DarwinSchemaHandler_v1")
			{
				return new DarwinSchemaHandler_v1();
			}
			else if (id == "DarwinSchemaHandler_v2")
			{
				return new DarwinSchemaHandler_v2();
			}
			else if (id == "CnsSchemaHandler_v1") 
			{
				return new CnsSchemaHandler_v1();
			}

			return null;
		}// end of member function GetInstance
	}
}
