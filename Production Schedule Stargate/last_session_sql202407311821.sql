/* SQL */
/* Date: 2024-07-31 18:21:35 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-07-31 18:21:35*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-19 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-07-31 18:21:35',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101720'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-08-19 00:00:00'
WHERE
	[SGQuote] = 'SG101720'
;

ROLLBACK;
COMMIT;