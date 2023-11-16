USE BWSdb
GO

BEGIN TRAN;

DECLARE 
	@nineNine NVARCHAR(MAX)
	,@cdnPrice MONEY
	,@usPrice MONEY
;

SELECT	@nineNine = '99000014',	@cdnPrice = 218.71,	@usPrice = 189.56;


SELECT
	*
FROM
	[Options]
WHERE
	[Draw/Part#] = @nineNine

UPDATE
	[Options]
SET
	[Price] = @cdnPrice
	,[US Price] = @usPrice
WHERE
	[Draw/Part#] = @nineNine
	
SELECT
	*
FROM
	[Options]
WHERE
	[Draw/Part#] = @nineNine

ROLLBACK;
COMMIT;
	
--SELECT
--	*
--FROM
--	[Budget Options]
--WHERE
--	[Price] IS NULL