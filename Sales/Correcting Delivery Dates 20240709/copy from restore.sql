USE BWSdb_20240709
GO

BEGIN TRAN;

	
SELECT
	[SGQuote]
	,[Delivery Date]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Delivery Date] = [N].[Delivery Date]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	[BWSdb_20240709].[dbo].[OrdersV2] [N]
ON
	[O].[SGQuote] = [N].[SGQuote]

	
SELECT
	[SGQuote]
	,[Delivery Date]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]

ROLLBACK;
COMMIT;