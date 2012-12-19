IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertGenuses')
	BEGIN
		PRINT 'Dropping Procedure InsertGenuses'
		DROP  Procedure  InsertGenuses
	END

GO

PRINT 'Creating Procedure InsertGenuses'
GO
CREATE Procedure InsertGenuses
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertGenuses
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


    declare @name varchar(500), @gName varchar(500), @parent uniqueidentifier, @fullname varchar(500)
    declare @dt datetime
    set @dt = getdate()

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name] + ',' + [phylum name] + ',' + [class name] + ',' + [subclass name] + ',' 
	    + [order name] + ',' + [family name], [genus name]
	FROM tblfundicclassification
	where [genus name] <> 'incertae sedis'

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name, @gName
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    	
	    set @fullname = @name + ',' + @gName
	    exec spGetName @fullname --into #tmpName table
	    	    
	    if not exists(select * from ##tmpName)
	    begin
	        exec spGetName @name
	        select @parent = NameGuid from ##tmpName
	        
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk, NameAuthors, NameYearOfPublication, NameYearOnPublication, NamePage, NameOrthographyVariant)
            select distinct [fundic record number], fc.[genus name], fc.[genus name], 8, @dt, 1, @parent, fc.authors, fc.[year of publication], fc.[year on publication], left(fc.page,20), fc.[orthography comment]
            from tblfundicclassification fc
            where [genus name] = @gName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @gName
	END

	CLOSE nc
	DEALLOCATE nc


update n
set n.namecurrentfk = n.nameguid
from tblname n
inner join tblfundicclassification fc on fc.[fundic record number] = n.namecounter

update n
set n.namecurrentfk = c.nameguid
from tblname n
inner join tblfundicclassification fc on fc.[fundic record number] = n.namecounter
inner join tblname c on c.namecounter = fc.[correct name fundic record number]

GO

GRANT EXEC ON InsertGenuses TO PUBLIC

GO
