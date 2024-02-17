USE BWSdb
GO

BEGIN TRAN;

SELECT
	[DataEntryCheck]
	,[DataEntryUser]
FROM
	[OrdersV2]
WHERE
	[SGQuote] = 'SG101133'
;

UPDATE
	[OrdersV2]

SET
	[DataEntryCheck] = 0
	,[DataEntryUser] = NULL
WHERE
	[SGQuote] = 'SG101133'
;

SELECT
	[DataEntryCheck]
	,[DataEntryUser]
FROM
	[OrdersV2]
WHERE
	[SGQuote] = 'SG101133'

ROLLBACK;
COMMIT;
