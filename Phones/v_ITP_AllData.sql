USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ITP_AllData]    Script Date: 2023-08-31 11:01:00 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_ITP_AllData] AS

	SELECT 
		'BWS' AS [Company]
		, [PL].[ID] AS [PL_ID]
		  ,[PL].[Extension] AS [PL_Extension]
		  ,[PL].[AssignedTo] AS [PL_AssignedTo]
		  ,[PL].[DateAssigned] AS [PL_DateAssigned]
		  ,[PL].[Active] AS [PL_Active]
		  ,[PL].[LastActive] AS [PL_LastActive]
		  ,[PL].[DisplayName] AS [PL_DisplayName]
		  ,[PL].[Section] AS [PL_Section]
		  ,[PL].[SectionOrder] AS [PL_SectionOrder]
		  ,[PL].[Notes] AS [PL_Notes]

		  ,[FS].[ID] AS [FS_ID]
		  ,[FS].[Name] AS [FS_Name]
		  ,[FS].[DateAdded] AS [FS_DateAdded]
		  ,[FS].[FormOrder] AS [FS_FormOrder]
		  ,[FS].[HeaderBackColour] AS [FS_HeaderBackColour]
		  ,[FS].[HeaderForeColour] AS [FS_HeaderForeColour]
		  ,[FS].[DataBackColour] AS [FS_DataBackColour]
		  ,[FS].[DataForeColour] AS [FS_DataForeColour]

		  ,[IC].[CustomerID] AS [IC_CustomerID]
		  ,[IC].[Name] AS [IC_Name]
		  ,[IC].[Department] AS [IC_Department]
		  ,[IC].[Company] AS [IC_Company]
		  ,[IC].[Email] AS [IC_Email]
		  ,[IC].[WorkPhone] AS [IC_WorkPhone]
		  ,[IC].[WorkExtension] AS [IC_WorkExtension]
		  ,[IC].[CellPhone] AS [IC_CellPhone]
		  ,[IC].[HomePhone] AS [IC_HomePhone]
		  ,[IC].[Active] AS [IC_Active]
		  ,[IC].[DateAdded] AS [IC_DateAdded]
		  ,[IC].[LastActive] AS [IC_LastActive]
		  ,[IC].[WorkPhoneLastActive] AS [IC_WorkPhoneLastActive]
		  ,[IC].[WorkExtensionLastActive] AS [IC_WorkExtensionLastActive]
		  ,[IC].[CellPhoneLastActive] AS [IC_CellPhoneLastActive]
		  ,[IC].[HomePhoneLastActive] AS [IC_HomePhoneLastActive]
		  ,[IC].[WindowsUser] AS [IC_WindowsUser]
	FROM
		[ITP PhoneLines] AS [PL]
	FULL OUTER JOIN
		[ITP FormSections] AS [FS]
	ON
		[PL].[Section] = [FS].[FormOrder]
	FULL OUTER JOIN
		[ITR Customers] AS [IC]
	ON
		[PL].[AssignedTo] = [IC].[CustomerID]
	WHERE
		[PL].[ID] IS NOT NULL
		AND [FS].[ID] IS NOT NULL

UNION

	SELECT 
		'STG' AS [Company]
		, [PL].[ID] AS [PL_ID]
		  ,[PL].[Extension] AS [PL_Extension]
		  ,[PL].[AssignedTo] AS [PL_AssignedTo]
		  ,[PL].[DateAssigned] AS [PL_DateAssigned]
		  ,[PL].[Active] AS [PL_Active]
		  ,[PL].[LastActive] AS [PL_LastActive]
		  ,[PL].[DisplayName] AS [PL_DisplayName]
		  ,[PL].[Section] AS [PL_Section]
		  ,[PL].[SectionOrder] AS [PL_SectionOrder]
		  ,[PL].[Notes] AS [PL_Notes]

		  ,[FS].[ID] AS [FS_ID]
		  ,[FS].[Name] AS [FS_Name]
		  ,[FS].[DateAdded] AS [FS_DateAdded]
		  ,[FS].[FormOrder] AS [FS_FormOrder]
		  ,[FS].[HeaderBackColour] AS [FS_HeaderBackColour]
		  ,[FS].[HeaderForeColour] AS [FS_HeaderForeColour]
		  ,[FS].[DataBackColour] AS [FS_DataBackColour]
		  ,[FS].[DataForeColour] AS [FS_DataForeColour]

		  ,[IC].[CustomerID] AS [IC_CustomerID]
		  ,[IC].[Name] AS [IC_Name]
		  ,[IC].[Department] AS [IC_Department]
		  ,[IC].[Company] AS [IC_Company]
		  ,[IC].[Email] AS [IC_Email]
		  ,[IC].[WorkPhone] AS [IC_WorkPhone]
		  ,[IC].[WorkExtension] AS [IC_WorkExtension]
		  ,[IC].[CellPhone] AS [IC_CellPhone]
		  ,[IC].[HomePhone] AS [IC_HomePhone]
		  ,[IC].[Active] AS [IC_Active]
		  ,[IC].[DateAdded] AS [IC_DateAdded]
		  ,[IC].[LastActive] AS [IC_LastActive]
		  ,[IC].[WorkPhoneLastActive] AS [IC_WorkPhoneLastActive]
		  ,[IC].[WorkExtensionLastActive] AS [IC_WorkExtensionLastActive]
		  ,[IC].[CellPhoneLastActive] AS [IC_CellPhoneLastActive]
		  ,[IC].[HomePhoneLastActive] AS [IC_HomePhoneLastActive]
		  ,[IC].[WindowsUser] AS [IC_WindowsUser]
	FROM
		[Stargatedb].[dbo].[ITP PhoneLines] AS [PL]
	FULL OUTER JOIN
		[Stargatedb].[dbo].[ITP FormSections] AS [FS]
	ON
		[PL].[Section] = [FS].[FormOrder]
	FULL OUTER JOIN
		[ITR Customers] AS [IC]
	ON
		[PL].[AssignedTo] = [IC].[CustomerID]
	WHERE
		[PL].[ID] IS NOT NULL
		AND [FS].[ID] IS NOT NULL
GO


