USE BWSdb
GO

SELECT * FROM [Orders] WHERE [WO#] = 10015165

BEGIN TRAN;

DECLARE @WO BIGINT;
SET @WO = 10015164;

SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = @WO
	AND [Description] LIKE '%Galv%'
;

UPDATE
	[Order Options]
SET
	[Weight] = 1450
WHERE
	[WO#] = @WO
	AND [Description] LIKE '%Galv%'
	
SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = @WO
	AND [Description] LIKE '%Galv%'
;

ROLLBACK;
COMMIT;



SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] IN (10015163, 10015164, 10015165, 10015209)
;