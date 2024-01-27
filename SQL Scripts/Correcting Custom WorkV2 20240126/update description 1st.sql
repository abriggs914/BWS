USE BWSdb
GO

-- Update on ID join from backup table
-- Ran 1st

BEGIN TRAN;

SELECT
	'Before',
	[CW2].[ID],
	[RCW2].[ID],
	[CW2].[Description],
	[RCW2].[Description]
FROM
	[Custom WorkV2] AS [CW2]
FULL OUTER JOIN
	[BWSdb_Restore_202401252100].[dbo].[Custom WorkV2] AS [RCW2]
ON
	[CW2].[ID] = [RCW2].[ID]
;

UPDATE
	[Custom WorkV2] -- AS [CW2]
SET
	--[CW2].[Description] = ''
	[Description] = [RCW2].[Description]
FROM
	--[Custom WorkV2] AS [CW2]
	[Custom WorkV2] [CW2]
INNER JOIN
	[BWSdb_Restore_202401252100].[dbo].[Custom WorkV2] AS [RCW2]
ON
	[CW2].[ID] = [RCW2].[ID]
;

SELECT
	'After',
	[CW2].[ID],
	[RCW2].[ID],
	[CW2].[Description],
	[RCW2].[Description]
FROM
	[Custom WorkV2] AS [CW2]
FULL OUTER JOIN
	[BWSdb_Restore_202401252100].[dbo].[Custom WorkV2] AS [RCW2]
ON
	[CW2].[ID] = [RCW2].[ID]
;

ROLLBACK;
COMMIT;