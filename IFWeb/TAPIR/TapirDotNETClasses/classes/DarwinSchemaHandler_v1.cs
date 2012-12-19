namespace TapirDotNET 
{

	public class DarwinSchemaHandler_v1:TpConceptualSchemaHandler
	{
		public TpConceptualSchema mConceptualSchema;
		
		public DarwinSchemaHandler_v1()
		{
			
		}
		
		
		public override bool Load(TpConceptualSchema conceptualSchema)
		{
			this.mConceptualSchema = conceptualSchema;
			return false;
			// Just a stub. Old Darwin not supported yet.
		}// end of member function Load
	}
}
