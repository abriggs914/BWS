USE BWSdb
GO

SELECT
	*
FROM
	[Orders]
WHERE [WO#] = 10015773

BEGIN TRAN

--SELECT
--	*
--FROM
--	[Order Options]
--INNER JOIN
--	[Orders]
--ON
--	[Order Options].[Quote#] = [Orders].[Quote#]
--WHERE [Orders].[WO#] = 10015773

UPDATE
	[Order Options]
SET
	[Weight] = 700
WHERE
	[Option No] = '53ET4XP-00063'
AND [WO#] = 10015773
	
--SELECT
--	*
--FROM
--	[Order Options]
--INNER JOIN
--	[Orders]
--ON
--	[Order Options].[Quote#] = [Orders].[Quote#]
--WHERE [Orders].[WO#] = 10015773
--AND [Order Options].[WO#] = 10015773
--SELECT
--	*
--FROM
--	[Orders]
--WHERE [Orders].[WO#] = 10015773
--AND [WO#] = 10015773
--SELECT
--	*
--FROM
--	[Order Options]
--WHERE [Order Options].[WO#] = 10015773
--AND [WO#] = 10015773

--SELECT
--	*
--FROM
--	[Order Options]
--WHERE
--	[Option No] = '53ET4XP-00063'
--AND [WO#] = 10015773

ROLLBACK;
COMMIT;