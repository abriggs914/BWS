/* SQL
 Date: 2024-05-13 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - INSERT - 2024-05-13 12:18:42

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-21 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-13 12:18:42',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101636'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-06-21 00:00:00'
WHERE
	[SGQuote] = 'SG101636'
;

ROLLBACK;
COMMIT;