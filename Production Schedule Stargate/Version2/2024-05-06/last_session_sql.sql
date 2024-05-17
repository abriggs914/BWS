/* SQL
 Date: 2024-05-16 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - INSERT - 2024-05-16 15:08:33*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-04 00:00:00',
	[JobAvailableLine] = 'WAR',
	[JobAvailableScheduled] = '2024-05-16 15:08:33',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG100027'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WAR',
	[JobFinishDate] = '2024-04-04 00:00:00'
WHERE
	[SGQuote] = 'SG100027'
;
/* SQL OUTPUT - INSERT - 2024-05-16 15:08:33*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-05 00:00:00',
	[JobAvailableLine] = 'WAR',
	[JobAvailableScheduled] = '2024-05-16 15:08:33',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG100025'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WAR',
	[JobFinishDate] = '2024-04-05 00:00:00'
WHERE
	[SGQuote] = 'SG100025'
;
/* SQL OUTPUT - INSERT - 2024-05-16 15:08:33*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2025-04-18 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-16 15:08:33',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG100404'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2025-04-18 00:00:00'
WHERE
	[SGQuote] = 'SG100404'
;
/* SQL OUTPUT - INSERT - 2024-05-16 15:08:33*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2025-04-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-16 15:08:33',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG100291'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2025-04-17 00:00:00'
WHERE
	[SGQuote] = 'SG100291'
;
/* SQL OUTPUT - INSERT - 2024-05-16 15:08:33*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2025-04-18 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-16 15:08:33',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG100026'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2025-04-18 00:00:00'
WHERE
	[SGQuote] = 'SG100026'
;
/* SQL OUTPUT - INSERT - 2024-05-16 15:08:33*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2025-04-17 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-16 15:08:33',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG100051'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2025-04-17 00:00:00'
WHERE
	[SGQuote] = 'SG100051'
;

ROLLBACK;
COMMIT;