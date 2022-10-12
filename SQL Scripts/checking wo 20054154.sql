USE SysproCompanyA
GO

DECLARE @job AS NVARCHAR(MAX);

SELECT @job = '20054154';

select
	DrawOfficeNum,
	OperationOffset,
		(case 
		when 
			subInfoDrawing.StockCode is not null
		then 
			0
		when 
			WipJobAllMat.StockCode like '%-I%' 
		then
			UnitQtyReqd
		else 
			1
		end) as QtyToPrint
    from WipJobAllMat with (nolock)
    inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
    left outer join (select Job, InvMaster.StockCode
                     from WipJobAllMat with (nolock)
                     inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
                     where ProductClass in ('BF', 'INFO')
                     and WipJobAllMat.StockCode like '%-I%') as subInfoDrawing on WipJobAllMat.Job = subInfoDrawing.Job
                                                                                  and WipJobAllMat.StockCode + '-I' = subInfoDrawing.StockCode
    where ProductClass in ('BF', 'INFO')
    and WipJobAllMat.Job = @job
    and DrawOfficeNum <> ''
    and UserField3 <> 'Y'
    union all select StockCode, null, 1 from WipMaster with (nolock)
    where Job = @job
    order by OperationOffset, DrawOfficeNum

DECLARE @t AS TABLE ([ID] INT IDENTITY(1, 1), [Draw#] NVARCHAR(MAX), [Op] NVARCHAR(MAX), [Qty] NVARCHAR(MAX));

INSERT INTO @t ([Draw#], [Op], [Qty])
select
	DrawOfficeNum,
	OperationOffset,
		(case 
		when 
			subInfoDrawing.StockCode is not null
		then 
			0
		when 
			WipJobAllMat.StockCode like '%-I%' 
		then
			UnitQtyReqd
		else 
			1
		end) as QtyToPrint
    from WipJobAllMat with (nolock)
    inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
    left outer join (select Job, InvMaster.StockCode
                     from WipJobAllMat with (nolock)
                     inner join InvMaster with (nolock) on WipJobAllMat.StockCode = InvMaster.StockCode
                     where ProductClass in ('BF', 'INFO')
                     and WipJobAllMat.StockCode like '%-I%') as subInfoDrawing on WipJobAllMat.Job = subInfoDrawing.Job
                                                                                  and WipJobAllMat.StockCode + '-I' = subInfoDrawing.StockCode
    where ProductClass in ('BF', 'INFO')
    and WipJobAllMat.Job = @job
    and DrawOfficeNum <> ''
    and UserField3 <> 'Y'
    union all select StockCode, null, 1 from WipMaster with (nolock)
    where Job = @job
    order by OperationOffset, DrawOfficeNum


SELECT * FROM @t ORDER BY [Draw#]