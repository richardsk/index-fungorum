
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'TransferIFRecord')
	BEGIN
		DROP  Procedure  TransferIFRecord
	END

GO

CREATE Procedure TransferIFRecord
	@ifpk int
AS

begin transaction ifrec

BEGIN TRY

	declare @rnk int, @rnkSort int, @verbName nvarchar(100), @fullName nvarchar(100), @verbRank nvarchar(255)
	declare @orthRecId int, @sts nvarchar(1), @corrId int
	declare @page nvarchar(255), @pgQual nvarchar(255), @year nvarchar(50), @yearOnPub nvarchar(50)
	declare @pubListRef nvarchar(500), @ref nvarchar(500)
	declare @bas int, @fundicRec int, @auth nvarchar(255)
	declare @misappAuth nvarchar(100), @orthComment nvarchar(500)
	declare @publink int, @pubAuth nvarchar(500), @vol nvarchar(50), @part nvarchar(50)
	declare @idDomain int, @refIdDomain int, @secIdDomain int
	
	set @idDomain = 21442377 
	set @refIdDomain = 21442379
	set @secIdDomain = 21442378
	
	set @verbName = null
	set @fullName = null
	set @page = null
	set @part = null
	set @vol = null
	set @pgQual = null
	set @corrId = null
	set @sts = null
	set @rnk = null
	set @rnkSort = null
	set @pubListRef = null
	set @ref = null
	set @bas = null
	set @fundicRec = null
	set @auth = null
	set @year = null
	set @yearOnPub = null
	set @misappAuth= null
	set @orthComment = null
	set @publink = null
	set @pubAuth = null
			
	select @rnk = isnull(r.TaxonNameRankID,0),
		@rnkSort = isnull(r.Sequence,9999),
		@verbRank = i.[INFRASPECIFIC RANK],
		@verbName = i.[NAME OF FUNGUS], 
		@fullName = i.[NAME OF FUNGUS],
		@page = i.PAGE,
		@year = i.[year of publication],
		@yearOnPub = i.[year on publication],
		@pgQual = null, --todo - probably not needed
		@sts = i.[STS FLAG],
		@corrId = i.[CURRENT NAME RECORD NUMBER],
		@pubListRef = i.[PUBLISHED LIST REFERENCE],
		@pubLink = publink,
		@pubAuth = i.[publishing authors],
		@part = part,
		@vol = volume,
		@bas = i.[basionym record number],
		@fundicRec = i.[name of fungus fundic record number],
		@auth = i.authors,
		@misappAuth = i.[misapplication authors],
		@orthComment = i.[orthography comment]
	from [IF].dbo.IndexFungorum i 
	left join [IF].dbo.StdRanks sr on sr.IFRank = i.[INFRASPECIFIC RANK] 
	left join TaxonNameRank r on r.Rank = sr.GNUBRank collate latin1_general_ci_ai
	left join [if].dbo.Publications p on p.publink = i.[literature link]
	where i.[RECORD NUMBER] = @ifpk 
	
	
	--verbatim name depends on whether there is an orth. var. record
		
	if (@sts = 'o') -- a 'dummy' record for orthographic variants
	begin
		
		select @orthComment = i.[orthography comment] 
		from TaxonNameRank r 
		inner join [IF].dbo.StdRanks sr on sr.GNUBRank = r.Rank collate latin1_general_ci_ai
		inner join [IF].dbo.IndexFungorum i on i.[INFRASPECIFIC RANK] = sr.IFRank collate latin1_general_ci_ai
		where i.[RECORD NUMBER] = @corrId 
		
		--only for orth variants where variant comes from protologue
		if (@orthComment is not null)
		begin
			--need to get values from corrected record		
			select @rnk = isnull(r.TaxonNameRankID,0), 
				@rnkSort = isnull(r.Sequence,9999),
				@page = i.PAGE,
				@year = i.[year of publication],
				@yearOnPub = i.[year on publication],
				@pgQual = null, --todo ?
				@sts = i.[STS FLAG],
				@corrId = i.[CURRENT NAME RECORD NUMBER],
				@pubListRef = i.[PUBLISHED LIST REFERENCE],
				@bas = i.[basionym record number],
				@fundicRec = i.[name of fungus fundic record number],
				@auth = i.authors,
				@misappAuth = i.[misapplication authors],
				@orthComment = i.[orthography comment],
				@publink = publink,
				@pubAuth = i.[publishing authors],
				@part = part,
				@vol = volume
			from TaxonNameRank r 
			inner join [IF].dbo.StdRanks sr on sr.GNUBRank = r.Rank collate latin1_general_ci_ai
			inner join [IF].dbo.IndexFungorum i on i.[INFRASPECIFIC RANK] = sr.IFRank collate latin1_general_ci_ai
			left join [if].dbo.Publications p on p.publink = i.[literature link]
			where i.[RECORD NUMBER] = @corrId 
		end
		else
		begin
			--otherwise just have blank orthographic record for now
			set @ref = 'Index Fungorum'
		end
		
			
		
	end


	if (@sts = 'y' or @misappAuth is not null) 
	begin
		--suppressed/misappl. 
		-- may need to delete from GNUB
		declare @agentId int
		select @agentId = AgentID 
		from AgentName 
		where OrganizationName = 'Index Fungorum (IF)'
		
		exec sprDelete_TaxonNameUsage @ifpk, @agentId
		
		commit transaction 
		
		return 		
	end
		
	--is there an orthographic variant for this record?
	set @orthRecId = null
	select @orthRecId = i.[RECORD NUMBER]
	from [IF].dbo.IndexFungorum i 
	where i.[STS FLAG] = 'o' and i.[CURRENT NAME RECORD NUMBER] = @ifpk
	
	if (@orthRecId is not null)
	begin
		select @verbName = i.[NAME OF FUNGUS]
		from [IF].dbo.IndexFungorum i
		where i.[RECORD NUMBER] = @orthRecId
		
		--in this case the reference is IndexFungourm
		set @ref = 'Index Fungorum'
	end
	
	--name element
	select @fullName =
			case when @rnkSort = 1700 --species
				then i.[SPECIFIC EPITHET] 
			when @rnkSort > 1700 -- sub species
				then i.[INFRASPECIFIC EPITHET]
			else
				i.[NAME OF FUNGUS]
			end
	from [IF].dbo.IndexFungorum i
	where i.[RECORD NUMBER] = @ifpk
	
	declare @isNotho bit
	if (@rnkSort = 1999) set @isNotho = CAST(1 as bit) 
	else set @isNotho = cast(0 AS BIT) 

	
	declare @actType int, @actText nvarchar(255), @actComment nvarchar(2000) 
	declare @sancRefId int, @sancRef nvarchar(255)
	
	set @actType = null
	set @actText = null
	set @actComment = null
	
	select @sancRefId = [sanctioning reference literature link],
		@actText = [nomenclatural comment],
		@actComment = [editorial comment]
	from [if].dbo.indexfungorum 
	where [record number] = @ifpk
	
	
	if (@sts = 'i') --isonym
	begin
		if (@corrId is not null) 
		begin
			select @bas = [basionym record number]
			from [if].dbo.indexfungorum
			where [record number] = @corrId
		end
	end
	
	if (@sts = 'd') set @bas = null --deprecated
	
	declare @basNomCmt nvarchar(200)
	select @basNomCmt = [NOMENCLATURAL COMMENT] from [if].dbo.IndexFungorum where [RECORD NUMBER] = @bas
	
	if (CHARINDEX('(', @actText) <> 0 and charindex('nom. illegit.', @basNomCmt) <> 0 and @bas <> @ifpk)
	begin
		select top 1 @bas = [record number]
		from [if].dbo.IndexFungorum 
		where [BASIONYM RECORD NUMBER] = @bas and CHARINDEX('(', [AUTHORS]) = 0 
			and [RECORD NUMBER] <> [BASIONYM RECORD NUMBER]
	end
	
	declare @pubtype nvarchar(20)
	if (@sancRefId is not null) 
	begin
		--name we are looking at is sanctioned
		set @actType = 2 --sanctioned		
		
		--need to insert another usage for the sanctioning usage		
		
		select @pubtype = pubtype 
		from [if].dbo.indexfungorum i
		inner join [if].dbo.publications p on p.publink = i.[sanctioning reference literature link]
		where [record number] = @sancRefId
				
		if (@pubtype = 'b')
		begin --book	
			select @sancRef = isnull('in ' + @pubAuth + ', ', '') 
				+ isnull(pubimiabbr, '')
				+ isnull(', ' + pubIMISupAbbr, '')
				+ isnull(' (' + PubIMIAbbrLoc + ')', '')
				+ isnull(' ' + @vol, '')
				+ isnull('(' + @part + ')', '')
				+ isnull(': ' + @page, '')
				+ isnull(' (' + @year + ')', '')
				+ isnull(' [' + @yearOnPub + ']', '')
			from [if].dbo.publications 
			inner join [if].dbo.indexfungorum 
					on [sanctioning reference literature link] = publink
			where [record number] = @sancRefId
		end
		else
		begin --serial
			select @sancRef = isnull('in ' + @pubAuth + ', ', '') 
				+ isnull(pubimiabbr, '')
				+ isnull(', ' + pubIMISupAbbr, '')
				+ isnull(' ' + @vol, '')
				+ isnull('(' + @part + ')', '')
				+ isnull(': ' + @page, '')
				+ isnull(' (' + @year + ')', '')
				+ isnull(' [' + @yearOnPub + ']', '')
			from [if].dbo.publications 
			inner join [if].dbo.indexfungorum 
					on [sanctioning reference literature link] = publink
			where [record number] = @sancRefId
		end
				
		exec UpdateIFTNURecord
			@ifpk, 
			@secIdDomain, --ID is of secondary name record
			'Index Fungorum PK', 
			@rnk,
			null, 
			@fullName, 
			@verbName, 
			@page, 
			@year,
			@pgQual, 
			@isNotho, 
			@sancRef,
			@ifpk, --ext id 
			@refIdDomain, --ref domain
			'Index Fungorum Pub', --ref note
			@auth, --authors
			0, --is not pub list ref
			3, --sanctioning usage 
			0, --dont add acts for sanc. usage
			null,
			null,
			@bas,
			@fundicRec
	end
	
	declare @addValidAct bit
	set @addValidAct = 1
	if (@sts in ('i', 'y', 'o', 'd')) set @addValidAct = 0
	
	
	--calc ref citation 
	if (@ref is null)
	begin
		if (@publink is null)
		begin
			set @ref = 'Index Fungorum'
		end
		else
		begin
			select @pubtype = pubtype 
			from [if].dbo.publications 
			where publink = @publink
			
			if (@pubtype = 'b')
			begin --book	
				select @ref = isnull('in ' + @pubAuth + ', ', '') 
					+ isnull(pubimiabbr, '')
					+ isnull(', ' + pubIMISupAbbr, '')
					+ isnull(' (' + PubIMIAbbrLoc + ')', '')
					+ isnull(' ' + @vol, '')
					+ isnull('(' + @part + ')', '')
					+ isnull(': ' + @page, '')
					+ isnull(' (' + @year + ')', '')
					+ isnull(' [' + @yearOnPub + ']', '')
				from [if].dbo.publications 
				where publink = @publink
			end
			else
			begin --serial
				select @ref = isnull('in ' + @pubAuth + ', ', '') 
					+ isnull(pubimiabbr, '')
					+ isnull(', ' + pubIMISupAbbr, '')
					+ isnull(' ' + @vol, '')
					+ isnull('(' + @part + ')', '')
					+ isnull(': ' + @page, '')
					+ isnull(' (' + @year + ')', '')
					+ isnull(' [' + @yearOnPub + ']', '')
				from [if].dbo.publications 
				where publink = @publink
			end
		end
	end
	
	
	--insert TNU records (may be multiple if not uninomial)
	exec UpdateIFTNURecord
		@ifpk, 
		@idDomain, --ID is of primary name record
		'Index Fungorum PK', 
		@rnk, 
		@verbRank,
		@fullName, 
		@verbName, 
		@page, 
		@year,
		@pgQual, 
		@isNotho, 
		@ref,
		@ifpk, --ext id 
		@refIdDomain, --ref domain
		'Index Fungorum Pub', --ref note
		@auth, --authors
		0, --is not pub list ref
		@actType, 
		@addValidAct,
		@actText,
		@actComment,
		@bas,
		@fundicRec
		
			

	--published list reference usages
	declare @barPos int, @curpos int, @pub nvarchar(500)
	
	if (@pubListRef is not null)
	begin
		
		set @curpos = 1
		
		while (@curpos <> 0)
		begin
		
			set @barPos = CHARINDEX('|', @pubListRef, @curpos)
		
			if (@barPos = 0)
			begin
				set @pub = SUBSTRING(@pubListRef, @curpos, len(@pubListRef))				
				set @curpos = 0
			end
			else
			begin
				set @pub = SUBSTRING(@pubListRef, @curpos, @barPos - @curpos)				
				set @curpos = @barPos + 1
			end

			
			--get publ. list ref type
			if (LEN(@pub) > 22 and LEFT(@pub, 22) = 'Saccardo''s Syll. fung.')
			begin
				--Saccardo refs

				set @ref = substring(@pub, 1, 22)	
				set @pub = SUBSTRING(@pub, 23, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk, 
					@secIdDomain, -- secondary name record 
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 20 and LEFT(@pub, 20) = 'Saccardo''s Omissions')
			begin
				--Saccardo omissions refs
				set @ref = substring(@pub, 1, 20)
				set @pub = SUBSTRING(@pub, 21, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@publistref,
					@pub,
					1,
					@ifpk, 
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 21 and LEFT(@pub, 21) = 'Petrak''s Lists volume')
			begin
	
				set @ref = substring(@pub, 1, 21)
				set @pub = SUBSTRING(@pub, 22, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk,
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 25 and LEFT(@pub, 25) = 'Petrak''s Lists Supplement')
			begin
	
				set @ref = substring(@pub, 1, 25)
				set @pub = SUBSTRING(@pub, 26, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk,
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 14 and LEFT(@pub, 14) = 'Index of Fungi')
			begin
	
				set @ref = substring(@pub, 1, 14)
				set @pub = SUBSTRING(@pub, 15, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk,
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 31 and LEFT(@pub, 31) = 'Zahlbruckner''s Cat. Lich. Univ.')
			begin
	
				set @ref = substring(@pub, 1, 31)
				set @pub = SUBSTRING(@pub, 32, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk,
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 23 and LEFT(@pub, 23) = 'Lamb''s Index nom. lich.')
			begin
	
				set @ref = substring(@pub, 1, 23)
				set @pub = SUBSTRING(@pub, 24, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk,
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
			if (LEN(@pub) > 35 and LEFT(@pub, 35) = 'Index of Fungi Supplement (Lichens)')
			begin
	
				set @ref = substring(@pub, 1, 35)
				set @pub = SUBSTRING(@pub, 36, len(@pub))
				
				exec sprInsertUpdate_PubListRef
					@ref,
					@pub,
					1,
					@ifpk, 
					@secIdDomain, -- secondary name record
					'Index Fungorum PK', 
					@rnk, 
					@fullName, 
					@verbName, 
					@page, 
					@pgQual, 
					@isNotho,
					@ifpk, 
					@refIdDomain, --IF refs domain
					'Index Fungorum Pub', 
					@bas,
					@fundicRec
								
			end
			
		end
				
	end

	commit transaction ifrec

END TRY
BEGIN CATCH
	if (@@TRANCOUNT > 0) rollback transaction 
	
	print('err ' + cast(ERROR_NUMBER() as varchar(50)))
	print('proc ' + ERROR_PROCEDURE())
	print('line ' + cast(ERROR_LINE() as varchar(50)))
	print('msg ' + ERROR_MESSAGE())
END CATCH


GO


GRANT EXEC ON TransferIFRecord TO PUBLIC

GO