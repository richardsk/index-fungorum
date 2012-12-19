IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'InsertOrders')
	BEGIN
		PRINT 'Dropping Procedure InsertOrders'
		DROP  Procedure  InsertOrders
	END

GO

PRINT 'Creating Procedure InsertOrders'
GO
CREATE Procedure InsertOrders
	/* Param List */
AS

/******************************************************************************
**		File: 
**		Name: InsertOrders
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

    declare @name varchar(500), @oName varchar(500), @parent uniqueidentifier, @fullname varchar(500)
    declare @dt datetime
    set @dt = getdate()

	DECLARE nc  CURSOR FAST_FORWARD FOR
	SELECT distinct [kingdom name] + ',' + [phylum name] + ',' + [class name] + ',' + [subclass name], [order name]
	FROM tblfundicclassification
	where [order name] <> 'incertae sedis'

	OPEN nc
	-- Perform the first fetch.
	FETCH NEXT FROM nc INTO @name, @oName
		
	-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
	WHILE @@FETCH_STATUS = 0
	BEGIN
	    	
	    set @fullname = @name + ',' + @oName
	    exec spGetName @fullname --into #tmpName table
	    	    
	    if not exists(select * from ##tmpName)
	    begin
	        exec spGetName @name
	        select @parent = NameGuid from ##tmpName
	        
	        insert into tblname(NameCounter, NameFull, NameCanonical, NameTaxonRankFk, NameAddedDate, NameAddedByFk, NameParentFk)
            select distinct null, fc.[order name], fc.[order name], 17, @dt, 1, @parent
            from tblfundicclassification fc
            where [order name] = @oName
	    end
			
		-- This is executed as long as the previous fetch succeeds.
		FETCH NEXT FROM nc INTO @name, @oName
	END

	CLOSE nc
	DEALLOCATE nc

GO

GRANT EXEC ON InsertOrders TO PUBLIC

GO
