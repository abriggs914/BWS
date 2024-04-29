-- SQL
-- Date: 2024-04-29 00:00:00 =

BEGIN TRAN;

-- SQL OUTPUT - SWAP - 2024-04-29 16:33:49

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-10 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-29 16:33:49',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101632'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-29 16:33:49',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101552'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-10 00:00:00'
WHERE
	[SGQuote] = 'SG101632'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-17 00:00:00'
WHERE
	[SGQuote] = 'SG101552'
;
-- SQL OUTPUT - INSERT - 2024-04-29 16:33:49

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-15 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-29 16:33:49',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101644'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-15 00:00:00'
WHERE
	[SGQuote] = 'SG101644'
;
-- SQL OUTPUT - SWAP - 2024-04-29 16:33:49

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-07 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-29 16:33:49',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101583'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-10 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-29 16:33:49',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101549'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-07 00:00:00'
WHERE
	[SGQuote] = 'SG101583'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-10 00:00:00'
WHERE
	[SGQuote] = 'SG101549'
;

-- SQL OUTPUT - DELETE ORDER - 2024-06-11 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101532

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-06-11 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101532'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101532'
;

-- SQL OUTPUT - SWAP - 2024-06-11 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-11 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101654'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-11 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-11 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101582'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-30 00:00:00'
WHERE
	[SGQuote] = 'SG101654'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-11 00:00:00'
WHERE
	[SGQuote] = 'SG101582'
;
-- SQL OUTPUT - SWAP - 2024-06-11 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-27 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-11 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101522'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-07 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-11 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101583'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-27 00:00:00'
WHERE
	[SGQuote] = 'SG101522'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-07 00:00:00'
WHERE
	[SGQuote] = 'SG101583'
;
-- SQL OUTPUT - SWAP - 2024-06-11 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-07 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-06-11 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101594'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-07 00:00:00'
WHERE
	[SGQuote] = 'SG101594'
;

-- SQL OUTPUT - DELETE ORDER - 2024-06-06 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101531

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101531'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101531'
;

-- SQL OUTPUT - SWAP - 2024-06-06 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101619'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-06 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101542'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101619'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-06 00:00:00'
WHERE
	[SGQuote] = 'SG101542'
;
-- SQL OUTPUT - SWAP - 2024-06-06 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-05 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101619'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-05 00:00:00'
WHERE
	[SGQuote] = 'SG101619'
;
-- SQL OUTPUT - SWAP - 2024-06-06 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-06 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-04 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;

-- SQL OUTPUT - DELETE ORDER - 2024-06-03 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101452

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-06-03 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101452'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101452'
;

-- SQL OUTPUT - SWAP - 2024-06-03 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-21 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-03 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101476'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-06-03 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101635'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-21 00:00:00'
WHERE
	[SGQuote] = 'SG101476'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-06-03 00:00:00'
WHERE
	[SGQuote] = 'SG101635'
;
-- SQL OUTPUT - SWAP - 2024-06-03 00:00:00

-- [BWSdb].[dbo].[OrdersV2]


-- [Stargatedb].[dbo].[dtProductionScheduleV2]


-- SQL OUTPUT - DELETE ORDER - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101529

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101529'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101529'
;

-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;

-- SQL OUTPUT - DELETE ORDER - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101540

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101540'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101540'
;

-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101590'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101596'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-17 00:00:00'
WHERE
	[SGQuote] = 'SG101590'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101596'
;
-- SQL OUTPUT - INSERT - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101654'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-30 00:00:00'
WHERE
	[SGQuote] = 'SG101654'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-09 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101369'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-09 00:00:00'
WHERE
	[SGQuote] = 'SG101369'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-14 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101616'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-27 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101522'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-14 00:00:00'
WHERE
	[SGQuote] = 'SG101616'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-27 00:00:00'
WHERE
	[SGQuote] = 'SG101522'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-08 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101562'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-22 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-08 00:00:00'
WHERE
	[SGQuote] = 'SG101562'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-22 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-02 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101459'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-21 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101476'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-02 00:00:00'
WHERE
	[SGQuote] = 'SG101459'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-21 00:00:00'
WHERE
	[SGQuote] = 'SG101476'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101452'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101590'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-03 00:00:00'
WHERE
	[SGQuote] = 'SG101452'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-17 00:00:00'
WHERE
	[SGQuote] = 'SG101590'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-01 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101561'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-14 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101616'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-01 00:00:00'
WHERE
	[SGQuote] = 'SG101561'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-14 00:00:00'
WHERE
	[SGQuote] = 'SG101616'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-14 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101551'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-14 00:00:00'
WHERE
	[SGQuote] = 'SG101551'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101534'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-10 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101601'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-04-30 00:00:00'
WHERE
	[SGQuote] = 'SG101534'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-10 00:00:00'
WHERE
	[SGQuote] = 'SG101601'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-06 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101531'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-10 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101632'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-06 00:00:00'
WHERE
	[SGQuote] = 'SG101531'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-10 00:00:00'
WHERE
	[SGQuote] = 'SG101632'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-07 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101532'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-09 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101369'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-07 00:00:00'
WHERE
	[SGQuote] = 'SG101532'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-09 00:00:00'
WHERE
	[SGQuote] = 'SG101369'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-08 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101562'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-08 00:00:00'
WHERE
	[SGQuote] = 'SG101562'
;
-- SQL OUTPUT - INSERT - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-07 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101532'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-07 00:00:00'
WHERE
	[SGQuote] = 'SG101532'
;
-- SQL OUTPUT - INSERT - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-06 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101531'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-06 00:00:00'
WHERE
	[SGQuote] = 'SG101531'
;
-- SQL OUTPUT - INSERT - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-03 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101452'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-03 00:00:00'
WHERE
	[SGQuote] = 'SG101452'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-02 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101459'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-02 00:00:00'
WHERE
	[SGQuote] = 'SG101459'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-01 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101561'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-01 00:00:00'
WHERE
	[SGQuote] = 'SG101561'
;
-- SQL OUTPUT - INSERT - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-31 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101529'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-05-31 00:00:00'
WHERE
	[SGQuote] = 'SG101529'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101534'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-04-30 00:00:00'
WHERE
	[SGQuote] = 'SG101534'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101534'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-04-30 00:00:00'
WHERE
	[SGQuote] = 'SG101534'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101534'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-04-30 00:00:00'
WHERE
	[SGQuote] = 'SG101534'
;
-- SQL OUTPUT - SWAP - 2024-05-31 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-15 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-31 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101512'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-04-15 00:00:00'
WHERE
	[SGQuote] = 'SG101512'
;

ROLLBACK;
COMMIT;