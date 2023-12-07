USE BWSdb
GO

--SELECT
--	*
--FROM
--	[Orders]
--WHERE
--	[DateLastQuoteReport] IS NOT NULL

--SELECT
--	*
--FROM
--	[OrdersV2]
--WHERE
--	[DateLastQuoteReport] IS NOT NULL

SELECT * FROM [ITI Inventory] WHERE [HardwareType] = 'Laptop'

SELECT * FROM [v_SFC_BWSUnionSTGLabour]

SELECT
	[Operation],
	[IMachine],
	[IExpUnitRunTim],
	[IExpSetUpTime],
	[IExpStartupTime],
	[IExpShutdownTim],
	[IWaitTime],
	[ICapacityReqd],
	[IMaxWorkOpertrs],
	[IMaxProdUnits],
	[ITimeTaken],
	[IQuantity],
	[IExpUnitRunTimEnt],
	[UnitValueReqd],
	[RunTimeIssued],
	[SetUpIssued],
	[ShutdownIssued],
	[ValueIssued],
	[PiecesCompleted],
	[ValueBilled],
	[OperCompleted],
	[QtyCompleted],
	[QtyScrapped],
	[LastScrapReason],
	[PlannedQueueDate],
	[PlannedStartDate],
	[PlannedEndDate],
	[ActualQueueDate],
	[ActualStartDate],
	[ActualFinishDate],
	[WorkCentre],
	[WorkCentreDesc],
	[ElapsedTime],
	[MovementTime],
	[UnitNumOfPieces],
	[InspectionFlag],
	[CapacityIssued],
	[ParentQtyPlanned],
	[ParentQtyPlanEnt]
FROM
	[v_SFC_BWSUnionSTGLabour]


SELECT * FROM [v_SFC_BWSUnionSTGProducts]

SELECT * FROM [v_SFC_BWSUnionSTGOrders] WHERE [Orders_Quote]  = '27941' -- YEAR([Orders_DateQuote]) = 2023

EXEC [SysproCompanyA].[dbo].[sp_WO Performance Snapshot Ops 4 5] @WO='10016151'

SELECT
	[M].[Job],
	[L].[Job],
	*
FROM
	[SysproCompanyA].[dbo].[WipMaster] AS [M]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobAllLab] AS [L]
ON
	[M].[Job] = [L].[Job]
ORDER BY
	[M].[Job]