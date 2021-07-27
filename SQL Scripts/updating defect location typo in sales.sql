USE BWSdb
GO

BEGIN TRAN;

SELECT * FROM [Defects_Location] WHERE [LocationID#] = 39

UPDATE
	[Defects_Location]
SET
	[Location] = 'Sales'
WHERE
	[LocationID#] = 39

SELECT * FROM [Defects_Location] WHERE [LocationID#] = 39

ROLLBACK;
COMMIT;