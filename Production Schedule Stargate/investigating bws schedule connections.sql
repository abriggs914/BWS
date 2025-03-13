SELECT
	*
FROM
	[BWSdb].[dbo].[Production]
;
SELECT
	*
FROM
	[BWSdb].[dbo].[dtProductionSchedule]
;

SELECT
  dtProductionSchedule.[Quote#],
  Production.[Prod#],
  dtProductionSchedule.[WO#],
  Production.[GN WO#],
  dtProductionSchedule.InputField1,
  Orders.Width,
  Orders.Spread,
  dtProductionSchedule.[WO Line 1],
  dtProductionSchedule.[Prod Date 1],
  dtProductionSchedule.[WO Line 2],
  dtProductionSchedule.[Prod Date 2],
  dtProductionSchedule.[Prod On],
  dtProductionSchedule.[Prod On Time],
  dtProductionSchedule.[Prod Off],
  dtProductionSchedule.[Prod Off Time],
  dtProductionSchedule.[Prod PM],
  dtProductionSchedule.[Prod2 On],
  dtProductionSchedule.[Prod2 On Time],
  dtProductionSchedule.[Prod2 Off],
  dtProductionSchedule.[Prod2 Off Time],
  dtProductionSchedule.[Prod2 PM],
  dtProductionSchedule.[Prod2 Complete],
  dtProductionSchedule.[Prod Complete],
  Production.[Prod Instructions],
  dtProductionSchedule.ApplyUpdate,
  dtProductionSchedule.ApplyUpdateUser
FROM [BWSdb].[dbo].Production
RIGHT JOIN ([BWSdb].[dbo].dtProductionSchedule
            LEFT JOIN [BWSdb].[dbo].Orders ON dtProductionSchedule.[Quote#]=Orders.[Quote#]) ON Production.[WO#]=Orders.[WO#]
WHERE (((dtProductionSchedule.[Prod Date 1]) Between '2025-02-12' And '2025-03-12')
       And ((dtProductionSchedule.[Prod2 Complete])=0
            Or (dtProductionSchedule.[Prod2 Complete]) Is Null));
;