USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ACDAllCustomersFireDrill]    Script Date: 2024-01-31 3:34:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_ACDAllCustomersFireDrill]
AS
SELECT
	[R].[Num] AS [R_Num]
	,[R].[ID] AS [R_ID]
	,[R].[DrillActive] AS [R_DrillActive]
	,[R].[CustomerID] AS [R_CustomerID]
	,[R].[Name] AS [R_Name]
	,[R].[Employee Name] AS [R_EmployeeName]
	,[R].[FirstName] AS [R_FirstName]
	,[R].[LastName] AS [R_LastName]
	,[C].[CustomerID] AS [C_CustomerID]
	,[C].[Name] AS [C_Name]
	,[C].[Department] AS [C_Department]
	,[C].[Company] AS [C_Company]
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
	,[C].[BirthYear] AS [C_BirthYear]
	,[C].[BirthMonth] AS [C_BirthMonth]
	,[C].[BirthDay] AS [C_BirthDay]  
	,[C].[HireYear] AS [C_HireYear]
	,[C].[HireMonth] AS [C_HireMonth]
	,[C].[HireDay] AS [C_HireDay]
	,[C].[EmpType] AS [C_EmpType]
	,[C].[TerminationYear] AS [C_TerminationYear]
	,[C].[TerminationMonth] AS [C_TerminationMonth]
	,[C].[TerminationDay] AS [C_TerminationDay]
	,[C].[MiddleName] AS [C_MiddleName]
FROM
	[v_ACD FireDrillRosterByBuilding] AS [R] WITH (NOLOCK)
FULL OUTER JOIN
	[ITR Customers] AS [C] WITH (NOLOCK)
ON
	[R].[CustomerID] = [C].[CustomerID]
;
GO


