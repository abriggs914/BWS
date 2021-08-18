USE BWSdb
GO

SELECT
	*
FROM
	[Order Hours]
WHERE
	[WO#] = 10014924
;
	
SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = 10014924

SELECT
	*
FROM
	[Options]
WHERE
	[Model No] LIKE '%35ADG2X NR%'
	AND [Description] LIKE '%tool%'

SELECT
	*
FROM
	[Options_FactoryLines]
WHERE
	[Model No] LIKE '%35ADG2X NR%'
	AND [Description] LIKE '%tool%'

SELECT
	*
FROM
	[Standards]
WHERE
	[Model No] LIKE '%35ADG2X NR%'



BEGIN TRAN;

SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = 10014924
	AND [Description] LIKE '%tool%'
;

UPDATE
	[Order Options]
SET
	[Line] = 0.9,
	[Step 2] = 0.9,
	[Blast] = 0.1,
	[Paint] = 0.1
WHERE
	[WO#] = 10014924
	AND [Description] LIKE '%tool%'
;

SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = 10014924
	AND [Description] LIKE '%tool%'
;

ROLLBACK;
COMMIT;