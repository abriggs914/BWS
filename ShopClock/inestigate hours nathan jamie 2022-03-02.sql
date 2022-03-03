
SELECT 
	[TransactionID],
	[JobNumber],
	[JobName],
	[EmployeeNumber],
	[EmployeeName],
	[LoggedOn],
	[LoggedOff]
FROM
	[ClkTransaction]
WHERE
	[LoggedOn] BETWEEN '2022-03-02' AND '2022-03-02 11:59 PM'
	AND (
		[EmployeeName] LIKE '%SMITH, JAMIE%' 
		OR [EmployeeName] LIKE '%NICHOLSON, NATHAN%'
	)
ORDER BY
	[EmployeeNumber], [LoggedOn]