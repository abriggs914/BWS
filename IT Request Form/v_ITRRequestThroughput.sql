USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ITRRequestThroughput]    Script Date: 2022-06-29 1:20:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[v_ITRRequestThroughput] AS
SELECT
	[Total Requests]
	, [Total Left Open]
	, 1 - ([Total Left Open] / ([Total Requests] + 0.0)) AS [Throughput]
FROM (
	SELECT
		SUM([CountOf Requests]) AS [Total Requests]
		, MAX([v_ITRequestsPerMonthTotals].[Sum Left Open Requests]) AS [Total Left Open]
	FROM
		[v_ITRequestsPerMonthTotals]
) AS [SrcA]
GO


