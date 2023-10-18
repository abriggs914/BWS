/****** Script for SelectTopNRows command from SSMS  ******/
SELECT
	[ID]
	,[WO#]
	,[DealerID]
	,[Model No]
	,[Serial Number]
	,[Claim Number]
	,[Claim Date]
	,[Date Closed]
	,[Approval Date]
	,[Reason Denied/Goodwill]
	,[Auth By]
	,[Issue Number]
	,[BWS Invoice #]
	,[Carrier]
	,[BOL#]
	,[Failure]
	,[Location]
	,[Dealer]
	,[Supplier]
	,[S/N]
	,[Customer]
	,[Parts/Labour]
	,[Customer V2]
	,[Dealer V2]
	,[S/N V2]
	,[Supplier V2]
FROM
	[BWSdb].[dbo].[Warranty Claims]
WHERE
	[DealerID] IN (1)
--	[DealerID] IN (427, 447, 330)
ORDER BY
	[Claim Date]


SELECT * FROM [BWSdb].[dbo].[Dealers]


DECLARE
	@dateIn AS DATETIME
	, @dateMonth AS INTEGER
	, @dateYear AS INTEGER
	, @minDate AS DATETIME
	, @periodLen AS DECIMAL(18, 8)
	, @maxYearsBack AS INT
	, @mode AS INT
;

SELECT
	@dateIn = GETDATE(),
	@mode = 1
;

	-- mode
	-- 0 - annual
	-- 1 - quarterly
	-- 2 - monthly
	-- 3 - weekly

	-- Negative mode queries each dealer
	-- Positive mode queries each day and each quote. If more than one quote for this day, then multiple records for that day

	SELECT
		@dateIn = ISNULL(@dateIn, GETDATE())
		, @dateMonth = MONTH(@dateIn)
		, @dateYear = YEAR(@dateIn)
		, @minDate = (CASE WHEN @maxYearsBack IS NULL THEN MIN([Quote Date]) ELSE DATEADD(YEAR, -ABS(@maxYearsBack), @dateIn) END)
		, @periodLen = (
			CASE ABS(@mode)
				WHEN 2 THEN 365/4
				WHEN 3 THEN 365/12
				WHEN 4 THEN 365/52
				ELSE 365
			END)
	FROM
		[Orders]
	WHERE
		[Quote Date] IS NOT NULL
	;


SELECT
	[DFQByPeriod]
	, [DealerID]
	, (CASE WHEN [TtlClaims] = 0 THEN NULL ELSE [FirstClaim] END) AS [FirstClaim]
	, (CASE WHEN [TtlClaims] = 0 THEN NULL ELSE [LastClaim] END) AS [LastClaim]
	--, [FirstClaim1]
	--, [LastClaim1]
	, [TtlClaims]
FROM (
	SELECT
		FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen) AS [DFQByPeriod]
	--	,[D].[ID]
	--	,[W].[DealerID]
	--	, *
	
		, [D].[ID] AS [DealerID]
		, MIN(CASE WHEN [W].[dealerID] = [D].[ID] THEN [Claim Date] ELSE NULL END) AS [FirstClaim]
		, MAX(CASE WHEN [W].[dealerID] = [D].[ID] THEN [Claim Date] ELSE NULL END) AS [LastClaim]
		--, MIN([Claim Date]) AS [FirstClaim]
		--, MAX([Claim Date]) AS [LastClaim]
		, SUM(CASE WHEN [W].[dealerID] = [D].[ID] THEN 1 ELSE 0 END) AS [TtlClaims]
	FROM
		[BWSdb].[dbo].[Warranty Claims] AS [W]
	CROSS JOIN
		[Dealers] AS [D]
	WHERE
		--[D].[CURRENT DEALER] = 1
		--AND [W].[DealerID] IS NOT NULL
		--AND
		[W].[Claim Date] BETWEEN @minDate AND @dateIn
		AND ISNULL([W].[DealerID], [D].[ID]) = [D].[ID]
	GROUP BY
		[D].[ID]
		,FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen)
) AS [Src]
ORDER BY
	[DFQByPeriod]
	,[DealerID]
;





SELECT
	FLOOR(ABS(DATEDIFF(DAY, @dateIn, [C].[Date])) / @periodLen) AS [DFQByPeriod]
	--,[D].[ID]
	--,[W].[DealerID]
	--, [Claim Date]
	--, [Date]
--	, *
	, [W].[WO#]
	, [W].[Serial Number] 
	, [D].[ID] AS [DealerID]
	, [C].[Date]
	, [D].[CURRENT DEALER]
	
	--,[W].*
	--,[D].*
	--, MIN(CASE WHEN [W].[dealerID] = [D].[ID] THEN [Claim Date] ELSE NULL END) AS [FirstClaim]
	--, MAX(CASE WHEN [W].[dealerID] = [D].[ID] THEN [Claim Date] ELSE NULL END) AS [LastClaim]
	--, MIN([Claim Date]) AS [FirstClaim]
	--, MAX([Claim Date]) AS [LastClaim]
	--, SUM(CASE WHEN [W].[dealerID] = [D].[ID] THEN 1 ELSE 0 END) AS [TtlClaims]
FROM
	[Calendar] AS [C]
CROSS JOIN
	[Dealers] AS [D]
LEFT JOIN
	[BWSdb].[dbo].[Warranty Claims] AS [W]
ON
	[C].[Date] = [W].[Claim Date]
	AND [D].[ID] = [W].[DealerID]
WHERE
	[D].[CURRENT DEALER] = 1
	--AND [W].[DealerID] IS NOT NULL
	AND
	[C].[Date] BETWEEN @minDate AND @dateIn
	--AND ISNULL([W].[DealerID], [D].[ID]) = [D].[ID]
	--AND [W].[DealerID] = [D].[ID]
	--AND [W].[Claim Date] IS NOT NULL
	
	--AND [D].[ID] = 1
	--AND	[C].[Date] = '2022-10-24'

GROUP BY
	[C].[Date]
	, [D].[ID]
	, [W].[WO#]
	, [W].[Serial Number]
	, FLOOR(ABS(DATEDIFF(DAY, @dateIn, [C].[Date])) / @periodLen)
	, [D].[CURRENT DEALER]
		
ORDER BY
	[DFQByPeriod]
	, [C].[Date]
	, [D].[ID]
	, [W].[WO#]
;




--SELECT
--	[DFQByPeriod]
--	, [DealerID]
--	, [WO#]
--	, [S/N]
--	, [S/N V2]
--	, [Serial Number]
--	, (CASE WHEN [TtlClaims] = 0 THEN NULL ELSE [FirstClaim] END) AS [FirstClaim]
--	, (CASE WHEN [TtlClaims] = 0 THEN NULL ELSE [LastClaim] END) AS [LastClaim]
--	--, [FirstClaim1]
--	--, [LastClaim1]
--	--, [TtlClaims]
--FROM (
--	SELECT
--		FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen) AS [DFQByPeriod]
--	--	,[D].[ID]
--	--	,[W].[DealerID]
--	--	, *
--		, [W].[WO#]
--		, [W].[S/N]
--		, [W].[S/N V2]
--		, [W].[Serial Number] 
--		, [D].[ID] AS [DealerID]
--		, [W].[Claim Date]
--		--, MIN(CASE WHEN [W].[dealerID] = [D].[ID] THEN [Claim Date] ELSE NULL END) AS [FirstClaim]
--		--, MAX(CASE WHEN [W].[dealerID] = [D].[ID] THEN [Claim Date] ELSE NULL END) AS [LastClaim]
--		--, MIN([Claim Date]) AS [FirstClaim]
--		--, MAX([Claim Date]) AS [LastClaim]
--		--, SUM(CASE WHEN [W].[dealerID] = [D].[ID] THEN 1 ELSE 0 END) AS [TtlClaims]
--	FROM
--		[BWSdb].[dbo].[Warranty Claims] AS [W]
--	CROSS JOIN
--		[Dealers] AS [D]
--	WHERE
--		--[D].[CURRENT DEALER] = 1
--		--AND [W].[DealerID] IS NOT NULL
--		--AND
--		[W].[Claim Date] BETWEEN @minDate AND @dateIn
--		AND ISNULL([W].[DealerID], [D].[ID]) = [D].[ID]
--	GROUP BY
--		[D].[ID]
--		, [W].[WO#]
--		, [W].[S/N]
--		, [W].[S/N V2]
--		, [W].[Serial Number]
--		, [W].[Claim Date]
--		, FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen)
--) AS [Src]
--ORDER BY
--	[DFQByPeriod]
--	, [DealerID]
--	, [WO#]
--;


----SELECT
----	FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen) AS [DFQByPeriod]
----	,[D].[ID]
----	,[W].[DealerID]
----	, *
------	[D].[ID]
------	, MIN([Claim Date]) AS [FirstClaim]
------	, MAX([Claim Date]) AS [LastClaim]
------	, COUNT([W].[ID]) AS [TtlClaims]
----FROM
----	[BWSdb].[dbo].[Warranty Claims] AS [W]
----CROSS JOIN
----	[Dealers] AS [D]
----WHERE
----	--[D].[CURRENT DEALER] = 1
----	--AND [W].[DealerID] IS NOT NULL
----	--AND
----	[W].[Claim Date] BETWEEN @minDate AND @dateIn
----	AND ISNULL([W].[DealerID], [D].[ID]) = [D].[ID]
------GROUP BY
------	[D].[ID]
------	,FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen)
----ORDER BY
----	[DFQByPeriod]
----	,[D].[ID]