USE SysproCompanyA
GO

-- [WipMaster]
-- [WipLabJnl]
-- [WipJobAllMat]
-- [WipLabJnl]
-- [WipAllMatLot]

-- SELECT * FROM WipJobAllLab;

DECLARE @JOB AS VARCHAR(20);
SET @JOB = '10014747'

/*
[Operation],
[UnitValueRequired],
[ValueIssued],
[RunTimeIssued],
[IExpUnitRunTime],
[ICapacityReqd],
[CapacityIssued]

	[Operation],
	[UnitValueReqd],
	[ValueIssued],
	[RunTimeIssued],
	[IExpUnitRunTim],
	[ICapacityReqd],
	[CapacityIssued]
*/
SELECT *
FROM
	[WipJobAllLab]
WHERE
	[Job] LIKE @JOB
ORDER BY
	[Job],
	[Operation]

------------------
Group BY
	[Job],
	[WipJobAllLab].[Operation],
	[WipJobAllLab].[SubcontractOp],
	[WipJobAllLab].[IMachine],
	[WipJobAllLab].[IExpUnitRunTim],
	[WipJobAllLab].[IExpSetUpTime],
	[WipJobAllLab].[IExpStartupTime],
	[WipJobAllLab].[IExpShutdownTim],
	[WipJobAllLab].[IWaitTime],
	[WipJobAllLab].[IWcRateInd],
	[WipJobAllLab].[IStartupQty],
	[WipJobAllLab].[ICapacityReqd],
	[WipJobAllLab].[IMaxWorkOpertrs],
	[WipJobAllLab].[IMaxProdUnits],
	[WipJobAllLab].[ITimeTaken],
	[WipJobAllLab].[IQuantity],
	[WipJobAllLab].[MaxOpSpan],
	[WipJobAllLab].[OpSlack],
	[WipJobAllLab].[IStartupQtyEnt],
	[WipJobAllLab].[IQuantityEnt],
	[WipJobAllLab].[IExpUnitRunTimEnt],
	[WipJobAllLab].[ITimeTakenEnt],
	[WipJobAllLab].[SubSupplier],
	[WipJobAllLab].[SupPoStkCode],
	[WipJobAllLab].[SubQtyPer],
	[WipJobAllLab].[SubOrderUom],
	[WipJobAllLab].[SubUnitValue],
	[WipJobAllLab].[SubWhatIfValue],
	[WipJobAllLab].[SubPlanner],
	[WipJobAllLab].[SubBuyer],
	[WipJobAllLab].[SubLeadTime],
	[WipJobAllLab].[SubDockToStock],
	[WipJobAllLab].[SubOffsiteDays],
	[WipJobAllLab].[SchStartDate],
	[WipJobAllLab].[SchStartTime],
	[WipJobAllLab].[SchEndDate],
	[WipJobAllLab].[SchEndTime],
	[WipJobAllLab].[OperationStatus],
	[WipJobAllLab].[OpSplitFlag],
	[WipJobAllLab].[MaxOpDelay],
	[WipJobAllLab].[UnitValueReqd],
	[WipJobAllLab].[RunTimeIssued],
	[WipJobAllLab].[SetUpIssued],
	[WipJobAllLab].[StartUpIssued],
	[WipJobAllLab].[ShutdownIssued],
	[WipJobAllLab].[ValueIssued],
	[WipJobAllLab].[PiecesCompleted],
	[WipJobAllLab].[ValueBilled],
	[WipJobAllLab].[OperCompleted],
	[WipJobAllLab].[QtyCompleted],
	[WipJobAllLab].[QtyScrapped],
	[WipJobAllLab].[LastScrapReason],
	[WipJobAllLab].[PlannedQueueDate],
	[WipJobAllLab].[PlannedStartDate],
	[WipJobAllLab].[PlannedEndDate],
	[WipJobAllLab].[ActualQueueDate],
	[WipJobAllLab].[ActualStartDate],
	[WipJobAllLab].[ActualFinishDate],
	[WipJobAllLab].[AutoNarrCode],
	[WipJobAllLab].[Narration],
	[WipJobAllLab].[NonConformFlag],
	[WipJobAllLab].[WorkCentre],
	[WipJobAllLab].[WorkCentreDesc],
	[WipJobAllLab].[ElapsedTime],
	[WipJobAllLab].[MovementTime],
	[WipJobAllLab].[UnitNumOfPieces],
	[WipJobAllLab].[InspectionFlag],
	[WipJobAllLab].[Milestone],
	[WipJobAllLab].[MinorSetUp],
	[WipJobAllLab].[MinorSetUpCode],
	[WipJobAllLab].[ToolSet],
	[WipJobAllLab].[ToolSetQty],
	[WipJobAllLab].[ToolConsumption],
	[WipJobAllLab].[QueueTime],
	[WipJobAllLab].[MilestoneComp],
	[WipJobAllLab].[CalcElapsedTime],
	[WipJobAllLab].[HierHead1],
	[WipJobAllLab].[HierHead2],
	[WipJobAllLab].[HierHead3],
	[WipJobAllLab].[HierHead4],
	[WipJobAllLab].[HierHead5],
	[WipJobAllLab].[CapacityIssued],
	[WipJobAllLab].[Line],
	[WipJobAllLab].[OpCompViaJob],
	[WipJobAllLab].[TransferQtyOrPct],
	[WipJobAllLab].[TransferQtyPct],
	[WipJobAllLab].[ParentQtyPlanned],
	[WipJobAllLab].[OperYieldPct],
	[WipJobAllLab].[OperYieldQty],
	[WipJobAllLab].[ParIssQty],
	[WipJobAllLab].[HoursBilled],
	[WipJobAllLab].[CoProductCostVal],
	[WipJobAllLab].[QtyScrappedEnt],
	[WipJobAllLab].[TransferQtyPctEnt],
	[WipJobAllLab].[ParentQtyPlanEnt],
	[WipJobAllLab].[OperYieldQtyEnt],
	[WipJobAllLab].[ParIssQtyEnt],
	[WipJobAllLab].[QtyCompletedEnt],
	[WipJobAllLab].[ResourceMask],
	[WipJobAllLab].[SchStartRunDate],
	[WipJobAllLab].[SchStartRunTime],
	[WipJobAllLab].[ScheduledMachine],
	[WipJobAllLab].[AllowOpSplit],
	[WipJobAllLab].[CreatedBy],
	[WipJobAllLab].[ProductCode],
	[WipJobAllLab].[LibraryCode],
	[WipJobAllLab].[FirstSeq],
	[WipJobAllLab].[SecondSeq],
	[WipJobAllLab].[TimeStamp],
	[WipJobAllLab].[JobNest]
;