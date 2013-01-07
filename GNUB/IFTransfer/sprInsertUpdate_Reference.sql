
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_Reference')
	BEGIN
		DROP  Procedure  sprInsertUpdate_Reference
	END

GO

CREATE Procedure sprInsertUpdate_Reference
	@reference nvarchar(500),
	@refTypeId int,
	@languageId int,
	@authors nvarchar(255),
	@refExtId nvarchar(255),
	@refIdDomain int,
	@refIdNote nvarchar(255),
	@nomenSignificance nvarchar(255),
	@refid int output
AS
	
	declare @refTitleId int
	
	if (@refid is null)
	begin
		print ('Inserting new Ref PK for ' + @refExtId)
		
		declare @tblId int, @idid int
		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'Reference'
		
		insert [PK]	(CorrectID, TableID)
		select 0, @tblId--Ref tbl -476989269
		
		select @refid = @@IDENTITY	
		update [PK] set CorrectID = @refid where [PKID] = @refid
		
		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'Identifier'

		insert [PK]	(CorrectID, TableID)
		select 0, @tblId --identifier table 
		
		select @idid = @@IDENTITY	
		update [PK] set CorrectID = @idid where [PKID] = @idid
		
		insert [Identifier]
		select @idid, @refIdDomain, @refid, @refExtId, @refIdNote

		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'ReferenceTitle'

		insert [PK]	(CorrectID, TableID)
		select 0, @tblId --ref title table 
		
		select @refTitleId = @@IDENTITY	
		update [PK] set CorrectID = @refTitleId where [PKID] = @refTitleId
	end

	

	--insert/update ref
	
	declare @enumId int
	
	if (not exists(select Reference.ReferenceID from Reference where ReferenceID = @refid))
	begin	
		insert Reference
		select @refid, 0, @refTypeId, @languageId
	
		select @enumId = EnumerationID
		from Enumeration  
		where EnumerationTypeID = 21953935 and EnumerationValue = 'Standard'
		
		insert ReferenceTitle 
		select @refTitleId, @refid, @enumId, @languageId, @reference
		
		--todo insert authors and nome significance - ref fields?
		--@nomenSignificance		
		--@authors
	end	
	--else
	--begin
		--todo update ref fields
		--update Reference
		--set CacheAuthors = @authors,
		--	CacheReference = @reference,
		--	NomenclaturalSignificance = @nomenSignificance
		--where ReferenceID = @refid
	
	--end
	
		
GO


GRANT EXEC ON sprInsertUpdate_Reference TO PUBLIC

GO

