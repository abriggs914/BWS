USE BWSdb
GO

SELECT TOP 500 * FROM [Orders] ORDER BY [Quote Date] DESC;
SELECT TOP 500 * FROM [OrdersV2] ORDER BY [Quote Date] DESC;
SELECT * FROM [Orders] WHERE [Quote#] = 29729 ORDER BY [Quote Date] DESC;




SELECT
	[O].[ProductID]
	,[P].[IDTrailer]
	,[O].[Quote#]
	,[O].[Model No] AS [OModelName]
	,[P].[Model No] AS [PModelName]
	,[O].[ProductID]
	,[O].[Quote Date]
FROM
	[Orders] AS [O]
LEFT OUTER JOIN
	[Products] AS [P]
ON
	[O].[ProductID] = [P].[IDTrailer]
ORDER BY
	[P].[Model No]
	,[O].[Model No]
;

SELECT
	[O].[ProductID]
	,[P].[IDTrailer]
	,[O].[Quote#]
	,[O].[Model No] AS [OModelName]
	,[P].[Model No] AS [PModelName]
	,[O].[ProductID]
	,[O].[Quote Date]
	,(CASE
		WHEN [O].[ProductID] IS NULL THEN (CASE
			WHEN [O].[Model No] = [P].[Model No] THEN 'A'
			ELSE 'B'
		END)
		ELSE (CASE
			WHEN [O].[ProductID] = [P].[IDTrailer] THEN 'C'
			ELSE 'D'
		END)
	END) AS [C]
FROM
	[Orders] AS [O]
LEFT OUTER JOIN
	[Products] AS [P]
ON
	(CASE
		WHEN [O].[ProductID] IS NULL THEN (CASE
			WHEN [O].[Model No] = [P].[Model No] THEN 1
			ELSE 0
		END)
		ELSE (CASE
			WHEN [O].[ProductID] = [P].[IDTrailer] THEN 1
			ELSE 0
		END)
	END) = 1
ORDER BY
	[P].[Model No]
	,[O].[Model No]