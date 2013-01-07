IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_NomenEvent')
	BEGIN
		DROP  Procedure  sprInsertUpdate_NomenEvent
	END

GO

CREATE Procedure sprInsertUpdate_NomenEvent
	@tnuid int,
	@nomenEventTypeId int,
	@relatedEventId int,
	@text nvarchar(255),
	@comments nvarchar(2000),
	@nomenEventId int output
AS

	declare @tblId int
		
	select @nomenEventId = NomenclaturalEventID
	from nomenclaturalevent
	where TaxonNameUsageid = @tnuid 
		and NomenclaturalEventTypeID = @nomenEventTypeId


	--reference
	
	if (@nomenEventId is null)
	begin
		print ('Inserting new Nomencl. Event PK for ' + cast(@tnuid as varchar(20)) + ' - relatedEventId : ' + cast(isnull(@relatedEventId,0) as varchar(20)))

		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'NomenclaturalEvent'

		insert [PK]	(CorrectID, TableID, UUID)
		select 0, @tblId, newid() 
		
		select @nomenEventId = @@IDENTITY	
		update [PK] set CorrectID = @nomenEventId where [PKID] = @nomenEventId
		
		--insert [Identifier]
		--select @idDomain, @nomenEventId, @externalIdentifier, @identifierNote
				
	end	
	
	--insert/update act
	if (not exists(select * from NomenclaturalEvent
		where NomenclaturalEventID = @nomenEventId )) 
	begin
		insert NomenclaturalEvent
		select @nomenEventId, @tnuid, @nomenEventTypeId, @relatedEventId, @comments, @text 
		
	end
	else
	begin
		update NomenclaturalEvent
		set RelatedNomenclaturalEventID = @relatedEventId,
			EventValue = @comments,
			EventDescription = @text
		where NomenclaturalEventID = @nomenEventId
	end	
	
	if (@comments is not null)
	begin
		declare @agentId int, @cmtId int
		select @agentId = agentid 
		from AgentName 
		where OrganizationName = 'Index Fungorum (IF)'

		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'Comment'
		
		insert [PK]	(CorrectID, TableID)
		select 0, @tblId 
		
		select @cmtId = @@IDENTITY	
		
		insert Comment
		select @cmtId, @nomenEventId, @agentId, 'Nomenclatural Event', @comments, GETDATE() --date of comment??
	end
	
	
GO


GRANT EXEC ON sprInsertUpdate_NomenEvent TO PUBLIC

GO

