/* SQL
 Date: 2024-05-27 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-05-27 17:46:14*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-02 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-27 17:46:14',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101561'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-02 00:00:00'
WHERE
	[SGQuote] = 'SG101561'
;

ROLLBACK;
COMMIT;