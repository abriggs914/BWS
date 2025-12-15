USE SysproCompanyA
GO

SELECT
	[CT].*
FROM
	[ClkEmployee] [C]
LEFT JOIN
	[ClkTransaction] [CT]
ON
	[C].[Employee] = [CT].[EmployeeNumber]
WHERE
	(
	LOWER([C].[Name]) LIKE LOWER('%Hath%')
	OR LOWER([C].[Name]) LIKE LOWER('%luis p%')
	OR LOWER([C].[Name]) LIKE LOWER('%damien%')
	OR LOWER([C].[Name]) LIKE LOWER('%sean hard%')
	OR LOWER([C].[Name]) LIKE LOWER('%Mason%'))
ORDER BY
	[LoggedOn] DESC


	
SELECT
	*
FROM
	[BWSdb].[dbo].[ITR Customers]
WHERE
	--(
	[Name] LIKE '%aver%'

SELECT
	*
FROM
	[BWSdb].[dbo].[Payroll]
WHERE
	--(
	--(([1st Name] LIKE '%aver%') OR [2nd Name] LIKE '%aver%')
	--OR 
	/*(([1st Name] LIKE '%josh%') AND [2nd Name] LIKE '%hath%')
	OR */
	(([1st Name] LIKE '%sean%') AND [2nd Name] LIKE '%hard%')
ORDER BY
	[Date] DESC