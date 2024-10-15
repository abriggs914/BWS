SELECT * FROM [BWSdb].[dbo].[Employees] WHERE [1st Name] LIKE '%RAN%';
SELECT * FROM [BWSdb].[dbo].[Employees - Salary] WHERE [1st Name] LIKE '%RAN%';

SELECT * FROM [SysproCompanyA].[dbo].[v_TLWRAllOperations];
SELECT * FROM [SysproCompanyA].[dbo].[v_ProdOperationNames];
SELECt * FROM [BWSdb].[dbo].[ITSTR_AppDirectory];


SELECT * FROM [SysproCompanyA].[dbo].[v_ProdOperationNames] ORDER BY [Operation];
SELECT * FROM [SysproCompanyS].[dbo].[v_ProdOperationNames] ORDER BY [Operation];

DECLARE @d0 DATETIME = '2024-07-19';
DECLARE @d1 DATETIME = '2024-07-31 23:59:59';

SELECT
	[JobNumber]
	,[Operation]
	,MIN([LoggedOn]) AS [FirstLogOn]
	,MAX([LoggedOn]) AS [LastLogOn]
FROM
	[SysproCompanyA].[dbo].[ClkTransaction]
WHERE
	--([LoggedOn] BETWEEN @d0 AND @d1 )
	--AND 
	(LEFT(ISNULL([JobNumber], ''), 1) = '1')
GROUP BY
	[Operation]
	,[JobNumber]
ORDER BY
	[JobNumber]
	,[Operation]

--------------------------
	
SELECT
	[EmployeeNumber]
	,[JobNumber]
	,[Operation]
	,MIN([LoggedOn]) AS [FirstLogOn]
	,MAX([LoggedOn]) AS [LastLogOn]
FROM
	[SysproCompanyA].[dbo].[ClkTransaction]
WHERE
	--([LoggedOn] BETWEEN @d0 AND @d1 )
	--AND 
	(LEFT(ISNULL([JobNumber], ''), 1) = '1')
GROUP BY
	[Operation]
	,[JobNumber]
	,[EmployeeNumber]
ORDER BY
	[JobNumber]
	,[Operation]
	,[EmployeeNumber]


--------------------


SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ClkTransaction]
WHERE
	[LoggedOn] 
BETWEEN
	@d0 AND @d1 
ORDER BY 
	[LoggedOn]
;

------------------

SELECT
	[Operation]
	,MIN([LoggedOn]) AS [FirstLogOn]
	,MAX([LoggedOn]) AS [LastLogOn]
FROM
	[SysproCompanyA].[dbo].[ClkTransaction]
WHERE
	[LoggedOn] 
BETWEEN
	@d0 AND @d1 
GROUP BY
	[Operation]
ORDER BY 
	[LoggedOn]
;


SELECT * FROM [BWSdb].[dbo].[Order Options]
SELECT * FROM [SysproCompanyA].[dbo].[WipJobAllMat] WHERE [Job] = '10017165' ORDER BY [OperationOffset];
SELECT * FROM [SysproCompanyA].[dbo].[WipJobPost] WHERE [Job] = '10017165'
SELECT * FROM [SysproCompanyA].[dbo].[WipJobPostBin] WHERE [Job] = '10017165'
SELECT * FROM [SysproCompanyA].[dbo].[WipJobPostSer] WHERE [Job] = '10017165'
SELECT * FROM [SysproCompanyA].[dbo].[WipMaster] WHERE [Job] = '10017165'
SELECT * FROM [SysproCompanyA].[dbo].[WipJobAmendJnl] WHERE [Job] = '10017165'



--DECLARE @wo NVARCHAR(MAX) = '10017165';
DECLARE @wo NVARCHAR(MAX) = '10017082';
SELECT 
	'Parts Used' AS [T]
	,[P].[TrnDate]
	,[M].[OperationOffset]
	,[P].[LOperation]
	,[M].[StockCode]
	,[P].[MStockCode]
	,[P].*
	,[M].*
	--,[J].*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [M]
FULL OUTER JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [P]
ON
	[P].[Job] = [M].[Job]
	AND [P].[MStockCode] = [M].[StockCode]
	--AND CAST([P].[LOperation] AS INT) = CAST([M].[OperationOffset] AS INT)
/*
FULL OUTER JOIN
	[SysproCompanyA].[dbo].[WipJobAmendJnl] [J]
ON
	([P].[Job] = [J].[Job])
	AND ([P].[MStockCode] = [J].[StockCode])
*/
WHERE
	([P].[Job] = @wo)
	AND ([TrnType] <> 'L')
;
SELECT 
	'Parts Left' AS [T]
	,[P].[TrnDate]
	,[M].[OperationOffset]
	,[P].[LOperation]
	,[M].[StockCode]
	,[P].[MStockCode]
	,[P].*
	,[M].*
	--,[J].*
FROM
	[SysproCompanyA].[dbo].[WipJobAllMat] [M]
LEFT JOIN
	[SysproCompanyA].[dbo].[WipJobPost] [P]
ON
	[P].[Job] = [M].[Job]
	AND [P].[MStockCode] = [M].[StockCode]
WHERE
	([M].[Job] = @wo)
	AND (([P].[Job] IS NULL) OR ([P].[MStockCode] IS NULL))
	AND ([TrnType] <> 'L')
;
	--AND CAST([P].[LOperation] AS INT) = CAST([M].[OperationOffset] AS INT)
/*
FULL OUTER JOIN
	[SysproCompanyA].[dbo].[WipJobAmendJnl] [J]
ON
	([P].[Job] = [J].[Job])
	AND ([P].[MStockCode] = [J].[StockCode])
*/


/*
DECLARE @wo NVARCHAR(MAX) = '10017165';
SELECT 
	*
FROM
	[SysproCompanyA].[dbo].[WipJobPost] [P]
INNER JOIN
	[SysproCompanyA].[dbo].[WipJobAmendJnl] [J]
ON
	[P].[Job] = [J].[Job]
	AND [P].[MStockCode] = [J].[StockCode]
	AND [P].[LOperation] = [J].[Operation]
WHERE
	[P].[Job] = @wo
*/


--ORDER BY [OperationOffset];