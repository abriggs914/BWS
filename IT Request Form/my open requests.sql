-- My open requests

USE BWSdb

GO

SELECT DISTINCT
	[RequestedBy] 
FROM 
	[IT Requests]
WHERE
	[Status] IN ('In Progress', 'Waiting')
	AND [StartDate] IS NOT NULL
;

SELECT
	[ITRequestID#]
	, [RequestedBy]
	, [RequestDateOriginal]
	, [DueDate]
	, [Request]
	, [Priority]
	, [SubPriority]
	, [Dept].[Dept]
	, [RequestType]
	, [RequestSubType]
	, [IT Requests].[Company]
	, [Status]
	, [Name]
	, [LabourEstimate]
	, [LabourActual]
FROM 
	[IT Requests]
LEFT JOIN
	[IT Personnel]
ON
	[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
LEFT JOIN
	[Dept]
ON
	[IT Requests].[Department] = [Dept].[DeptID]
WHERE
	[Status] IN ('In Progress', 'Waiting')
	AND [StartDate] IS NOT NULL
ORDER BY
	[RequestedBy]
	, [ITRequestID#]
;