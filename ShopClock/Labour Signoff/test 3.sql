



DECLARE @d1 AS DATETIME;
DECLARE @d2 AS DATETIME;
--SELECT @d = DATEADD(DAY, -1, GETDATE());
SELECT @d1 = '2023-07-13';
SELECT @d2 = '2023-08-23';

SELECT
	[Calendar].[Date]
	,[EmployeeName]
	,[EmployeeNumber]
	,CAST(
	CAST(YEAR([LoggedOn]) AS NVARCHAR(4))
	+ '-' + RIGHT('00' + CAST(MONTH([LoggedOn]) AS NVARCHAR(2)), 2)
	+ '-' + RIGHT('00' + CAST(DAY([LoggedOn]) AS NVARCHAR(2)), 2)
	AS DATETIME) AS [ED]
FROM
	[BWSdb].[dbo].[Calendar]
LEFT JOIN
	[ClkTransaction]
ON
	CAST(CAST(YEAR([LoggedOn]) AS NVARCHAR(4))
	+ '-' + RIGHT('00' + CAST(MONTH([LoggedOn]) AS NVARCHAR(2)), 2)
	+ '-' + RIGHT('00' + CAST(DAY([LoggedOn]) AS NVARCHAR(2)), 2)
	AS DATETIME) = [Calendar].[Date]
WHERE
	--[LoggedOn] BETWEEN @d1 AND @d2
	--AND
	[Calendar].[Date] BETWEEN @d1 AND @d2
	--AND LOWER([EmployeeName]) LIKE '%ekpe%'
GROUP BY
	[Calendar].[Date]
	,[EmployeeName]
	,[EmployeeNumber]
	,YEAR([LoggedOn])
	,MONTH([LoggedOn])
	,DAY([LoggedOn])
ORDER BY
	[Calendar].[Date]


SELECT
	*
FROM
	[BWSdb].[dbo].[Calendar]
WHERE
	[Date] BETWEEN @d1 AND @d2

SELECT
	*
FROM 
	[ClkEmployee]
ORDER BY
	[Name]

SELECT
	*
FROM
	[ClkGroup]