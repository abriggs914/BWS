USE Stargatedb
GO
BEGIN TRAN;

SELECT * FROM [Employees - Salary]

INSERT INTO 
	[Employees - Salary]
SELECT
	Emp#,
	[2nd Name],
	[1st Name],
	[Initial],
	[Dept],
	[Shift],
	[Date Hired],
	[Terminated],
	[Re-Hire],
	[Standard Hours],
	[Status],
	[Comments],
	[DOB],
	[Gender],
	[Province],
	[Health],
	[Dental],
	[Dep Life]
FROM
	[Employees]
WHERE
	[Hourly/Salary] = 1
	
SELECT * FROM [Employees - Salary]
ROLLBACK;
COMMIT;