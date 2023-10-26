
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
	[D2].[COMPANY NAME] LIKE '%arkel%'
	--AND [O2].[CompanyID] = 
	AND [WO#] IS NULL
	AND [Date Declined] IS NULL
	--AND ISNULL([Delivery Date], DATEADD(DAY, 1, GETDATE())) > GETDATE()
ORDER BY
	[SGQuote]
;