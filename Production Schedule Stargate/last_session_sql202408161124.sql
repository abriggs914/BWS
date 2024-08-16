/* SQL */
/* Date: 2024-08-16 11:24:47 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-16 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101559'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-08-16 00:00:00'
WHERE
	[SGQuote] = 'SG101559'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-21 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101720'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-08-21 00:00:00'
WHERE
	[SGQuote] = 'SG101720'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-21 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101626'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-21 00:00:00'
WHERE
	[SGQuote] = 'SG101626'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-21 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101626'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-22 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101606'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-21 00:00:00'
WHERE
	[SGQuote] = 'SG101626'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-22 00:00:00'
WHERE
	[SGQuote] = 'SG101606'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-22 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101606'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-28 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101731'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-22 00:00:00'
WHERE
	[SGQuote] = 'SG101606'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-28 00:00:00'
WHERE
	[SGQuote] = 'SG101731'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-27 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101605'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-09-04 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101593'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-27 00:00:00'
WHERE
	[SGQuote] = 'SG101605'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-09-04 00:00:00'
WHERE
	[SGQuote] = 'SG101593'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-26 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101430'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-26 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-28 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101731'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-22 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101606'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-28 00:00:00'
WHERE
	[SGQuote] = 'SG101731'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-22 00:00:00'
WHERE
	[SGQuote] = 'SG101606'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-21 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101626'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-28 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101731'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-21 00:00:00'
WHERE
	[SGQuote] = 'SG101626'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-28 00:00:00'
WHERE
	[SGQuote] = 'SG101731'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-26 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101430'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-27 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101605'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-26 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-27 00:00:00'
WHERE
	[SGQuote] = 'SG101605'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-26 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101430'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-26 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-23 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101730'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-23 00:00:00'
WHERE
	[SGQuote] = 'SG101730'
;
/* SQL OUTPUT - SWAP - 2024-08-16 11:24:47*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-21 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-08-16 11:24:47',
	[JobAvailableScheduledBy] = 'gf'
WHERE
	[SGQuote] = 'SG101626'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-08-21 00:00:00'
WHERE
	[SGQuote] = 'SG101626'
;

ROLLBACK;
COMMIT;