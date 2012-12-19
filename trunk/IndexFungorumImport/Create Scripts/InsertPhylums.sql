IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertPhylums')
	BEGIN
		PRINT 'Dropping Procedure InsertPhylums'
		DROP  Procedure  InsertPhylums
	END

GO

PRINT 'Creating Procedure InsertPhylums'
GO
CREATE Procedure InsertPhylums
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertPhylums
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


    declare @name varchar(500), @phName varchar(500), @kName varchar(500), @parent uniqueidentifier
    declare @dt datetime
    set @dt = getdate()

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name] + ',' + [phylum name], [phylum name], [kingdom name]
	FROM tblfundicclassification
	where [phylum name] <> 'incertae sedis'

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name, @phName, @kName
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    	
	    exec spGetName @name --into #tmpName table
	    	    
	    if not exists(select * from ##tmpName)
	    begin
	        exec spGetName @kName
	        select @parent = NameGuid from ##tmpName
	        
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk)
            select distinct null, fc.[phylum name], fc.[phylum name], 19, @dt, 1, @parent
            from tblfundicclassification fc
            where [phylum name] = @phName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @phName, @kName
	END

	CLOSE nc
	DEALLOCATE nc


GO

GRANT EXEC ON InsertPhylums TO PUBLIC

GO
