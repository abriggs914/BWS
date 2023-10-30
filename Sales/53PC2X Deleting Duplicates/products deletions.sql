USE BWSdb
GO

DECLARE @mn AS NVARCHAR(MAX) = '53PC2X';

BEGIN TRAN;

SELECT
	*
FROM
	[Products]
WHERE 
	[Model No] = @mn
;

DELETE FROM
	[Products]
WHERE 
	[IDTrailer] = 2273
;

SELECT
	*
FROM
	[Products]
WHERE 
	[Model No] = @mn
;

ROLLBACK;
COMMIT;