USE SysproCompanyA
GO

SELECT
	*
FROM
	[ClkEmployee] [C]
WHERE
	(
	[Name] LIKE '%Hath%'
	OR [Name] LIKE '%luis p%'
	OR [Name] LIKE '%sean hard%')
	AND [LoggedOn] BETWEEN '2022-01-01' AND GETDATE()


	
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