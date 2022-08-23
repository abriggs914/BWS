USE BWSdb	
GO

SELECT
	* 
FROM
	[ITR Settings]
INNER JOIN
	[ITR Customers] 
ON
	[ITR Settings].[ITRCustomerID] = [ITR Customers].[CustomerID]
INNER JOIN
	[ITR ColourSchemes]
ON
	[ITR Settings].[Theme] = [ITR ColourSchemes].[ID]

--SELECT * WHERE