USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ITR SettingsJoinCustomers]    Script Date: 2023-11-15 3:51:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[v_ITR SettingsJoinCustomers] AS
SELECT
	[S].[ID] AS [SettingsID]
	,[S].[ITRCustomerID] AS [SettingsITRCustomerID]
	,[S].[Theme] AS [SettingsTheme]
	,[S].[AutoLockOwnRequests] AS [SettingsAutoLockOwnRequests]
	,[S].[AutoSeeOwnRequests] AS [SettingsAutoSeeOwnRequests]
	
	,[C].[CustomerID] AS [CustomerID]
	,[C].[Name] AS [CustomerName]
	,[C].[Department] AS [CustomerDepartment]
	,[C].[Company] AS [CustomerCompany]
	,[C].[Email] AS [CustomerEmail]
	,[C].[WorkPhone] AS [CustomerWorkPhone]
	,[C].[WorkExtension] AS [CustomerWorkExtension]
	,[C].[CellPhone] AS [CustomerCellPhone]
	,[C].[HomePhone] AS [CustomerHomePhone]
	,[C].[Active] AS [CustomerActive]
	,[C].[DateAdded] AS [CustomerDateAdded]
	,[C].[LastActive] AS [CustomerLastActive]
	,[C].[WorkPhoneLastActive] AS [CustomerWorkPhoneLastActive]
	,[C].[WorkExtensionLastActive] AS [CustomerWorkExtensionLastActive]
	,[C].[CellPhoneLastActive] AS [CustomerCellPhoneLastActive]
	,[C].[HomePhoneLastActive] AS [CustomerHomePhoneLastActive]
	,[C].[WindowsUser] AS [CustomerWindowsUser]
	,[C].[BirthYear] AS [CustomerBirthYear]
	,[C].[BirthMonth] AS [CustomerBirthMonth]
	,[C].[BirthDay] AS [CustomerBirthday]

	,[T].[ID] AS [ThemeID]
	,[T].[DateAdded] AS [ThemeDateAdded]
	,[T].[TimeStamp] AS [ThemeTimeStamp]
	,[T].[Name] AS [ThemeName]
	,[T].[Font_Button] AS [ThemeFont_Button]
	,[T].[Font_CheckBox] AS [ThemeFont_CheckBox]
	,[T].[Font_ComboBox] AS [ThemeFont_ComboBox]
	,[T].[Font_HyperLink] AS [ThemeFont_HyperLink]
	,[T].[Font_Label] AS [ThemeFont_Label]
	,[T].[Font_ListBox] AS [ThemeFont_ListBox]
	,[T].[Font_TextField] AS [ThemeFont_TextField]
	,[T].[Font_Colour_Button] AS [ThemeFont_Colour_Button]
	,[T].[Font_Colour_CheckBox] AS [ThemeFont_Colour_CheckBox]
	,[T].[Font_Colour_ComboBox] AS [ThemeFont_Colour_ComboBox]
	,[T].[Font_Colour_HyperLink] AS [ThemeFont_Colour_HyperLink]
	,[T].[Font_Colour_Label] AS [ThemeFont_Colour_Label]
	,[T].[Font_Colour_ListBox] AS [ThemeFont_Colour_ListBox]
	,[T].[Font_Colour_TextField] AS [ThemeFont_Colour_TextField]
	,[T].[Back_Colour_Button] AS [ThemeBack_Colour_Button]
	,[T].[Back_Colour_CheckBox] AS [ThemeBack_Colour_CheckBox]
	,[T].[Back_colour_ComboBox] AS [ThemeBack_colour_ComboBox]
	,[T].[Back_Colour_Hyperlink] AS [ThemeBack_Colour_Hyperlink]
	,[T].[Back_Colour_Label] AS [ThemeBack_Colour_Label]
	,[T].[Back_Colour_ListBox] AS [ThemeBack_Colour_ListBox]
	,[T].[Back_Colour_TextField] AS [ThemeBack_Colour_TextField]
	,[T].[Colour_Detail] AS [ThemeColour_Detail]
	,[T].[Form_ITR_Edit_Label_Admin] AS [ThemeForm_ITR_Edit_Label_Admin]
	,[T].[Form_ITR_Edit_Label_Title] AS [ThemeForm_ITR_Edit_Label_Title]
	
	,[P].[ITPersonID#] AS [ITPersonnelITPersonID#]
	,[P].[Name] AS [ITPersonnelName]
	,[P].[Company] AS [ITPersonnelCompany]	  
	,[P].[Emp#] AS [ITPersonnelEmp#]
	,[P].[ITRCustomerID] AS [ITPersonnelITRCustomerID]
	,[P].[DateCreated] AS [ITPersonnelDateCreated]
	,[P].[Active] AS [ITPersonnelActive]
	,[P].[DateActive] AS [ITPersonnelDateActive]
	,[P].[DateInactive] AS [ITPersonnelDateInactive]
	,[P].[AccessAliasFullName] AS [ITPersonnelAccessAliasFullName]
	,[P].[AccessAliasWindowsUser] AS [ITPersonnelAccessAliasWindowsUser]
	,[P].[UseAccessAlias] AS [ITPersonnelUseAccessAlias]
	
FROM 
	[ITR Settings] AS [S]
INNER JOIN
	[ITR Customers] AS [C]
ON
	[S].[ITRCustomerID] = [C].[CustomerID]
INNER JOIN
	[ITR ColourSchemes] AS [T]
ON
	[S].[Theme] = [T].[ID]
LEFT JOIN
	[IT Personnel] AS [P] 
ON
	[C].[CustomerID] = [P].[ITRCustomerID]
GO


