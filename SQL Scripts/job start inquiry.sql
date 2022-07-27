SELECT * FROM [ClkTransaction] WHERE [JobNumber] IN ('10015747', '10015647', '10016977')

SELECT * FROM [BWSdb].[dbo].[Production] WHERE [WO#] IN (10015747, 10015647, 10016977)
SELECT * FROM [BWSdb].[dbo].[dtProductionSchedule] WHERE [WO#] IN (10015747, 10015647, 10016977)

SELECT 
	DISTINCT
		[Beam Line]
		,[GN Line]
		,[FO Line]
		,[GN FO Line]
		,[Other Line]
		,[Prod line]
		,[Prod Line2]
FROM
	[BWSdb].[dbo].[Production]
--WHERE
--	[WO#] = 100015747
--GROUP BY
--		[Beam Line]
--		,[GN Line]
--		,[FO Line]
--		,[GN FO Line]
--		,[Other Line]
--		,[Prod line]
--		,[Prod Line2]
;

SELECT * FROM [BWSdb].[dbo].[dtProductionSchedule] WHERE [WO#] = 100015747