USE BWSdb
GO

-- 2024-01-22 1007
-- Avery Briggs
-- Gather employee information joined with the grouped departments from [ITD Dept].

ALTER VIEW [v_ITRCustomersWithDepartments] AS

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
	
	,[C].[Department] AS [C_Department]
	,[C].[Email] AS [C_Email]
	,[C].[WorkPhone] AS [C_WorkPhone]
	,[C].[WorkExtension] AS [C_WorkExtension]
	,[C].[CellPhone] AS [C_CellPhone]
	,[C].[HomePhone] AS [C_HomePhone]
	,[C].[Active] AS [C_Active]
	,[C].[DateAdded] AS [C_DateAdded]
	,[C].[LastActive] AS [C_LastActive]
	,[C].[WorkPhoneLastActive] AS [C_WorkPhoneLastActive]
	,[C].[WorkExtensionLastActive] AS [C_WorkExtensionLastActive]
	,[C].[CellPhoneLastActive] AS [C_CellPhoneLastActive]
	,[C].[HomePhoneLastActive] AS [C_HomePhoneLastActive]
	,[C].[WindowsUser] AS [C_WindowsUser]
	,[C].[HireYear] AS [C_HireYear]
	,[C].[HireMonth] AS [C_HireMonth]
	,[C].[HireDay] AS [C_HireDay]
	,[C].[EmpType] AS [C_EmpType]
	,[C].[TerminationYear] AS [C_TerminationYear]
	,[C].[TerminationMonth] AS [C_TerminationMonth]
	,[C].[TerminationDay] AS [C_TerminationDay]
	,[C].[MiddleName] AS [C_MiddleName]
	,[D].[ID] AS [D_ID]
	,[D].[DeptRelations] AS [D_DeptRelations]
	,[D].[DateAdded] AS [D_DateAdded]

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
		([C].[Active] = 1)
		AND ([C].[Name] <> 'UNKNOWN')
	--ORDER BY
	--	[Employee Name]

GO

;