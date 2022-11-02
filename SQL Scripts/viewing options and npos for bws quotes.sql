USE BWSdb
GO

DECLARE @t AS TABLE([Quote] INT, [Model No] NVARCHAR(MAX), [Dealer] INT, [Customer] INT, [WO] NVARCHAR(8));
INSERT INTO @t ([Quote]) VALUES
(28070),
(22783),
(28062)
;

UPDATE
	@t
SET
	[Model No] = [Orders].[Model No]
	, [Dealer] = [Orders].[DealerID]
	, [Customer] = [Orders].[CustID]
	, [WO] = [Orders].[WO#]
FROM
	[Orders]
WHERE
	[@t].[Quote] = [Orders].[Quote#]
;

-- quote specific selects
SELECT 'Orders' AS [T], * FROM [Orders] INNER JOIN @t ON [Orders].[Quote#] = [@t].[Quote]
SELECT 'Order Options' AS [T], * FROM [Order Options] INNER JOIN @t ON [Order Options].[Quote#] = [@t].[Quote]
SELECT 'Order Options_FactoryLines' AS [T], * FROM [Order Options_FactoryLines] INNER JOIN @t ON [Order Options_FactoryLines].[Quote#] = [@t].[Quote]
SELECT 'Order Options_SpecLines' AS [T], * FROM [Order Options_SpecLines] INNER JOIN @t ON [Order Options_SpecLines].[Quote#] = [@t].[Quote]
SELECT 'Design' AS [T], * FROM [Design] INNER JOIN @t ON [Design].[Quote#] = [@t].[Quote]
SELECT 'Customers' AS [T], * FROM [Customers] INNER JOIN @t ON [Customers].[ID#] = [@t].[Customer]
SELECT 'Production' AS [T], * FROM [Production] INNER JOIN @t ON [Production].[Quote#] = [@t].[Quote]
SELECT 'Order Hours' AS [T], * FROM [Order Hours] INNER JOIN @t ON [Order Hours].[Quote#] = [@t].[Quote]
SELECT 'dtProductionSchedule' AS [T], * FROM [dtProductionSchedule] INNER JOIN @t ON [dtProductionSchedule].[Quote#] = [@t].[Quote]

-- quote specific NPOs
SELECT 'Custom Work' AS [T], * FROM [Custom Work] INNER JOIN @t ON [Custom Work].[Quote#] = [@t].[Quote]
SELECT 'Custom Work_FactoryLines' AS [T], * FROM [Custom Work_FactoryLines] INNER JOIN @t ON [Custom Work_FactoryLines].[Quote#] = [@t].[Quote]
SELECT 'Custom Work_SpecLines' AS [T], * FROM [Custom Work_SpecLines] INNER JOIN @t ON [Custom Work_SpecLines].[Quote#] = [@t].[Quote]

-- non quote specific selects
SELECT 'Products' AS [T], * FROM [Products] INNER JOIN @t ON [Products].[Model No] = [@t].[Model No]
SELECT 'Standards' AS [T], * FROM [Standards] INNER JOIN @t ON [Standards].[Model No] = [@t].[Model No]
SELECT 'Order Standards' AS [T], * FROM [Order Standards] INNER JOIN @t ON [Order Standards].[Quote#] = [@t].[Quote]

-- non quote specific options
SELECT 'Options' AS [T], * FROM [Options] INNER JOIN @t ON [Options].[Model No] = [@t].[Model No]
SELECT 'Budget Options' AS [T], * FROM [Budget Options] INNER JOIN @t ON [Budget Options].[Model No] = [@t].[Model No]
SELECT 'Options_FactoryLines' AS [T], * FROM [Options_FactoryLines] INNER JOIN @t ON [Options_FactoryLines].[Model No] = [@t].[Model No]
SELECT 'Options_SpecLines' AS [T], * FROM [Options_SpecLines] INNER JOIN @t ON [Options_SpecLines].[Model No] = [@t].[Model No]

-- wo specific selects
SELECT 'Defects' AS [T] FROM [Defects] INNER JOIN @t ON [Defects].[WO#] = [@t].[WO]
SELECT 'Defects_BPF' AS [T] FROM [Defects_BPF] INNER JOIN @t ON [Defects_BPF].[WO#] = [@t].[WO]
SELECT 'Defects_Print' AS [T] FROM [Defects_Print] INNER JOIN @t ON [Defects_Print].[WO#] = [@t].[WO]
SELECT 'Defects_Snags' AS [T] FROM [Defects_Snags] INNER JOIN @t ON [Defects_Snags].[WO#] = [@t].[WO]

-- syspro selects
SELECT 'WipJobAllLab' AS [T], * FROM [SysproCompanyA].[dbo].[WipJobAllLab] INNER JOIN @t ON [WipJobAllLab].[Job] COLLATE DATABASE_DEFAULT = [@t].[WO] COLLATE DATABASE_DEFAULT
SELECT 'WipJobAmendJnl' AS [T], * FROM [SysproCompanyA].[dbo].[WipJobAmendJnl] INNER JOIN @t ON [WipJobAmendJnl].[Job] COLLATE DATABASE_DEFAULT = [@t].[WO] COLLATE DATABASE_DEFAULT
SELECT 'ClkTransaction' AS [T], * FROM [SysproCompanyA].[dbo].[ClkTransaction] INNER JOIN @t ON [ClkTransaction].[JobNumber] COLLATE DATABASE_DEFAULT = [@t].[WO] COLLATE DATABASE_DEFAULT