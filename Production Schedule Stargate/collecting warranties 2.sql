
DECLARE @warJobs AS TABLE (
	[ID] INT IDENTITY(0, 1), 
	[Job] NVARCHAR(MAX), 
	[LastVin] NVARCHAR(MAX)
);

INSERT INTO @warJobs ([Job], [LastVin]) VALUES
('3000236', '9747'),
('30000239', '9756'),
('30000210', 'RM000184'),
('30000235', '3202')

	
SELECT
	'G' AS [G]
	,[O].[WO#]
	,[O].[Serial Number]
	,*
FROM
	[SysproCompanyS].[dbo].[WipMaster] AS [WM]
FULL JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O]
ON
	RIGHT(ISNULL([WM].[StockDescription], '    '), 4) COLLATE DATABASE_DEFAULT = RIGHT(ISNULL([O].[Serial Number], '    '), 4)
WHERE
	--(
	(LEFT([Job], 1) = '3')
	--OR (ISNULL([JobClassification], '') = 'WAR'))
	AND (ISNULL([StockDescription], '') <> '')
	AND ([SGQuote] IS NOT NULL)
ORDER BY
	[WM].[Job]
;

-------------------------------------------------------------------------------------------------

SELECT
	'G' AS [G]
	,[O].[WO#]
	,[O].[Serial Number]
	,*
FROM
	[SysproCompanyS].[dbo].[WipMaster] AS [WM]
FULL JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O]
ON
	RIGHT(ISNULL([WM].[StockDescription], '    '), 4) COLLATE DATABASE_DEFAULT = RIGHT(ISNULL([O].[Serial Number], '    '), 4)
INNER JOIN
	@warJobs [W]
ON
	[WM].[Job] COLLATE DATABASE_DEFAULT = [W].[Job]
WHERE
	--(
	(LEFT([WM].[Job], 1) = '3')
	--OR (ISNULL([JobClassification], '') = 'WAR'))
	AND (ISNULL([WM].[StockDescription], '') <> '')
	AND ([O].[SGQuote] IS NOT NULL)
ORDER BY
	[WM].[Job]
;
