USE SysproCompanyA
GO

DECLARE @SD AS DATETIME, @ED AS DATETIME;
SET @SD = '1950-01-01';
SET @ED = '2050-09-23';

--select DATENAME(MONTH, CAST(CAST(year(DateWorked) AS varchar(50))+'-'+RIGHT('00'+CAST(month(DateWorked) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(DateWorked) AS varchar(30)) AS [Date],


select DATENAME(MONTH, CAST(CAST(year(JobDeliveryDate) AS varchar(50))+'-'+RIGHT('00'+CAST(month(JobDeliveryDate) AS varchar(50)), 2)+'-01' AS DATETIME)) + ' - ' + CAST(year(JobDeliveryDate) AS varchar(30)) AS [Date],
count(WipMaster.Job) as NoPastDueWOs
from WipMaster with (nolock)
cross join MrpReqCtl with (nolock)
where JobDeliveryDate < MrpReqCtl.SupplyDemandDate
and ActCompleteDate is null and JobDeliveryDate between @SD and @ED
group by year(JobDeliveryDate), month(JobDeliveryDate)
order by year(JobDeliveryDate), month(JobDeliveryDate)


select year(JobDeliveryDate) as [Date],
count(WipMaster.Job) as NoPastDueWOs
from WipMaster with (nolock)
cross join MrpReqCtl with (nolock)
where JobDeliveryDate < MrpReqCtl.SupplyDemandDate
and ActCompleteDate is null and JobDeliveryDate between @SD and @ED
group by year(JobDeliveryDate)
order by year(JobDeliveryDate)
