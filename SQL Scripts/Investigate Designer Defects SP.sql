USE BWSdb
GO

DECLARE @SD AS DATETIME;
SET @SD = '2021-01-01'
DECLARE @ED AS DATETIME;
SET @ED = '2021-08-31'

SELECT * FROM [Design StaffV2]

SELECT
	[Staff],
	*
FROM
	[Defects_Print]
INNER JOIN
	[Design StaffV2]
ON
	[Engineer] = [ID-SaleStaff]
WHERE
	[Input Date] BETWEEN @SD AND @ED
;

exec [sp_defectsEngineeringByDesignerReport] @SD, @ED, '0,1';
