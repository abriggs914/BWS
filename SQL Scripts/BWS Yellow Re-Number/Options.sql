USE BWSdb
GO

DECLARE @oldNum AS VARCHAR(12);
SET @oldNum = '%PPG#920612%'

BEGIN TRAN;

SELECT
	*
FROM
	[Options]
WHERE
	[Description] LIKE @oldNum

UPDATE
	[Options]
SET
	[Description] = LEFT([Description], PATINDEX(@oldNum, [Description]) - 1) + 'PPG#911699' + RIGHT([Description], LEN([Description]) - ((PATINDEX(@oldNum, [Description]) - 1) + (LEN(@oldNum) - 2)))
WHERE
	[Description] LIKE @oldNum

SELECT
	*
FROM
	[Options]
WHERE
	[Description] LIKE @oldNum

SELECT
	*
FROM
	[Options]
WHERE
	[Description] LIKE '%PPG#911699%'

SELECT
	*
FROM
	[Options]
WHERE
	[Description] LIKE '%PPG#911699%'

ROLLBACK;
COMMIT;