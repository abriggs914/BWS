
-- List similar quotes


DECLARE @quote INT = 31009;
SELECT @quote = 30897;


DECLARE @simQs TABLE ([ID] INT IDENTITY(0, 1), [Quote] INT);

INSERT INTO @simQs ([Quote])
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
	WHERE
		[Quote#] <> @quote
	GROUP BY
		[Quote#]
	ORDER BY
		[Quote#] DESC

SELECT
	*
FROM
	@simQs
;

-- Just checking the other tables

SELECT '[O]' AS [T], * FROM [BWSdb].[dbo].[Orders] [O] WHERE [O].[Quote#] = @quote ORDER BY [O].[Quote#];
SELECT '[OS]' AS [T], * FROM [BWSdb].[dbo].[Order Standards] [OS] WHERE [OS].[Quote#] = @quote ORDER BY [OS].[Quote#];
SELECT '[OO]' AS [T], * FROM [BWSdb].[dbo].[Order Options] [OO] WHERE [OO].[Quote#] = @quote ORDER BY [OO].[Quote#];
SELECT '[CW]' AS [T], * FROM [BWSdb].[dbo].[Custom Work] [CW] WHERE [CW].[Quote#] = @quote ORDER BY [CW].[Quote#];

SELECT '[O]' AS [T], * FROM [BWSdb].[dbo].[Orders] [O] INNER JOIN	@simQs [sQ] ON [O].[Quote#] = [sQ].[Quote] ORDER BY [sQ].[Quote];
SELECT '[OS]' AS [T], * FROM [BWSdb].[dbo].[Order Standards] [OS] INNER JOIN @simQs [sQ] ON [OS].[Quote#] = [sQ].[Quote] ORDER BY [sQ].[Quote];
SELECT '[OO]' AS [T], * FROM [BWSdb].[dbo].[Order Options] [OO] INNER JOIN	@simQs [sQ] ON [OO].[Quote#] = [sQ].[Quote] ORDER BY [sQ].[Quote];
SELECT '[CW]' AS [T], * FROM [BWSdb].[dbo].[Custom Work] [CW] INNER JOIN @simQs [sQ] ON [CW].[Quote#] = [sQ].[Quote] ORDER BY [sQ].[Quote];