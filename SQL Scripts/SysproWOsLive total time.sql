USE SysproCompanyA
GO

DECLARE @job AS VARCHAR(10) = '70000317';

SELECT
	[WipMaster].[Job],
	[QtyToMake],
	[WipJobAllLab].[IExpUnitRunTim],
	[QtyToMake] * [WipJobAllLab].[IExpUnitRunTim] AS [Result]
FROM
	[WipMaster]
INNER JOIN
	[WipJobAllLab]
ON
	[WipMaster].[Job] = [WipJobAllLab].[Job]
WHERE
	[WipMaster].[Job] = @job