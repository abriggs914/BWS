USE SysproCompanyS
GO

DECLARE @sc AS NVARCHAR(MAX);
SET @sc = '.250 X 72 X 204'
SET @sc = '05703'

SELECT
	InvWarehouse.StockCode,
	InvWhAmendJnl.After AS [Current Bin Location],
	InvWhAmendJnl.Before AS [Prior Bin Location]
	,InvWhAmendJnl.*
FROM
	InvWhAmendJnl
INNER JOIN
	InvWarehouse
ON
	(InvWhAmendJnl.After=InvWarehouse.DefaultBin)
	AND (InvWhAmendJnl.Warehouse=InvWarehouse.Warehouse)
	AND (InvWhAmendJnl.StockCode=InvWarehouse.StockCode)

WHERE
	InvWarehouse.StockCode=@sc

GROUP BY
	InvWarehouse.StockCode,
	InvWhAmendJnl.After,
	InvWhAmendJnl.Before,
	InvWhAmendJnl.ColumnName
HAVING
	--(((InvWarehouse.StockCode)=Forms![Bin Location Lookup]!StockCode) 
	(((InvWarehouse.StockCode)=@sc) 
	And ((InvWhAmendJnl.ColumnName)='DefaultBin'));