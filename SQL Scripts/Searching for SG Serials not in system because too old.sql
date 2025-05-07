
--Other units Required
--  2S9DA6354PM119747

SELECT * FROM [BWSdb].[dbo].[ITR Pushes]
SELECT * FROM [BWSdb].[dbo].[Orders] ORDER BY [Quote#]
SELECT * FROM [BWSdb].[dbo].[OrdersV2] ORDER BY [SGQuote]
SELECT * FROM [BWSdb].[dbo].[OrdersV2] WHERE [SGQuote] = 'SG100575' ORDER BY [SGQuote]
SELECT * FROM [BWSdb].[dbo].[OrdersV2] WHERE [Customer WO#] IS NOT NULL


DECLARE @st NVARCHAR(MAX) = '2SVS69434TM000233'

SELECT
	CAST([Quote#] AS NVARCHAR(MAX)) AS [Quote]
FROM
	[BWSdb].[dbo].[Orders]
WHERE
	([Serial Number] IN (
		'2S9DA6354PM119747'
	))
	--OR (
	--	([Serial Number] = '2S9DA64634M115319')
	--	OR ([Serial Number] = '2S9DA2144YM115038')
	--	OR ([Serial Number] = '2S9DA6468HM117329')
	--)
	OR (
		([Notes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([EngNotes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA6354PM119747%')
	)
	UNION
SELECT
	[SGQuote]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	([Serial Number] IN (
		'2S9DA6354PM119747'
	))
	--OR (
	--	([Serial Number] = '2S9DA64634M115319')
	--	OR ([Serial Number] = '2S9DA2144YM115038')
	--	OR ([Serial Number] = '2S9DA6468HM117329')
	--)
	OR (
		([Notes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([EngNotes] LIKE '%2S9DA6354PM119747%')
	)
	OR (
		([Special Instructions] LIKE '%2S9DA6354PM119747%')
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

SELECT
	[SGQuote]
	,[Serial Number]
FROM
	[BWSdb].[dbo].[OrdersV2]
WHERE
	[Serial Number] = '2SVS6P434TM000233'
ORDER BY
	[Serial Number]
;
