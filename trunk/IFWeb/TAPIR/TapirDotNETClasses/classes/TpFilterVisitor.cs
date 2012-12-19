namespace TapirDotNET 
{

	public class TpFilterVisitor
	{
		public TpFilterVisitor()
		{
			
		}
		
		
		public virtual object VisitLogicalOperator(TpLogicalOperator lop, object args)
		{
			return null;	
		}// end of member function VisitLogicalOperatior
		
		public virtual object VisitComparisonOperator(TpComparisonOperator cop, object args)
		{
			return null;
		}// end of member function VisitComparisonOperator
		
		public virtual object VisitExpression(TpExpression expression, object args)
		{
			return null;
		}// end of member function VisitExpression
	}
}
