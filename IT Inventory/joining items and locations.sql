SELECT 
	*
FROM
	[ITR Customers]
LEFT JOIN
	[ITI Locations]
ON
	[ITR Customers].[CustomerID] = [ITI Locations].[ID]
LEFT JOIN
	[ITI Buildings]
ON
	[ITI Locations].[BuildingID] = [ITI Buildings].[ID]