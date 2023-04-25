USE BWSdb
GO


SELECT TOP 100 [SGQuote], DataEntryCheck, DataEntryUser FROM OrdersV2


BEGIN TRAN;
SELECT [SGQuote], DataEntryCheck, DataEntryUser FROM OrdersV2 WHERE [DataEntryCheck] = 1
UPDATE
	OrdersV2
SET
	[DataEntryCheck] = 0
	, [DataEntryUser] = NULL
WHERE
	[DataEntryCheck] = 1
	
;
SELECT [SGQuote], DataEntryCheck, DataEntryUser FROM OrdersV2 WHERE [DataEntryCheck] = 1

ROLLBACK;
COMMIT;