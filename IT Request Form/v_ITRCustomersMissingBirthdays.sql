USE BWSdb
GO

-- 2024-01-22 0722
-- Avery Briggs
-- Gather employee information for any employees that have missing birthday imformation.

ALTER VIEW [v_ITRCustomersMissingBirthdays] AS

--SELECT * FROM [ITD Dept]

SELECT
	--LEN([D].[DeptRelations]) AS [L1]
	--,LEN(CAST([C].[Department] AS NVARCHAR(MAX))) AS [L2]
	--,(LEN([D].[DeptRelations]) - LEN(CAST([C].[Department] AS NVARCHAR(MAX)))) AS [LL]
	--,CHARINDEX(';' + CAST([C].[Department] AS NVARCHAR(MAX)) + ';', [D].[DeptRelations]) AS [A]
	--,CHARINDEX(CAST([C].[Department] AS NVARCHAR(MAX)) + ';', [D].[DeptRelations]) AS [B]
	--,CHARINDEX(';' + CAST([C].[Department] AS NVARCHAR(MAX)), [D].[DeptRelations]) AS [C]
	--,
	[C].[CustomerID]
	,[C].[BirthYear]
	,[C].[BirthMonth]
	,[C].[BirthDay]
	,[C].[Name] AS [Employee Name]
	,[C].[Company]
	,[D].[Name] AS [Department]
	--,[C].[Department]
	--,[D].[DeptRelations]
FROM
	[ITR Customers] AS [C]
LEFT JOIN
	[ITD Dept] AS [D]
ON
	1 = (CASE 
			WHEN CAST([C].[Department] AS NVARCHAR(MAX)) = [D].[DeptRelations] THEN 1
			WHEN CHARINDEX(';' + CAST([C].[Department] AS NVARCHAR(MAX)) + ';', [D].[DeptRelations]) > 0 THEN 1
			WHEN CHARINDEX(CAST([C].[Department] AS NVARCHAR(MAX)) + ';', [D].[DeptRelations]) = 1 THEN 1
			WHEN CHARINDEX(';' + CAST([C].[Department] AS NVARCHAR(MAX)), [D].[DeptRelations]) = (1 + LEN([D].[DeptRelations]) - LEN(CAST([C].[Department] AS NVARCHAR(MAX)))) THEN 1
			ELSE 0
		END)
WHERE
	(0 = (ISNULL([C].[BirthYear], 0) * ISNULL([C].[BirthMonth], 0) * ISNULL([C].[BirthDay], 0)))
	AND ([C].[Active] = 1)
	AND ([C].[Name] <> 'UNKNOWN')
--ORDER BY
--	[Employee Name]

GO

;