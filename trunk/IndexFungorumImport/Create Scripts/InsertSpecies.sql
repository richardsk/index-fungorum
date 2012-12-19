IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertSpecies')
	BEGIN
		PRINT 'Dropping Procedure InsertSpecies'
		DROP  Procedure  InsertSpecies
	END

GO

PRINT 'Creating Procedure InsertSpecies'
GO
CREATE Procedure InsertSpecies
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertSpecies
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

    declare @name varchar(500), @sName varchar(500), @parent uniqueidentifier, @fullname varchar(500)
    declare @dt datetime
    set @dt = getdate()

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name] + ',' + [phylum name] + ',' + [class name] + ',' + [subclass name] + ',' + [order name] + 
	    ',' + [family name] + ',' + [genus name], i.[name of fungus]
	FROM tblfundicclassification fc
	inner join tblindexfungorum i on i.[name of fungus fundic record number] = fc.[fundic record number]
	where i.[name of fungus] <> 'incertae sedis' and i.[infraspecific rank] is null

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name, @sName
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    	
	    set @fullname = @name + ',' + @sName
	    exec spGetName @fullname --into #tmpName table
	    	    
	    if not exists(select * from ##tmpName)
	    begin
	        exec spGetName @name
	        select @parent = NameGuid from ##tmpName
	        
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk, NameAuthors, NameYearOfPublication, NameYearOnPublication, NamePage, NameOrthographyVariant)
            select distinct i.[record number], i.[name of fungus], i.[name of fungus], 24, @dt, 1, @parent, i.authors, i.[year of publication], i.[year on publication], left(i.page,20), i.[orthography comment]
            from tblindexfungorum i
            where [name of fungus] = @sName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @sName
	END

	CLOSE nc
	DEALLOCATE nc
	

update n
set n.namebasionymfk = b.nameguid
from tblname n
inner join tblindexfungorum i on i.[record number] = n.namecounter
inner join tblname b on b.namecounter = i.[basionym record number]


update n
set n.namecurrentfk = n.nameguid
from tblname n
where n.nametaxonrankfk = 24

update n
set n.namecurrentfk = c.nameguid
from tblname n
inner join tblindexfungorum i on i.[record number] = n.namecounter
inner join tblname c on c.namecounter = i.[current name record number]


--set species canonical name
update tblname 
set namecanonical = substring(namefull, charindex(' ',namefull) + 1, len(namefull))
where nametaxonrankfk = 24

GO

GRANT EXEC ON InsertSpecies TO PUBLIC

GO
