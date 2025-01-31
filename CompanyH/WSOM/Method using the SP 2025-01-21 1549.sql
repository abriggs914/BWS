
-- Method using the SP 2025-01-21 1549


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
	, [WO] INT NULL
	, [QuoteDate] DATETIME NULL
	, [ProdDate] DATETIME NULL
);

DECLARE @i INT = 0;
DECLARE @j INT = 0;
DECLARE @k1 INT = -1;
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

		IF @comp = 'STG' BEGIN
			INSERT INTO @tSimQuotes ([Quote], [WO], [QuoteDate], [ProdDate])
			EXEC [BWSdb].[dbo].[sp_QuickRef_ListSimilarQuotesV2] @quote
		END
		ELSE BEGIN
			INSERT INTO @tSimQuotes ([Quote], [WO], [QuoteDate], [ProdDate])
			EXEC [BWSdb].[dbo].[sp_QuickRef_ListSimilarQuotes] @quote
		END

		SELECT
			@k1 = ISNULL(@k2, -1)
		;

		SELECT
			@k2 = MAX([ID])
		FROM 
			@tSimQuotes

		IF ISNULL(@k2, @k1) = @k1 BEGIN
			INSERT INTO @tSimQuotes ([BaseQuote], [Quote], [WO], [QuoteDate], [ProdDate])
			VALUES (@quote, NULL, NULL, NULL, NULL)
			SELECT
				@k2 = MAX([ID])
			FROM 
				@tSimQuotes 
		END
		ELSE BEGIN

			UPDATE
				@tSimQuotes
			SET
				[BaseQuote] = @quote
			WHERE 
				(ISNULL(@k1, -1) < [ID]) AND ([ID] <= ISNULL(@k2, 0))
			;
		END
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