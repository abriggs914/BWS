
--DECLARE @WAREHOUSE AS NVARCHAR(MAX);
--SET @WAREHOUSE = NULL
--DECLARE @split_wh AS TABLE ([idx] INT, [splitted_data] NVARCHAR(MAX))
--INSERT INTO @split_wh SELECT * FROM [BWSdb].[dbo].[split_string_idx](@WAREHOUSE, ';')

--SELECT * FROM @split_wh

--SELECT [Warehouse] FROM [SysproCompanyA].[dbo].[InvWarehouse] GROUP BY [Warehouse]

SELECT * FROM [SysproCompanyA].[dbo].[BomOperations]
SELECT * FROM [SysproCompanyA].[dbo].[InvMaster]

SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWhControl] GROUP BY [Warehouse]
SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[InvWarehouse] GROUP BY [Warehouse]
SELECT ROW_NUMBER() OVER (ORDER BY [Warehouse]) AS [Row#], [Warehouse] FROM [SysproCompanyA].[dbo].[WipMaster] GROUP BY [Warehouse]
SELECT ROW_NUMBER() OVER (ORDER BY [Operation]) AS [Row#], [Operation] FROM [SysproCompanyA].[dbo].[WipJobAllLab] GROUP BY [Operation]

SELECT ROW_NUMBER() OVER (ORDER BY [PartCategory]) AS [Row#], [PartCategory] FROM [SysproCompanyA].[dbo].[InvMaster] GROUP BY [PartCategory]
SELECT ROW_NUMBER() OVER (ORDER BY [PartCategory]) AS [Row#], * FROM [SysproCompanyA].[dbo].[InvMaster]