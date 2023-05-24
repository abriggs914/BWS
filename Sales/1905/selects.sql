
--SELECT 
--	LEFT(RIGHT(CAST([PO Date] AS NVARCHAR(MAX)), 12), 4),
--	* 
--FROM
--	[BWSdb].[dbo].[OrdersV2]
--WHERE
--	[SGQuote] IN ('SG100035', 'SG100838', 'SG100818', 'SG100819')
--;


DECLARE @notFound AS TABLE ([ID] INT IDENTITY(0, 1), [Quote] NVARCHAR(8));
INSERT INTO @notFound ([Quote]) VALUES
	('SG100376'),
	('SG100378'),
	('SG100035'),
	('SG100787'),
	('SG100905'),
	('SG100906'),
	('SG100907'),
	('SG100911'),
	('SG100922'),
	('SG100923'),
	('SG100925'),
	('SG100926'),
	('SG100929'),
	('SG100933'),
	('SG100934'),
	('SG100935'),
	('SG100936'),
	('SG100937'),
	('SG100938'),
	('SG100939'),
	('SG101186'),
	('SG101185'),
	('SG101184'),
	('SG101152'),
	('SG101150'),
	('SG101137'),
	('SG101106'),
	('SG101104'),
	('SG101103'),
	('SG101101'),
	('SG101100'),
	('SG101099'),
	('SG101098'),
	('SG101096'),
	('SG101095'),
	('SG101094'),
	('SG101090'),
	('SG101086'),
	('SG101085'),
	('SG101084'),
	('SG101074'),
	('SG101073'),
	('SG101072'),
	('SG101071'),
	('SG101064'),
	('SG101040'),
	('SG101039'),
	('SG101037'),
	('SG101029'),
	('SG101028'),
	('SG101026'),
	('SG101023'),
	('SG101022'),
	('SG101021'),
	('SG101020'),
	('SG101010'),
	('SG100996'),
	('SG100991'),
	('SG100990'),
	('SG100989'),
	('SG100988'),
	('SG100987'),
	('SG100986'),
	('SG100985'),
	('SG100984'),
	('SG100983'),
	('SG100982'),
	('SG100981'),
	('SG100980'),
	('SG100961'),
	('SG100960'),
	('SG100959'),
	('SG100958'),
	('SG100957'),
	('SG100956'),
	('SG100955'),
	('SG100954'),
	('SG100953'),
	('SG100952'),
	('SG100951'),
	('SG100950'),
	('SG100949'),
	('SG100948'),
	('SG100947'),
	('SG100946'),
	('SG100945'),
	('SG100944'),
	('SG100943'),
	('SG100941'),
	('SG100940'),

	('SG101214'),
	('SG101075'),
	('SG101058'),
	('SG101054'),
	('SG101053'),

	('SG100918'),
	('SG100916'),
	('SG100886'),
	('SG100884'),
	('SG100846'),
	('SG100652'),
	('SG100565'),
	('SG100346'),

	('SG100978'),
	('SG100977'),

	('SG101068'),

	('SG101080'),

	('SG101177'),
	('SG101173'),
	('SG101070'),
	('SG100629'),

	('SG101205'),
	('SG101201'),
	('SG101200'),
	('SG101199'),
	('SG101198'),
	('SG101196'),
	('SG101195'),
	('SG101165'),
	('SG101031'),
	('SG101024'),
	('SG100972'),
	('SG100971'),
	('SG100970'),
	('SG100880'),
	('SG100801')
;

SELECT
	[COMPANY NAME]
	,[Purchase Order]
	,[PO Date]
	,*
FROM
	[BWSdb].[dbo].[OrdersV2]
INNER JOIN
	[BWSdb].[dbo].[DealersV2]
ON
	[OrdersV2].[DealerID] = [DealersV2].[ID]
WHERE
	LEFT(RIGHT(CAST([PO Date] AS NVARCHAR(MAX)), 12), 2) <> '20'
ORDER BY
	[DealersV2].[COMPANY NAME],
	[SGQuote]
;

--SELECT
--	[COMPANY NAME]
--	,*
--FROM
--	[BWSdb].[dbo].[OrdersV2]
--INNER JOIN
--	[BWSdb].[dbo].[DealersV2]
--ON
--	[OrdersV2].[DealerID] = [DealersV2].[ID]
--LEFT JOIN
--	@notFound
--ON
--	[OrdersV2].[SGQuote] = [@notFound].[Quote]
--WHERE
--	[@notFound].[Quote] IS NULL
--	AND
--	LEFT(RIGHT(CAST([PO Date] AS NVARCHAR(MAX)), 12), 2) <> '20'
--	--AND [COMPANY NAME] LIKE '%Wieland Sales%'
--	--AND [COMPANY NAME] LIKE '%Transit Trailer Limited%'
--	--AND [COMPANY NAME] LIKE '%Trans e%'
--	--AND [COMPANY NAME] LIKE '%remorques%'
--	--AND [COMPANY NAME] LIKE '%R.R. Charlesbois Inc%'
--	--AND [COMPANY NAME] LIKE '%Quality Trailers%'
--	--AND [COMPANY NAME] LIKE '%nuss%'
--	--AND [COMPANY NAME] LIKE '%northeast%'
--	--AND [COMPANY NAME] LIKE '%fleet%'