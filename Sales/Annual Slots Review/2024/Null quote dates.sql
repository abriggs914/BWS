USE BWSdb
GO


-- Quotes vs orders
SELECT
	*
FROM 
	[Orders]
WHERE
	[Quote Date] IS NULL

SELECT * FROM Reason ORDER BY Reason.ID, Reason.Reason; 


SELECT
	*
FROM 
	[Dealers]


DECLARE @
SELECT
	[O].[DealerID]
	, [D].[COMPANY NAME]
	, COUNT((CASE WHEN (([O].[Order Date] IS NOT NULL) AND ([O].[Decline/Rejected] = 4)) THEN 1 ELSE NULL END)) AS [NumOrderedQuotes]
	--, COUNT((CASE ISNULL([O].[Decline/Rejected], -1) WHEN 4 THEN 1 ELSE NULL END)) AS [NumOrderedQuotes]
	--, COUNT(ISNULL([O].[Decline/Rejected], -1) = 4) AS [NumOrderedQuotes]
	, COUNT(*) AS [NumTotalQuotes]
FROM 
	[Orders] AS [O] WITH (NOLOCK)
LEFT JOIN
	[Dealers] AS [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]
WHERE
	[D].[CURRENT DEALER] = 1
GROUP BY
	[O].[DealerID]
	, [D].[COMPANY NAME]
ORDER BY
	[D].[COMPANY NAME]


SELECT
	[D].[COMPANY NAME]
	, COUNT((CASE WHEN (([O].[Order Date] IS NOT NULL) AND ([O].[Decline/Rejected] = 4)) THEN 1 ELSE 0 END)) AS [NumOrderedQuotes]
FROM 
	[Orders] AS [O] WITH (NOLOCK)
LEFT JOIN
	[Dealers] AS [D] WITH (NOLOCK)
ON
	[O].[DealerID] = [D].[ID]