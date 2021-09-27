USE SysproCompanyA
GO



DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';


select year(ActCompleteDate) AS [Date],
sum(ValueIssued) as Material,
sum(UnitQtyReqd * UnitCost) as Budget
from WipMaster with (nolock)
inner join WipJobAllMat with (nolock) on WipMaster.Job = WipJobAllMat.Job
where ActCompleteDate is not null and ActCompleteDate BETWEEN @SD AND @ED
group by year(ActCompleteDate)
order by year(ActCompleteDate)