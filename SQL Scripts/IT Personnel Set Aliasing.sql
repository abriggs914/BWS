
BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[IT Personnel]
;	

UPDATE
	[BWSdb].[dbo].[IT Personnel]
SET
	[UseAccessAlias] = 0
WHERE
	[ITPersonID#] = 4
;

SELECT
	*
FROM
	[BWSdb].[dbo].[IT Personnel]
;

ROLLBACK;
COMMIT;