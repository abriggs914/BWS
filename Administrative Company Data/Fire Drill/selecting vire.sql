-- Fire Drills
-- Internal
-- Admin
-- ACD

SELECT
	[FDR].[ID] AS [FDR_ID]
	,[FDR].[DateCreated] AS [FDR_DateCreated]
	,[FDR].[Active] AS [FDR_Active]
	,[FDR].[DateActive] AS [FDR_DateActive]
	,[FDR].[DateInactive] AS [FDR_DateInactive]
	,[FDR].[IDBuilding] AS [FDR_IDBuilding]
	,[FDR].[IDITRCustomers] AS [FDR_IDITRCustomers]
FROM
	[ACD FireDrillRoster] AS [FDR] WITH (NOLOCK)
;


SELECT
	*
FROM (
	SELECT
		LTRIM(RTRIM(SUBSTRING([Name], 0, CHARINDEX(' ', [Name])))) AS [FirstName]
		,LTRIM(RTRIM(SUBSTRING([Name], CHARINDEX(' ', [Name]), LEN([Name])))) AS [LastName]
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
		[ITR Customers] AS [C] WITH (NOLOCK)
	WHERE
		([Active] = 1)
		AND ([Company] = 'BWS')
		AND ([Name] NOT IN (
			'UNKNOWN'
			,'Receiving _'
			,'Eng Desk'
			,'Parts Desk'
		))
) AS [Src]
WHERE
	([FirstName] <> '')
	AND ([LastName] <> '')
	AND ([C_Department] IS NOT NULL)
ORDER BY
	[LastName]
	,[FirstName]
;

SELECT
        [D].[ID] AS [D_ID]
        ,[D].[Name] AS [D_Name]
        ,[D].[DeptRelations] AS [D_DeptRelations]
        ,[D].[DateAdded] AS [D_DateAdded]
FROM
        [ITD Dept] AS [D] WITH (NOLOCK)
;

SELECT
        [B].[ID] AS [B_ID]
        ,[B].[DateCreated] AS [B_DateCreated]
        ,[B].[Active] AS [B_Active]
        ,[B].[DateActive] AS [B_DateActive]
        ,[B].[DateInactive] AS [B_DateInactive]
        ,[B].[Name] AS [B_Name]
        ,[B].[Address] AS [B_Address]
        ,[B].[Province] AS [B_Province]
        ,[B].[Floors] AS [B_Floors]
        ,[B].[MapFile] AS [B_MapFile]
FROM
        [ITI Buildings] AS [B] WITH (NOLOCK)
;


--BEGIN TRAN;

--ROLLBACK;
--COMMIT;