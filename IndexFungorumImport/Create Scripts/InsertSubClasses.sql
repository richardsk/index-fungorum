IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertSubClasses')
	BEGIN
		PRINT 'Dropping Procedure InsertSubClasses'
		DROP  Procedure  InsertSubClasses
	END

GO

PRINT 'Creating Procedure InsertSubClasses'
GO
CREATE Procedure InsertSubClasses
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertSubClasses
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
	SELECT distinct [kingdom name] + ',' + [phylum name] + ',' + [class name], [subclass name]
	FROM tblfundicclassification
	where [subclass name] <> 'incertae sedis'

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
            select distinct null, fc.[subclass name], fc.[subclass name], 26, @dt, 1, @parent
            from tblfundicclassification fc
            where [subclass name] = @clName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @clName
	END

	CLOSE nc
	DEALLOCATE nc


GO

GRANT EXEC ON InsertSubClasses TO PUBLIC

GO
