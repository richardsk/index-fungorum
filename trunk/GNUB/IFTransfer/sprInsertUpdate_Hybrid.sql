
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprInsertUpdate_Hybrid')
	BEGIN
		DROP  Procedure  sprInsertUpdate_Hybrid
	END

GO

CREATE Procedure sprInsertUpdate_Hybrid
	@tnuId int,
	@p1 int,
	@p2 int
AS

	delete HybridNameUsage where HybridNameUsageID = @tnuId
	
	if (@p1 is not null or @p2 is not null)
	begin		
		insert HybridNameUsage
		select @tnuid, isnull(@p1,0), isnull(@p2,0)
	end
	
GO


GRANT EXEC ON sprInsertUpdate_Hybrid TO PUBLIC

GO

