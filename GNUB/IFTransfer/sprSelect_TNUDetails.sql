
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_TNUDetails')
	BEGIN
		DROP  Procedure  sprSelect_TNUDetails
	END

GO

CREATE Procedure sprSelect_TNUDetails
	@nameId uniqueidentifier
as

	declare @tblId int, @tnuId int
	select @tblId = SchemaItem.SchemaItemID from SchemaItem where SchemaItemName = 'TaxonNameUsage' and SchemaItemTypeID = 2

	select @tnuId = tnu.taxonnameusageid
	from taxonnameusage tnu
	inner join pk
	on pk.tableid = @tblId and PK.PKID = tnu.TaxonNameUsageID
	where uuid = @nameId

	select distinct tnu.*, 
		pk.uuid as NameID, 
		tr.RankName, 
		anpk.UUID AS AcceptedNameID,
		p.VerbatimNameString as Basionym, 
		ppk.UUID as BasionymID,
		r.CacheReference as AccordingTo, 		
		par.CacheNameComplete as ParentName,
		parpk.UUID as ParentNameID,
		pr.CacheReference as PublishedIn,
		pr.ReferenceID as ScientificNameAuthors
	from TaxonNameUsage tnu 
	inner join PK on pk.pkid = tnu.TaxonNameUsageID
	inner join TaxonRank tr on tr.TaxonRankID = tnu.TaxonRankID 
	left join PK anpk on anpk.PKID = tnu.ValidUsageID
	left join TaxonNameUsage p on p.TaxonNameUsageID = tnu.ProtonymID 
	left join PK ppk on ppk.PKID = p.TaxonNameUsageID
	left join TaxonNameUsage par on par.TaxonNameUsageID = tnu.ParentUsageID
	left join PK parpk on parpk.PKID = par.TaxonNameUsageID
    inner join Reference r on r.ReferenceID = tnu.ReferenceID  
    left join Reference pr on pr.ReferenceID = p.ReferenceID
    where tnu.TaxonNameUsageID = @tnuId
	
    select ne.*, net.NomenclaturalEventType, nc.NomenclaturalCode 
	from TaxonNameUsage tnu 
    inner join NomenclaturalEvent ne on ne.TaxonNameUsageID = tnu.TaxonNameUsageID 
    inner join NomenclaturalEventType net on net.NomenclaturalEventTypeID = ne.NomenclaturalEventTypeID 
    inner join NomenclaturalCode nc on nc.NomenclaturalCodeID = net.NomenclaturalCodeID 
    where tnu.TaxonNameUsageID = @tnuId
    
    select r.CacheReference as Citation, r.* 
    from Reference r 
    inner join TaxonNameUsage tnu on tnu.ReferenceID = r.ReferenceID 
    where tnu.TaxonNameUsageID = @tnuId
                        
                        
                        
GO


GRANT EXEC ON sprSelect_TNUDetails TO PUBLIC

GO