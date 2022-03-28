USE SysproCompanyA
GO

DECLARE @SC AS NVARCHAR(MAX) = '404132944';

SELECT 'A', [Warehouse], * FROM [WipMaster] WHERE [StockCode] = @SC
SELECT 'B', * FROM [InvMaster] WHERE [StockCode] = @SC
SELECT 'C', * FROM [InvWarehouse] WHERE [StockCode] = @SC
--SELECT 'D', * FROM [WipJobAllLab] WHERE [StockCode] = @SC
SELECT 'E', * FROM [WipJobAllMat] WHERE [StockCode] = @SC
SELECT 'F', * FROM [PorMasterDetail] WHERE [MStockCode] = @SC

EXEC [dbo].[sp_TopLevelWOReportJamieMultiV2] @WO='10015406;10015407;10015410', @INCOMPLETEONLY=0, @PARTCATEGORY='M;B;S', @OPERATION='04', @WAREHOUSE='01', @WORKCENTRE=NULL, @MACHINE=NULL;