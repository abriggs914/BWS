USE BWSdb
GO

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;
SET @StartDate = '2020-07-01'
SET @EndDate = '2021-07-02'

EXEC [dbo].[sp_defectsReceivingBySupplierReport] @StartDate=@StartDate, @EndDate=@EndDate