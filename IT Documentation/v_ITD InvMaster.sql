USE BWSdb
GO


/****** Script for SelectTopNRows command from SSMS  ******/

CREATE VIEW [dbo].[v_ITD InvMaster] AS
	SELECT
		[ITD InvMaster].[ID]
		,[ITD InvMaster].[DocName]
		,[ITD InvMaster].[Description]
		,[ITD InvMaster].[PrepDate]
		,[ITD InvMaster].[PrepBy]
		,[ITR Customers].[Name] AS [PrepByName]
		,[ITD InvMaster].[ITLevel]
		,[ITD InvMaster].[RevNo]
		,[ITD InvMaster].[URL]
		,[ITD InvMaster].[DateAdded]
		,[ITD InvMaster].[DateInActive]
		,[ITD InvMaster].[SourceDepartments]
		,[ITD Dept A].[Name] AS [SourceDepartmentName]
		,[ITD InvMaster].[Comments]
		,[ITD InvMaster].[IsActive]
		,[ITD InvMaster].[Departments]
		,[ITD Dept].[ID] AS [DepartmentID]
		,[ITD Dept].[Name] AS [DepartmentNames]
		,[ITD InvMaster].[Types]
		,[ITD Type].[ID] AS [TypeID]
		,[ITD Type].[Name] AS [TypeNames]
		,[ITD InvMaster].[LastUpdated]
		,[ITD InvMaster].[LastUpdatedBy]
	FROM
		[BWSdb].[dbo].[ITD InvMaster]
	LEFT JOIN
		[ITR Customers]
	ON
		[ITD InvMaster].[PrepBy] = [ITR Customers].[CustomerID]
	LEFT JOIN
		[ITD Dept]
	ON
		[ITD Dept].[ID] IN (SELECT [splited_data] FROM split_string_idx([ITD InvMaster].[Departments], ';'))
	LEFT JOIN
		[ITD Type]
	ON
		[ITD Type].[ID] IN (SELECT [splited_data] FROM split_string_idx([ITD InvMaster].[Types], ';'))
	LEFT JOIN
		[ITD Dept] AS [ITD Dept A]
	ON
		[ITD Dept A].[ID] IN (SELECT [splited_data] FROM split_string_idx([ITD InvMaster].[SourceDepartments], ';'))
