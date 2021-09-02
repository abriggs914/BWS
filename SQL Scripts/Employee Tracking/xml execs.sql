USE SysproCompanyA
GO

EXEC [sp_WOSnapshotSubsHoursXML] @WO='20021300'
EXEC [sp_WOSnapshotSubsHoursXML] @WO='70003117'
EXEC [sp_WOSnapshotSubsHoursXML] @WO='20032100'
EXEC [sp_WOSnapshotSubsHoursXML] @WO='10014747'
EXEC [sp_WOSnapshotSubsHoursXML] @WO='70001030'
EXEC [sp_WOSnapshotSubsHoursXML] @WO='70000773'


USE BWSdb
GO
SELECT
	COUNT(*) AS [Total Defects]
FROM
	[Defects]
WHERE
	CAST([WO#] AS NVARCHAR(MAX)) LIKE '70001030';

SELECT
	[WO#]
FROM
	[Defects]
WHERE
	LEFT(CAST([WO#] AS VARCHAR(10)), 1) != '1'
GROUP BY
	[WO#]
HAVING
	COUNT([#Defects]) > 0