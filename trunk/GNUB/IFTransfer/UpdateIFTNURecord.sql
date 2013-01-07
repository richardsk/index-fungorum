IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'UpdateIFTNURecord')
	BEGIN
		DROP  Procedure  UpdateIFTNURecord
	END

GO

CREATE Procedure UpdateIFTNURecord
	@externalIdentifier nvarchar(255),
	@idDomain int,
	@identifierNote nvarchar(255),
	@rank int,
	@verbRank nvarchar(255),
	@nameElement nvarchar(255),
	@verbName nvarchar(255),
	@page nvarchar(255),
	@year nvarchar(50),
	@pgQualifier nvarchar(255),
	@isNotho bit,	
	@reference nvarchar(500),
	@refExtId nvarchar(255),
	@refIdDomain int,
	@refIdNote nvarchar(255),
	@authors nvarchar(255),	
	@isPubListRef bit,
	@eventTypeId int,
	@addValidEvent bit,
	@eventText nvarchar(255),
	@eventComment nvarchar(2000),
	@protonymExtId nvarchar(255),
	@genExtId nvarchar(255)
AS

	--inserts/updates a TNU record
	--inserts "parent(s)" usage record if the taxon name is binomial or trinomial
	--inserts reference records
	--inerts nomencl acts
	
	declare @rnkSort int, @genRank int, @spRank int
	declare @tnuid int, @nomenEventId int, @refId int, @protonymNomCmt nvarchar(500)
	declare @relatedEventId int, @sts nvarchar(1), @synonymy nvarchar(500)
	declare @typ nvarchar(255), @loc nvarchar(255), @host nvarchar(255)
			
	
	select @rnkSort = Sequence from TaxonNameRank where TaxonNameRankID = @rank

	select @sts = [sts flag], @synonymy = synonymy,
		@typ = [typification details], @loc = location, @host = host
	from [if].dbo.indexfungorum
	where [record number] = @externalIdentifier

	select @protonymNomCmt = [nomenclatural comment]
	from [if].dbo.indexfungorum
	where [record number] = @protonymExtId

	--is this rec invalid and does it have a later validation?
	--act comment (editorial comment) will have later validation record number
	declare @laterValRec int, @dollarPos int
	if ((charindex('nom. inval.', @eventText) <> 0 or
		 charindex('nom. rejic.', @eventText) <> 0 or
		 charindex('nom. illegit.', @eventText) <> 0)
		and	@eventComment is not null)
	begin
		set @dollarPos = charindex('$', @eventComment)
		if (@dollarPos <> 0)
		begin
			set @laterValRec = cast(substring(@eventComment, 1, @dollarPos-1) as int)
		end
	end

	--reference 	
	
	select @refid = r.ReferenceID
	from Identifier		
	left join ReferenceTitle r on r.ReferenceID = identifier.pkid
	where Identifier = @refExtId
		and ReferenceTitle = @reference
		and Identifier.IdentifierDomainID = @refidDomain
		
	if (@refid is null and @reference is not null)
	begin
		exec sprInsertUpdate_Reference 
			@reference,
			0,
			0,
			@authors,
			@refExtId,
			@refIdDomain,
			@refIdNote,
			null, --todo - nomen. sig. ?
			@refid output
	end
	
	set @verbName = LTRIM(rtrim(@verbName))
	print('verb: ' + isnull(@verbName,'') + ' : ' + cast(@rnkSort as varchar(50)))
	print('elem: ' + @nameElement)
	
	--insert extra parent records for binomials and trinomials?
	declare @spPos int, @nm nvarchar(255), @endSpPos int
	if (@rnkSort > 1600) -- below genus 
	begin
		set @spPos = CHARINDEX(' ', @verbName)
		
		if (@spPos <> 0)
		begin
			select @genRank = TaxonNameRankID 
			from TaxonNameRank 
			where Rank = 'genus' 
					
						
			set @nm = SUBSTRING(@verbName, 1, @spPos - 1)
			exec dbo.sprInsertUpdate_Name 
				@externalIdentifier, 
				21442378, --secondary name id domain
				'Index Fungorum PK', 
				@genRank,
				null, 
				@nm, 
				@nm, 
				@page, 
				@pgQualifier, 
				0,
				0,
				@reference, 
				@genExtId,
				@tnuID output
				
				
		end
	end
	
	if (@rnkSort > 1700) -- below species - trinomial
	begin		
		set @spPos = CHARINDEX(' ', @verbName) -- end of genus
		set @endSpPos = CHARINDEX(' ', @verbName, @spPos + 1) -- end of species
		
		if (@spPos <> 0)
		begin
		
			select @spRank = TaxonNameRankID from TaxonNameRank where Rank = 'species'
			
			declare @spLen int
			set @spLen = LEN(@verbName)
			if (@endSpPos <> 0) set @spLen = @endSpPos - @spPos - 1
			
			set @nm = SUBSTRING(@verbName, @spPos + 1, @spLen)
			exec dbo.sprInsertUpdate_Name 
				@externalIdentifier, 
				21442378, --secondary name id domain
				'Index Fungorum PK', 
				@spRank, 
				null,
				@nm, 
				@nm, 
				@page, 
				@pgQualifier, 
				0,
				@tnuID,
				@reference,
				0, --todo - need to determine the specific name id for a trinomial - no direct link in index fungorum
				@tnuID output
				
		end	
	end
	
	--insert main taxon name usage	
			
	exec dbo.sprInsertUpdate_Name 
		@externalIdentifier, 
		@idDomain,
		'Index Fungorum PK', 
		@rank, 
		@verbRank,
		@nameElement, 
		@verbName, 
		@page, 
		@pgQualifier, 
		@isNotho,
		@tnuID,
		@reference,
		@protonymExtId,
		@tnuID output

	
	--delete all acts and typifications for this name, 
	--then reinsert relevant ones		
	delete nomenclaturalevent where TaxonNameUsageID = @tnuid
	
	--todo
	--delete typification where taxonnameusageid = @tnuid
	
	
	--nomencl. acts
	if (@isPubListRef = 0)
	begin
		declare @notValid bit -- when specific nom comment is nom inval
		declare @isValid bit --when a nom comment of nom cons or nom rejic - ie some effort has gone into this, so can assume it is "Valid"
		set @isValid= 0
		set @notValid = 0
		
		if (@eventTypeId is not null)
		begin
			set @nomeneventId = null
			
			exec sprInsertUpdate_NomenEvent
				@tnuid,
				@eventTypeId, 
				@relatedEventId, 
				@eventText,
				@eventComment,
				@nomenEventId output
							
		end
		
		--other acts?
		if (charindex('nom. inval.', @eventText) <> 0)
		begin		
			set @nomenEventId = null
			
			exec sprInsertUpdate_NomenEvent
				@tnuid,
				4, --invalid  
				0, 
				@eventText,
				@eventComment,
				@nomenEventId output
	
			--is there a later validation
			if (@laterValRec is not null)
			begin
				--insert act for the other, validating, name usage
				declare @valtnuid int, @validEventId int
				select @valtnuid = pkid
				from Identifier			
				left join taxonnameusage t on t.taxonnameusageid = identifier.pkid
				where Identifier = @laterValRec
					and Identifier.IdentifierDomainID = 21442377 --primary name source
				
				exec sprInsertUpdate_NomenEvent
					@valtnuid,
					11, --validation
					@nomenEventId, --related to invalid act of this name 
					null,
					null,
					@validEventId output				
				
				--set the invalid act ofr this name to be related to the validation act	
				update NomenclaturalEvent
				set RelatedNomenclaturalEventID = @validEventId
				where NomenclaturalEventID = @nomenEventId
				
			end
			
			set @notValid = 1
		end
		
		
		if (@synonymy is not null) --nom novs
		begin
			set @nomenEventId = null
			declare @otherRecId int
			
			--tautonym
			if (substring(@synonymy, 1, 8) = 'tautonym') 
			begin					
				exec sprInsertUpdate_NomenEvent
					@tnuid,
					13, --tautonym avoidance
					0, 
					@eventText,
					@eventComment,
					@nomenEventId output
			end
			else if (substring(@synonymy, 1, 7) = 'autonym') 
			begin					
				exec sprInsertUpdate_NomenEvent
					@tnuid,
					14, --autonym avoidance
					0, 
					@eventText,
					@eventComment,
					@nomenEventId output
			end
			else
			begin if (charindex('nom. illegit.', @protonymNomCmt) = 0)
				--Only link for "avoid illegitimacy".  
				--If protonym Nom Comment has 'nom. illegit.' then it is the case for "fixing illegitimacy" 
				-- rather than avoiding illegitimacy - in which case we dont want to link the acts.
				--get related record
				declare @nomNovRec int
				set @dollarPos = charindex('$', @synonymy)
				if (@dollarPos <> 0)
				begin
					set @nomNovRec = cast(substring(@synonymy, 1, @dollarPos-1) as int)
				end
				
				begin
					--get act for the other name usage
					select top 1 @otherRecId = a.nomenclaturaleventid
					from Identifier			
					inner join taxonnameusage t on t.taxonnameusageid = identifier.pkid
					inner join nomenclaturalevent a on a.taxonnameusageid = t.taxonnameusageid
						and (a.nomenclaturaleventtypeid = 6 or a.nomenclaturaleventtypeid = 7) --valid or assumed valid act of nom nov
					where Identifier = @nomNovRec
						and Identifier.IdentifierDomainID = 21442377 --primary name source
												
				end	
			end
			
			
			exec sprInsertUpdate_NomenEvent
				@tnuid,
				12, --nom nov type
				@otherRecId, 
				@eventText,
				@eventComment,
				@nomenEventId output
			
				
			if (@otherRecId is not null)
			begin
				update NomenclaturalEvent
				set relatednomenclaturalEVENTid = @nomenEVENTId
				where nomenclaturalEVENTid = @otherRecId
			end
		end
		
		
		if (charindex('nom. illegit.', @eventText) <> 0)
		begin
			set @nomeneventId = null
			declare @validRecId int
						
			--is there a conserved name
			if (@laterValRec is not null)
			begin
				--get event for the other, conserved, name usage
				select top 1 @validRecId = a.nomenclaturaleventid
				from Identifier			
				inner join taxonnameusage t on t.taxonnameusageid = identifier.pkid
				inner join nomenclaturalevent a on a.taxonnameusageid = t.taxonnameusageid
					and (a.nomenclaturaleventtypeid = 6 or a.nomenclaturaleventtypeid = 7) --valid or assumed valid act of nom nov
				where Identifier = @laterValRec
					and Identifier.IdentifierDomainID = 21442377 --primary name source
											
			end	
			
			exec sprInsertUpdate_Nomenevent
				@tnuid,
				5, --illegitimate
				@validRecId, 
				@eventText,
				@eventComment,
				@nomeneventId output
				
			if (@validRecId is not null)
			begin
				update nomenclaturalevent
				set relatednomenclaturaleventid = @nomeneventId
				where nomenclaturaleventid = @validRecId
			end
		end
		
		
		if (charindex('nom. cons.', @eventText) <> 0)
		begin
			set @nomeneventId = null
			set @isValid = 1
			
			exec sprInsertUpdate_Nomenevent
				@tnuid,
				8, --conserved  
				0, 
				@eventText,
				@eventComment,
				@nomeneventId output
				
		end
		
		if (charindex('nom. rejic.', @eventText) <> 0)
		begin
			set @nomeneventId = null
			set @isValid = 1
			
			declare @conseventId int
			
			--is there a conserved name
			if (@laterValRec is not null)
			begin
				--get act for the other, conserved, name usage
				select @conseventId = a.nomenclaturaleventid
				from Identifier			
				inner join taxonnameusage t on t.taxonnameusageid = identifier.pkid
				inner join nomenclaturalevent a on a.taxonnameusageid = t.taxonnameusageid
					and a.nomenclaturaleventtypeid = 8 --conserved
				where Identifier = @laterValRec
					and Identifier.IdentifierDomainID = 21442377 --primary name source
											
			end
					
			exec sprInsertUpdate_Nomenevent
				@tnuid,
				9, --rejected
				@conseventId, --may be null 
				@eventText,
				@eventComment,
				@nomeneventId output

			if (@conseventId is not null)
			begin
				update nomenclaturalevent
				set relatednomenclaturaleventid = @nomeneventId
				where nomenclaturaleventid = @conseventId
			end
							
		end

		--sts flags may have been set to say name has no nomencl. sig. 
		-- so dont add validity act			
		if (@notValid = 0 and @addValidevent = 1)
		begin
			if (@isValid = 0 and (isnumeric(@year) = 0 or cast(@year as int) < 1980))
			begin
				set @nomeneventId = null
			
				exec sprInsertUpdate_NomenEvent
					@tnuid,
					7, --assumed valid
					0, 
					null,
					null,
					@nomeneventId output
			end
			else
			begin
				set @nomeneventId = null
				
				exec sprInsertUpdate_Nomenevent
					@tnuid,
					6, --valid
					0, 
					null,
					null,
					@nomeneventId output
			end
		end
		
		--isonym
		if (@sts = 'i')
		begin	
			set @nomeneventId = null
				
			exec sprInsertUpdate_Nomenevent
				@tnuid,
				10, --isonym 
				0, 
				@eventText,
				@eventComment,
				@nomeneventId output
		end
	end

	--typification
	
	if (@loc is not null or @typ is not null or @host is not null)
	begin
	
		declare @recId int, @typId int
		declare @tblId int
		
		select @tblId = si.SchemaItemID
		from SchemaItem si
		inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
		where e.EnumerationValue = 'Table' and si.SchemaItemName = 'Typification'

		--todo get typification table into schemitem tables and remove following line
		set @tblId = -9999999
			
		if (@rnkSort >= 1700) --species and below
		begin
			declare @typType int
			set @typType = 8 --default
			
			print('Inserting typification : ' + @typ + ' : host = ' + @host + ' : location = ' + @loc)
			
			if (@typ is not null and len(@typ) > 13 and substring(@typ, 1, 13) <> 'typification:')
			begin
				set @sppos = charindex(' ', @typ)
				--todo
				--if (@sppos is not null and @sppos <> 0) 
				--begin
				--	select @typType = typificationtypeid
				--	from typificationtype
				--	where typeoftype = substring(@typ, 1, @sppos-1)
				--end
			end
							
			insert [PK]	(CorrectID, TableID)
			select 0, @tblId --typification table 
			
			select @typId = @@IDENTITY	
			update [PK] set CorrectID = @typId where [PKID] = @typId
			
			--todo
			--insert typification
			--select @typId,
			--	@tnuid,
			--	@typType,
			--	null,
			--	null,
			--	null,
			--	null,
			--	null,
			--	null,
			--	@loc,
			--	@host,
			--	null,
			--	@typ
		end
		else if (@rnkSort >= 1600) --genus to above species
		begin 
			select @recId = t.taxonnameusageid
			from Identifier			
			inner join taxonnameusage t on t.taxonnameusageid = identifier.pkid
			where Identifier = @typ
				and Identifier.IdentifierDomainID = 21442377 --primary name source				
			
			if (@recId is not null)
			begin
			
				insert [PK]	(CorrectID, TableID)
				select 0, @tblId --typification table 
				
				select @typId = @@IDENTITY	
				update [PK] set CorrectID = @typId where [PKID] = @typId
				
				--todo
				--insert typification
				--select @typId,
				--	@tnuid,
				--	8, --default type
				--	@recId,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null
			end
		end
		else --above genus 
		begin 
			set @dollarPos = charindex('$', @typ)
			if (@dollarPos <> 0)
			begin
				select @recId = t.taxonnameusageid
				from Identifier			
				inner join taxonnameusage t on t.taxonnameusageid = identifier.pkid
				where Identifier = substring(@typ, 1, @dollarPos-1) 
					and Identifier.IdentifierDomainID = 21442377 --primary name source				
					
					--todo
				--select @typType = typificationtypeid
				--from typificationtype
				--where typeoftype = substring(@typ, @dollarpos + 1, len(@typ))
			end
			
			if (@typType is null) set @typType = 8 --default Type
			
			if (@recId is not null)
			begin
			
				insert [PK]	(CorrectID, TableID)
				select 0, @tblId --typification table 
				
				select @typId = @@IDENTITY	
				update [PK] set CorrectID = @typId where [PKID] = @typId
			
			--todo
				--insert typification
				--select @typId,
				--	@tnuid,
				--	@typType,
				--	@recId,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null,
				--	null
			end
		end
	end
	
		
	--notho / hybrid
	if (@verbName like '%×[^ ]%')
	begin
	
		--find existing parents
		declare @p1 int, @p2 int, @edCmt nvarchar(500), @num nvarchar(20), @pos int, @endPos int
		
		select @edCmt = i.[editorial comment]
		from [if].dbo.indexfungorum i
		where [record number] = @externalIdentifier
	
		set @pos = charindex('</i>', @edCmt)
		set @endPos = charindex('>', @edCmt, @pos + 5)
		set @num = substring(@edCmt, @pos + 5, @endPos - 5 - @pos)
	
		select @p1 = pkid
		from Identifier			
		left join taxonnameusage t on t.taxonnameusageid = identifier.pkid
		where Identifier = @num
			and Identifier.IdentifierDomainID = 21442377
			
		
		set @pos = charindex('</i>', @edCmt, @endPos)
		set @endPos = charindex('>', @edCmt, @pos + 5)
		set @num = substring(@edCmt, @pos + 5, @endPos - 5 - @pos)
		
		select @p2 = pkid
		from Identifier			
		left join taxonnameusage t on t.taxonnameusageid = identifier.pkid
		where Identifier = @num
			and Identifier.IdentifierDomainID = 21442377
				
		if (@p1 is not null and @p2 is not null)
		begin
			print ('Adding hybrid record for ' + @externalIdentifier)
			exec sprInsertUpdate_Hybrid @tnuid, @p1, @p2
		end
	end
		
GO


GRANT EXEC ON UpdateIFTNURecord TO PUBLIC

GO
