USE BWSdb
GO


SELECT * FROM [Custom Work]

	
DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
DECLARE @MN AS VARCHAR(30);
SET @SD = '2021-08-08';
SET @ED = '2021-08-09';
SET @MN = '%51VT4V DCI%'
SELECT
	[Model No],
	[Quote#],
	SUM([Price]) AS [SP]
FROM
	[Orders]
WHERE 
	[Model No] LIKE @MN
	AND [Orders].[Quote Date] BETWEEN @SD AND @ED
GROUP BY
	[Model No],
	[Quote#]




CAST(COUNT([Orders].[Model No]) AS VARCHAR(4)) + ' x ' + [Orders].[Model No] + ' ($ ' + REPLACE(CONVERT(VARCHAR(50), (CAST(SUM([Orders].[Price]) + SUM([Order Options].[Price]) + SUM([Custom Work].[Price]) AS MONEY)), 1), '.00', '')+ ')' AS [Model No],
        ROUND(SUM([Orders].[Price]) + SUM([Order Options].[Price]) + SUM([Custom Work].[Price]), 2) AS [Total Sales]

	
DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
DECLARE @MN AS VARCHAR(30);
SET @SD = '2021-04-01';
SET @ED = '2021-08-09';
SET @MN = '%53ET3X%'


SELECT TOP 20
	CAST(SUM([Count]) AS VARCHAR(4)) + ' x ' + [Model No] +  + ' ($ ' + REPLACE(CONVERT(VARCHAR(50), (CAST(SUM([SP]) AS MONEY)), 1), '.00', '') + ')' AS [Model No],
	SUM([SP]) AS [Total Sales]
FROM (
	SELECT
		[Model No] AS [Model No],
		[Model No] + ' |BASE|' AS [BASE],
		COUNT(*) AS [Count],
		SUM([Price]) AS [SP]
	FROM
		[Orders]
	WHERE 
		[Order Date] IS NOT NULL
		AND [Orders].[Quote Date] BETWEEN @SD AND @ED
	GROUP BY
		[Model No]
	UNION (
		SELECT
			[Model No] AS [Model No],
			[Model No] + ' |STDOP|' AS [Options],
			COUNT(*) AS [Count],
			SUM([Price] * [Qty]) AS [SP]
		FROM (
			SELECT (
				SELECT TOP 1
					[splited_data]
				FROM
					split_string([Option No], '-')
				) AS [Model No],
				*
			FROM
				[Order Options]
		) AS [Orders Src]
		WHERE
			[Order Date] IS NOT NULL
			AND [Quote Date] BETWEEN @SD AND @ED
		GROUP BY
			[Model No]
	)
	UNION (
		SELECT
			[Model No] AS [Model No],
			[Model No] + ' |NPO|' AS [NPO],
			COUNT(*) AS [Count],
			SUM([Custom Work].[Price] * [Custom Work].[Qty]) AS [SP]
		FROM 
			[Custom Work]
		INNER JOIN
			[Orders]
		ON
			[Orders].[Quote#] = [Custom Work].[Quote#]
		WHERE
			[Custom Work].[Order Date] IS NOT NULL
			AND [Custom Work].[Quote Date] BETWEEN @SD AND @ED
		GROUP BY
			[Model No]
	)
) AS [SrcTable]
GROUP BY
	[Model No]
ORDER BY
	[Total Sales] DESC
	
SELECT * FROM [Order Options] WHERE [Option No] LIKE '%53ET3X%' ORDER BY [Order Date] DESC
SELECT * FROM [Custom Work] WHERE [Option No] LIKE '%53ET3X%' ORDER BY [Order Date] DESC

SELECT * FROM [Products] ORDER BY [Model No] DESC