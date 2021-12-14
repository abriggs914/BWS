USE BWSdb
GO

SELECT * FROM [OrdersV2] WHERE [SGQuote] = 'SG100498'
SELECT * FROM [Order OptionsV2] WHERE [SGQuote] = 'SG100498'
SELECT * FROM [Options_FactoryLinesV2] WHERE [Model No] = 'End Dump 3X'
SELECT * FROM [Options_SpecLinesV2] WHERE [Model No] = 'End Dump 3X' AND [SpecSortSeLine] = -88
--SELECT * FROM [Options V2_FactoryLines]
--SELECT * FROM [Options V2_SpecLines]


DECLARE @OT AS TABLE ([option#s] NVARCHAR(MAX))
INSERT INTO @OT VALUES 
('End Dump 3X-00069'),
('End Dump 3X-00070'),
('End Dump 3X-00131'),
('End Dump 3X-00133')

SELECT [SGQuote] FROM [Order OptionsV2] WHERE [SGQuote] = 'SG100498' AND [Option No] IN (SELECT [option#s] FROM @OT) GROUP BY [SGQuote] HAVING COUNT(*) > 1


SELECT [Model No], [Option No], [Line#], [SpecSortG], [SpecSection], [SpecSortSe], [SpecDescription], [SpecSortSeLine] FROM [Options_SpecLinesV2] WHERE [Model No] = 'End Dump 3X' AND [SpecSortSeLine] = -88