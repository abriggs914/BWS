USE BWSdb
GO


CREATE PROCEDURE [sp_DSD_WarrantyClaimsByDealer] 
--DECLARE
	@dateIn DATETIME=NULL,
	@dealerID INT=NULL,
	@mode NVARCHAR(MAX)=-1,
	@maxYearsBack INT=NULL
AS BEGIN

DECLARE
	@dateMonth AS INTEGER
	, @dateYear AS INTEGER
	, @minDate AS DATETIME
	, @periodLen AS DECIMAL(18, 8)
;

--SELECT
--	@dateIn = GETDATE(),
--	@mode = 1
--;

	-- mode -- DONT USE 0 (zero)
	-- Default	- annual
	-- 2		- quarterly
	-- 3		- monthly
	-- 4		- weekly

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


	IF @mode < 0 BEGIN
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
				AND (CASE WHEN @dealerID IS NULL THEN 1 ELSE 
				(CASE WHEN @dealerID = [D].[ID] THEN 1 ELSE 0 END)
				END) = 1
			GROUP BY
				[D].[ID]
				,FLOOR(ABS(DATEDIFF(DAY, @dateIn, [Claim Date])) / @periodLen)
		) AS [Src]
		ORDER BY
			[DFQByPeriod]
			,[DealerID]
		;
	END
	ELSE BEGIN
		
		SELECT
			FLOOR(ABS(DATEDIFF(DAY, @dateIn, [C].[Date])) / @periodLen) AS [DFQByPeriod]
			, [W].[WO#]
			, [W].[Serial Number] 
			, [D].[ID] AS [DealerID]
			, [C].[Date]
			, [D].[CURRENT DEALER]
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
			AND
			[C].[Date] BETWEEN @minDate AND @dateIn
			AND (CASE WHEN @dealerID IS NULL THEN 1 ELSE 
			(CASE WHEN @dealerID = [D].[ID] THEN 1 ELSE 0 END)
			END) = 1

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


	END
END
