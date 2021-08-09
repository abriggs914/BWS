USE BWSdb
GO



SELECT * FROM [Orders];
SELECT * FROM [Products];

SELECT DISTINCT 
	[Orders].[Model No],
	COUNT(*) AS [Times Sold]
FROM
	[Orders]
INNER JOIN
	[Products]
ON	
	[Products].[Model No] = [Orders].[Model No]
WHERE
	[Non-Current] = 0
	AND [Proposed] = 0
GROUP BY
	[Orders].[Model No]
ORDER BY
	[Orders].[Model No];


--SELECT TOP 20
--	CAST(COUNT([Orders].[Model No]) AS VARCHAR(4)) + ' x ' + [Orders].[Model No] AS [Model No],
--	ROUND(SUM([Orders].[Price]), 2) AS [Total Sales]
--FROM
--	[Orders]
--INNER JOIN
--	[Products]
--ON	
--	[Products].[Model No] = [Orders].[Model No]
--WHERE
--	[Non-Current] = 0
--	AND [Proposed] = 0
--	AND [Orders].[Quote Date]  BETWEEN @SD AND @ED
--GROUP BY
--	[Orders].[Model No]
--ORDER BY
--	[Orders].[Model No]

	
DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2021-07-01';
SET @ED = '2021-08-01';

SELECT TOP 20
	CAST(COUNT([Orders].[Model No]) AS VARCHAR(4)) + ' x ' + [Orders].[Model No] + '\n($ ' + CAST(CAST(SUM([Orders].[Price]) AS MONEY) AS VARCHAR(25)) + ')' AS [Model No],
	ROUND(SUM([Orders].[Price]), 2) AS [Total Sales]
FROM
	[Orders]
INNER JOIN
	[Products]
ON	
	[Products].[Model No] = [Orders].[Model No]
WHERE
	[Non-Current] = 0
	AND [Proposed] = 0
	AND [Orders].[Quote Date]  BETWEEN @SD AND @ED
GROUP BY
	[Orders].[Model No]
ORDER BY
	[Orders].[Model No]
;


	'$ ' + CAST(CAST([Price] AS MONEY) AS VARCHAR(20)) AS [Num]

SELECT 
	'$ ' + REPLACE(CONVERT(VARCHAR(50), (CAST([Price] AS money)), 1), '.00', '') AS [Num]
FROM
	[Orders]
;


SELECT * FROM [Custom Work]



DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2021-08-08';
SET @ED = '2021-08-09';

SELECT TOP 20
        CAST(COUNT([Orders].[Model No]) AS VARCHAR(4)) + ' x ' + [Orders].[Model No] + ' ($ ' + REPLACE(CONVERT(VARCHAR(50), (CAST(SUM([Orders].[Price]) + SUM([Order Options].[Price]) + SUM([Custom Work].[Price]) AS MONEY)), 1), '.00', '')+ ')' AS [Model No],
        ROUND(SUM([Orders].[Price]) + SUM([Order Options].[Price]) + SUM([Custom Work].[Price]), 2) AS [Total Sales]
    FROM
        [Orders]
    INNER JOIN
        [Products]
    ON	
        [Products].[Model No] = [Orders].[Model No]
	INNER JOIN
		[Order Options]
	ON
		[Orders].[Quote#] = [Order Options].[Quote#]
	INNER JOIN
		[Custom Work]
	ON
		[Orders].[Quote#] = [Custom Work].[Quote#]
    WHERE
        [Non-Current] = 0
        AND [Proposed] = 0
        AND [Orders].[Quote Date] BETWEEN @SD AND @ED
    GROUP BY
        [Orders].[Model No]
    ORDER BY
        [Total Sales] DESC





DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2021-08-08';
SET @ED = '2021-08-09';

SELECT TOP 20
        CAST(COUNT([Orders].[Model No]) AS VARCHAR(4)) + ' x ' + [Orders].[Model No] + ' ($ ' + REPLACE(CONVERT(VARCHAR(50), (CAST(SUM([Orders].[Price]) + SUM([Order Options].[Price]) + SUM([Custom Work].[Price]) AS MONEY)), 1), '.00', '')+ ')' AS [Model No],
        ROUND(SUM([Orders].[Price]) + SUM([Order Options].[Price]) + SUM([Custom Work].[Price]), 2) AS [Total Sales]
    FROM
        [Orders]
    INNER JOIN
        [Products]
    ON	
        [Products].[Model No] = [Orders].[Model No]
	INNER JOIN
		[Order Options]
	ON
		[Orders].[Quote#] = [Order Options].[Quote#]
	INNER JOIN
		[Custom Work]
	ON
		[Orders].[Quote#] = [Custom Work].[Quote#]
    WHERE
		[Orders].[Quote#] = 26286
    GROUP BY
        [Orders].[Model No]
    ORDER BY
        [Total Sales] DESC




DECLARE @SD AS DATETIME;
DECLARE @ED AS DATETIME;
SET @SD = '2021-08-08';
SET @ED = '2021-08-09';

SELECT TOP 20
	[Orders].[Model No],
	CAST(COUNT([Orders].[Model No]) AS VARCHAR(4)) AS [Model Count]
FROM
	[Orders]
INNER JOIN
	[Products]
ON	
	[Products].[Model No] = [Orders].[Model No]
INNER JOIN
	[Order Options]
ON
	[Orders].[Quote#] = [Order Options].[Quote#]
INNER JOIN
	[Custom Work]
ON
	[Orders].[Quote#] = [Custom Work].[Quote#]
WHERE
	[Orders].[Quote#] = 26286
GROUP BY
	[Orders].[Model No]
ORDER BY
	[Orders].[Model No] DESC




SELECT DISTINCT
	[Orders].[Model No],
	[Order Options].[Option No],
	[Custom Work].[ID]
FROM
	[Orders]
INNER JOIN
	[Products]
ON	
	[Products].[Model No] = [Orders].[Model No]
INNER JOIN
	[Order Options]
ON
	[Orders].[Quote#] = [Order Options].[Quote#]
INNER JOIN
	[Custom Work]
ON
	[Orders].[Quote#] = [Custom Work].[Quote#]
WHERE
	[Orders].[Quote#] = 26286
ORDER BY
	[Orders].[Model No] DESC



SELECT
	[Orders].[Model No],
	COUNT(*) AS [Count],
	SUM([Orders].[Price]) + (
		SELECT
			[Total Sales]
		FROM (
			SELECT
				SUM([Order Options].[Price]) AS [Total Sales]
			FROM
				[Order Options]
			WHERE
				[Orders].[Model No] = [dbo].split_string([Order Options].[Option No], '-')
		) AS [Option Sales]
	) AS [Total Sales]
FROM
	[Orders]
INNER JOIN
	[Products]
ON
	[Orders].[Model No] = [Products].[Model No]
WHERE
	[Non-Current] = 0
	AND [Proposed] = 0
GROUP BY
	[Orders].[Model No]
ORDER BY
	[Orders].[Model No]
