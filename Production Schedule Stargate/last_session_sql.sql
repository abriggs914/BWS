/* SQL */
/* Date: 2024-07-11 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-07-11 17:02:08*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-07-11 17:02:08',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;

ROLLBACK;
COMMIT;