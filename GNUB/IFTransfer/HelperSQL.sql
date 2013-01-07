--update [IF].dbo.IndexFungorum set UpdatedDate = '02/20/2009' 
--where [RECORD NUMBER] in (160160, 199609, 115123, 283568, 285037, 279639, 270821, 270823, 180004, 240731, 357915, 315395, 451279, 357542, 102094, 146048, 145291, 17043, 17045, 105118, 373106, 298252, 311246, 454305, 28381, 361609, 488019, 367867, 211193, 147364, 464704, 175430, 327610, 138489, 3749, 7545, 749, 8812)

--select * from [if].dbo.indexfungorum where [record number] = 160160 or [record number] = 270823

--select * from [if].dbo.indexfungorum
--where [sts flag] = 'o' and [RECORD NUMBER] in (102094, 146048, 145291, 17043, 17045, 105118, 373106, 298252, 311246, 454305, 28381, 361609, 488019, 367867, 211193, 147364, 464704, 175430, 327610, 138489, 3749, 7545, 749, 8812)

--update [if].dbo.indexfungorum
--set [nomenclatural comment] = 'autonym avoidance ...', [synonymy] = 'autonym blah ' 
--where [record number] = 160160

--update [if].dbo.indexfungorum
--set [nomenclatural comment] = 'Nom. Illegit., Art. 53.1',
--	[editorial comment] = '145291$Macrophoma peckiana (Thüm.) Berl. & Voglino 1886'
--where [record number] = 146048
--357915

--select * from Identifier where Identifier = '320534'
--select * from [if].dbo.publications where publink = 56

--update [if].dbo.indexfungorum 
--set [infraspecific rank] = 'sp.'
--where [infraspecific rank] is null
--	and [name of fungus] like '% %' and [name of fungus] not like '% % %'
--select * from [if].dbo.indexfungorum where [record number] = 488019

select * 
from TaxonNameUsage 
inner join Identifier on Identifier.PKID = TaxonNameUsageID
where Identifier.ResolutionNote = 'Index Fungorum PK'
order by nameelement

select * from NomenclaturalEvent
inner join Identifier on Identifier.PKID = TaxonNameUsageID
where Identifier.ResolutionNote = 'Index Fungorum PK'


select * from typification

select * from hybrid

--select top 100 p.pubacceptedtitle + isnull(', ' + i.authors, '') collate latin1_general_ci_ai
--from [if].dbo.indexfungorum i
--inner join [if].dbo.publications p on p.publink = i.[literature link] 

--select * from Identifier where Identifier in ('320534', '221354', '351936')
--select * from [IF].dbo.IndexFungorum 
--where [RECORD NUMBER] in (138489)

--select * from [if].dbo.indexfungorum where [name of fungus] like '%×%'
--select * from [IF].dbo.IndexFungorum where [INFRASPECIFIC RANK] = 'subsp.'
/*
update [if].dbo.indexfungorum
set [editorial comment] = '(<i>Melampsora medusae</i><211193> × <i>M. occidentalis</i><147364>)'
where [record number] = 464704


delete Identifier
where Identifier.ResolutionNote = 'Index Fungorum PK'

delete Identifier
where Identifier.ResolutionNote = 'Index Fungorum pub'


delete P
from PK p
left join Identifier on Identifier.PKID = P.PKID
where Identifier.PKID is null


delete t
from TaxonNameUsage t
left join Identifier on IdentifierID = t.TaxonNameUsageID
where Identifier.PKID is null


delete r
from Reference r
left join Identifier on IdentifierID = r.ReferenceID
where Identifier.PKID is null

delete hybrid

delete typification


*/

--update [IF].dbo.IndexFungorum set [INFRASPECIFIC RANK] = 'sp.' 
--where [RECORD NUMBER] in (138489)

--221354
--351936
--175430
--327610