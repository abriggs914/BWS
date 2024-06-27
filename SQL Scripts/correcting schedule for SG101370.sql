USE BWSdb
GO

DECLARE @d1 DATETIME = '2024-07-30';
DECLARE @d2 DATETIME = '2024-08-01';

DECLARE @qInQuestion NVARCHAR(MAX) = 'SG101370'

SELECT
	*
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2]
WHERE
	[SGQuote] IN (
		@qInQuestion
	)
;

SELECT
	*
FROM
	[Stargatedb].[dbo].[Prod Lines]
WHERE
	[Active] = 1
;

SELECT
	*
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
WHERE
	[SGQuote] IN (
		@qInQuestion
	)
;

SELECT
	*
FROM
	[OrdersV2] [O]
WHERE
	([O].[Available Date] BETWEEN @d1 AND @d2)
	OR ([O].[Delivery Date] BETWEEN @d1 AND @d2)
	OR ([O].[Finish Date] BETWEEN @d1 AND @d2)




SELECT
	*
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
INNER JOIN	
	[Stargatedb].[dbo].[Prod Lines] [L]
ON
	[P].[JobStartLine] = [L].[Prod Line]
WHERE
	[L].[Active] = 1
	AND [P].[InputField1] LIKE '%live%'
;
WHERE
	[SGQuote] IN (
		@qInQuestion
	)
;

BEGIN TRAN;



UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobFinishDate] = '2024-07-03'
WHERE
	[SGQuote] = 'SG101592'
;

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobFinishDate] = '2024-07-02'
WHERE
	[SGQuote] = 'SG101692'
;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[JobAvailableScheduled] = GETDATE()
	,[JobAvailableScheduledBy] = 'abriggs'
	,[Available Date] = '2024-07-03'
WHERE
	[SGQuote] = 'SG101592'
;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[JobAvailableScheduled] = GETDATE()
	,[JobAvailableScheduledBy] = 'abriggs'
	,[Available Date] = '2024-07-02'
WHERE
	[SGQuote] = 'SG101692'
;

ROLLBACK;
COMMIT;