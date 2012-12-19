IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertFamilies')
	BEGIN
		PRINT 'Dropping Procedure InsertFamilies'
		DROP  Procedure  InsertFamilies
	END

GO

PRINT 'Creating Procedure InsertFamilies'
GO
CREATE Procedure InsertFamilies
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertFamilies
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


    declare @name varchar(500), @fName varchar(500), @parent uniqueidentifier, @fullname varchar(500)
    declare @dt datetime
    set @dt = getdate()

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name] + ',' + [phylum name] + ',' + [class name] + ',' + [subclass name] + ',' + [order name],
	    [family name]
	FROM tblfundicclassification
	where [family name] <> 'incertae sedis'

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name, @fName
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    	
	    set @fullname = @name + ',' + @fName
	    exec spGetName @fullname --into #tmpName table
	    	    
	    if not exists(select * from ##tmpName)
	    begin
	        exec spGetName @name
	        select @parent = NameGuid from ##tmpName
	        
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk, NameAuthors, NameYearOfPublication, NameYearOnPublication, NamePage, NameOrthographyVariant)
            select distinct f.id, fc.[family name], fc.[family name], 7, @dt, 1, @parent, f.[authors], f.[year of publication], f.[year on publication], left(f.page, 20), f.[orthography comment]
            from tblfundicclassification fc
            left join tblFamilyNames f on f.[genus fundic record number] = fc.[fundic record number]
            where fc.[family name] = @fName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @fName
	END

	CLOSE nc
	DEALLOCATE nc
    
GO

GRANT EXEC ON InsertFamilies TO PUBLIC

GO
