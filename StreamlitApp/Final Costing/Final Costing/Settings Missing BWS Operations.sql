
SELECT
	*
FROM
	[BWSdb].[dbo].[ProductionOperations]
;

BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ProductionOperations]
SET
	[MachineCodeDescription] = '01 - Steel Kit'
	,[MachineCode] = '01'
WHERE
	([OperationNum] = 1)
	AND ([CompanyID] = 0)
;

UPDATE
	[BWSdb].[dbo].[ProductionOperations]
SET
	[MachineCodeDescription] = '02 - Beams'
	,[MachineCode] = '02'
WHERE
	([OperationNum] = 3)
	AND ([CompanyID] = 0)
;

UPDATE
	[BWSdb].[dbo].[ProductionOperations]
SET
	[MachineCodeDescription] = '21 - Gooseneck'
	,[MachineCode] = '21'
WHERE
	([OperationNum] = 4)
	AND ([CompanyID] = 0)
;

ROLLBACK;
COMMIT;