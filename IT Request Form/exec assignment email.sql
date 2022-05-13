BEGIN TRAN;

UPDATE
	[IT Requests]
SET
	[ITPersonAssignedID] = 4
WHERE
	[ITRequestID#] = 582

ROLLBACK:
COMMIT;