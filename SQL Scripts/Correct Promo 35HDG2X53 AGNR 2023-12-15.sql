USE BWSdb
GO

SELECT TOP 5 [Promo Drawing] FROM [Products]

BEGIN TRAN;

DECLARE @pth AS NVARCHAR(MAX) = '\\server4\Design\DRAWINGS\Promos\9A) PROMOS BY MODEL 2021\Hydraulics (2021)\35HDG2X53 AGC (40936412) (2021).pdf#';

SELECT
	*
FROM
	[Products]
WHERE
	[Model No] = '35HDG2X53 AGNR'
	OR [Model No] = '35HDG2X53 AGC'
;


UPDATE
	[Products]
SET
	[Promo Drawing] = CAST([Promo Drawing] AS NVARCHAR(MAX)) + '#' + CAST([Promo Drawing] AS NVARCHAR(MAX)) + '#'
FROM
	[Products] AS [P]
WHERE
	[Model No] = '35HDG2X53 AGNR'
	OR [Model No] = '35HDG2X53 AGC'
;

SELECT
	*
FROM
	[Products]
WHERE
	[Model No] = '35HDG2X53 AGNR'
	OR [Model No] = '35HDG2X53 AGC'
;

ROLLBACK;
COMMIT;