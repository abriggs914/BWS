USE [SysproCompanyA]
GO

/****** Object:  View [dbo].[v_ClkShiftMissingEmpsAssignments]    Script Date: 2022-04-11 9:03:58 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_ClkShiftMissingEmpsAssignments] AS
-- Missing list
SELECT
	[EmployeeNumber],
	[EmployeeName],
	MIN([LoggedOn]) AS [First Day],
	MAX([LoggedOff]) AS [Last Day],
	[ClkShiftMaster].[ShiftName] AS [ShopClock Shift]
FROM
	[ClkTransaction]
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].Emp#
LEFT JOIN
	[ClkShiftMaster]
ON
	[ClkTransaction].[ShiftID] = [ClkShiftMaster].[ShiftID]
WHERE
	[ClkShiftEmpAssign].[Emp#] IS NULL
GROUP BY
	[EmployeeName],
	[EmployeeNumber],
	[ClkShiftMaster].[ShiftName]
;
GO


