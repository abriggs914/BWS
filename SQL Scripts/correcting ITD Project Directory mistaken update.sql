USE BWSdb
GO

SELECT
	*
FROM
	[ITD Project Directory]
	
USE BWSdb_Restore_202404231629
GO

SELECT
	*
FROM
	[ITD Project Directory]


BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[ITD Project Directory]

UPDATE
	[BWSdb].[dbo].[ITD Project Directory]
SET
	[Description] = [N].[Description]
	,[LongName] = [N].[LongName]
FROM
	[BWSdb_Restore_202404231629].[dbo].[ITD Project Directory] AS [N]
WHERE
	[ITD Project Directory].[Acronym] = [N].[Acronym]

SELECT
	*
FROM
	[BWSdb].[dbo].[ITD Project Directory]


ROLLBACK;
COMMIT;