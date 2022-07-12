USE BWSdb
GO


DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2000-01-01';
SET @ed = '2030-01-01';


SELECT
	YEAR([Input Date]) AS [Year]
	, MONTH([Input Date]) AS [Month]
	, DATENAME(MONTH, DATEADD(MONTH, MONTH([Input Date]) , 0 ) - 1 ) + ' ' + CAST(YEAR([Input Date]) AS NVARCHAR(4)) AS [DateFmt]
	, [Defect]
	, COUNT([Defect]) AS [# Defects]
FROM
	[Defects_Print]
LEFT JOIN
	[Defects_Print_Problems]
ON
	[Defects_Print].[ProblemID] = [Defects_Print_Problems].[DefPrintProbsID#]
LEFT JOIN
	[Design StaffV2]
ON
	[Engineer] = [Design StaffV2].[ID-SaleStaff]
WHERE
	[Input Date] BETWEEN @sd AND @ed
	AND [CompanyID] IS NOT NULL
	AND [Defect] IS NOT NULL
GROUP BY
	YEAR([Input Date])
	, MONTH([Input Date])
	, [Defect]
ORDER BY
	[Year]
	, [Month]
	, [Defect]
;