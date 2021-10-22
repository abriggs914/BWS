USE Stargatedb
GO

SELECT
	[StaffID#],
	[Emp#],
	[2nd Name],
	[1st Name],
	[Initial],
	[Dept],
	[Shift],
	[Hourly]
	[Date Hired],
	[Terminated],
	[Re-Hire],
	[Standard Hours],
	[Eligable Days],
	[Status],
	[Comments],
	[DOB],
	[Gender],
	[Province],
	[Health],
	[Dental],
	[Dep Life],

FROM [Employees]
UNION ALL
SELECT * FROM [Employees - Salary]