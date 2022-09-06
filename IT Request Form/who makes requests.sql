--SELECT[RequestedBy[ FROM (SELECT DISTINCT ITRequests.RequestedBy
--FROM ITRequests LEFT JOIN [ITR Personnel] ON ITRequests.RequestedBy = [ITR Personnel].Name) AS [Src]
--ORDER BY IIF([Name] IS NULL, 0, 1), [ITRequests].[RequestedBy];

USE BWSdb
GO

SELECT
	*
FROM (
	SELECT
		[IT Requests].[RequestedBy],
		[Name],
		COUNT(*) AS [Number],
		SUM((CASE WHEN [Status] NOT IN ('Complete', 'Declined', 'Incomplete') THEN 1 ELSE 0 END)) AS [Open],
		SUM((CASE WHEN [Status] IN ('Complete', 'Declined', 'Incomplete') THEN 1 ELSE 0 END)) AS [Closed],
		CAST(ROUND(100 * SUM((CASE WHEN [Status] IN ('Complete', 'Declined', 'Incomplete') THEN 1 ELSE 0 END)) / COUNT(*), 2) AS NVARCHAR(MAX)) + ' %' AS [Thru]
	FROM
		[IT Requests]
	LEFT JOIN
		[IT Personnel]
	ON
		[IT Requests].[RequestedBy] = [IT Personnel].[Name]
	GROUP BY
		[RequestedBy]
		, [Name]
	) AS [Src]
ORDER BY
	(CASE WHEN [Name] IS NOT NULL THEN 0 ELSE 1 END),
	RequestedBy
--	IIF([Name] IS NULL, 0, 1), [ITRequests].[RequestedBy];