USE [SysproCompanyA]
GO

DECLARE @T1 AS TABLE ([FmtDate] NVARCHAR(MAX), [Units Sold] INT, [Initials] NVARCHAR(MAX), [Trailer Selling Price] FLOAT, [Trailer COGS] FLOAT, [Parts Selling Price] FLOAT, [Parts COGS] FLOAT)

INSERT INTO @T1
EXEC [dbo].[sp_DealerPartsSalesSummary] '2018-11-01', '2022-02-28', '2018-11-01', '2022-02-28'

SELECT * FROM @T1

SELECT 
	MAX([FmtDate]) AS [FmtDate],
	SUM([Units Sold]) AS [Units Sold],
	[Initials],
	SUM([Trailer Selling Price]) AS [Trailer Selling Price],
	SUM([Trailer COGS]) AS [Trailer COGS],
	SUM([Parts Selling Price]) AS [Parts Selling Price],
	SUM([Parts COGS]) AS [Parts COGS]
FROM @T1 GROUP BY [Initials]


DECLARE @T2 AS TABLE ([PriorGrossPrice] FLOAT, [PriorDiscount] FLOAT, [PriorSellingPrice] FLOAT, [PriorCOGS] FLOAT
, [PriorMargin] FLOAT, [PriorMargin%] FLOAT, [GlCode] int, [LblGroup] NVARCHAR(MAX), [Dealer] NVARCHAR(MAX), [CurrentGrossPrice] FLOAT, [CurrentDiscount] FLOAT, [CurrentSellingPrice] FLOAT, [CurrentCOGS] FLOAT
, [CurrentMargin] FLOAT, [CurrentMargin%] FLOAT, [Change%] FLOAT)

INSERT INTO @T2
EXEC [sp_PartsSalesDetail] '2018-11-01', '2022-02-28', '2018-11-01', '2022-02-28'

SELECT * FROM @T2 ORDER BY [Dealer]


	--[Dealer],
	--[PriorSellingPrice],
	--[PriorCOGS]

SELECT 
	[Initials],
	[Parts Selling Price],
	[Parts COGS],
	[Dealer],
	[PriorSellingPrice],
	[PriorCOGS]
FROM (
	SELECT
		[Initials],
		[Parts Selling Price],
		[Parts COGS]
	FROM 
		(
			SELECT 
				[Initials],
				SUM([Parts Selling Price]) AS [Parts Selling Price],
				SUM([Parts COGS]) AS [Parts COGS]
			FROM
				@T1
			GROUP BY
				[Initials]
		) AS [SrcA]
	) AS [SrcB]
LEFT JOIN
	@T2 
ON 
	[Dealer] = [SrcB].[Initials] 
WHERE
	[PriorSellingPrice] <> [Parts Selling Price] OR [Parts COGS] <> [PriorCOGS]
GROUP BY
	[Initials],
	[Dealer],
	[PriorSellingPrice],
	[PriorCOGS],
	[Parts Selling Price],
	[Parts COGS]