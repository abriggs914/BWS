/* SQL */
/* Date: 2024-06-21 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-06-21 17:39:14*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-09-27 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-06-21 17:39:14',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101582'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-09-27 00:00:00'
WHERE
	[SGQuote] = 'SG101582'
;

ROLLBACK;
COMMIT;