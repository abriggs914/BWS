USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_WorkOrderStatusAsOf]    Script Date: 2022-04-22 10:53:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--ALTER PROCEDURE [dbo].[sp_WorkOrderStatusAsOf] 
	-- Add the parameters for the stored procedure here
DECLARE
	@ed DATETIME;
SET @ed = '2022-03-31';
DECLARE @i AS BIGINT;
DECLARE @c AS BIGINT;

DECLARE @t AS TABLE ([Row#] BIGINT, [Job#] NVARCHAR(20));
INSERT INTO @t SELECT ROW_NUMBER()  OVER(
	ORDER BY [WipMaster].[Job]
),
[WipMaster].[Job]
from WipJobAllMat with (nolock)
	inner join WipMaster with (nolock) on WipJobAllMat.Job = WipMaster.Job
	--inner join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
	left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
	left outer join (select Job, MStockCode, MAllocationLine, sum(MQtyIssued) as QtyIssued, sum(TrnValue) as ValueIssued 
	                 from WipJobPost with (nolock) where TrnDate <= @ed
					 group by Job, MStockCode, MAllocationLine) as subA on WipJobAllMat.Job = subA.Job 
					                                                  and WipJobAllMat.StockCode = subA.MStockCode
																	  and WipJobAllMat.Line = subA.MAllocationLine
	left outer join (select WipMaster.Job, 
					 case when sum(MaterialValue) is null then 0 else sum(MaterialValue) end as Material, 
					 case when sum(LabourValue) is null then 0 else sum(LabourValue) end as Labour,
					 case when sum(MaterialValue) + sum(LabourValue)  is null then 0 else convert(float, sum(MaterialValue) + sum(LabourValue)) end as Total from WipMaster with (nolock)
					 left outer join WipPartBook with (nolock) on WipMaster.Job = WipPartBook.Job
					 where TrnDate <= 'june 30 2015'
					 group by WipMaster.Job) as subB on WipMaster.Job = subB.Job
		where 
			([ActCompleteDate] IS NULL OR [ActCompleteDate] > @ed)
			AND [JobTenderDate] < @ed
			--AND LEFT([WipMaster].[Job], 1) = '2'
GROUP BY
	[WipMaster].[Job]
;

--SELECT * FROM @t;
SET @i = 1;
SET @c = (SELECT COUNT(*) FROM @t);

DECLARE @r AS TABLE (
	[Job] NVARCHAR(20),
	[JobDescription] NVARCHAR(MAX),
	[ParentPart] NVARCHAR(MAX),
	[ParentDescription] NVARCHAR(MAX),
	[JobTenderDate] DATETIME,
	[ActCompleteDate] DATETIME,
	[QtyToMake] FLOAT,
	[Material Grouping] NVARCHAR(MAX),
	[PartCategory] NVARCHAR(MAX),
	[StockCode] NVARCHAR(MAX),
	[StockDescription] NVARCHAR(MAX),
	[Uom] NVARCHAR(MAX),
	[UnitCost] FLOAT,
	[WarehouseToUse] NVARCHAR(MAX),
	[QtyRequired] FLOAT,
	[VR] FLOAT,
	[QtyIssued] FLOAT,
	[ValueIssued] FLOAT,
	[Variance] FLOAT,
	[Total] FLOAT
);
--AS
--BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

    -- Insert statements for procedure here
	WHILE @i < @c BEGIN
		INSERT INTO @r
		select WipMaster.Job, WipMaster.JobDescription, WipMaster.StockCode AS ParentPart, WipMaster.StockDescription as ParentDescription, WipMaster.JobTenderDate, 
		WipMaster.ActCompleteDate, WipMaster.QtyToMake, 
		case PartCategory when 'B' then 'Total Bought Out Material:'
		when 'M' then 'Total Made In Material:'
		when 'G' then 'Total Phantom Material:'
		when 'S' then 'Total Subcontracted Material:'
		when 'P' then 'Total Planning Material:'
		when 'K' then 'Total Kit Material:'
		when 'C' then 'Total Co-Product Material:'
		else '' end as MaterialGrouping, 
		case when PartCategory is null or PartCategory = 'S' then 'B'
		else PartCategory end as PartCategory,
		WipJobAllMat.StockCode, 
		WipJobAllMat.StockDescription, 
		WipJobAllMat.Uom,
		UnitCost,
		WipJobAllMat.Warehouse as WarehouseToUse /*InvMaster.WarehouseToUse*/, 
		UnitQtyReqd * QtyToMake AS QtyRequired,
		cast((UnitQtyReqd * QtyToMake) * UnitCost as float) as VR,
		cast(case when subA.QtyIssued is null then 0 else subA.QtyIssued end as float) as QtyIssued, 
		cast(case when subA.ValueIssued is null then 0 else subA.ValueIssued end as float) as ValueIssued,
		cast((UnitQtyReqd * QtyToMake) * UnitCost as float) - cast(case when subA.ValueIssued is null then 0 else subA.ValueIssued end as float) as Variance,
		subB.Total from WipJobAllMat with (nolock)
		inner join WipMaster with (nolock) on WipJobAllMat.Job = WipMaster.Job
		--inner join v_JobWIPValue on WipMaster.Job = v_JobWIPValue.Job
		left outer join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
		left outer join (select Job, MStockCode, MAllocationLine, sum(MQtyIssued) as QtyIssued, sum(TrnValue) as ValueIssued 
						 from WipJobPost with (nolock) where TrnDate <= @ed
						 group by Job, MStockCode, MAllocationLine) as subA on WipJobAllMat.Job = subA.Job 
																		  and WipJobAllMat.StockCode = subA.MStockCode
																		  and WipJobAllMat.Line = subA.MAllocationLine
		left outer join (select WipMaster.Job, 
						 case when sum(MaterialValue) is null then 0 else sum(MaterialValue) end as Material, 
						 case when sum(LabourValue) is null then 0 else sum(LabourValue) end as Labour,
						 case when sum(MaterialValue) + sum(LabourValue)  is null then 0 else convert(float, sum(MaterialValue) + sum(LabourValue)) end as Total from WipMaster with (nolock)
						 left outer join WipPartBook with (nolock) on WipMaster.Job = WipPartBook.Job
						 where TrnDate <= 'june 30 2015'
						 group by WipMaster.Job) as subB on WipMaster.Job = subB.Job
		where 
			WipMaster.Job = (SELECT [Job#] FROM @t WHERE [Row#] = @i)
			AND ([ActCompleteDate] IS NULL OR [ActCompleteDate] > @ed)
			AND [JobTenderDate] < @ed
		ORDER BY
			[Job]
		;
		SET @i = @i + 1;
	END

SELECT * FROM @r;

--END

