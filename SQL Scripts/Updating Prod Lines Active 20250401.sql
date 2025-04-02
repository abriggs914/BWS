
BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[Prod Lines]
;

UPDATE
	[BWSdb].[dbo].[Prod Lines]
SET
	[Active] = 1
WHERE
	[Prod Line] IN (
		'T1',
		'T2',
		'T3',
		'T4',
		'T5',
		'T6',
		'T7',
		'T8',
		'T9',
		'T14',
		'T15',

		'AL1',
		'AL2',
		'GNK1',
		'GNK2',
		'GNK3',
		'B1',
		'B2',
		'B3',
		'T10',
		'T11',
		'T12',

		'TS1',
		'TS2'
	)

SELECT
	*
FROM
	[BWSdb].[dbo].[Prod Lines]
;


ROLLBACK;
COMMIT;