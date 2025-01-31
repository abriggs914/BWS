
-- Method uses my attempted view method


DECLARE @sd DATETIME = '2025-01-22';
DECLARE @ed DATETIME = DATEADD(MONTH, 6, @sd);

DECLARE @results TABLE (
	[ID] INT IDENTITY(0, 1)
	, [Comp] NVARCHAR(3) NULL
	, [ProdDate] DATETIME NULL
	, [Quote] NVARCHAR(12) NULL
	, [WO] INT NULL
	, [Model No] NVARCHAR(255) NULL
	, [Width] INT NULL
	, [Spread] INT NULL
	, [SalesPerson] NVARCHAR(255) NULL
	, [Slot#] INT NULL
	, [WOReviewed] INT NULL
);

DECLARE @tQuotes TABLE (
	[ID] INT NULL
	, [Comp] NVARCHAR(3) NULL
	, [Quote] NVARCHAR(12) NULL
);

DECLARE @tSimQuotes TABLE (
	[ID] INT IDENTITY(0, 1)
	, [BaseQuote] NVARCHAR(12) NULL
	, [Quote] NVARCHAR(12) NULL
);

DECLARE @i INT = 0;
DECLARE @j INT = 0;
DECLARE @k1 INT = 0;
DECLARE @k2 INT = 0;
DECLARE @comp NVARCHAR(3);
DECLARE @quote NVARCHAR(12);
DECLARE @x INT = 0;

-- Gather all quotes to be reviewed at meeting
INSERT INTO @results
SELECT
	'BWS' AS [Comp],
	[Production].[Prod Date],
	[Orders].[Quote#],
	[Orders].[WO#],
	[Orders].[Model No],
	[Orders].[Width],
	[Orders].[Spread],
	[Sales Staff].[Sales Person],
	[Orders].[Slot#],
	[Orders].[WO Reviewed]
FROM (
	[BWSdb].[dbo].[Sales Staff] WITH (NOLOCK)
INNER JOIN 
	[BWSdb].[dbo].[Orders] WITH (NOLOCK)
ON
	[Sales Staff].[ID-SaleStaff] = [Orders].[Sale PersonID]
)
INNER JOIN
	[BWSdb].[dbo].[Production] WITH (NOLOCK)
ON 
	[Orders].[Quote#] = [Production].[Quote#]
WHERE
	([Production].[Prod Date] BETWEEN @sd AND @ed)
	AND ISNULL([Orders].[WO Reviewed], 0) = 0

UNION ALL

SELECT
	'STG' AS [Comp],
	[ProductionV2].[Prod Date],
	[OrdersV2].[SGQuote],
	[OrdersV2].[WO#],
	[OrdersV2].[Model No],
	[OrdersV2].[Width],
	[OrdersV2].[Spread],
	[Sales Staff].[Sales Person],
	[OrdersV2].[Slot#],
	[OrdersV2].[WO Reviewed]
FROM (
	[BWSdb].[dbo].[Sales Staff] WITH (NOLOCK)
INNER JOIN 
	[BWSdb].[dbo].[OrdersV2] WITH (NOLOCK)
ON
	[Sales Staff].[ID-SaleStaff] = [OrdersV2].[Sale PersonID]
)
INNER JOIN
	[BWSdb].[dbo].[ProductionV2] WITH (NOLOCK)
ON 
	[OrdersV2].[SGQuote] = [ProductionV2].[SGQuote]
WHERE
	([ProductionV2].[Prod Date] BETWEEN @sd AND @ed)
	AND ISNULL([OrdersV2].[WO Reviewed], 0) = 0
ORDER BY
	[Orders].[Model No]
	,[Production].[Prod Date]
	,[Orders].[Quote#]
;

-- Copy the list as a temp list
INSERT INTO @tQuotes ([ID], [Comp], [Quote])
SELECT
	[R].[ID]
	, [R].[Comp]
	, [R].[Quote]
FROM
	@results [R]
;

-- Calculate the number of quotes to be looked at
SELECT @j = COUNT(*) FROM @tQuotes;

SELECT
	'About to search' AS [X]
	, @j AS [TotalQuotes]
;

-- Loop known quotes, finding any like-quotes, recording the result
-- and removing the like-quotes from the list of yet-to-check
WHILE @i < @j BEGIN
	SELECT
		@quote = [TQ].[Quote]
		, @comp = [TQ].[Comp]
	FROM 
		@tQuotes [TQ]
	WHERE
		[TQ].[ID] = @i
	;

	/*
	DELETE FROM @tSimQuotes
	WHERE 1 = 1
	;
	*/

	IF NOT EXISTS(
		SELECT
			[Quote]
		FROM
			@tSimQuotes
		WHERE
			[Quote] = @quote
	) BEGIN

		SELECT @x = 1;
		
		SELECT
			@k1 = MAX([ID])
		FROM 
			@tSimQuotes
		;

		IF @comp = 'STG' BEGIN
			INSERT INTO @tSimQuotes ([Quote])
			EXEC [BWSdb].[dbo].[sp_QuickRef_ListSimilarQuotesV2] @quote
		END
		ELSE BEGIN
			INSERT INTO @tSimQuotes ([Quote])
			--EXEC [BWSdb].[dbo].[sp_QuickRef_ListSimilarQuotes] @quote
			SELECT
				[Quote#]
			FROM (
	
				SELECT		
					[O1].[Quote#]
					, [O1].[Order Date]
					, [O1].[WO#]
					, [O1].[Model No]
					, [Os2].[Group]
					, [Os2].[Section]
					, [Os2].[Description] AS [OStanDesc]
					, [Op2].[Option No]
					, [Op2].[Description] AS [OOptnDesc]
					, [Cw2].[Description] AS [CWorkDesc]
				FROM
					[BWSdb].[dbo].[Orders] [O1] WITH (NOLOCK)
				CROSS JOIN (
					SELECT
						*
					FROM
						[BWSdb].[dbo].[Orders] WITH (NOLOCK)
					WHERE
						[Quote#] = @quote
				) AS [O2]
	
				-- Add [Order Standards]
				CROSS JOIN (
					SELECT
						*
					FROM
						[BWSdb].[dbo].[Order Standards] WITH (NOLOCK)
					WHERE
						[Quote#] = @quote
				) AS [Os1]
			
				-- Add [Order Options]
				CROSS JOIN (
					SELECT
						*
					FROM
						[BWSdb].[dbo].[Order Options] WITH (NOLOCK)
					WHERE
						[Quote#] = @quote
				) AS [Op1]

				-- Add [Custom Work]
				CROSS JOIN (
					SELECT
						*
					FROM
						[BWSdb].[dbo].[Custom Work] WITH (NOLOCK)
					WHERE
						[Quote#] = @quote
				) AS [Cw1]
				LEFT JOIN
					[BWSdb].[dbo].[Order Standards] [Os2] WITH (NOLOCK)
				ON
					[O1].[Quote#] = [Os2].[Quote#]
				LEFT JOIN
					[BWSdb].[dbo].[Order Options] [Op2] WITH (NOLOCK)
				ON
					[O1].[Quote#] = [Op2].[Quote#]
				LEFT JOIN
					[BWSdb].[dbo].[Custom Work] [Cw2] WITH (NOLOCK)
				ON
					[O1].[Quote#] = [Cw2].[Quote#]
				WHERE
					-- Non-cancelled unit
					([O1].[Date Declined] IS NULL)
					AND (
						-- Matching [Orders].[ProductID], [Orders].[Width], and [Orders].[Spread]
						([O1].[ProductID] = [O2].[ProductID])
						AND ([O1].[Width] = [O2].[Width])
						AND ([O1].[Spread] = [O2].[Spread])
					)
					AND (
						-- Matching [Order Standards].[Group], [Order Standards].[Section], and [Order Standards].[Description]
						([Os1].[Group] = [Os2].[Group])
						AND ([Os1].[Section] = [Os2].[Section])
						AND ([Os1].[Description] = [Os2].[Description])
					)
					AND (
						-- Matching [Order Options].[Sections] and [Order Options].[Description]
						([Op1].[Sections] = [Op2].[Sections])
						AND ([Op1].[Description] = [Op2].[Description])
						AND ([Op1].[Qty] = [Op2].[Qty])
					)
					AND (
						-- Matching [Custom Work].[Description]
						--[Cw1].[Section] = [Cw2].[Section]
						--AND 
						[Cw1].[Description] = [Cw2].[Description]
					)
				GROUP BY
					[O1].[Quote#]
					, [O1].[Order Date]
					, [O1].[WO#]
					, [O1].[Model No]
					, [Os2].[Group]
					, [Os2].[Section]
					, [Os2].[Description]
					, [Op2].[Option No]
					, [Op2].[Description]
					, [Cw2].[Description]
	
			) [Src]
			INNER JOIN
				@results [Res]
			ON
				CAST([Src].[Quote#] AS NVARCHAR(12)) = [Res].[Quote]
			WHERE
				([Quote#] <> @quote)
			GROUP BY
				[Quote#]
			ORDER BY
				[Quote#] DESC


		END

		SELECT
			@k1 = @k2
		;

		SELECT
			@k2 = MAX([ID])
		FROM 
			@tSimQuotes

		UPDATE
			@tSimQuotes
		SET
			[BaseQuote] = @quote
		WHERE 
			(@k1 <= [ID]) AND ([ID] <= @k2)
		;
	END
	ELSE BEGIN
	
		SELECT @x = 2;

	END

	SELECT
		@quote AS [Q]
		, @comp AS [C]
		, @i AS [I]
		, @k1 AS [k1]
		, @k2 AS [k2]
		, @x AS [x]

	SELECT @i = @i + 1;
END

SELECT
	'@results' AS [T]
	, *
FROM
	@results
;

SELECT
	'@tSimQuotes' AS [T]
	, *
FROM
	@tSimQuotes
;