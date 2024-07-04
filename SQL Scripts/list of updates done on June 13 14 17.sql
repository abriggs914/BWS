
DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [WO] INT);
INSERT INTO @t ([WO]) VALUES
(10001554),
(10001555),
(10001550),
(10001551),
(10001404),
(10001556)



-- Main list of updates done on June 13, 14 & 17 JOIN shelleys list
SELECT
	'Main list of updates done on June 13, 14 & 17 JOIN shelleys list' AS [T]
	,[PU].[UpdateDate]
	,[PU].[SGQuote]
	,[PU].[AvailableDate]
	,[PU].[Line]
	,[PU].[UpdaterName]
	,[PU].[AvailableDateOld]
	,[PU].[LineOld]
	,[O2].[WO#]
FROM
	[Stargatedb].[dbo].[PDS Updates] [PU]
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2] [O2]
ON
	[PU].[SGQuote] = [O2].[SGQuote]
INNER JOIN
	@t [T]
ON
	[O2].[WO#] = [T].[WO]
WHERE
	YEAR([PU].[UpdateDate]) = 2024
	AND MONTH([PU].[UpdateDate]) > 1
	AND (
		[PU].[Line] <> [PU].[LineOld]
		OR [PU].[AvailableDate] <> [PU].[AvailableDateOld]
	)
	AND [O2].[Delivery Date] > DATEADD(MONTH, -4, GETDATE())
GROUP BY
	[PU].[UpdateDate]
	,[PU].[SGQuote]
	,[PU].[AvailableDate]
	,[PU].[Line]
	,[PU].[UpdaterName]
	,[PU].[AvailableDateOld]
	,[PU].[LineOld]
	,[O2].[WO#]
ORDER BY
	[PU].[UpdateDate]


-- Main list of Quotes updated on June 13, 14 & 17
SELECT
	'Main list of Quotes updated on June 13, 14 & 17' AS [T]
	,[Src].[SGQuote]
	,[Src].[Line]
	,[Src].[AvailableDate]
	,[Src].[LineOld]
	,[Src].[AvailableDateOld]
FROM (
	SELECT
		[PU].[UpdateID]
		,[PU].[SGQuote]
		,[PU].[UpdateDate]
		,[PU].[AvailableDate]
		,[PU].[Line]
		,[PU].[UpdaterName]
		,[PU].[AvailableDateOld]
		,[PU].[LineOld]
	FROM
		[Stargatedb].[dbo].[PDS Updates] [PU]
	LEFT JOIN
		[BWSdb].[dbo].[OrdersV2] [O2]
	ON
		[PU].[SGQuote] = [O2].[SGQuote]
	WHERE
		YEAR([PU].[UpdateDate]) = 2024
		AND MONTH([PU].[UpdateDate]) > 1
		AND (
			[PU].[Line] <> [PU].[LineOld]
			OR [PU].[AvailableDate] <> [PU].[AvailableDateOld]
		)
		AND [O2].[Delivery Date] > DATEADD(MONTH, -4, GETDATE())
	GROUP BY
		[PU].[UpdateID]
		,[PU].[SGQuote]
		,[PU].[UpdateDate]
		,[PU].[AvailableDate]
		,[PU].[Line]
		,[PU].[UpdaterName]
		,[PU].[AvailableDateOld]
		,[PU].[LineOld]
) [Src]
GROUP BY
	[Src].[SGQuote]
	,[Src].[Line]
	,[Src].[AvailableDate]
	,[Src].[LineOld]
	,[Src].[AvailableDateOld]
ORDER BY
	[Src].[SGQuote]
	,[Src].[Line]
	,[Src].[AvailableDate]
	,[Src].[LineOld]
	,[Src].[AvailableDateOld]



-- Main list of updates done on June 13, 14 & 17
SELECT
	'Main list of updates done on June 13, 14 & 17' AS [T]
	,[PU].[UpdateDate]
	,[PU].[SGQuote]
	,[PU].[AvailableDate]
	,[PU].[Line]
	,[PU].[UpdaterName]
	,[PU].[AvailableDateOld]
	,[PU].[LineOld]
FROM
	[Stargatedb].[dbo].[PDS Updates] [PU]
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2] [O2]
ON
	[PU].[SGQuote] = [O2].[SGQuote]
WHERE
	YEAR([PU].[UpdateDate]) = 2024
	AND MONTH([PU].[UpdateDate]) > 1
	AND (
		[PU].[Line] <> [PU].[LineOld]
		OR [PU].[AvailableDate] <> [PU].[AvailableDateOld]
	)
	AND [O2].[Delivery Date] > DATEADD(MONTH, -4, GETDATE())
GROUP BY
	[PU].[UpdateDate]
	,[PU].[SGQuote]
	,[PU].[AvailableDate]
	,[PU].[Line]
	,[PU].[UpdaterName]
	,[PU].[AvailableDateOld]
	,[PU].[LineOld]
ORDER BY
	[PU].[UpdateDate]


-- All list of updates
SELECT
	'All list of updates' AS [T]
	,[PU].[UpdateID]
	,[PU].[SGQuote]
	,[PU].[UpdateDate]
	,[PU].[AvailableDate]
	,[PU].[Line]
	,[PU].[UpdaterName]
	,[PU].[AvailableDateOld]
	,[PU].[LineOld]
FROM
	[Stargatedb].[dbo].[PDS Updates] [PU]
LEFT JOIN
	[BWSdb].[dbo].[OrdersV2] [O2]
ON
	[PU].[SGQuote] = [O2].[SGQuote]
WHERE
	YEAR([PU].[UpdateDate]) = 2024
	AND MONTH([PU].[UpdateDate]) > 1
	/*
	AND (
		[PU].[Line] <> [PU].[LineOld]
		OR [PU].[AvailableDate] <> [PU].[AvailableDateOld]
	)
	AND [O2].[Delivery Date] > DATEADD(MONTH, -4, GETDATE())
	*/
GROUP BY
	[PU].[UpdateID]
	,[PU].[SGQuote]
	,[PU].[UpdateDate]
	,[PU].[AvailableDate]
	,[PU].[Line]
	,[PU].[UpdaterName]
	,[PU].[AvailableDateOld]
	,[PU].[LineOld]
ORDER BY
	[PU].[UpdateDate]