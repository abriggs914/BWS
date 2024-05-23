USE BWSdb
GO


CREATE VIEW [v_ADO_All_User_Settings] AS

	SELECT
		[CUS_CustomerID]
		,[CUS_Name]
		,[CUS_Department]
		,[CUS_Company]
		,[CUS_Email]
		,[CUS_WorkPhone]
		,[CUS_WorkExtension]
		,[CUS_CellPhone]
		,[CUS_HomePhone]
		,[CUS_Active]
		,[CUS_DateAdded]
		,[CUS_LastActive]
		,[CUS_WorkPhoneLastActive]
		,[CUS_WorkExtensionLastActive]
		,[CUS_CellPhoneLastActive]
		,[CUS_HomePhoneLastActive]
		,[CUS_WindowsUser]
		,[CUS_BirthYear]
		,[CUS_BirthMonth]
		,[CUS_BirthDay]
		,[CUS_HireYear]
		,[CUS_HireMonth]
		,[CUS_HireDay]
		,[CUS_EmpType]
		,[CUS_TerminationYear]
		,[CUS_TerminationMonth]
		,[CUS_TerminationDay]
		,[CUS_MiddleName]
		,[CUS_IsAPerson]
		,[CUS_ShirtSize]
		,[CUS_DateShirtSize]

		,[MOD_ID]
		,[MOD_DateCreated]
		,[MOD_Active]
		,[MOD_DateActive]
		,[MOD_DateInActive]
		,[MOD_ModuleName]
		,[MOD_ModuleDescription]
		,[MOD_DateLastModified]

		,[U].[ID] AS [UAC_ID]
		,[U].[DateCreated] AS [UAC_DateCreated]
		,[U].[Active] AS [UAC_Active]
		,[U].[DateActive] AS [UAC_DateActive]
		,[U].[DateInActive] AS [UAC_DateInActive]
		,[U].[DateLastModified] AS [UAC_DateLastModified]
		,[U].[ITRCustomerID] AS [UAC_ITRCustomerID]
		,[U].[ADOModuleID] AS [UAC_ADOModuleID]
		,[U].[ValidFrom] AS [UAC_ValidFrom]
		,[U].[ValidTo] AS [UAC_ValidTo]	
	
		,[M].[ADOMasterID] AS [ADO_ADOMasterID]
		,[M].[ADODatabaseID] AS [ADO_ADODatabaseID]
		,[M].[ObjectType] AS [ADO_ObjectType]
		,[M].[ObjectName] AS [ADO_ObjectName]
		,[M].[DateCreated] AS [ADO_DateCreated]
		,[M].[Active] AS [ADO_Active]
		,[M].[DateActive] AS [ADO_DateActive]
		,[M].[DateInactive] AS [ADO_DateInactive]
		,[M].[DateLastModified] AS [ADO_DateLastModified]
		,[M].[Description] AS [ADO_Description]
		,[M].[Notes] AS [ADO_Notes]
		,[M].[ModuleID] AS [ADO_ModuleID]
	FROM (
		SELECT
			[C].[CustomerID] AS [CUS_CustomerID]
			,[C].[Name] AS [CUS_Name]
			,[C].[Department] AS [CUS_Department]
			,[C].[Company] AS [CUS_Company]
			,[C].[Email] AS [CUS_Email]
			,[C].[WorkPhone] AS [CUS_WorkPhone]
			,[C].[WorkExtension] AS [CUS_WorkExtension]
			,[C].[CellPhone] AS [CUS_CellPhone]
			,[C].[HomePhone] AS [CUS_HomePhone]
			,[C].[Active] AS [CUS_Active]
			,[C].[DateAdded] AS [CUS_DateAdded]
			,[C].[LastActive] AS [CUS_LastActive]
			,[C].[WorkPhoneLastActive] AS [CUS_WorkPhoneLastActive]
			,[C].[WorkExtensionLastActive] AS [CUS_WorkExtensionLastActive]
			,[C].[CellPhoneLastActive] AS [CUS_CellPhoneLastActive]
			,[C].[HomePhoneLastActive] AS [CUS_HomePhoneLastActive]
			,[C].[WindowsUser] AS [CUS_WindowsUser]
			,[C].[BirthYear] AS [CUS_BirthYear]
			,[C].[BirthMonth] AS [CUS_BirthMonth]
			,[C].[BirthDay] AS [CUS_BirthDay]
			,[C].[HireYear] AS [CUS_HireYear]
			,[C].[HireMonth] AS [CUS_HireMonth]
			,[C].[HireDay] AS [CUS_HireDay]
			,[C].[EmpType] AS [CUS_EmpType]
			,[C].[TerminationYear] AS [CUS_TerminationYear]
			,[C].[TerminationMonth] AS [CUS_TerminationMonth]
			,[C].[TerminationDay] AS [CUS_TerminationDay]
			,[C].[MiddleName] AS [CUS_MiddleName]
			,[C].[IsAPerson] AS [CUS_IsAPerson]
			,[C].[ShirtSize] AS [CUS_ShirtSize]
			,[C].[ShirtSizeDate] AS [CUS_DateShirtSize]
		
			,[M].[ID] AS [MOD_ID]
			,[M].[DateCreated] AS [MOD_DateCreated]
			,[M].[Active] AS [MOD_Active]
			,[M].[DateActive] AS [MOD_DateActive]
			,[M].[DateInActive] AS [MOD_DateInActive]
			,[M].[ModuleName] AS [MOD_ModuleName]
			,[M].[ModuleDescription] AS [MOD_ModuleDescription]
			,[M].[DateLastModified] AS [MOD_DateLastModified]
		FROM
			[ITR Customers] AS [C] WITH (NOLOCK)
		CROSS JOIN
			[ADO_Modules] AS [M] WITH (NOLOCK)
	) [Src]
	LEFT JOIN
		[ADO_User_Access] [U]
	ON
		[Src].[CUS_CustomerID] = [U].[ITRCustomerID]
		AND [Src].[MOD_ID] = [U].[ADOModuleID]
	LEFT JOIN
		[ADO Master] AS [M] WITH (NOLOCK)
	ON
		[Src].[MOD_ID] = [M].[ModuleID]
	/*
	ORDER BY
		[CUS_Name]
		,[MOD_ID]
	*/
;