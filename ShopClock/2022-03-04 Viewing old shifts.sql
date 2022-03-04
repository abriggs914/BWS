SELECT * FROM [SysproCompanyA].[dbo].[ClkEmployee]

SELECT
	[ShiftName],
	COUNT(*) AS Num
FROM
	[SysproCompanyA].[dbo].[ClkEmployee]
INNER JOIN	
	[SysproCompanyA].[dbo].[ClkShiftMaster]
ON
	[ClkEmployee].ShiftID = [ClkShiftMaster].[ShiftID]
GROUP BY
	[ShiftName]
;

SELECT * FROM [SysproCompanyA].[dbo].[ClkShiftMaster] WHERE [ShiftName] LIKE '%Catch%'