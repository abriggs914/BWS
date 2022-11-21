USE BWSdb
GO


SELECT
	[ITI Locations].[Name] AS [LocationName]
	, [ITI Locations].[Description]
	, [ITI Buildings].[Name]
	, [ITI Locations].[FloorNumber]
	, [ITR Customers].[Name] AS [EmployeeAssigned]
	, [Dept].[Dept]
FROM
	[ITI Locations]
LEFT JOIN
	[ITR Customers]
ON
	[ITI Locations].[EmployeeAssigned] = [ITR Customers].[CustomerID]
LEFT JOIN
	[ITI Buildings]
ON
	[ITI Locations].[BuildingID] = [ITI Buildings].[ID]
LEFT JOIN
	[Dept]
ON
	[ITR Customers].[Department] = [Dept].[DeptID]
