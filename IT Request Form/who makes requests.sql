--SELECT[RequestedBy[ FROM (SELECT DISTINCT ITRequests.RequestedBy
--FROM ITRequests LEFT JOIN [ITR Personnel] ON ITRequests.RequestedBy = [ITR Personnel].Name) AS [Src]
--ORDER BY IIF([Name] IS NULL, 0, 1), [ITRequests].[RequestedBy];

USE BWSdb
GO

SELECT
	[RequestedBy]
FROM (
	SELECT DISTINCT
		[IT Requests].[RequestedBy],
		[Name]
	FROM
		[IT Requests]
	LEFT JOIN
		[IT Personnel]
	ON
		[IT Requests].[RequestedBy] = [IT Personnel].[Name]
	) AS [Src]
ORDER BY
	(CASE WHEN [Name] IS NOT NULL THEN 0 ELSE 1 END),
	RequestedBy
--	IIF([Name] IS NULL, 0, 1), [ITRequests].[RequestedBy];