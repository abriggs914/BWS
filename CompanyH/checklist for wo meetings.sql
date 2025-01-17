USE BWSdb
GO

SELECT Production.[Prod Date], Orders.[SGQuote], Orders.[wo#], Orders.[model no], Orders.width, Orders.spread, [Sales Staff].[Sales Person], Orders.[slot#], Orders.[WO Reviewed]
FROM (
	[OrdersV2] AS [Orders]
INNER JOIN
	[ProductionV2] AS [Production]
ON
	Orders.[SGQuote] = Production.[SGQuote])
LEFT JOIN
	[Sales Staff]
ON Orders.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
WHERE (((Production.[Prod Date]) Between '1/14/2025 14:7:32' And '7/14/2025 14:7:32') 
	AND
	(CASE WHEN ISNULL([Orders].[WO Reviewed], 0) = 0 THEN 1 ELSE 0 END) = 1);
	--((Nz([Orders].[WO Reviewed],False))=False));
