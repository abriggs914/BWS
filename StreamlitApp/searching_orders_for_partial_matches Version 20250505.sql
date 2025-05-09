
--Other units Required
--  2S9DA64634M115319
--  2S9DA2144YM115038
--  2S9DA6468HM117329


SELECT * FROM [BWSdb].[dbo].[Orders] [O] LEFT JOIN [BWSdb].[dbo].[Order Standards] [OS] ON [O].[Quote#] = [OS].[Quote#] WHERE [O].[Quote#] = 31400


SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 30231
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 30855
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 31400
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 7000
SELECT * FROM [BWSdb].[dbo].[Orders] WHERE [Quote#] = 10017
SELECT * FROM [BWSdb].[dbo].[OrdersV2] WHERE [SGQuote] = 'SG100179'
SELECT * FROM [BWSdb].[dbo].[Sales Staff]
SELECT * FROM [BWSdb].[dbo].[dtProductionSchedule] 
SELECT * FROM [BWSdb].[dbo].[Production] 
SELECT * FROM [BWSdb].[dbo].[OrdersV2]
SELECT * FROM [Stargatedb].[dbo].[dtProductionSchedule] 
SELECT * FROM [Stargatedb].[dbo].[Production] 
SELECT * FROM [BWSdb].[dbo].[ProductionV2] 


USE BWSdb
GO
SELECT 
	[Orders].*,
	--IIF(ISNULL([Production].[Prod Date]), [Production].[Prod Date2], [Production].[Prod Date]) AS [ProdDate],
	ISNULL([Production].[Prod Date], [Production].[Prod Date2]) AS [ProdDate],
	[Sales Staff].[Sales Person],
	[Dealers].[COMPANY NAME] 
FROM
	[Orders]
LEFT JOIN
	[Production]
ON
	[Orders].[Quote#] = [Production].[Quote#]
LEFT JOIN
	[Sales Staff]
ON
	[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff] 
LEFT JOIN
	[Dealers]
ON
	[Orders].[DealerID] = [Dealers].[ID] 
WHERE
	[Orders].[Quote#] = 30224



SELECT
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote]
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	([Serial Number] IN (
		'2S9DA64634M115319',
		'2S9DA2144YM115038',
		'2S9DA6468HM117329'
	))
	--OR (
	--	([Serial Number] = '2S9DA64634M115319')
	--	OR ([Serial Number] = '2S9DA2144YM115038')
	--	OR ([Serial Number] = '2S9DA6468HM117329')
	--)
	OR (
		([Notes] LIKE '%2S9DA64634M115319%')
		OR ([Notes] LIKE '%2S9DA2144YM115038%')
		OR ([Notes] LIKE '%2S9DA6468HM117329%')
	)
	OR (
		([EngNotes] LIKE '%2S9DA64634M115319%')
		OR ([EngNotes] LIKE '%2S9DA2144YM115038%')
		OR ([EngNotes] LIKE '%2S9DA6468HM117329%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA64634M115319%')
		OR ([Special Instructions] LIKE '%2S9DA2144YM115038%')
		OR ([Special Instructions] LIKE '%2S9DA6468HM117329%')
	)
	OR (
		([Special Instructions] LIKE '%December%')
		OR ([Special Instructions] LIKE '%2S9DA2144YM115038%')
		OR ([Special Instructions] LIKE '%2S9DA6468HM117329%')
	)
	UNION
SELECT
	[SGQuote]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	([Serial Number] IN (
		'2S9DA64634M115319',
		'2S9DA2144YM115038',
		'2S9DA6468HM117329'
	))
	--OR (
	--	([Serial Number] = '2S9DA64634M115319')
	--	OR ([Serial Number] = '2S9DA2144YM115038')
	--	OR ([Serial Number] = '2S9DA6468HM117329')
	--)
	OR (
		([Notes] LIKE '%2S9DA64634M115319%')
		OR ([Notes] LIKE '%2S9DA2144YM115038%')
		OR ([Notes] LIKE '%2S9DA6468HM117329%')
	)
	OR (
		([EngNotes] LIKE '%2S9DA64634M115319%')
		OR ([EngNotes] LIKE '%2S9DA2144YM115038%')
		OR ([EngNotes] LIKE '%2S9DA6468HM117329%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA64634M115319%')
		OR ([Special Instructions] LIKE '%2S9DA2144YM115038%')
		OR ([Special Instructions] LIKE '%2S9DA6468HM117329%')
	)
;

SELECT
	[Quote#]
	,[Serial Number]
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	([Serial Number] IS NOT NULL)
	AND (LEN(ISNULL([Serial Number], '')) = 17)
	AND (LEFT([Serial Number], 5) = '2S9DA')
ORDER BY
	[Serial Number]
;

SELECT
	[SGQuote]
	,[Serial Number]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	([Serial Number] IS NOT NULL)
	AND (LEN(ISNULL([Serial Number], '')) = 17)
	AND (LEFT([Serial Number], 5) = '2S9DA')
ORDER BY
	[Serial Number]
;
