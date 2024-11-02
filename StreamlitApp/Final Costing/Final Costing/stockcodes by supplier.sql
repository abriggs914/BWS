DECLARE @job NVARCHAR(20) = '10012345'

-- Phase 1: Parts in WO BOM
SELECT [WipMaster].*
    , BomStructure.*
    , [ApSupplier].*
FROM
    [SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
INNER JOIN
    [SysproCompanyA].[dbo].[BomStructure] WITH (NOLOCK)
ON
    [WipMaster].[StockCode] = [BomStructure].[ParentPart]
INNER JOIN
    [SysproCompanyA].[dbo].[InvMaster] WITH (NOLOCK)
ON
    [BomStructure].[Component] = [InvMaster].[StockCode]
INNER JOIN
    [SysproCompanyA].[dbo].[ApSupplier] WITH (NOLOCK)
ON
    [InvMaster].[Supplier] = [ApSupplier].[Supplier]
WHERE
    [WipMaster].[Job] = @job

-- Phase 2: Flattened WO BOM
DECLARE @StockCode NVARCHAR(30)

SELECT @StockCode = [WipMaster].[StockCode]
FROM
    [SysproCompanyA].[dbo].[WipMaster] WITH (NOLOCK)
WHERE
    [WipMaster].[Job] = @job

EXEC [SysproCompanyA].[dbo].[sp_FlattenedBOMExcelExport_AnyStockCode] @StockCode, 0

-- Stargate version of sp_FlattenedBOMExcelExport_AnyStockCode doesn't exist yet