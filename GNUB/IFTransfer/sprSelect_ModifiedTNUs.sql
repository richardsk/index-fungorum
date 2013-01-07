
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprSelect_ModifiedTNUs')
	BEGIN
		DROP  Procedure  sprSelect_ModifiedTNUs
	END

GO

CREATE Procedure sprSelect_ModifiedTNUs
	@fromDate datetime
as

	declare @ids table(id int)

	insert @ids 
	select TaxonNameUsageID		
	from TaxonNameUsage
	join SchemaItem s on SchemaItemTypeID = 2 and SchemaItemName = 'TaxonNameUsage'
	left join EditLog e on e.SchemaItemID = s.SchemaItemID and e.PKID = TaxonNameUsageID
	where e.TimeStamp is null or e.TimeStamp > @fromDate


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
	from @ids tnuid
	inner join TaxonNameUsage tnu on tnu.TaxonNameUsageID = tnuid.id
	inner join PK on pk.pkid = tnu.TaxonNameUsageID
	inner join TaxonRank tr on tr.TaxonRankID = tnu.TaxonRankID 
	left join PK anpk on anpk.PKID = tnu.ValidUsageID
	left join TaxonNameUsage p on p.TaxonNameUsageID = tnu.ProtonymID 
	left join PK ppk on ppk.PKID = p.TaxonNameUsageID
	left join TaxonNameUsage par on par.TaxonNameUsageID = tnu.ParentUsageID
	left join PK parpk on parpk.PKID = par.TaxonNameUsageID
    inner join Reference r on r.ReferenceID = tnu.ReferenceID  
    left join Reference pr on pr.ReferenceID = p.ReferenceID
	
		                      
                        
GO


GRANT EXEC ON sprSelect_ModifiedTNUs TO PUBLIC

GO