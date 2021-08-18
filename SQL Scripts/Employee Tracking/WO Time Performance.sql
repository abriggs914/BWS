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

-- SELECT * FROM [BWSdb].[dbo].[Defects] WHERE CAST([WO#] AS VARCHAR(10)) = @JOB

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
/*
SELECT
	SUM(IExpUnitRunTim) AS [Total Budgeted Hours],
	SUM([RunTimeIssued]) AS [Total Hours Issued],
	SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [Hours Over Budget]
FROM
	[WipJobAllLab]
WHERE
	[Job] LIKE @JOB
GROUP BY
	[Job]
;

SELECT
	COUNT(*) AS [Total Defects]
FROM
	[BWSdb].[dbo].[Defects]
WHERE
	CAST([WO#] AS VARCHAR(10)) = @JOB
;

*/


SELECT 
	[WO#],
	SUM([4 Total Budgeted Hours]) AS [4 Total Budgeted Hours],
	SUM([4 Total Hours Issued]) AS [4 Total Hours Issued],
	SUM([4 Hours Over Budget]) AS [4 Hours Over Budget],
	SUM([5 Total Budgeted Hours]) AS [5 Total Budgeted Hours],
	SUM([5 Total Hours Issued]) AS [5 Total Hours Issued],
	SUM([5 Hours Over Budget]) AS [5 Hours Over Budget],
	[Total Defects]
FROM (

SELECT
	@Job AS [WO#],
	[4 Total Budgeted Hours],
	[4 Total Hours Issued],
	[4 Hours Over Budget],
	[5 Total Budgeted Hours],
	[5 Total Hours Issued],
	[5 Hours Over Budget],
	(
		SELECT
			COUNT(*)
		FROM
			[BWSdb].[dbo].[Defects]
		WHERE
			CAST([WO#] AS VARCHAR(10)) = @JOB
	) AS [Total Defects]
FROM (
	SELECT
		'' AS [Job],
		SUM(IExpUnitRunTim) AS [4 Total Budgeted Hours],
		SUM([RunTimeIssued]) AS [4 Total Hours Issued],
		SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [4 Hours Over Budget],
		0 AS [5 Total Budgeted Hours],
		0 AS [5 Total Hours Issued],
		0 AS [5 Hours Over Budget]
	FROM
		[WipJobAllLab]
	WHERE
		[Job] LIKE @JOB
		AND [Operation] = 4
	GROUP BY
		[Job]
) AS [SrcTable1]

UNION (

	SELECT
		@Job AS [WO#],
		0 AS [4 Total Budgeted Hours],
		0 AS [4 Total Hours Issued],
		0 AS [4 Hours Over Budget],
		[5 Total Budgeted Hours],
		[5 Total Hours Issued],
		[5 Hours Over Budget],
		(
			SELECT
				COUNT(*)
			FROM
				[BWSdb].[dbo].[Defects]
			WHERE
				CAST([WO#] AS VARCHAR(10)) = @JOB
		) AS [Total Defects]
	FROM (
		SELECT
			0 AS [4 Total Budgeted Hours],
			0 AS [4 Total Hours Issued],
			0 AS [4 Hours Over Budget],
			SUM(IExpUnitRunTim) AS [5 Total Budgeted Hours],
			SUM([RunTimeIssued]) AS [5 Total Hours Issued],
			SUM([RunTimeIssued]) - SUM(IExpUnitRunTim) AS [5 Hours Over Budget]
		FROM
			[WipJobAllLab]
		WHERE
			[Job] LIKE @JOB
			AND [Operation] = 5
		GROUP BY
			[Job]
	) AS [SrcTable2]
)
) AS [SrcTable3]
GROUP BY
	[WO#],
	[Total Defects]
;
/*
SELECT
	COUNT(*) AS [Total Defects]
FROM
	[BWSdb].[dbo].[Defects]
WHERE
	CAST([WO#] AS VARCHAR(10)) = @JOB
;
*/
/*





SELECT
	COUNT(*) AS [Total Defects]
FROM
	
WHERE
	CAST([WO#] AS VARCHAR(10)) = @JOB
;
*/
/*
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
;*/