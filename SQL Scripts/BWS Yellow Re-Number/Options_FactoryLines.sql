USE BWSdb
GO

DECLARE @oldNum AS VARCHAR(12);
SET @oldNum = '%PPG#920612%'

SELECT
	*
FROM
	[Options]
WHERE
	[Description] LIKE @oldNum
	
SELECT
	*
FROM
	[Options_SpecLines]
WHERE
	[SpecDescription] LIKE @oldNum
	
SELECT
	*
FROM
	[Options_FactoryLines]
WHERE
	[SpecDescription] LIKE @oldNum














BEGIN TRAN;

SELECT
	*
FROM
	[Options_FactoryLines]
WHERE
	[SpecDescription] LIKE @oldNum


UPDATE
	[Options_FactoryLines]
SET
	[SpecDescription] = LEFT([Description], PATINDEX(@oldNum, [SpecDescription]) - 1) + 'PPG#911699' + RIGHT([SpecDescription], LEN([SpecDescription]) - ((PATINDEX(@oldNum, [SpecDescription]) - 1) + (LEN(@oldNum) - 2)))
WHERE
	[SpecDescription] LIKE @oldNum

SELECT
	*
FROM
	[Options_FactoryLines]
WHERE
	[SpecDescription] LIKE @oldNum
SELECT
	*
FROM
	[Options_FactoryLines]
WHERE
	[SpecDescription] LIKE '%PPG#911699%'

ROLLBACK;
COMMIT;