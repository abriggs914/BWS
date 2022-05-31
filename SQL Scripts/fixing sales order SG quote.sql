USE BWSdb
GO

BEGIN TRAN;

SELECT [Sales Order#], * FROM [OrdersV2] WHERE [SGQuote] = 'SG100121';

UPDATE 
	[OrdersV2]
SET
	[Sales Order#] = 500532
WHERE
	[SGQuote] = 'SG100121'
	
SELECT [DataEntryUser], [Sales Order#], * FROM [OrdersV2] WHERE [SGQuote] = 'SG100121';

ROLLBACK;
COMMIT;