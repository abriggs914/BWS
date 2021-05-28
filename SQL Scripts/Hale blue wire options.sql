use BWSdb
go

--SELECT * FROM [ORDERS] where [Model No] LIKE '25ART' AND [Width] = 114 order by [Quote Date]
--SELECT * FROM [Dealers] WHERE [ID] = 265

--SELECT [ID#], [Model No], [Option No], [Price], [Sections], [Description] FROM OPTIONS WHERE [Description] LIKE '%blue%' and [Description] LIKE '%Power%' AND [Obsolete] = 0
SELECT * FROM OPTIONS where [Description] like '%fender%'
SELECT * FROM [Options_SpecLines] where [SpecSortG] =73 and [SpecSortSe] = 110 order by [SpecSection]