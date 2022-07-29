USE SysproCompanyA
GO

-- update all default bins from "SCANDIA" -> "SCAND" to ensure less than 6 chars.

BEGIN TRAN

SELECT
	* 
FROM
	[InvWarehouse]
WHERE
	[DefaultBin] LIKE '%SCAND%'

UPDATE
	[InvWarehouse]
SET
	[InvWarehouse].[DefaultBin] = 'SCAND'
WHERE
	[DefaultBin] LIKE '%SCANDIA%'

SELECT
	[InvMaster].[StockCode]
	,[InvMaster].[Description]
	,[InvMaster].[LongDesc]
	,[DefaultBin]
FROM 
	[InvWarehouse]
LEFT JOIN
	[InvMaster]
ON
	[InvWarehouse].[StockCode] = [InvMaster].[StockCode]
WHERE
	[DefaultBin] LIKE '%SCAND%'

ROLLBACK
COMMIT

--USE SysproCompanyS
--GO

--SELECT
--	* 
--FROM 
--	[InvMaster]
--LEFT JOIN
--	[InvWarehouse]
--ON
--	[InvMaster].[StockCode] = [InvWarehouse].[StockCode]
--WHERE
--	[DefaultBin] LIKE '%SCANDIA%'