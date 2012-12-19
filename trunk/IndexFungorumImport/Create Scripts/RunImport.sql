IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'RunImport')
	BEGIN
		PRINT 'Dropping Procedure RunImport'
		DROP  Procedure  RunImport
	END

GO

PRINT 'Creating Procedure RunImport'
GO
CREATE Procedure RunImport
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: RunImport
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

print 'Inserting Ranks...'
exec InsertRanks

if not exists(select * from tblname where namefull = 'biota')
begin
    declare @rootID uniqueidentifier
    select @rootID = nameguid from tblname where namefull = 'root'
    
    insert into tblname(NameCanonical, NameFull, NameTaxonRankFk, NameParentFk)
    values('biota', 'biota', 16, @rootID)
end


print 'Inserting Kingdoms...'
exec InsertKingdoms
print 'Inserting Phylums...'
exec InsertPhylums
print 'Inserting Classes...'
exec InsertClasses
print 'Inserting Subclasses...'
exec InsertSubClasses
print 'Inserting Orders...'
exec InsertOrders
print 'Inserting Families...'
exec InsertFamilies
print 'Inserting Genuses...'
exec InsertGenuses
print 'Inserting Species...'
exec InsertSpecies
print 'Inserting Subspecies...'
exec InsertSubspecies

print 'Update name details...'
exec UpdateAllNames

print 'Done.'

GO

GRANT EXEC ON RunImport TO PUBLIC

GO
