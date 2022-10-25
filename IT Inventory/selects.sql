USE BWSdb
GO
SELECT 'ITI InvMaster' AS [Table], * FROM [ITI InvMaster];
SELECT 'ITI InvMaster Snap' AS [Table], * FROM [ITI InvMaster Snap];
SELECT 'v_Tools&Equip' AS [Table], * FROM [uniPoint_Live].[dbo].[v_Tools&Equip];
SELECT 'ITI Item' AS [Table], * FROM [ITI Item];
SELECT 'v_ITI Item' AS [Table], * FROM [dbo].[v_ITI_Items];

EXEC sp_ITI_ListSimilarItems;

SELECT 'ITI Computer' AS [Table], * FROM [ITI Computer];
SELECT 'ITI Condition' AS [Table], * FROM [ITI Condition];
SELECT 'ITI Network' AS [Table], * FROM [ITI Network];
SELECT 'ITI Peripherals' AS [Table], * FROM [ITI Peripherals];
SELECT 'ITI Status' AS [Table], * FROM [ITI Status];
SELECT 'ITI Type' AS [Table], * FROM [ITI Type];
SELECT 'ITI UOM' AS [Table], * FROM [ITI UOM];
SELECT 'ITI Wire' AS [Table], * FROM [ITI Wire];



SELECT
	[ITI Item].[ID]
	, 'ITI InvMaster' AS [Table]
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
;


EXEC [sp_ITI_ListSimilarItems] @name='17" Monitor'
EXEC [sp_ITI_ListSimilarItemsWithType] @name='17" Monitor'
EXEC [sp_ITI_ListSimilarItems] @name='VGA Cable'
EXEC [sp_ITI_ListSimilarItemsWithType] @name='VGA Cable'