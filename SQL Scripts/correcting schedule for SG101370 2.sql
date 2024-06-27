
BEGIN TRAN;


DECLARE @qInQuestion NVARCHAR(MAX) = 'SG101370'


UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobFinishDate] = '2024-07-31'
	,[JobStartLine] = 'WFL'
WHERE
	[SGQuote] = @qInQuestion
;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[JobAvailableScheduled] = GETDATE()
	,[JobAvailableLine] = 'WFL'
	,[JobAvailableScheduledBy] = 'abriggs'
	,[Available Date] = '2024-07-31'
WHERE
	[SGQuote] = @qInQuestion
;

ROLLBACK;
COMMIT;