USE BWSdb
GO

SELECT
	'STG' AS [Comp]
	,[COMPANY NAME]
	,	*
FROM
	[OrdersV2] AS [O2]
INNER JOIN
	[DealersV2] AS [D2]
ON
	[O2].[DealerID] = [D2].[ID]
WHERE
	([D2].[COMPANY NAME] LIKE '%hale%'
	OR [D2].[COMPANY NAME] LIKE '%arkel%')
	AND [Date Declined] IS NULL
	AND ISNULL([Delivery Date], DATEADD(DAY, 1, GETDATE())) > GETDATE()
ORDER BY
	[SGQuote]
;


SELECT
	'STG' AS [Comp]
	,[COMPANY NAME]
	,*
FROM
	[OrdersV2] AS [O2]
INNER JOIN
	[DealersV2] AS [D2]
ON
	[O2].[DealerID] = [D2].[ID]
WHERE
	[O2].[SGQuote] IN (
		'SG101362'
	)
	AND [Date Declined] IS NULL
	AND ISNULL([Delivery Date], DATEADD(DAY, 1, GETDATE())) > GETDATE()
ORDER BY
	[SGQuote]
;




--SELECT
--	'BWS' AS [Comp]
--	,[COMPANY NAME]
--	,	*
--FROM
--	[Orders] AS [O]
--INNER JOIN
--	[Dealers] AS [D]
--ON
--	[O].[DealerID] = [D].[ID]
--WHERE
--	[D].[COMPANY NAME] LIKE '%hale%'
--	OR [D].[COMPANY NAME] LIKE '%arkel%'
--ORDER BY
--	[Quote#]
--;


--SELECT
--	'BWS' AS [Comp]
--	,[COMPANY NAME]
--	,*
--FROM
--	[Orders] AS [O]
--INNER JOIN
--	[Dealers] AS [D]
--ON
--	[O].[DealerID] = [D].[ID]
--WHERE
--	[O].[Quote#] IN (
--		'SG101362'
--	)
--ORDER BY
--	[Quote#]
--;
