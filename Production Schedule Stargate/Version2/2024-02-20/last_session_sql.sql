/* SQL
 Date: 2024-05-15 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-19 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101650'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-22 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101605'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-19 00:00:00'
WHERE
	[SGQuote] = 'SG101650'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-22 00:00:00'
WHERE
	[SGQuote] = 'SG101605'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-19 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101650'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-19 00:00:00'
WHERE
	[SGQuote] = 'SG101650'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101602'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-17 00:00:00'
WHERE
	[SGQuote] = 'SG101602'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-18 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101552'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-07-18 00:00:00'
WHERE
	[SGQuote] = 'SG101552'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-12 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101595'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101602'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-12 00:00:00'
WHERE
	[SGQuote] = 'SG101595'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-17 00:00:00'
WHERE
	[SGQuote] = 'SG101602'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-10 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101451'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-16 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101549'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-10 00:00:00'
WHERE
	[SGQuote] = 'SG101451'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-07-16 00:00:00'
WHERE
	[SGQuote] = 'SG101549'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-09 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101607'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-15 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101599'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-09 00:00:00'
WHERE
	[SGQuote] = 'SG101607'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-15 00:00:00'
WHERE
	[SGQuote] = 'SG101599'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-08 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101642'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-12 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101595'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-08 00:00:00'
WHERE
	[SGQuote] = 'SG101642'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-12 00:00:00'
WHERE
	[SGQuote] = 'SG101595'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-05 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101615'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-11 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101618'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-05 00:00:00'
WHERE
	[SGQuote] = 'SG101615'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-07-11 00:00:00'
WHERE
	[SGQuote] = 'SG101618'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101614'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-10 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101451'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-04 00:00:00'
WHERE
	[SGQuote] = 'SG101614'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-10 00:00:00'
WHERE
	[SGQuote] = 'SG101451'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101613'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-09 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101607'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-03 00:00:00'
WHERE
	[SGQuote] = 'SG101613'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-09 00:00:00'
WHERE
	[SGQuote] = 'SG101607'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-08 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101642'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-08 00:00:00'
WHERE
	[SGQuote] = 'SG101642'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-28 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101641'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101614'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-28 00:00:00'
WHERE
	[SGQuote] = 'SG101641'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-04 00:00:00'
WHERE
	[SGQuote] = 'SG101614'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101614'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-05 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101615'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-04 00:00:00'
WHERE
	[SGQuote] = 'SG101614'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-05 00:00:00'
WHERE
	[SGQuote] = 'SG101615'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-27 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101584'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101614'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-27 00:00:00'
WHERE
	[SGQuote] = 'SG101584'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-04 00:00:00'
WHERE
	[SGQuote] = 'SG101614'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-26 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101612'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101613'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-26 00:00:00'
WHERE
	[SGQuote] = 'SG101612'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-03 00:00:00'
WHERE
	[SGQuote] = 'SG101613'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-02 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101593'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-07-02 00:00:00'
WHERE
	[SGQuote] = 'SG101593'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-28 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101641'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-28 00:00:00'
WHERE
	[SGQuote] = 'SG101641'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-21 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101570'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-27 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101584'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-21 00:00:00'
WHERE
	[SGQuote] = 'SG101570'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-27 00:00:00'
WHERE
	[SGQuote] = 'SG101584'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-27 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101640'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-27 00:00:00'
WHERE
	[SGQuote] = 'SG101640'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-26 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101612'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-26 00:00:00'
WHERE
	[SGQuote] = 'SG101612'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-19 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101639'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-25 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101611'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-19 00:00:00'
WHERE
	[SGQuote] = 'SG101639'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-25 00:00:00'
WHERE
	[SGQuote] = 'SG101611'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-24 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101331'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-24 00:00:00'
WHERE
	[SGQuote] = 'SG101331'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-20 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101332'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-20 00:00:00'
WHERE
	[SGQuote] = 'SG101332'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101582'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-17 00:00:00'
WHERE
	[SGQuote] = 'SG101582'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-21 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101570'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-21 00:00:00'
WHERE
	[SGQuote] = 'SG101570'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-13 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101583'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-19 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101639'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-13 00:00:00'
WHERE
	[SGQuote] = 'SG101583'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-19 00:00:00'
WHERE
	[SGQuote] = 'SG101639'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-12 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101542'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-18 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101597'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-12 00:00:00'
WHERE
	[SGQuote] = 'SG101542'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-18 00:00:00'
WHERE
	[SGQuote] = 'SG101597'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101619'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101582'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101619'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-17 00:00:00'
WHERE
	[SGQuote] = 'SG101582'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-14 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101625'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-14 00:00:00'
WHERE
	[SGQuote] = 'SG101625'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-13 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101583'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-13 00:00:00'
WHERE
	[SGQuote] = 'SG101583'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-12 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101542'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-12 00:00:00'
WHERE
	[SGQuote] = 'SG101542'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101619'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101619'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-07 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101635'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-13 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101594'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-07 00:00:00'
WHERE
	[SGQuote] = 'SG101635'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-13 00:00:00'
WHERE
	[SGQuote] = 'SG101594'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-07 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101635'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-07 00:00:00'
WHERE
	[SGQuote] = 'SG101635'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-15 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101578'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-15 00:00:00'
WHERE
	[SGQuote] = 'SG101578'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-21 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101577'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-16 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101575'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-21 00:00:00'
WHERE
	[SGQuote] = 'SG101577'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-16 00:00:00'
WHERE
	[SGQuote] = 'SG101575'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-21 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101577'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-21 00:00:00'
WHERE
	[SGQuote] = 'SG101577'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101592'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-22 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101592'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-22 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101592'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101592'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-23 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101425'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-23 00:00:00'
WHERE
	[SGQuote] = 'SG101425'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101632'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-23 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101632'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-23 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101133'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101133'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101632'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101632'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101551'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-30 00:00:00'
WHERE
	[SGQuote] = 'SG101551'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101589'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101589'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101596'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101596'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101654'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101654'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101646'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101646'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101645'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-15 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101541'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101645'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-15 00:00:00'
WHERE
	[SGQuote] = 'SG101541'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-16 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101476'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-16 00:00:00'
WHERE
	[SGQuote] = 'SG101476'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-24 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101590'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101646'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-24 00:00:00'
WHERE
	[SGQuote] = 'SG101590'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101646'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-23 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101616'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101645'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-23 00:00:00'
WHERE
	[SGQuote] = 'SG101616'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101645'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-23 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101616'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-23 00:00:00'
WHERE
	[SGQuote] = 'SG101616'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-24 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101590'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-17 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-24 00:00:00'
WHERE
	[SGQuote] = 'SG101590'
;
/* SQL OUTPUT - SWAP - 2024-05-15 15:17:20

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 15:17:20',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-17 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;

ROLLBACK;
COMMIT;