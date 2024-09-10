
SELECT
	*
FROM
	[Stargatedb].[dbo].[PDS Valid Updaters] [PDSV]

SELECT
	*
FROM
	[Stargatedb].[dbo].[PDS Updates] [PDSU]

SELECT
	[LastUpdateOfDay]
	,[UpdaterName]
	,ROW_NUMBER() OVER(
		ORDER BY
			[LastUpdateOfDay]
	) AS [RN]
FROM (
	SELECT
		CAST(
			CAST([Y] AS NVARCHAR(4)) 
			+ '-' + RIGHT('00' + CAST([M] AS NVARCHAR(2)), 2) 
			+ '-' + RIGHT('00' + CAST([D] AS NVARCHAR(2)), 2)
			+ ' ' + LEFT(CAST([Time] AS NVARCHAR(MAX)), 12)
		AS DATETIME) AS [LastUpdateOfDay]
		,[UpdaterName]
	FROM (
		SELECT
			YEAR([PDSU].[UpdateDate]) AS [Y]
			,MONTH([PDSU].[UpdateDate]) AS [M]
			,DAY([PDSU].[UpdateDate]) AS [D]
			,MAX(CAST(
				RIGHT('00' + CAST(DATEPART(HOUR, [PDSU].[UpdateDate]) AS NVARCHAR(2)), 2)
				+ ':' + RIGHT('00' + CAST(DATEPART(MINUTE, [PDSU].[UpdateDate]) AS NVARCHAR(2)), 2)
				+ ':' + RIGHT('00' + CAST(DATEPART(SECOND, [PDSU].[UpdateDate]) AS NVARCHAR(2)), 2)
			AS TIME)) AS [Time]
			,[PDSU].[UpdaterName]
		FROM
			[Stargatedb].[dbo].[PDS Updates] [PDSU]
		GROUP BY
			YEAR([PDSU].[UpdateDate])
			,MONTH([PDSU].[UpdateDate])
			,DAY([PDSU].[UpdateDate])
			,[PDSU].[UpdaterName]
	) AS [SrcA]
) AS [SrcB]

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2021-03-08'
	,[JobAvailableLine] = NULL
WHERE
	[SGQuote] = 'SG100025'

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL
	,[JobFinishDate] = '2021-03-08'
WHERE
	[SGQuote] = 'SG100025'

ROLLBACK;
COMMIT;
*/