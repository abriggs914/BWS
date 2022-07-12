USE BWSdb
GO


DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SET @sd = '2000-01-01';
SET @ed = '2030-01-01';


SELECT
	[Defect_PrintID#]
	, [Input Date]
	, [CompanyID]
	, [Staff]
	, [Engineer]
	, [Defect]
	, [Comment]
	, [ReportedBy]
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
ORDER BY
	[Input Date] DESC
;

exec [sp_defectsEngineeringByDesignerReport] 'January 01 2000', 'July 11 2030', '0'
exec [sp_defectsEngineeringByDesignerReport] 'January 01 2000', 'July 11 2030', '1'
exec [sp_defectsEngineeringByDesignerReport] 'January 01 2000', 'July 11 2030', '0,1'
