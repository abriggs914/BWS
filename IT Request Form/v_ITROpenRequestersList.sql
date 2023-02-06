USE BWSdb
GO

ALTER VIEW [v_ITROpenRequestersList]
AS

	SELECT 
		[RequestedBy]
		, MAX([RowIdx1]) AS [NumRequests]
		, MAX([RowIdx2]) AS [RequesterNumber]
	FROM (
		SELECT DISTINCT
			[RequestedBy]
			, COUNT([RequestedBy]) AS [RowIdx1]
			, ROW_NUMBER() OVER (
				ORDER BY
					[RequestedBy]
			) AS [RowIdx2]
		FROM 
			[IT Requests]
		WHERE
			[Status] IN ('In Progress', 'Waiting')
			AND [StartDate] IS NOT NULL
		GROUP BY
			[RequestedBy]
	) AS [SubA]
		GROUP BY
			[RequestedBy]
	;
