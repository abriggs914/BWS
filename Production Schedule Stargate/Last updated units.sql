USE Stargatedb
GO


DECLARE @t AS TABLE (
	[UpdateID] INT,
	[UpdateDate] DATETIME, 
	[SGQuote] NVARCHAR(8),
	[AvailableDate] DATETIME,
	[Line] NVARCHAR(255),
	[UpdaterName] NVARCHAR(255),
	[AvailableDateOld] DATETIME,
	[LineOld] NVARCHAR(255)
)

INSERT INTO @t
(
	[UpdateID],
	[UpdateDate], 
	[SGQuote],
	[AvailableDate],
	[Line],
	[UpdaterName],
	[AvailableDateOld],
	[LineOld]
)
SELECT
	[P2].[UpdateID]
	,[P2].[UpdateDate]
	,[P2].[SGQuote]
	,[P2].[AvailableDate]
	,[P2].[Line]
	,[P2].[UpdaterName]
	,[P2].[AvailableDateOld]
	,[P2].[LineOld]
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY [P1].[SGQuote]
			ORDER BY [P1].[UpdateDate] DESC
		) AS [RowN]
		, [P1].[SGQuote]
		, [P1].[UpdateID]
	FROM
		[PDS Updates] AS [P1]
	GROUP BY
		[P1].[SGQuote]
		, [P1].[UpdateID]
		, [P1].[UpdateDate]
) AS [A]
INNER JOIN
	[PDS Updates] AS [P2]
ON
	[A].[UpdateID] = [P2].[UpdateID]
WHERE
	[RowN] = 1
	AND [IsTest] <> 1
ORDER BY
	[SGQuote]
;

SELECT * FROM @t;

SELECT DISTINCT
	[Line]
FROM 
	@t
UNION
SELECT DISTINCT
	[LineOld]
FROM 
	@t
;

SELECT * FROM [Prod Lines];

EXEC [sp_ProductionSchedule V4_Slots] '2023-01-01', '2023-12-31';
EXEC [sp_ProductionSchedule V5_Slots] '2023-01-01', '2023-12-31';
