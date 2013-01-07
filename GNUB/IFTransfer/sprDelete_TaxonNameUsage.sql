
IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'sprDelete_TaxonNameUsage')
	BEGIN
		DROP  Procedure  sprDelete_TaxonNameUsage
	END

GO

CREATE Procedure sprDelete_TaxonNameUsage
	@extIdentifier nvarchar(500),
	@idDomainAgentId int
AS


	delete i
	from Identifier i
	inner join IdentifierDomain d on d.IdentifierDomainID = i.IdentifierDomainID
	where d.IssuerID = @idDomainAgentId and i.Identifier = @extIdentifier

	declare @tblId int
	select @tblId = si.SchemaItemID
	from SchemaItem si
	inner join Enumeration e on e.EnumerationID = si.SchemaItemTypeID
	where e.EnumerationValue = 'Table' and si.SchemaItemName = 'TaxonNameUsage'
	
	delete P
	from PK p
	left join Identifier on Identifier.PKID = P.PKID
	where TableID = @tblId and Identifier.PKID is null

	delete tap
	from TaxonNameAppearance tap
	left join Identifier on Identifier.IdentifierID = tap.TaxonNameUsageID
	where Identifier.PKID is null
	 
	delete t
	from TaxonNameUsage t
	left join Identifier on IdentifierID = t.TaxonNameUsageID
	where Identifier.PKID is null

	DELETE na
	from NomenclaturalEvent na
	left join TaxonNameUsage tnu on tnu.TaxonNameUsageID = na.TaxonNameUsageID
	where tnu.TaxonNameUsageID is null

	--delete t
	--from typification t
	--left join TaxonNameUsage tnu on tnu.TaxonNameUsageID = t.TaxonNameUsageID
	--where tnu.TaxonNameUsageID is null
	
	delete rt
	from ReferenceTitle rt
	inner join Reference r on r.ReferenceID = rt.ReferenceID	
	left join Identifier on IdentifierID = r.ReferenceID
	where Identifier.PKID is null
	
	delete r
	from Reference r
	left join Identifier on IdentifierID = r.ReferenceID
	where Identifier.PKID is null

	
	delete h
	from HybridNameUsage h
	left join TaxonNameUsage tnu on tnu.TaxonNameUsageID = h.HybridNameUsageID
	where tnu.TaxonNameUsageID is null




GO


GRANT EXEC ON sprDelete_TaxonNameUsage TO PUBLIC

GO
