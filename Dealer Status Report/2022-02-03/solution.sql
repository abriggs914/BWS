USE BWSdb
GO

BEGIN TRAN;

SELECT * FROM [Dealers]

UPDATE 
	[Dealers]
SET
	[SlotsRequestedPerMonth] = 11
WHERE
	[ID] = 430

SELECT * FROM [Dealers]

ROLLBACK;
COMMIT;