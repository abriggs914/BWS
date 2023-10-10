USE BWSdb
GO

DECLARE @t AS TABLE(
	[ID] INT IDENTITY(0, 1),
	[DealerID] INT,
	
	[USDealer] BIT,
	[CDNDealer] BIT,
	[TtlQuotes] INT,
	[TtlOrders] INT,
	[PeriodGrouping] INT,
	[USSale] BIT,
	[TtlPrice] DECIMAL(18, 8),
	[FirstDate] DATETIME,
	[lastDate] DATETIME
)

INSERT INTO @t
EXEC sp_DSR_DealerCounts
	--@dealerID=6,
	--@maxYearsBack=3

SELECT * FROM @t

SELECT
	[COMPANY NAME]
	, SUM([TtlQuotes]) AS [TtlQuotes]
	, SUM([TtlOrders]) AS [TtlOrders]
	, [PeriodGrouping]
	, SUM([TtlPrice]) AS [TtlPrice]
	, MIN([FirstDate]) AS [FirstDate]
	, MAX([LastDate]) AS [LastDate]
FROM
	@t AS [T]
LEFT JOIN
	[Dealers] AS [D]
ON
	[T].[DealerID] = [D].[ID]
GROUP BY
	[COMPANY NAME]
	, [PeriodGrouping]
ORDER BY
	[COMPANY NAME]
	, [PeriodGrouping]