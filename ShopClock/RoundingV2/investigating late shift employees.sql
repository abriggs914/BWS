USE SysproCompanyA
GO

SELECT
	[EmployeeName]
	, [EmployeeNumber]
	, [LoggedOn]
	, [LoggedOff]
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] IN (
		200528,
		200447,
		200141,
		200634
	)
ORDER BY
	[LoggedOn] DESC
;