
SELECT * FROM [SysproCompanyA].[dbo].[ClkShiftMaster]


-- View all employees on 'day shift shift 7:00am' currently in shopclock
SELECT 
	*
FROM
	[SysproCompanyA].[dbo].[ClkEmployee] AS [A]
INNER JOIN
	[SysproCompanyA].[dbo].[ClkShiftMaster] AS [B]
ON 
	[A].[ShiftID] = [B].[ShiftID]
WHERE
	[A].[ShiftID] = 37