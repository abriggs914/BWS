USE BWSdb
GO
SELECT * FROM [IT Requests]

BEGIN TRAN;

UPDATE
	[IT Requests]
SET
	[RequestedBy] = 'James Crawford'
WHERE
	[ITRequestID#] = 5

ROLLBACK;
COMMIT;