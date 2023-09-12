USE BWSdb
GO

CREATE VIEW [v_ITI_ValidLocations] AS
SELECT [ITI Locations].[ID], [ITI Locations].[Description], [ITI Locations].FloorNumber, [ITI Locations].Name AS Location, [ITI Buildings].Name AS Building, [ITR Customers].Name AS Employee
FROM ([ITI Locations] INNER JOIN [ITI Buildings] ON [ITI Locations].BuildingID = [ITI Buildings].ID) INNER JOIN [ITR Customers] ON [ITI Locations].EmployeeAssigned = [ITR Customers].CustomerID
WHERE ((([ITI Locations].Active)=1))
--ORDER BY [ITI Locations].Description
;