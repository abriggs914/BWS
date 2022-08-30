USE BWSdb

GO

DECLARE @quote AS INT;
SET @quote = 26492; -- broken
--SET @quote = 26491; -- fixed
--SET @quote = 25706;

SELECT 'Orders' AS [Table], * FROM [Orders] WHERE [Quote#] = @quote ORDER BY [Quote#];
SELECT 'AudOrders' AS [Table], * FROM [audOrders] WHERE [Quote#] = @quote ORDER BY [Quote#];
SELECT 'audOrders_RevHistory' AS [Table], * FROM [audOrders_RevHistory] WHERE [Quote#] = @quote ORDER BY [Quote#];

SELECT 'Order Options' AS [Table], * FROM [Order Options] WHERE [Quote#] = @quote ORDER BY [Option No];
SELECT 'Order Options_FactoryLines' AS [Table], * FROM [Order Options_FactoryLines] WHERE [Quote#] = @quote ORDER BY [Option No];
SELECT 'Order Options_SpecLines' AS [Table], * FROM [Order Options_SpecLines] WHERE [Quote#] = @quote ORDER BY [Option No];

SELECT 'Custom Work' AS [Table], * FROM [Custom Work] WHERE [Quote#] = @quote ORDER BY [Description];
SELECT 'Custom Work_FactoryLines' AS [Table], * FROM [Custom Work_FactoryLines] WHERE [Quote#] = @quote ORDER BY [Description];
SELECT 'Custom Work_SpecLines' AS [Table], * FROM [Custom Work_SpecLines] WHERE [Quote#] = @quote ORDER BY [Description];

SELECT 'Order Standards' AS [Table], [Order Standards].* FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote ORDER BY [Standard No]
SELECT 'Standards' AS [Table], [Standards].* FROM [Standards] INNER JOIN [Orders] ON [Standards].[Model No] = [Orders].[Model No] WHERE [Orders].[Quote#] = @quote ORDER BY [Standard No]
SELECT 'Options_FactoryLines' AS [Table], [Options_FactoryLines].* FROM [Options_FactoryLines] INNER JOIN [Orders] ON [Options_FactoryLines].[Model No] = [Orders].[Model No] WHERE [Orders].[Quote#] = @quote ORDER BY [Option No]
SELECT 'Options_SpecLines' AS [Table], [Options_SpecLines].* FROM [Options_SpecLines] INNER JOIN [Orders] ON [Options_SpecLines].[Model No] = [Orders].[Model No] WHERE [Orders].[Quote#] = @quote ORDER BY [Option No]


--BEGIN TRAN;


--SELECT 'Order Standards' AS [Table], [Order Standards].* FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote ORDER BY [Standard No]

--DELETE FROM
--	[Order Standards]
--WHERE
--	[Quote#] = @quote
--	AND [Model No] = '35ADG2X NR'

--SELECT 'Order Standards' AS [Table], [Order Standards].* FROM [Order Standards] INNER JOIN [Orders] ON [Order Standards].[Quote#] = [Orders].[Quote#] WHERE [Orders].[Quote#] = @quote ORDER BY [Standard No]

--ROLLBACK;
--COMMIT;