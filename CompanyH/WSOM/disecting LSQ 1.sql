/*
-- ~ 9M rows in 36s
SELECT
	[S_O1].[ProductID]
	, [S_O1].[Quote#] AS [Parent]
	, [S_O2].[Quote#] AS [SimTo]
FROM (
	SELECT
		[O1].[Quote#]
		,[O1].[ProductID]
	FROM
		[BWSdb].[dbo].[Orders] [O1]
) AS [S_O1]
INNER JOIN (
	SELECT
		[O2].[Quote#]
		,[O2].[ProductID]
	FROM
		[BWSdb].[dbo].[Orders] [O2]
) AS [S_O2]
ON
	([S_O1].[Quote#] <> [S_O2].[Quote#])
	AND ([S_O1].[ProductID] = [S_O2].[ProductID])
*/

DECLARE @q INT = 31137;
--SELECT @q = 30577;
SELECT
	*
FROM
	[BWSdb].[dbo].[Custom Work] [C] WITH (NOLOCK)
WHERE
	[Quote#] = @q
SELECT
	*
FROM
	[BWSdb].[dbo].[Custom Work_SpecLines] [S] WITH (NOLOCK)
WHERE
	[Quote#] = @q

	
SELECT
	*
FROM
	[BWSdb].[dbo].[Custom Work] [C] WITH (NOLOCK)
LEFT JOIN
	[BWSdb].[dbo].[Custom Work_SpecLines] [S] WITH (NOLOCK)
ON
	[C].[ID] = [S].[NPOID]
WHERE
	[C].[Quote#] = @q


DECLARE @t TABLE (
	[ID] INT IDENTITY(0, 1),
	[Quote] INT,
	[ProductID] INT,
	[Section] NVARCHAR(MAX),
	[Group] NVARCHAR(MAX),
	[Description] NVARCHAR(MAX),
	[Qty] INT
)
INSERT INTO @t VALUES
(31137, 2173, NULL, NULL, 'None', 1),
(31137, 2173, 'Flip Axle/Booster Ready', 'GENERAL SPECIFICATIONS', 'Remove Flip axle Ready', 1),
(31137, 2173, 'Axles', 'SUSPENSION/AXLES', 'Complete with fixed 4th axle', 1),
(31137, 2173, 'Suspension', 'SUSPENSION/AXLES', 'Complete with fixed 4th axle', 1),
(31137, 2173, 'Overall Length', 'TRAILER', 'Complete with fixed 4th axle', 1),
(31137, 2173, 'Axles', 'SUSPENSION/AXLES', 'Air Lift c/w Control Box', 1),
(31137, 2173, 'Spread', 'SUSPENSION/AXLES', '49 in. spread', 1),
(31137, 2173, 'NULL', 'NULL', 'Rmove rear bridge to bolster line', 1)
;

DECLARE @i INT = 0;
SELECT [Q].[Quote], [Q].[ProductID], [SL].[SpecSection], [SL].[SpecGroup], [C].[Description], [C].[Qty]
FROM [BWSdb].[dbo].[Custom Work] [C] WITH (NOLOCK)
LEFT JOIN [BWSdb].[dbo].[Custom Work_SpecLines] [SL] WITH (NOLOCK)
ON [C].[ID] = [SL].[NPOID]
INNER JOIN (
	SELECT
		0 AS [ID]
		, 2173 AS [ProductID]
		, 31137 AS [Quote]
) AS [Q]
ON [C].[Quote#] = [Q].[Quote]
WHERE [Q].[ID] = @i;


----------------------------

		SELECT -- [C1].[ProductID], [C1].[Quote], [C2].[Quote#]
			*
		FROM (
			SELECT * FROM @t
) AS [C1]
		INNER JOIN [BWSdb].[dbo].[Custom Work] [C2] WITH (NOLOCK)
		ON 
			([C1].[Quote] <> [C2].[Quote#])
			AND ([C1].[Description] = [C2].[Description])
			AND ([C1].[Qty] = [C2].[Qty])
		INNER JOIN [BWSdb].[dbo].[Custom Work_SpecLines] [CL] WITH (NOLOCK)
		ON 
			([C2].[ID] = [CL].[NPOID])
			AND ([C1].[Section] = [CL].[SpecSection])
			AND ([C1].[Group] = [CL].[SpecGroup])
			AND ([C1].[Description] = [CL].[Description])
		/*
		GROUP BY 
			[C1].[ProductID]
			,[C1].[Quote]
			,[C2].[Quote#]
		*/

----------------------------


		SELECT
			*
		FROM (
			SELECT * FROM @t
) AS [C1]
		INNER JOIN [BWSdb].[dbo].[Custom Work] [C2] WITH (NOLOCK)
		ON 
			([C1].[Quote] <> [C2].[Quote#])
			AND ([C1].[Description] = [C2].[Description])
			AND ([C1].[Qty] = [C2].[Qty])
		INNER JOIN [BWSdb].[dbo].[Custom Work_SpecLines] [CL] WITH (NOLOCK)
		ON 
			--([C2].[ID] = [CL].[NPOID])
			--AND 
			([C1].[Section] = [CL].[SpecSection])
			AND ([C1].[Group] = [CL].[SpecGroup])
			AND ([C1].[Description] = [CL].[Description])