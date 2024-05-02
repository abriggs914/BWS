/* SQL
 Date: 2024-05-01 00:00:00 =*/

BEGIN TRAN;

/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-15 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101649'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-07-15 00:00:00'
WHERE
	[SGQuote] = 'SG101649'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-08 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101648'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-07-08 00:00:00'
WHERE
	[SGQuote] = 'SG101648'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-02 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101647'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-07-02 00:00:00'
WHERE
	[SGQuote] = 'SG101647'
;
/* SQL OUTPUT - INSERT - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-15 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101644'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-15 00:00:00'
WHERE
	[SGQuote] = 'SG101644'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-15 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101644'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-07-15 00:00:00'
WHERE
	[SGQuote] = 'SG101644'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-24 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101441'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-24 00:00:00'
WHERE
	[SGQuote] = 'SG101441'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-17 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101461'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-17 00:00:00'
WHERE
	[SGQuote] = 'SG101461'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-13 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101529'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-13 00:00:00'
WHERE
	[SGQuote] = 'SG101529'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-10 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
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
	[SGQuote] = 'SG101528'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-06 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101576'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-06 00:00:00'
WHERE
	[SGQuote] = 'SG101576'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
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
	[SGQuote] = 'SG101643'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101579'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101579'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-25 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101593'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-25 00:00:00'
WHERE
	[SGQuote] = 'SG101593'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-18 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101331'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-18 00:00:00'
WHERE
	[SGQuote] = 'SG101331'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-14 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101332'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-14 00:00:00'
WHERE
	[SGQuote] = 'SG101332'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
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
	[SGQuote] = 'SG101635'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
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
	[SGQuote] = 'SG101580'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-28 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101444'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-28 00:00:00'
WHERE
	[SGQuote] = 'SG101444'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-24 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101577'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-24 00:00:00'
WHERE
	[SGQuote] = 'SG101577'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-23 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101573'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-23 00:00:00'
WHERE
	[SGQuote] = 'SG101573'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-21 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
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
	[SGQuote] = 'SG101575'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-20 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101592'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-20 00:00:00'
WHERE
	[SGQuote] = 'SG101592'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-14 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101435'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-14 00:00:00'
WHERE
	[SGQuote] = 'SG101435'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-10 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101442'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-10 00:00:00'
WHERE
	[SGQuote] = 'SG101442'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-07 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101526'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-07 00:00:00'
WHERE
	[SGQuote] = 'SG101526'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-06 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101555'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-06 00:00:00'
WHERE
	[SGQuote] = 'SG101555'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-03 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101525'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-03 00:00:00'
WHERE
	[SGQuote] = 'SG101525'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-01 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101511'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-01 00:00:00'
WHERE
	[SGQuote] = 'SG101511'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-27 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101522'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-27 00:00:00'
WHERE
	[SGQuote] = 'SG101522'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-16 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101589'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-16 00:00:00'
WHERE
	[SGQuote] = 'SG101589'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-15 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101133'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-15 00:00:00'
WHERE
	[SGQuote] = 'SG101133'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-13 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-13 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;
/* SQL OUTPUT - SWAP - 2024-05-01 20:55:53

 [BWSdb].[dbo].[OrdersV2]*/
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-01 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-01 20:55:53',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101561'
;

/* [Stargatedb].[dbo].[dtProductionScheduleV2]*/
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-01 00:00:00'
WHERE
	[SGQuote] = 'SG101561'
;

ROLLBACK;
COMMIT;