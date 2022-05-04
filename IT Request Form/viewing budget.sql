USE BWSdb
GO

SELECT * FROM [IT Requests] WHERE [LabourEstimate] < [LabourActual] ORDER BY [RequestDate]
SELECT SUM([LabourActual]) AS [Labour Actual OverBud], SUM([LabourEstimate]) AS [Labour Estimate OverBud] FROM [IT Requests] WHERE [LabourEstimate] < [LabourActual]
SELECT SUM([LabourActual]) AS [Labour Actual], SUM([LabourEstimate]) AS [Labour Estimate] FROM [IT Requests]
SELECT * FROM [IT Requests] WHERE [Status] IN ('In Progress', 'Queued') ORDER BY [RequestDate]
SELECT * FROM [IT Requests] WHERE [Status] IN ('In Progress', 'Queued') AND ([RequestedBy] = 'Aver Briggs' OR [ITPersonAssignedID] = 4) ORDER BY [RequestDate]