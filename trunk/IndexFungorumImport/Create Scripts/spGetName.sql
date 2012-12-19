IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'spGetName')
	BEGIN
		PRINT 'Dropping Procedure spGetName'
		DROP  Procedure  spGetName
	END

GO

PRINT 'Creating Procedure spGetName'
GO
CREATE Procedure spGetName
(
    @nameStr varchar(500)
)
AS

/******************************************************************************
**		File: 
**		Name: spGetName
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

begin
    declare @nameguid uniqueidentifier
        
    declare @query nvarchar(4000), @pos int, @where nvarchar(2000), @lastTaxon varchar(10), @header varchar(100), @end bit
    
    if exists(select * from tempdb..sysobjects where name = '##tmpName')
        delete ##tmpName
    else
        create table ##tmpName(nameguid uniqueidentifier)
    
    set @end = 0
    set @lastTaxon = 'k'
    set @header = 'insert into ##tmpName select '
    set @query = '.nameguid from tblname k '
    set @where = 'where k.nametaxonrankfk = 15 and k.namecanonical = '''
    
    set @pos = charindex(',', @nameStr)
    if @pos is null or @pos = 0 
    begin
        set @where = @where + @nameStr + ''''
        set @end = 1
    end
    else set @where = @where + substring(@namestr, 0, @pos) + '''' 
    
    declare @level int , @endPos int, @name nvarchar(100)
    set @level = 1
    
    while @end = 0
    begin
        /*if @pos = 0 --from last loop
        begin
            set @name = substring(@namestr, @pos + 1, @endpos - @pos - 1)
            set @end = 1
        end
        else
        begin*/
            set @endPos = charindex(',', @nameStr, @pos + 1)
            if @endpos is null or @endPos = 0  
            begin
                set @name = substring(@namestr, @pos + 1, len(@namestr) - @pos)
                set @end = 1
            end
            else
                set @name = substring(@namestr, @pos + 1, @endpos - @pos - 1)                
        --end
                
        if @name <> 'incertae sedis'
        begin
            if @level = 1 
            begin
                set @query = @query + 'inner join tblname p on p.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and p.nametaxonrankfk = 19 and p.namecanonical = ''' + @name + ''' '
                set @lastTaxon = 'p'
            end
            else if @level = 2 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname c on c.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and c.nametaxonrankfk = 3 and c.namecanonical = ''' + @name + ''' '
                set @lastTaxon = 'c'
            end
            else if @level = 3 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname sc on sc.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and sc.nametaxonrankfk = 26 and sc.namecanonical = ''' + @name + ''' '
                set @lastTaxon = 'sc'
            end        
            else if @level = 4 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname o on o.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and o.nametaxonrankfk = 17 and o.namecanonical = ''' + @name + ''' '
                set @lastTaxon = 'o'
            end                
            else if @level = 5 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname f on f.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and f.nametaxonrankfk = 7 and f.namecanonical = ''' + @name + ''' '
                set @lastTaxon = 'f'
            end
            else if @level = 6 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname g on g.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and g.nametaxonrankfk = 8 and g.namecanonical = ''' + @name + ''' '
                set @lastTaxon = 'g'
            end            
            else if @level = 7 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname s on s.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and s.nametaxonrankfk = 24 and s.namefull = ''' + @name + ''' '
                set @lastTaxon = 's'
            end            
            else if @level = 8 and len(@name) > 0
            begin
                set @query = @query + 'inner join tblname ss on ss.nameparentfk = ' + @lastTaxon + '.nameguid '
                set @where = @where + ' and ss.namefull = ''' + @name + ''' '
                set @lastTaxon = 'ss'
            end
        end
        
        set @level = @level + 1       
        set @pos = @endPos
    end
        
        set @query = @header + @lastTaxon + @query + @where
                
        exec(@query)
        
end


GO

GRANT EXEC ON spGetName TO PUBLIC

GO
