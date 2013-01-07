IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_PubListRef')
	BEGIN
		DROP  Procedure  sprInsertUpdate_PubListRef
	END

GO

CREATE Procedure sprInsertUpdate_PubListRef
	@ref nvarchar(255),
	@pubListRef nvarchar(500),
	@hasVol bit,
	@externalIdentifier nvarchar(255),
	@idDomain int,
	@identifierNote nvarchar(255),
	@rank int,
	@nameElement nvarchar(255),
	@verbName nvarchar(255),
	@page nvarchar(255),
	@pgQualifier nvarchar(255),
	@isNotho bit,
	@refExtId nvarchar(255),
	@refIdDomain int,
	@refIdNote nvarchar(255),
	@protonymExtId nvarchar(255),
	@genExtId nvarchar(255)
	--todo @authors ?
	
AS
	--@pubListRef is one list ref component of the IF Published List Ref field
	-- ie the part between the |
	
	declare @semiColPos int, @curSemiColPos int, @colPos int
	declare @commaPos int, @curCommaPos int
	
	declare @vol nvarchar(50), @pg nvarchar(50)
	declare @pub nvarchar(50)
		
		
	set @curSemiColPos = 1
	while (@curSemiColPos <> 0)
	begin			
		set @semiColPos = CHARINDEX(';', @pubListRef, @curSemiColPos)
		if (@semiColPos = 0)
		begin		
			set @pub = ltrim(rtrim(SUBSTRING(@pubListRef, @curSemiColPos, LEN(@pubListRef))))
			set @curSemiColPos = 0
		end
		else
		begin
			set @pub = LTRIM(rtrim(SUBSTRING(@pubListRef, @curSemiColPos, @semiColPos - @curSemiColPos)))
			set @curSemiColPos = @semiColPos + 1
		end

		print('Inserting name usage for pub list ref : ' + @pub)		
		
		--get volume - up to the :
		set @colPos = CHARINDEX(':', @pub)
		set @vol = null
		if (@colPos <> 0) set @vol = rtrim(ltrim(SUBSTRING(@pub, 1, @colPos - 1)))
		
		
		--work through pages	
		set @curCommaPos = @colPos + 1
		while (@curCommaPos <> 0)
		begin
			set @commaPos = CHARINDEX(',', @pub, @curCommaPos)
			if (@commaPos = 0)
			begin	
				set @pg = ltrim(rtrim(SUBSTRING(@pub, @curCommaPos, len(@pub))))
				set @curCommaPos = 0
			end
			else
			begin
				set @pg = ltrim(rtrim(SUBSTRING(@pub, @curCommaPos + 1, @commaPos - @curCommaPos - 1)))
				set @curCommaPos = @commaPos + 1
			end

			if (LEN(@pg) > 0)
			begin
				declare @fullRef nvarchar(500)
				set @fullRef = @ref + ' ' + @pub
				
				--insert TNU records (may be multiple if not uninomial)
				exec UpdateIFTNURecord
					@externalIdentifier, 
					@idDomain, 
					'Index Fungorum PK', 
					@rank, 
					null,
					@nameElement, 
					@verbName, 
					@pg, 
					null,
					null, 
					@isNotho,
					@fullRef,
					@refExtId,
					@refIdDomain,
					@refIdNote,
					null, -- todo @authors
					1, --is pub list ref
					null, -- act - none for pub list ref
					0,
					null, --act text
					null, --act comment
					@protonymExtId,
					@genExtId
			end
		end
	end
	

GO


GRANT EXEC ON sprInsertUpdate_PubListRef TO PUBLIC

GO


