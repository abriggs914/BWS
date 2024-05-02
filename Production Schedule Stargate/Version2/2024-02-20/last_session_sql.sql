/* SQL
 Date: 2024-05-01 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-05-01 21:03:46

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-23 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-01 21:03:46',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101573'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-05-23 00:00:00'
WHERE
	[SGQuote] = 'SG101573'
;
/* SQL OUTPUT - SWAP - 2024-05-01 21:03:46

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-27 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 21:03:46',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101522'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-27 00:00:00'
WHERE
	[SGQuote] = 'SG101522'
;

ROLLBACK;
COMMIT;