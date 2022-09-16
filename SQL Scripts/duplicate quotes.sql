SELECT
	[Quote#],
	cast(Orders.WO# as varchar(20)) AS [A]
	, [v_CompletedJobInfo].[Job] AS [B]
	, (CASE WHEN cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job THEN 'Y' ELSE 'N' END) AS [C]
	--, *
FROM
	[Orders] 
left outer join
	SysproCompanyA.dbo.v_CompletedJobInfo
on
	cast(Orders.WO# as varchar(20)) = v_CompletedJobInfo.Job
GROUP BY
	[Quote#]
	, Orders.WO# 
	, [Job]
HAVING 
	COUNT(*) > 1
ORDER BY
	[Orders].[Quote#]