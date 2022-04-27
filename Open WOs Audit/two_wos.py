from utility import *

import pandas as pd
import pyodbc
from xlwt import Workbook

# Program to query and dump Work order status data into an excel spreadsheet
# with each job# on it's own tab. (Yes, A LOT of tabs)
# All jobs are queried for status as of EOD on 2022-03-31.

if __name__ == '__main__':
    do_BWS = True
    start_t = dt.datetime.now()

    # server = "server3"
    # database = "SysproCompanyA"
    # username = "SRS"
    # password = ""
    # cstr = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password

    if do_BWS:
        # BWS output
        cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyA;UID=SRS;PWD="
    else:
        # STG output
        cstr = "DRIVER={SQL Server};SERVER=server3;DATABASE=SysproCompanyS;UID=SCSRS;PWD="

    sql = """
    SET NOCOUNT ON;
DECLARE
	@ed DATETIME;
SET @ed = '2022-04-30';
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
		
			--([WipMaster].[Job] = '10015032'
			--	OR [WipMaster].[Job] = '10015028')
			--AND
			(([ActCompleteDate] IS NULL OR [ActCompleteDate] > @ed) OR ([WipMaster].[Job] = '10015028' OR [WipMaster].[Job] = '10015032'))
			AND [JobTenderDate] < @ed
			--AND LEFT([WipMaster].[Job], 1) = '2'
GROUP BY
	[WipMaster].[Job]
;

--SELECT * FROM @t ORDER BY [Job#];
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
			--AND ([ActCompleteDate] IS NULL OR [ActCompleteDate] > @ed)
			--AND (([ActCompleteDate] IS NULL OR [ActCompleteDate] > @ed) OR [WipMaster].[Job] = '10015028')
			AND (([ActCompleteDate] IS NULL OR [ActCompleteDate] > @ed) OR ([WipMaster].[Job] = '10015028' OR [WipMaster].[Job] = '10015032'))
			AND [JobTenderDate] < @ed
		ORDER BY
			[Job]
		;
		SET @i = @i + 1;
	END

SELECT * FROM @r WHERE [Job] IN ('10015028', '10015032')

--END


"""

    print("connecting...")
    conn = pyodbc.connect(cstr)
    end_conn_t = dt.datetime.now()

    print("querying...")
    df = pd.DataFrame(pd.read_sql_query(sql, conn))
    end_query_t = dt.datetime.now()

    cols = list(df.columns)
    # cols: Index(['Job', 'JobDescription', 'ParentPart', 'ParentDescription',
    #    'JobTenderDate', 'ActCompleteDate', 'QtyToMake', 'Material Grouping',
    #    'PartCategory', 'StockCode', 'StockDescription', 'Uom', 'UnitCost',
    #    'WarehouseToUse', 'QtyRequired', 'VR', 'QtyIssued', 'ValueIssued',
    #    'Variance', 'Total'],
    #   dtype='object')
    # print(f"cols: {cols}")

    wb = Workbook()
    sheets = {}

    print("writing...")
    writable = False
    for i, row_dat in df.iterrows():
        writable = True
        job, *rest = row_dat

        # add new sheet for new job
        if job not in sheets:
            sheets[job] = wb.add_sheet(job), 0

        # current sheet and row on that sheet
        sheet, row_count = sheets[job]
        for j, c_r in enumerate(zip(cols, row_dat)):
            c, r = c_r
            if row_count == 0:

                # if first row, write column headers first
                for k, col_name in enumerate(cols):
                    sheet.write(0, k, col_name)
                row_count += 1

            # write data to cell
            sheet.write(row_count, j, r)

        # increment sheet row count
        sheets[job] = sheet, row_count + 1

    # for i, k_v in enumerate(data.items()):
    #     k, v = k_v
    #     sheet.

    end_process_t = dt.datetime.now()
    # print(data[list(data.keys())[0]])

    if writable:
        if do_BWS:
            wb.save("BWS output 5028 5032.xls")
        else:
            wb.save("STG output 5028 5032.xls")

    conn.close()

    print("done!")
    end_t = dt.datetime.now()
    time_diff = (end_t - start_t).seconds
    time_conn = (end_conn_t - start_t).seconds
    time_query = (end_query_t - end_conn_t).seconds
    time_process = (end_process_t - end_query_t).seconds
    time_results = {
        "start time": start_t,
        "end time": end_t,
        "time connecting": time_conn,
        "time querying": time_query,
        "time writing": time_process,
        "Total Time (s)": time_diff
    }
    print(dict_print(time_results, "Time Results"))
