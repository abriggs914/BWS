USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.05;

BEGIN TRAN;

SELECT * FROM [Products];
UPDATE
	[Products]
SET
	[Price] = [Price] * @INC,
	[US Price] = [US Price] * @INC
;
SELECT * FROM [Products];

SELECT * FROM [Options];
UPDATE
	[Options]
SET
	[Price] = [Price] * @INC,
	[US Price] = [US Price] * @INC
;
SELECT * FROM [Options];
ROLLBACK;
COMMIT;
