IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertRanks')
	BEGIN
		PRINT 'Dropping Procedure InsertRanks'
		DROP  Procedure  InsertRanks
	END

GO

PRINT 'Creating Procedure InsertRanks'
GO
CREATE Procedure InsertRanks
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertRanks
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/

insert into tblTaxonRank(TaxonRankName, TaxonRankSort, TaxonRankFullName, TaxonRankColumnText, TaxonRankShowRank)
select distinct i.[infraspecific rank], 5600, i.[infraspecific rank], i.[infraspecific rank], 1
from tblindexfungorum i
where i.[infraspecific rank] is not null and
    not exists(select taxonrankname from tbltaxonrank where taxonrankname = i.[infraspecific rank])


GO

GRANT EXEC ON InsertRanks TO PUBLIC

GO
