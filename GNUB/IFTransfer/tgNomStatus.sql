IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tgNomStatus')
	BEGIN
		DROP  Trigger tgNomStatus
	END
GO

CREATE Trigger tgNomStatus ON NomenclaturalEvent 
FOR INSERT, UPDATE, DELETE AS 

	declare @status nvarchar(50), @tnuid int
	select @tnuid = TaxonNameUsageID from inserted
	if (@tnuid is null) select @tnuid = TaxonNameUsageID from deleted
	
	set @status = ''
	if (exists(select top 1 ne.NomenclaturalEventID from NomenclaturalEvent ne 
				inner join NomenclaturalEventType net on net.NomenclaturalEventTypeID = ne.NomenclaturalEventTypeID
				where ne.TaxonNameUsageID = @tnuid
				and (net.NomenclaturalEventType = 'Invalid' or net.NomenclaturalEventType = 'Illegitimate' or net.NomenclaturalEventType = 'Rejected') ))
	begin
		set @status = 'Invalid' 
	end
	else
	begin
		set @status = 'Valid'
	end
	
	update TaxonNameUsage set CacheNomStatus = @status where TaxonNameUsageID = @tnuid
	


GO

