IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertClasses')
	BEGIN
		PRINT 'Dropping Procedure InsertClasses'
		DROP  Procedure  InsertClasses
	END

GO

PRINT 'Creating Procedure InsertClasses'
GO
CREATE Procedure InsertClasses
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertClasses
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


    declare @name varchar(500), @clName varchar(500), @parent uniqueidentifier, @fullname varchar(500)
    declare @dt datetime
    set @dt = getdate()

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name] + ',' + [phylum name], [class name]
	FROM tblfundicclassification
	where [class name] <> 'incertae sedis'

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name, @clName
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    	
	    set @fullname = @name + ',' + @clName
	    
	    exec spGetName @fullname --into #tmpName table
	    	    
	    if not exists(select * from ##tmpName)
	    begin
	        exec spGetName @name
	        select @parent = NameGuid from ##tmpName
	        
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk)
            select distinct null, fc.[class name], fc.[class name], 3, @dt, 1, @parent
            from tblfundicclassification fc
            where [class name] = @clName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @clName
	END

	CLOSE nc
	DEALLOCATE nc


GO

GRANT EXEC ON InsertClasses TO PUBLIC

GO
