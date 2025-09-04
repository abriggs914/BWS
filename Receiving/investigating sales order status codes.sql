DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [SO] INT);
INSERT INTO @t ([SO]) VALUES
	(115154),
	(115218),
	(115131),
	(115275),
	(115295),
	(115052),
	(115291),
	(115312),
	(115189)
;


SELECT 
	*
FROM
	@t [T]
LEFT JOIN
	[SysproCompanyA].[dbo].[SorDetail] [SD]
ON
	RIGHT('000000000000000' + CAST([T].[SO] AS NVARCHAR(MAX)), 15) = [SD].[SalesOrder]
WHERE
	ISNULL([SD].[MStockCode], '') <> ''
ORDER BY
	[SD].[MBin],
	[SD].[SalesOrder]
;


SELECT 
	*
FROM
	@t [T]
LEFT JOIN
	[SysproCompanyA].[dbo].[SorMaster] [SD]
ON
	RIGHT('000000000000000' + CAST([T].[SO] AS NVARCHAR(MAX)), 15) = [SD].[SalesOrder]
ORDER BY
	[SD].[SalesOrder]
;


DECLARE @SorOrderStatusLookup TABLE (
    [StatusCode] VARCHAR(2) PRIMARY KEY,
    [Description] VARCHAR(100)
);

INSERT INTO @SorOrderStatusLookup ([StatusCode], Description)
VALUES
    ('1', 'Open Order'),
    ('2', 'Open Backorder'),
    ('3', 'Released backorder'),
    ('4', 'In Warehouse'),
    ('9', 'Ready to Invoice'),
    ('S', 'Suspended'),
    ('*', 'Cancelled during entry'),
    ('\', 'Cancelled');  -- Note: You need to escape backslash in some environments




SELECT * FROM [SysproCompanyA].[dbo].[v_OpenSalesOrders] [SD]
;

SELECT
	[SD].[OrderStatus],
	[SL].[Description],
	COUNT(*) AS [Total],
	MAX([SD].[SalesOrder]) AS [LastSO],
	MAX([SD].[OrderDate]) AS [LastSODate]
FROM
	[SysproCompanyA].[dbo].[SorMaster] [SD]
INNER JOIN
	@SorOrderStatusLookup [SL]
ON
	[SD].[OrderStatus] = [SL].[StatusCode]
WHERE
	[SD].[OrderStatus] IS NOT NULL
GROUP BY
	[SD].[OrderStatus],
	[SL].[Description]
ORDER BY
	[Total]


SELECT 
    SD.OrderStatus,
    CASE CAST(SD.OrderStatus AS VARCHAR)
        WHEN '1' THEN 'Live / Open'
        WHEN '2' THEN 'Complete'
        WHEN '3' THEN 'Lost Sale'
        WHEN '4' THEN 'Cancelled'
        WHEN '5' THEN 'On Hold'
        WHEN '6' THEN 'Archived / Invoiced?'
        WHEN '7' THEN 'Back Order / Dispatched'
        WHEN '8' THEN 'Ready for Invoicing'
        WHEN '9' THEN 'Closed'
        WHEN 'S' THEN 'Saved / Suspended / Staged'
        ELSE 'Unknown'
    END AS StatusDescription,
    COUNT(*) AS Total,
    MIN(SD.SalesOrder) AS FirstSO,
    MAX(SD.SalesOrder) AS LastSO,
    MAX(SD.OrderDate) AS LastSODate
FROM 
    [SysproCompanyA].[dbo].[SorMaster] SD
WHERE 
    SD.OrderStatus IS NOT NULL
GROUP BY 
    SD.OrderStatus
ORDER BY 
    Total DESC;



SELECT TOP 10 * FROM [SysproCompanyA].[dbo].MdnMasterCons
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].MdnMasterRepCon
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].MrpQotSoMasterHdr
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].MrpSoMasterHdr
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].QotSoMasterHdr
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].SorArcMaster
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].SorMaster
SELECT TOP 10 * FROM [SysproCompanyA].[dbo].SorMasterRep


SELECT
	[IW].[StockCode],
	[IW].[DefaultBin],
	*
FROM
	[SysproCompanyA].[dbo].[InvWarehouse] [IW]
WHERE
    ([IW].[StockCode] = '402521-KIT')
    AND ([IW].[Warehouse] = '01')
;


/*
SELECT
	[IM].[StockCode],
	[IM].[bin],
	*
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
WHERE
    ([IM].[StockCode] = '402521-KIT')
    AND ([IM].[Warehouse] = '01')
*/