
USE SysproCompanyA
GO

SELECT
	*
FROM
	INFORMATION_SCHEMA.COLUMNS
WHERE
	LOWER([COLUMN_NAME]) LIKE '%serial%'
	--[COLUMN_NAME] LIKE '%serial%'
ORDER BY
	[TABLE_NAME],
	[COLUMN_NAME]
;

DECLARE @SC NVARCHAR(MAX) = '402154-AXN';
SELECT * FROM [InvSerialHead] WHERE [StockCode] = @SC
SELECT * FROM [InvSerialTrack] WHERE [StockCode] = @SC
--SELECT * FROM [InvControl] WHERE [MStockCode] = @SC
SELECT * FROM [InvInspectSerial] WHERE [StockCode] = @SC
--SELECT * FROM [InvInspectDet] WHERE [StockCode] = @SC
SELECT * FROM [InvStockTakeSerial] WHERE [StockCode] = @SC
SELECT * FROM [WipAllMatSer] WHERE [StockCode] = @SC
SELECT * FROM [WipAllMatLot] WHERE [StockCode] = @SC
SELECT * FROM [WipReservedSerial] WHERE [StockCode] = @SC
SELECT * FROM [InvSerialCrossRef] WHERE [StockCode] = @SC
SELECT * FROM [WipJobPost] WHERE [MStockCode] = @SC
--SELECT * FROM [SorMaster] WHERE [MStockCode] = @SC
SELECT * FROM [SorDetail] WHERE [MStockCode] = @SC
--SELECT * FROM [SorDetailSer] WHERE [MStockCode] = @SC
--SELECT * FROM [WipJobPostSer] WHERE [MStockCode] = @SC

--SELECT * FROM [InvSerialHead] WHERE [Serial] = '2XBB6GW2XRA001106';
--SELECT * FROM [InvSerialCrossRef] WHERE	[Serial] = '2XBB6GW2XRA001106';
--SELECT * FROM [InvSerialTrn] WHERE [Serial] = '2XBB6GW2XRA001106';
--SELECT * FROM [InvSerialTrack] WHERE [Serial] = '2XBB6GW2XRA001106';
