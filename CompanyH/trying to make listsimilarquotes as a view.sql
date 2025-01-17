
-- trying to make listsimilarquotes as a view

DECLARE @sd DATETIME = '2016-01-01'

SELECT		
	[O1].[Quote#]
	, [O1].[Order Date]
	, [O1].[WO#]
	, [O1].[Model No]
	
	, [Os].[Group]
	, [Os].[Section]
	, [Os].[Description] AS [OStanDesc]
	/*
	, [Op2].[Option No]
	, [Op2].[Description] AS [OOptnDesc]
	, [Cw2].[Description] AS [CWorkDesc]
	*/
FROM
	[BWSdb].[dbo].[Orders] [O1] WITH (NOLOCK)
INNER JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Orders] WITH (NOLOCK)
	WHERE
		[Orders].[Order Date] BETWEEN @sd AND GETDATE() 
) AS [O2]
ON
	([O1].[ProductID] = [O2].[ProductID])
	AND ([O1].[Width] = [O2].[Width])
	AND ([O1].[Spread] = [O2].[Spread])
INNER JOIN
	[BWSdb].[dbo].[Order Standards] [OS] WITH (NOLOCK)
ON
	([O1].[Quote#] = [OS].[Quote#]) OR ([O2].[Quote#] = [OS].[Quote#])
WHERE
	[O1].[Order Date] BETWEEN @sd AND GETDATE() 
/*
-- Add [Order Standards]
CROSS JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Order Standards] WITH (NOLOCK)
) AS [Os1]
			
-- Add [Order Options]
INNER JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Order Options] WITH (NOLOCK)
) AS [Op1]
ON
	[O1].[Quote#] = [Op1].[Quote#]

-- Add [Custom Work]
INNER JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[Custom Work] WITH (NOLOCK)
) AS [Cw1]
ON
	[O1].[Quote#] = [Cw1].[Quote#]
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
	*/
GROUP BY
	[O1].[Quote#]
	, [O1].[Order Date]
	, [O1].[WO#]
	, [O1].[Model No]
	
	, [Os].[Group]
	, [Os].[Section]
	, [Os].[Description]
	/*
	, [Op2].[Option No]
	, [Op2].[Description]
	, [Cw2].[Description]
	*/

SELECT
	*
FROM
	[BWSdb].[dbo].[Order Standards] [OS1] WITH (NOLOCK)
INNER JOIN
	[BWSdb].[dbo].[Order Standards] [OS2] WITH (NOLOCK)
ON
	([Os1].[Group] = [Os2].[Group])
	AND ([Os1].[Model No] = [Os2].[Model No])
	AND ([Os1].[Section] = [Os2].[Section])
	AND ([Os1].[Description] = [Os2].[Description])


SELECT
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]
	, COUNT(*) AS [N]
FROM
	[BWSdb].[dbo].[Order Standards] [OS1] WITH (NOLOCK)
GROUP BY
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]

SELECT
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]
	, COALESCE([OS1].[Quote#], ';') AS [ListQuotes]
FROM
	[BWSdb].[dbo].[Order Standards] [OS1] WITH (NOLOCK)
GROUP BY
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]

SELECT
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]
	, CONCAT_WS(';', [OS1].[Quote#]) AS [ListQuotes]
FROM
	[BWSdb].[dbo].[Order Standards] [OS1] WITH (NOLOCK)
GROUP BY
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]

SELECT
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]
FROM
	[BWSdb].[dbo].[Order Standards] [OS1] WITH (NOLOCK)
GROUP BY
	[OS1].[Model No]
	, [Os1].[Group]
	, [Os1].[Section]
	, [Os1].[Description]
FOR XML AUTO