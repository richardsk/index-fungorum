IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'UpdateAllNames')
	BEGIN
		PRINT 'Dropping Procedure UpdateAllNames'
		DROP  Procedure  UpdateAllNames
	END

GO

PRINT 'Creating Procedure UpdateAllNames'
GO
CREATE Procedure UpdateAllNames
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: UpdateAllNames
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

--set LSIDs
update tblname set namelsid = 
    isnull('URN:LSID:indexfungorum.org:Names:' + cast(namecounter as varchar(20)),'')
where namelsid is null 

update tblname set nameupk = nameguid where nameupk is null

update tblname set namecurrentfk = nameguid where namecurrentfk is null

update tblname set NameNomCode = 'ICZN'

GO

GRANT EXEC ON UpdateAllNames TO PUBLIC

GO
