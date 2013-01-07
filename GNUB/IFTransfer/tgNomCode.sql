IF EXISTS (SELECT * FROM sysobjects WHERE type = 'TR' AND name = 'tgNomCode')
	BEGIN
		DROP  Trigger tgNomCode
	END
GO

CREATE Trigger tgNomCode ON NomenclaturalEvent 
FOR INSERT, UPDATE, DELETE AS 

	declare @codes nvarchar(50), @tnuid int
	select @tnuid = TaxonNameUsageID from inserted
	if (@tnuid is null) select @tnuid = TaxonNameUsageID from deleted
	
	set @codes = ''
	select @codes = @codes + 
		case when charindex(nc.NomenclaturalCode, @codes) <> 0 then '' else '|' + nc.NomenclaturalCode end
	from NomenclaturalCode nc
	inner join NomenclaturalEventType net on net.NomenclaturalCodeID = nc.NomenclaturalCodeID
	inner join NomenclaturalEvent ne on ne.NomenclaturalEventTypeID = net.NomenclaturalEventTypeID
	where ne.TaxonNameUsageID = @tnuid
	if (len(@codes) > 1) set @codes = SUBSTRING(@codes, 2, len(@codes))
	
	update TaxonNameUsage set CacheNomCode = @codes where TaxonNameUsageID = @tnuid

GO

