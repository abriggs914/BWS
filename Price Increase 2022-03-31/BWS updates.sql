USE BWSdb
GO

DECLARE @INC AS MONEY;
SET @INC = 1.06;

-- Update
-- Products
-- Options
-- Budget Options
-- Master Options

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

SELECT * FROM [Budget Options];
UPDATE
	[Budget Options]
SET
	[Cost] = [Cost] * @INC
;
SELECT * FROM [Budget Options];

SELECT * FROM [Master Options];
UPDATE
	[Master Options]
SET
	[Cost] = [Cost] * @INC,
	[Price] = [Price] * @INC,
	[US Price] = [US Price] * @INC
;
SELECT * FROM [Master Options];


ROLLBACK;
COMMIT;
