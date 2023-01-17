USE SysproCompanyA
GO

DECLARE @so AS NVARCHAR(MAX);
DECLARE @sc AS NVARCHAR(MAX);

SELECT @sc = '20ART-102-27728';
SELECT @so = [SalesOrder] FROM [SorDetail] WHERE [SorDetail].[MStockCode] = @sc;

SELECT * FROM [SorDetail] WHERE [SorDetail].[MStockCode] = @sc
SELECT * FROM [SorDetailRep] WHERE [SorDetailRep].[SalesOrder] = @so