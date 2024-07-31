/* SQL */
/* Date: 2024-07-31 18:23:45 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-07-31 18:23:45*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-10-15 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-07-31 18:23:45',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101732'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-10-15 00:00:00'
WHERE
	[SGQuote] = 'SG101732'
;

ROLLBACK;
COMMIT;