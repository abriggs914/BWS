USE SysproCompanyA
GO

SELECT
	[WipLabJnl].[WorkCentre]
	, [WorkCentreDesc]
	, COUNT(*)
FROM
	[WipLabJnl]
INNER JOIN
	[BomWorkCentre]
ON
	[WipLabJnl].[WorkCentre] = [BomWorkCentre].[WorkCentre]
INNER JOIN
	[WipJobAllLab]
ON
	[WipLabJnl].[Job] = [WipJobAllLab].[Job]
	AND [WipLabJnl].[WorkCentre] = [WipJobAllLab].[WorkCentre]
GROUP BY
	[WipLabJnl].[WorkCentre]
	, [WipJobAllLab].[WorkCentreDesc]
ORDER BY
	[WipLabJnl].[WorkCentre]