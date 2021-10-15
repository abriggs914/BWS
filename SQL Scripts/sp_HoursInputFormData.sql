USE Stargatedb
Go

CREATE PROCEDURE [dbo].[sp_HoursInputFormData]
	@date DATETIME
AS
BEGIN
SELECT
	[Hours Worked].[StaffID#] AS [StaffID#],
	Employees.[Emp#],
	Employees.[2nd Name] AS [2nd Name],
	Employees.[1st Name],
	[Hours Worked].DateWorked,
	[Hours Worked].[Hours Work],
	[Hours Worked].Vacation,
	[Hours Worked].Absent,
	[Hours Worked].Absent_BQOverride,
	[Hours Worked].[Sick Leave],
	[Hours Worked].Late,
	[Hours Worked].[Leave Early],
	[Hours Worked].[Shortage of Work],
	[Hours Worked].Comments,
	[Hours Worked].Safety,
	[Hours Worked].[GetBonus?],
	[Hours Worked].XSyspro,
	[Hours Worked].[Syspro Hours],
	[Hours Worked].[Non Syspro Hours]
FROM
	Employees
RIGHT JOIN
	[Hours Worked]
ON
	Employees.[StaffID#]=[Hours Worked].[StaffID#]
WHERE
	((([Hours Worked].DateWorked)=@date)
	And ((Employees.Hourly)=1))
ORDER BY
	Employees.[2nd Name], Employees.[1st Name];
END