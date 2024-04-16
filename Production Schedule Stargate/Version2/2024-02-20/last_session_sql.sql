-- SQL
-- 2024-04-16 18:35:30


BEGIN TRAN;


-- SQL OUTPUT - FIX DOUBLE - 2024-04-16 18:01:32

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101594

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-04-16 18:01:32',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101594'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101594'
;

-- SQL OUTPUT - SWAP - 2024-04-16 18:01:32

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-12 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-16 18:01:32',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101453'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-04-12 00:00:00'
WHERE
	[SGQuote] = 'SG101453'
;

-- SQL OUTPUT - DELETE ORDER - 2024-04-19 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101430

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-04-19 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101430'
;

-- SQL OUTPUT - SWAP - 2024-04-19 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-19 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-04-19 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101450'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-04-19 00:00:00'
WHERE
	[SGQuote] = 'SG101450'
;
-- SQL OUTPUT - SWAP - 2024-04-19 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-01 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-19 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101423'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-04-01 00:00:00'
WHERE
	[SGQuote] = 'SG101423'
;

-- SQL OUTPUT - DELETE ORDER - 2024-04-16 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101573

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101573'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101573'
;

-- SQL OUTPUT - SWAP - 2024-04-16 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-17 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101424'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-16 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101511'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-04-17 00:00:00'
WHERE
	[SGQuote] = 'SG101424'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-04-16 00:00:00'
WHERE
	[SGQuote] = 'SG101511'
;
-- SQL OUTPUT - SWAP - 2024-04-16 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-17 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101424'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-04-17 00:00:00'
WHERE
	[SGQuote] = 'SG101424'
;
-- SQL OUTPUT - SWAP - 2024-04-16 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-17 00:00:00',
	[JobAvailableLine] = 'TPL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101425'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'TPL',
	[JobFinishDate] = '2024-04-17 00:00:00'
WHERE
	[SGQuote] = 'SG101425'
;
-- SQL OUTPUT - SWAP - 2024-04-16 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-26 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101573'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-19 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101591'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-04-26 00:00:00'
WHERE
	[SGQuote] = 'SG101573'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-04-19 00:00:00'
WHERE
	[SGQuote] = 'SG101591'
;
-- SQL OUTPUT - INSERT - 2024-04-16 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-26 00:00:00',
	[JobAvailableLine] = 'WFL',
	[JobAvailableScheduled] = '2024-04-16 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101573'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'WFL',
	[JobFinishDate] = '2024-04-26 00:00:00'
WHERE
	[SGQuote] = 'SG101573'
;

-- SQL OUTPUT - DELETE ORDER - 2024-05-09 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101632

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101632'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101632'
;

-- SQL OUTPUT - SWAP - 2024-05-09 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-08 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-09 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101581'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-08 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-09 00:00:00'
WHERE
	[SGQuote] = 'SG101581'
;
-- SQL OUTPUT - SWAP - 2024-05-09 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-07 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101369'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-08 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101477'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-07 00:00:00'
WHERE
	[SGQuote] = 'SG101369'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-08 00:00:00'
WHERE
	[SGQuote] = 'SG101477'
;
-- SQL OUTPUT - SWAP - 2024-05-09 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-06 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101632'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-07 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101369'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-06 00:00:00'
WHERE
	[SGQuote] = 'SG101632'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-07 00:00:00'
WHERE
	[SGQuote] = 'SG101369'
;
-- SQL OUTPUT - INSERT - 2024-05-09 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-06 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-09 00:00:00',
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
	[SGQuote] = 'SG101632'
;

-- SQL OUTPUT - DELETE ORDER - 2024-05-13 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101583

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-13 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101583'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101583'
;

-- SQL OUTPUT - SWAP - 2024-05-13 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-13 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101596'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-13 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-13 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101134'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-17 00:00:00'
WHERE
	[SGQuote] = 'SG101596'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-13 00:00:00'
WHERE
	[SGQuote] = 'SG101134'
;

-- SQL OUTPUT - DELETE ORDER - 2024-05-15 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101596

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-15 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101596'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101596'
;

-- SQL OUTPUT - SWAP - 2024-05-15 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-15 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101133'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-15 00:00:00'
WHERE
	[SGQuote] = 'SG101133'
;
-- SQL OUTPUT - INSERT - 2024-05-15 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-15 00:00:00',
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
	[SGQuote] = 'SG101596'
;
-- SQL OUTPUT - INSERT - 2024-05-15 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-17 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-15 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101430'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-05-17 00:00:00'
WHERE
	[SGQuote] = 'SG101430'
;

-- SQL OUTPUT - DELETE ORDER - 2024-05-27 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101527

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-27 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101527'
;

-- SQL OUTPUT - INSERT - 2024-05-27 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-27 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-27 00:00:00',
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
	[SGQuote] = 'SG101583'
;

-- SQL OUTPUT - DELETE ORDER - 2024-05-30 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101451

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-05-30 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101451'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101451'
;

-- SQL OUTPUT - SWAP - 2024-05-30 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-30 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101527'
;
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-30 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-30 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101582'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-29 00:00:00'
WHERE
	[SGQuote] = 'SG101527'
;
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-05-30 00:00:00'
WHERE
	[SGQuote] = 'SG101582'
;
-- SQL OUTPUT - INSERT - 2024-05-30 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-05-29 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-05-30 00:00:00',
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
	[SGQuote] = 'SG101527'
;
-- SQL OUTPUT - INSERT - 2024-05-30 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-06-06 00:00:00',
	[JobAvailableLine] = 'ED2',
	[JobAvailableScheduled] = '2024-05-30 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101594'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED2',
	[JobFinishDate] = '2024-06-06 00:00:00'
WHERE
	[SGQuote] = 'SG101594'
;

-- SQL OUTPUT - DELETE ORDER - 2024-07-04 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
-- Quote: SG101598

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = NULL,
	[JobAvailableLine] = NULL,
	[JobAvailableScheduled] = '2024-07-04 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101598'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = NULL,
	[JobFinishDate] = NULL
WHERE
	[SGQuote] = 'SG101598'
;

-- SQL OUTPUT - INSERT - 2024-07-04 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-04 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-07-04 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101451'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-07-04 00:00:00'
WHERE
	[SGQuote] = 'SG101451'
;
-- SQL OUTPUT - INSERT - 2024-07-04 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-07-15 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-07-04 00:00:00',
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
-- SQL OUTPUT - INSERT - 2024-07-04 00:00:00

-- [BWSdb].[dbo].[OrdersV2]
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-08-01 00:00:00',
	[JobAvailableLine] = 'ED1',
	[JobAvailableScheduled] = '2024-07-04 00:00:00',
	[JobAvailableScheduledBy] = 'abriggs'
WHERE
	[SGQuote] = 'SG101598'
;

-- [Stargatedb].[dbo].[dtProductionScheduleV2]
UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobStartLine] = 'ED1',
	[JobFinishDate] = '2024-08-01 00:00:00'
WHERE
	[SGQuote] = 'SG101598'
;

ROLLBACK;
COMMIT;
