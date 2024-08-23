USE BWSdb
GO


ALTER VIEW [dbo].[v_ITRRequestThroughputIndividual]
AS


SELECT
	*,
	ROW_NUMBER() OVER(
		ORDER BY
			[Open] + [Closed] DESC,
			LEN([Thru]) DESC,
			[Thru] DESC, 
			[isITPerson] DESC,
			[Name]
	) AS [RowN]
FROM (

	SELECT
		[ITR Customers].[Name],
		MIN([IT Requests].[ITRequestID#]) AS [FirstRequestID],
		MAX([IT Requests].[ITRequestID#]) AS [LastRequestID],
		(CASE WHEN ISNULL([IT Personnel].[ITPersonID#], -1) >= 0 THEN 'Y' ELSE 'N' END) AS [IsITPerson],
		(CASE WHEN ISNULL([IT Personnel].[Active], 0) = 1 THEN 'Y' ELSE 'N' END) AS [StillWorksInIT],
		(CASE WHEN ISNULL([ITR Customers].[Active], 0) = 1 THEN 'Y' ELSE 'N' END) AS [StillWorksHere],
		COUNT([IT Requests].[RequestedBy]) AS [Number],
		SUM((CASE WHEN [Status] NOT IN ('Complete', 'Declined', 'Incomplete') THEN 1 ELSE 0 END)) AS [Open],
		SUM((CASE WHEN [Status] IN ('Complete', 'Declined', 'Incomplete') THEN 1 ELSE 0 END)) AS [Closed],
		CAST(ROUND(100 * SUM((CASE WHEN [Status] IN ('Complete', 'Declined', 'Incomplete') THEN 1 ELSE 0 END)) / COUNT(*), 2) AS NVARCHAR(MAX)) + ' %' AS [Thru]
	FROM
		[ITR Customers]
	LEFT JOIN
		[IT Personnel]
	ON
		[IT Personnel].[ITRCustomerID] = [ITR Customers].[CustomerID]
	LEFT JOIN
		[IT Requests]
	ON
		[IT Requests].[RequestedBy] = [ITR Customers].[Name]
	GROUP BY
		[RequestedBy]
		, [ITPersonID#]
		, [ITR Customers].[Name]
		, [IT Personnel].[Active]
		, [ITR Customers].[Active]

) AS [Src]
/*
ORDER BY
	[Open] + [Closed] DESC,
	LEN([Thru]) DESC,
	[Thru] DESC, 
	[isITPerson] DESC,
	[Name]
*/

GO