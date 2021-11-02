USE BWSdb
GO

SELECT * FROM [Orders] INNER JOIN [Sales Staff] ON [Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff] WHERE [WO#] = 10015343

BEGIN TRAN;

DECLARE @WO BIGINT;
SET @WO = 10015343;

SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = @WO
	AND [Description] LIKE '%120%'
;

UPDATE
	[Order Options]
SET
	[Blast] = 1,
	[Paint] = 2
WHERE
	[WO#] = @WO
	AND [Description] LIKE '%120%'
	
SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] = @WO
	AND [Description] LIKE '%120%'
;

SELECT
	*
FROM
	[Order Options]
WHERE
	[WO#] IN (10015343)
;

ROLLBACK;
COMMIT;


