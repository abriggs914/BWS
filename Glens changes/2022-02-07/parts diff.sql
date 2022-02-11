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

DECLARE @T3 AS TABLE ([PriorGrossPrice] FLOAT, [PriorDiscount] FLOAT, [PriorSellingPrice] FLOAT, [PriorCOGS] FLOAT
, [PriorMargin] FLOAT, [PriorMargin%] FLOAT, [GlCode] int, [LblGroup] NVARCHAR(MAX), [Dealer] NVARCHAR(MAX), [CurrentGrossPrice] FLOAT, [CurrentDiscount] FLOAT, [CurrentSellingPrice] FLOAT, [CurrentCOGS] FLOAT
, [CurrentMargin] FLOAT, [CurrentMargin%] FLOAT, [Change%] FLOAT)

INSERT INTO @T2
EXEC [sp_PartsSalesDetail] '2018-11-01', '2022-02-28', '2018-11-01', '2022-02-28'

INSERT INTO @T3 SELECT
SUM([PriorGrossPrice]),
SUM([PriorDiscount]),
SUM([PriorSellingPrice]),
SUM([PriorCOGS]),
SUM([PriorMargin]),
SUM([PriorMargin%]),
[GlCode],
[LblGroup],
[Dealer],
SUM([CurrentGrossPrice]),
SUM([CurrentDiscount]),
SUM([CurrentSellingPrice]),
SUM([CurrentCOGS]),
SUM([CurrentMargin]),
SUM([CurrentMargin%]),
SUM([Change%])
FROM @T2 GROUP BY [Dealer], [GlCode], [LblGroup]

SELECT * FROM @T2 ORDER BY [Dealer]
SELECT * FROM @T3 ORDER BY [Dealer]


	--[Dealer],
	--[PriorSellingPrice],
	--[PriorCOGS]

SELECT 
	[Initials],
	[Parts Selling Price], -- My calculated value
	[PriorSellingPrice], -- From report SP
	(CASE WHEN CAST([Parts Selling Price] AS MONEY) <> CAST([PriorSellingPrice] AS MONEY) THEN 'Y' ELSE '' END) AS [Check Selling Price],
	LOWER([Dealer]),
	[Parts COGS], -- My calculated value
	[PriorCOGS], -- From report SP
	(CASE WHEN CAST([PriorCOGS] AS MONEY) <> CAST([Parts COGS] AS MONEY) THEN 'Y' ELSE '' END) AS [Check COGS] 
FROM (
	SELECT
		[Initials],
		[Parts Selling Price],
		[Parts COGS]
	FROM 
		(
			SELECT 
				LOWER(CAST([Initials] AS NVARCHAR(MAX))) AS [Initials],
				SUM([Parts Selling Price]) AS [Parts Selling Price],
				SUM([Parts COGS]) AS [Parts COGS]
			FROM
				@T1
			GROUP BY
				LOWER(CAST([Initials] AS NVARCHAR(MAX)))
		) AS [SrcA]
	) AS [SrcB]
LEFT JOIN
	@T3 
ON 
	LOWER(CAST([Dealer] AS NVARCHAR(MAX))) = [SrcB].[Initials]
WHERE
	[PriorSellingPrice] <> [Parts Selling Price] OR [Parts COGS] <> [PriorCOGS]
GROUP BY
	[Initials],
	[Dealer],
	[PriorSellingPrice],
	[PriorCOGS],
	[Parts Selling Price],
	[Parts COGS]


SELECT 
	[Initials],
	SUM([Parts Selling Price]), -- My calculated value
	SUM([PriorSellingPrice]), -- From report SP
	(CASE WHEN CAST(SUM([Parts Selling Price]) AS MONEY) <> CAST(SUM([PriorSellingPrice]) AS MONEY) THEN 'Y' ELSE '' END) AS [Check Selling Price],
	LOWER([Dealer]),
	SUM([Parts COGS]), -- My calculated value
	SUM([PriorCOGS]), -- From report SP
	(CASE WHEN CAST(SUM([PriorCOGS]) AS MONEY) <> CAST(SUM([Parts COGS]) AS MONEY) THEN 'Y' ELSE '' END) AS [Check COGS] 
FROM (
	SELECT
		[Initials],
		[Parts Selling Price],
		[Parts COGS]
	FROM 
		(
			SELECT 
				LOWER(CAST([Initials] AS NVARCHAR(MAX))) AS [Initials],
				SUM([Parts Selling Price]) AS [Parts Selling Price],
				SUM([Parts COGS]) AS [Parts COGS]
			FROM
				@T1
			GROUP BY
				LOWER(CAST([Initials] AS NVARCHAR(MAX)))
		) AS [SrcA]
	) AS [SrcB]
LEFT JOIN
	@T3 
ON 
	LOWER(CAST([Dealer] AS NVARCHAR(MAX))) = [SrcB].[Initials]
WHERE
	[PriorSellingPrice] <> [Parts Selling Price] OR [Parts COGS] <> [PriorCOGS]
GROUP BY
	[Initials],
	[Dealer]