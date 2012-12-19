namespace TapirDotNET 
{

	public class TpTransparentConcept:TpConcept
	{
		public TpTransparentConcept(string table, string field, object localType)
		{
			this.mMapping = new SingleColumnMapping();
			
			((SingleColumnMapping)this.mMapping).SetTable(table);
			((SingleColumnMapping)this.mMapping).SetField(field);
			this.mMapping.SetLocalType(localType);
			
			this.SetId(table + "." + field);
		}
		
		
		public override void SetId(string id)
		{
			// ids in this case are "table.column"
			Utility.OrderedMap parts;
			
			base.SetId(id);
			
			parts = new Utility.OrderedMap(id.ToString().Split(".".ToCharArray()));
			
			if (Utility.OrderedMap.CountElements(parts) == 2)
			{
				((SingleColumnMapping)this.mMapping).SetTable(parts[0].ToString());
				((SingleColumnMapping)this.mMapping).SetField(parts[1].ToString());
			}
		}// end of member function SetId
	}
}
