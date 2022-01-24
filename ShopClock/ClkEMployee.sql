--INSERT INTO [ClkShiftRoundRules] ([Name]) VALUES ('New Shift 1')
USE SysproCompanyA
GO


--SELECT * FROM [ClkShiftRoundRules]
--SELECT * FROM [ClkEmployee]
--SELECT [Employee] FROM [ClkEmployee] GROUP BY [Employee] HAVING COUNT(*) > 1

SELECT MAX([Employee]), [Name] FROM [ClkEmployee] GROUP BY [Name] ORDER BY [Name]
SELECT [ShiftID], [Name] FROM [ClkShiftRoundRules]


SELECT
	MAX([Employee]) AS [Emp#],
	[ClkEmployee].[Name],
	(CASE WHEN [ClkShiftRoundRules].[Name] IS NULL THEN (SELECT TOP 1 [Name] FROM [ClkShiftRoundRules]) ELSE [ClkShiftRoundRules].[Name] END) AS [ShiftName]
FROM
	[ClkEmployee]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[ClkEmployee].[Employee] = [ClkShiftEmpAssign].[EmployeeNumber]
LEFT JOIN	
	[ClkShiftRoundRules]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules].[ShiftID]
GROUP BY
	[ClkEmployee].[Name],
	[ClkShiftRoundRules].[Name]
ORDER BY
	[ClkEmployee].[Name]
	
SELECT TOP 1 * FROM [ClkEmployee]
SELECT TOP 1 * FROM [ClkShiftEmpAssign]
SELECT TOP 1 * FROM [ClkShiftRoundRules]


--BEGIN TRAN;
--UPDATE
--	[ClkShiftRoundRules]
--SET 
--	[StartTime] = '7:00:00 AM',
--	[EndTime] = '5:00:00 PM',
--	[Interval] = 15,
--	[Threshold] = 2,
--	[IncludeLunch] = 1
--WHERE
--	[StartTime] IS NULL

--ROLLBACK;
--COMMIT;