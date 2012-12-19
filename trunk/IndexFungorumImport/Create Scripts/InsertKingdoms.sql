IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertKingdoms')
	BEGIN
		PRINT 'Dropping Procedure InsertKingdoms'
		DROP  Procedure  InsertKingdoms
	END

GO

PRINT 'Creating Procedure InsertKingdoms'
GO
CREATE Procedure InsertKingdoms
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertKingdoms
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

    declare @name varchar(500), @parent uniqueidentifier
    declare @dt datetime
    set @dt = getdate()

    select @parent = nameguid from tblname where namefull = 'biota'

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name]
	FROM tblfundicclassification

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    exec spGetName @name --into #tmpName table
	    
	    if not exists(select * from ##tmpName)
	    begin
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk)
            select distinct null, fc.[kingdom name], fc.[kingdom name], 15, @dt, 1, @parent
            from tblfundicclassification fc
            where [kingdom name] = @name
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO 
			@name
	END

	CLOSE nc
	DEALLOCATE nc

GO

GRANT EXEC ON InsertKingdoms TO PUBLIC

GO 