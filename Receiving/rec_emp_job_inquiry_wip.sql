-- What job is _____ on now - today - when?
SELECT
	*
FROM 
	[SysproCompanyA].[dbo].[ClkTransaction]
WHERE
	(LOWER([EmployeeName]) LIKE '%scott%')
	AND ([LoggedOn] > '2025-06-19')


SELECT
	[InvWarehouse].[QtyAllocated],
	[InvWarehouse].[QtyAllocatedToPick],
	[InvWarehouse].[QtyAllocatedWip],
	[InvWarehouse].[QtyOnBackOrder],
	[InvWarehouse].[QtyOnHand],
	[InvWarehouse].[QtyOnOrder],
	[InvWarehouse].[QtyOnHand] - ([InvWarehouse].[QtyAllocated] + [InvWarehouse].[QtyAllocatedToPick] + [InvWarehouse].[QtyAllocatedWip]) AS [Available],
	*
FROM
	[SysproCompanyA].[dbo].[InvWarehouse]
LEFT JOIN
	[SysproCompanyA].[dbo].[InvMaster]
ON
	[InvWarehouse].[StockCode] = [InvMaster].[StockCode]
WHERE
	[InvWarehouse].[StockCode] = '08300'
ORDER BY
	[InvWarehouse].[Warehouse]


---------------------------------------------------

-- Sales Orders
SELECT
	*
FROM
	[SysproCompanyA].[dbo].[SorMaster]
WHERE
	[EntrySystemDate] >= '2025-06-01'


-- Purchase Orders
SELECT TOP 200
	*
FROM
	[SysproCompanyA].[dbo].[Por]
WHERE
	[] >= '2025-06-01'
;


SELECT TOP 200
	*
FROM
	[BWSdb].[dbo].[Orders]
ORDER BY
	[Order Date] DESC



SELECT
	*
FROM
	[BWSdb].[dbo].[hist_REC_Events]
