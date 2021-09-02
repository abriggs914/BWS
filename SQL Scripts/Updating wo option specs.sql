USE BWSdb
GO

BEGIN TRAN;
SELECT * FROM [Order Options_SpecLines] WHERE [WO#] = 10015258 AND [ID] = 704214

UPDATE
	[Order Options_SpecLines]
SET
	[SpecDescription] = 'Keruing / Apitong Floor'
WHERE
	[WO#] = 10015258
	AND [ID] = 704214

SELECT * FROM [Order Options_SpecLines] WHERE [WO#] = 10015258 AND [ID] = 704214

ROLLBACK
COMMIT;