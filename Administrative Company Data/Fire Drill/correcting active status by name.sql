USE BWSdb
GO


BEGIN TRAN;

UPDATE
	[ITR Customers]
SET
	[Active] = 0
WHERE
	[Name] = 'Savanah Cullins'
;

SELECT
	*
FROM
	[ITR Customers]
WHERE
	([Active] = 1)
	AND ([Company] = 'BWS')
	AND ([Name] NOT IN (
		'UNKNOWN'
		,'Receiving _'
		,'Receiving'
		,'Eng Desk'
		,'Parts Desk'
		,'Warehouse'
	))

ROLLBACK;
COMMIT;