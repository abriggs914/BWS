USE BWSdb
GO

ALTER VIEW [dbo].[v_ITI_Items] AS

	SELECT
		[ITI Item].[ID]
		, [Quantity]
		, [ITI Item].[Name] AS [Item]
		, [ITI Condition].[Name] AS [Condition]
		, [ITI Status].[Name] AS [Status]
		, [ITI Type].[Name] AS [Type]
		, [ITI Computer].[Name] AS [Computer]
		, [ITI Peripherals].[Name] AS [Peripherals]
		, [ITI Wire].[Name] AS [Wire]
		, [ITI Network].[Name] AS [Network]
		, [ITI Unknown].[Name] AS [Unknown]
	FROM
		[ITI InvMaster]
	LEFT JOIN
		[ITI Item]
	ON
		[ITI InvMaster].[Item] = [ITI Item].[ID]
	LEFT JOIN
		[ITI Condition]
	ON
		[ITI Item].[Condition] = [ITI Condition].[ID]
	LEFT JOIN
		[ITI Status]
	ON
		[ITI Item].[Status] = [ITI Status].[ID]
	LEFT JOIN
		[ITI Type]
	ON
		[ITI Item].[Type] = [ITI Type].[ID]
	LEFT JOIN
		[ITI Computer]
	ON
		[ITI Item].[Type] = (SELECT [ID] FROM [ITI Type] WHERE [Name] = 'Computer')
		AND [ITI Item].[SubType] = [ITI Computer].[ID]
	LEFT JOIN
		[ITI Peripherals]
	ON
		[ITI Item].[Type] = (SELECT [ID] FROM [ITI Type] WHERE [Name] = 'Peripherals')
		AND [ITI Item].[SubType] = [ITI Peripherals].[ID]
	LEFT JOIN
		[ITI Wire]
	ON
		[ITI Item].[Type] = (SELECT [ID] FROM [ITI Type] WHERE [Name] = 'Wire')
		AND [ITI Item].[SubType] = [ITI Wire].[ID]
	LEFT JOIN
		[ITI Network]
	ON
		[ITI Item].[Type] = (SELECT [ID] FROM [ITI Type] WHERE [Name] = 'Network')
		AND [ITI Item].[SubType] = [ITI Network].[ID]
	LEFT JOIN
		[ITI Unknown]
	ON
		[ITI Item].[Type] = (SELECT [ID] FROM [ITI Type] WHERE [Name] = 'UNKNOWN')
		AND [ITI Item].[SubType] = [ITI Unknown].[ID]

GO