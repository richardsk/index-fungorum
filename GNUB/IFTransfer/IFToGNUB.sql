
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'IFToGNUB')
	BEGIN
		DROP  Procedure  IFToGNUB
	END

GO

CREATE Procedure IFToGNUB
	
AS
	set nocount on


	--cleanup old hanging Ids
	declare @tblId int
	
	select @tblId = si.SchemaItemID
	from SchemaItem si
	inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
	where e.EnumerationValue = 'Table' and si.SchemaItemName = 'TaxonNameUsage'
		
	delete identifier
	from Identifier 
	left join TaxonNameUsage on TaxonNameUsageID = PKID
	inner join PK on PK.PKID = Identifier.PKID
	where TaxonNameUsageID is null and PK.TableID = @tblId
		and (IdentifierDomainID = 21442377 or IdentifierDomainID = 21442378)
		
		
	declare @updateDate datetime, @updateId uniqueidentifier, @provId uniqueidentifier
	--select @provId = providerid from admin.Provider where ProviderName = 'Index Fungorum'
	--select @updateDate = MAX(CompleteDate) 
	--from admin.UpdateLog 
	--where providerid = @provId and Status = 'Succeeded'
	
	--TODO check this and re-add auto update/admin tables if required
	
	--all records?
	--if (@updateDate is null) 
	--	select @updateDate = MAX(modifieddate) 
	--	from PK 
	--	inner join Identifier on IdentifierID = PK.PKID
	--	where ResolutionNote like 'Index Fungorum%'
		
	if (@updateDate is null) set @updateDate = '01-01-1900' 
	
	print ('updating records after ' + cast(@updateDate as nvarchar(50)))
	
	set @updateId = NEWID()
	--insert admin.updatelog select @updateId, @provId, GETDATE(), null, 'Started'

	declare @records table(row int identity, ifpk int, bas int, authors nvarchar(255), nomCmt nvarchar(500), synonymy nvarchar(255), deleted bit)
	declare @IFdDomainID int, @del bit
	declare @pos int, @ifpk int, @cnt int, @newid int, @exPK int
	declare @nomCmt nvarchar(500), @syn nvarchar(255), @bas int, @auth nvarchar(255)
	set @IFdDomainID = 1


	--for each IF record after update date

	insert @records 
	select [record number], [basionym record number], AUTHORS, [nomenclatural comment], synonymy, 0
	from [IF].dbo.IndexFungorum
	where [UpdatedDate] > @updateDate and not exists(select identifier from identifier where Identifier = [RECORD NUMBER])
	order by [record number]


	--first do non-parenthetical author basionyms with no nom. comment
	select @cnt = COUNT(*), @pos = 1 from @records 

	print('Updating ' + cast(@cnt as nvarchar(30)) + ' records...')
	
	while (@pos <= @cnt)
	begin

		select @ifpk = ifpk, @auth = authors, @bas = bas, @nomCmt = nomCmt
		from @records where row = @pos

		if (CHARINDEX('(', @auth) = 0 and @bas = @ifpk and @nomCmt is null)
		begin
			print('updating record ' + cast(@ifpk as varchar(20)))
		
			exec TransferIFRecord @ifpk

			update @records set deleted = 1 where ifpk = @ifpk --done with it				
		end
		
		set @pos = @pos + 1
		
	end

	--then do basionyms
	select @cnt = COUNT(*), @pos = 1 from @records 

	while (@pos <= @cnt)
	begin

		select @ifpk = ifpk, @bas = bas, @del = deleted 
		from @records where row = @pos

		if ( @ifpk = @bas and @del = 0 )
		begin
			print('updating record ' + cast(@ifpk as varchar(20)))
		
			exec TransferIFRecord @ifpk

			update @records set deleted = 1 where ifpk = @ifpk --done with it				
		end
		
		set @pos = @pos + 1
		
	end


	--next do all names with no nomencl. comment - ie not isonyms, invalid, rejected, orthograhpic variants, etc

	select @cnt = COUNT(*), @pos = 1 from @records 

	while (@pos <= @cnt)
	begin

		select @ifpk = ifpk, @nomCmt = nomcmt, @del = deleted
		from @records where row = @pos

		if ( @nomCmt is null and @del = 0)
		begin
			print('updating record ' + cast(@ifpk as varchar(20)))
		
			exec TransferIFRecord @ifpk

			update @records set deleted = 1 where ifpk = @ifpk --done with it				
		end
			
		set @pos = @pos + 1
		
	end


	--next do all but nom novs

	select @cnt = COUNT(*), @pos = 1 from @records 

	while (@pos <= @cnt)
	begin

		select @ifpk = ifpk, @syn = synonymy, @del = deleted
		from @records where row = @pos

		if ( @syn is null and @del = 0)
		begin
			print('updating record ' + cast(@ifpk as varchar(20)))
		
			exec TransferIFRecord @ifpk

			update @records set deleted = 1 where ifpk = @ifpk --done with it				
		end
			
		set @pos = @pos + 1
		
	end


	--next do rest

	select @cnt = COUNT(*), @pos = 1 from @records 

	while (@pos <= @cnt)
	begin

		select @ifpk = ifpk, @nomCmt = nomcmt, @del = deleted 
		from @records where row = @pos

		if (@del = 0)
		begin
			print('updating record ' + cast(@ifpk as varchar(20)))

			exec TransferIFRecord @ifpk
		end
		
		set @pos = @pos + 1
		
	end

	--clean up
	delete i
	from Identifier i
	inner join reference r on r.referenceid = i.pkid
	left join taxonnameusage u on u.referenceid = r.referenceid
	where i.ResolutionNote = 'Index Fungorum pub'
		and u.taxonnameusageid is null

	delete r
	from Reference r
	left join Identifier on pkid = r.ReferenceID
	where Identifierid is null

	select @tblId = si.SchemaItemID
	from SchemaItem si
	inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
	where e.EnumerationValue = 'Table' and si.SchemaItemName = 'Identifier'

	delete P
	from PK p
	left join Identifier on Identifier.PKID = P.PKID
	where TableID = @tblId and Identifier.PKID is null


	--update admin.updatelog set completedate = GETDATE() where updatelogid = @updateId
	
	print('Update Completed')
	
GO


GRANT EXEC ON IFToGNUB TO PUBLIC

GO
