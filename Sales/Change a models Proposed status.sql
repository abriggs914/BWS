USE BWSdb
GO

SELECT
	*
FROM 
	[Products]
WHERE
	[Model No] = '33LBT3X W'


BEGIN TRAN;


SELECT
	*
FROM 
	[Products]
WHERE
	[Model No] = '33LBT3X W'
UPDATE
	[Products]
SET
	[Proposed] = 0
WHERE
	[Model No] = '33LBT3X W'
SELECT
	*
FROM 
	[Products]
WHERE
	[Model No] = '33LBT3X W'

ROLLBACK;
COMMIT;