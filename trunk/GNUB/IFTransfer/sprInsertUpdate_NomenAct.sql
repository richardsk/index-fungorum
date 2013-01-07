IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_NomenAct')
	BEGIN
		DROP  Procedure  sprInsertUpdate_NomenAct
	END

GO

CREATE Procedure sprInsertUpdate_NomenAct
	@tnuid int,
	@nomenActTypeId int,
	@relatedActId int,
	@text nvarchar(255),
	@comments nvarchar(2000),
	@nomenActId int output
AS

	select @nomenActId = NomenclaturalEventID
	from NomenclaturalEvent
	where TaxonNameUsageid = @tnuid 
		and NomenclaturalEventTypeID = @nomenActTypeId 
	
	if (@nomenActId is null)
	begin
		print ('Inserting new Nomencl. Event PK for ' + cast(@tnuid as varchar(20)))
	
		declare @tblId int
		select @tblId = SchemaItem.SchemaItemID from SchemaItem where SchemaItemName = 'NomenclaturalEvent' and SchemaItemTypeID = 2
		
		insert [PK]	(CorrectID, TableID, ModifiedDate)
		select 0, @tblId, GETDATE() --nomen. event table 
			
		select @nomenActId = @@IDENTITY	
		update [PK] set CorrectID = @nomenActId where [PKID] = @nomenActId
		
		--insert [Identifier]
		--select @idDomain, @nomenActId, @externalIdentifier, @identifierNote
				
	end		
	else
	begin
		update PK set ModifiedDate = GETDATE() where PKID = @nomenActId
	end
	
	--insert/update act
	if (not exists(select * from NomenclaturalEvent
		where NomenclaturalEventID = @nomenActId )) 
	begin
		insert NomenclaturalEvent
		select @nomenActId, @tnuid, @nomenActTypeId, @relatedActId, @text
		
	end
	else
	begin
		update NomenclaturalEvent
		set RelatedNomenclaturalEventID = @relatedActId,
			EventDescription = @text,
			NomenclaturalEventTypeID = @nomenActTypeId
		where NomenclaturalEventID = @nomenActId 
	end	
	
	declare @agentId int
	select @agentId = agentid from Agent where CacheFullAgentName = 'Index Fungorum (IF)'
	
	delete Comment where PKID = @nomenActId and AuthorID = @agentId
	
	if (@comments is not null)
	begin
		declare @cmtTblId int, @cmtId int
		select @cmtTblId = SchemaItem.SchemaItemID from SchemaItem where SchemaItemName = 'Comment' and SchemaItemTypeID = 2
		
		insert [PK]	(CorrectID, TableID, ModifiedDate)
		select 0, @cmtTblId, GETDATE() --nomen. event table 
			
		select @cmtId = @@IDENTITY	
		update [PK] set CorrectID = @cmtId where [PKID] = @cmtId
		
		insert Comment
		select @cmtId, @nomenActId, @agentId, 'Nomenclatural Event Comment', @comments, GETDATE()
	end
	
	
GO


GRANT EXEC ON sprInsertUpdate_NomenAct TO PUBLIC

GO

