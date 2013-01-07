IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_Name')
	BEGIN
		DROP  Procedure  sprInsertUpdate_Name
	END

GO

CREATE Procedure sprInsertUpdate_Name
	@externalIdentifier nvarchar(255),
	@idDomain int,
	@identifierNote nvarchar(255),
	@rank int,
	@verbRank nvarchar(255),
	@nameElement nvarchar(255),
	@verbName nvarchar(255),
	@page nvarchar(255),
	@pgQualifier nvarchar(255),
	@isNotho bit,
	@parentID int,
	@reference nvarchar(500),
	@protonymExtId int,
	@tnuID int output
AS

	--declare @newid int
	declare @refid int, @protonym int, @tapid int

	--insert Pks?
	set @tnuID =  null
	set @refid = null
	--does a name usage record exist for this name + rank comb.
	-- todo and nomencl. act type?
	select @tnuID = PKID, @refid = rt.ReferenceID, @tapid = tap.TaxonNameAppearanceID
	from Identifier		
	inner join TaxonNameUsage tnu on tnu.TaxonNameUsageID = PKID
	inner join TaxonNameAppearance tap on tap.TaxonNameUsageID = tnu.TaxonNameUsageID
	left join ReferenceTitle rt on rt.ReferenceID = tnu.ReferenceID
	where Identifier = @externalIdentifier
		and tap.TaxonNameRankID = @rank 
		and isnull(rt.ReferenceTitle, '[null]') = isnull(@reference, '[null]')
		and Identifier.IdentifierDomainID = @idDomain
	
	if (@refid is null)
	begin
		select @refid = referenceid 
		from ReferenceTitle 
		where ReferenceTitle = @reference
	end
	
	if (@tnuID is null)
	begin
		print ('Inserting new PK ' + cast(@externalIdentifier as varchar(40)) + ' - Name : ' + @verbName + ' - Rank : ' + cast(@rank as nvarchar(30)) 
			+ ' - Protonym : ' + cast(@protonymExtId as nvarchar(20)) 
			+ ' - Ref : ' + @reference 
			+ ' - ParentID : ' + cast(isnull(@parentID,0) as varchar(40)))
		
		declare @tblId int, @idid int
		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'TaxonNameUsage'
		
		insert [PK]	(CorrectID, TableID)
		select 0, @tblId --name table 444286146
		
		select @tnuID = @@IDENTITY	
		update [PK] set CorrectID = @tnuID where [PKID] = @tnuID
		
		
		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'Identifier'

		insert [PK]	(CorrectID, TableID)
		select 0, @tblId --identifier table 
		
		select @idid = @@IDENTITY	
		update [PK] set CorrectID = @idid where [PKID] = @idid
		
		insert [Identifier]
		select @idid, @idDomain, @tnuID, @externalIdentifier, @identifierNote
		
		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'TaxonNameAppearance'

		insert [PK]	(CorrectID, TableID)
		select 0, @tblId --identifier table 
		
		select @tapid = @@IDENTITY	
		update [PK] set CorrectID = @tapid where [PKID] = @tapid
		
		print ('tnuid: ' + cast(@tnuid as varchar(15)) + ' - idid: ' + cast(@idid as varchar(15)))		
	end
	
	--todo insert verb rank into appearance table
	--insert/update taxon name usage
	if (not exists(select TaxonNameUsage.TaxonNameUsageID from TaxonNameUsage where TaxonNameUsageID = @tnuID))
	begin				
		insert TaxonNameAppearance
		select @tapid,
			@tnuID,
			@rank,
			@nameElement,
			@verbName,
			@page,
			@pgQualifier,
			@isNotho
			
		insert TaxonNameUsage 
		select @tnuID, 
			0, 
			@refid, 
			@tnuID,
			@tnuID,
			@parentID,
			@tapid
	end
	else
	begin
		update TaxonNameUsage 
		set ProtonymID = 0, 
			ReferenceID = @refid, 
			AcceptedUsageID = @tnuID,
			CitedUsageID = @tnuID,
			ParentUsageID = @parentID,
			PreferredTaxonNameAppearanceID = @tapid
			
		update TaxonNameAppearance
		set TaxonNameRankID = @rank,
			NameElement = @nameElement,			
			VerbatimNameString = @verbName, 
			Page = @page, 
			PageQualifier = @pgQualifier, 
			IsNothoTaxon = @isNotho
		where TaxonNameAppearanceID = @tapid
	end

	--update protonym
	declare @protonymId int
	select top 1 @protonymId = PKID
	from Identifier	i	
	inner join TaxonNameUsage t on t.TaxonNameUsageID = PKID
	where i.Identifier = @protonymExtId
		and i.IdentifierDomainID = 21442377 -- primary name source

	if (@protonymId is null) set @protonymId = @tnuID
	
	print('updated name protonymId: ' + cast(@protonymId as varchar(15)))

	if (not exists(select Protonymid from Protonym where ProtonymID = @protonymId))
	begin
		insert Protonym
		select @protonymId, 0, 0
	end
	
	update TaxonNameUsage
	set ProtonymID = @protonymId
	where TaxonNameUsageId = @tnuid

GO


GRANT EXEC ON sprInsertUpdate_Name TO PUBLIC

GO


