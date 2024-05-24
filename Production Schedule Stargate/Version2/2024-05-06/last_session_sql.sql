/* SQL
 Date: 2024-05-24 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-10 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101522'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-19 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101528'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-10 00:00:00'
WHERE
	[SGQuote] = 'SG101522'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-19 00:00:00'
WHERE
	[SGQuote] = 'SG101528'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-17 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101576'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-17 00:00:00'
WHERE
	[SGQuote] = 'SG101576'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-14 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101643'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-14 00:00:00'
WHERE
	[SGQuote] = 'SG101643'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-13 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-06-13 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-18 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101635'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-18 00:00:00'
WHERE
	[SGQuote] = 'SG101635'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-20 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
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
	[SGQuote] = 'SG101581'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-20 00:00:00'
WHERE
	[SGQuote] = 'SG101619'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101133'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
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
	[SGQuote] = 'SG101133'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101632'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-10 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
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
	[SGQuote] = 'SG101134'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-10 00:00:00'
WHERE
	[SGQuote] = 'SG101551'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-10 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101551'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-10 00:00:00'
WHERE
	[SGQuote] = 'SG101551'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-10 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101551'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-10 00:00:00'
WHERE
	[SGQuote] = 'SG101551'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
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
	[SGQuote] = 'SG101430'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-30 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101133'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101133'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-06 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101589'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-06 00:00:00'
WHERE
	[SGQuote] = 'SG101589'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101444'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101444'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101444'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-12 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101592'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101444'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-12 00:00:00'
WHERE
	[SGQuote] = 'SG101592'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101578'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101578'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101444'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101444'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-10 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101522'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-10 00:00:00'
WHERE
	[SGQuote] = 'SG101522'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101580'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101580'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101577'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101577'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101575'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101575'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101541'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101541'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101590'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101590'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101541'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101541'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101590'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101590'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101369'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101645'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101369'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101645'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101476'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-06 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101646'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101476'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-06 00:00:00'
WHERE
	[SGQuote] = 'SG101646'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/


/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/

/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-13 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101654'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-13 00:00:00'
WHERE
	[SGQuote] = 'SG101654'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-14 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101596'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-14 00:00:00'
WHERE
	[SGQuote] = 'SG101596'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101578'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101578'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101573'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101573'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-30 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101476'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101476'
;
/* SQL OUTPUT - SWAP - 2024-05-24 17:38:22*/

/* [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-24 17:38:22',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101369'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101369'
;

ROLLBACK;
COMMIT;