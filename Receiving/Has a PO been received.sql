/*
-- Has a PO been received? if so. highlight the YT record 

SELECT
	[YT].[WO]
	, [YT].[StockCode]
	, [YT].[QtyMissing]
	, [YT].[PO]
	, [PMD].[MReceivedQty]
	, *
FROM
	[BWSdb].[dbo].[v_PROD_YellowTags] [YT]
LEFT JOIN
	[SysproCompanyA].[dbo].[PorMasterDetail] [PMD]
ON
	([YT].[PO] = [PMD].[PurchaseOrder] COLLATE DATABASE_DEFAULT)
	AND ([YT].[StockCode] = [PMD].[MStockCode] COLLATE DATABASE_DEFAULT)
WHERE
	([YT].[Active] = 1)          -- Current YTs
	--AND ([YT].[PO] IS NOT NULL)  -- Purchase Order must be known
;

SELECT
	[IM].[StockCode]
	, [IM].[DrawOfficeNum]
FROM
	[SysproCompanyA].[dbo].[InvMaster] [IM]
WHERE
	LEFT([IM].[StockCode], 3) = '409'
*/

SELECT
	[WM].[Job],
	[O].[Model No],
	[WM].[JobDescription]
	--,
	--*
FROM
	[SysproCompanyA].[dbo].[WipMaster] [WM]
LEFT JOIN
	[BWSdb].[dbo].[Orders] [O]
ON
	[WM].[Job] COLLATE DATABASE_DEFAULT = CAST([O].[WO#] AS NVARCHAR(MAX))
WHERE
	--([WM].[ActCompleteDate] IS NULL)
	--OR
	ISNULL([WM].[JobStartDate], GETDATE()) >= DATEADD(DAY, -365, GETDATE())
GROUP BY
	[WM].[Job],
	[O].[Model No],
	[WM].[JobDescription]
ORDER BY
	[WM].[Job]

SELECT
    Production.[WO#],
    Production.[Model No]
FROM
    Production
GROUP BY
    Production.[WO#],
    Production.[Model No],
    Production.[Date Completed],
    Production.[Prod Date]
HAVING
    (
        (
            (Production.[Prod Date]) >= DateAdd(DAY, -365, GETDATE())
        )
        AND ((ISNULL ([Production].[WO#], 0)) <> 0)
    );




SELECT
	[WipMaster].[Job],
	[Orders].[Model No],
	[WipMaster].[JobDescription]
FROM
(	[WipMaster]
LEFT JOIN
	[Orders]
ON
	[WipMaster].[Job] = [Orders].[WO#])
WHERE
	NZ([WipMaster].[JobStartDate], now()) >= DATEADD("d", -365, now())
GROUP BY
	[WipMaster].[Job],
	[Orders].[Model No],
	[WipMaster][JobDescription]
ORDER BY
	[WipMaster].[Job]