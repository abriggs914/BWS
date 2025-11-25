

SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ClkTransaction] [C]
WHERE
	(
	LOWER([EmployeeName]) LIKE LOWER('%Hath%')
	OR LOWER([EmployeeName]) LIKE LOWER('%luis p%')
	OR LOWER([EmployeeName]) LIKE LOWER('%sean hard%')
	OR LOWER([EmployeeName]) LIKE LOWER('%Mason%')
	OR LOWER([EmployeeName]) LIKE LOWER('%damien%'))
ORDER BY
	[LoggedOn] DESC



SELECT
	*
FROM
	[BWSdb].[dbo].[Employees] [E]
WHERE
	(
	LOWER([1st Name]) LIKE LOWER('%Hath%')
	OR LOWER([1st Name]) LIKE LOWER('%luis p%')
	OR LOWER([1st Name]) LIKE LOWER('%sean hard%')
	OR LOWER([1st Name]) LIKE LOWER('%Mason%')
	OR LOWER([1st Name]) LIKE LOWER('%damien%'))
ORDER BY
	[2nd Name] DESC