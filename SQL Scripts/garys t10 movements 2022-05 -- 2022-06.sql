USE BWSdb


BEGIN TRAN;

SELECT * FROM [dtProductionSchedule] WHERE [WO#] IN (10015349, 10015350, 10015360, 10015361, 10015362)

UPDATE 
	[dtProductionSchedule]
SET
	[Prod Date 1] = '2022-05-12'
WHERE
	[WO#] = 10015349

UPDATE 
	[dtProductionSchedule]
SET
	[Prod Date 1] = '2022-05-19'
WHERE
	[WO#] = 10015350

UPDATE 
	[dtProductionSchedule]
SET
	[Prod Date 1] = '2022-06-07'
WHERE
	[WO#] = 10015360

UPDATE 
	[dtProductionSchedule]
SET
	[Prod Date 1] = '2022-06-09'
WHERE
	[WO#] = 10015361

UPDATE 
	[dtProductionSchedule]
SET
	[Prod Date 1] = '2022-06-10'
WHERE
	[WO#] = 10015362
	
UPDATE 
	[dtProductionSchedule]
SET
	[ApplyUpdate] = 1,
	[ApplyUpdateUser] = 'abriggs'
WHERE
	[WO#] IN (10015349, 10015350, 10015360, 10015361, 10015362)
	
SELECT * FROM [dtProductionSchedule] WHERE [WO#] IN (10015349, 10015350, 10015360, 10015361, 10015362)

EXEC sp_ProductionSchedule_V4_UpdateLiveTablesV2 @apupdateuser = 'abriggs'

ROLLBACK;
COMMIT;

--SELECT [ApplyUpdate] FROM [Orders]
