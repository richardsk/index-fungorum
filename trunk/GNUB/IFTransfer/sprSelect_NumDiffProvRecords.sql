IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_NumDiffProvRecords')
	BEGIN
		DROP  Procedure  sprSelect_NumDiffProvRecords
	END

GO

CREATE Procedure sprSelect_NumDiffProvRecords
	@providerId uniqueidentifier,
	@updateDate datetime
as

	declare @cnt int, @prov nvarchar(150)
	select @cnt = 0, @prov = providername from admin.Provider where ProviderID = @providerId
		
	if (@prov = 'Index Fungorum') --IF
	begin
		select @cnt = COUNT([RECORD NUMBER])
		from [IF].dbo.IndexFungorum 
		where UpdatedDate > @updateDate
	end
	
	select @cnt
	
GO


GRANT EXEC ON sprSelect_NumDiffProvRecords TO PUBLIC

GO