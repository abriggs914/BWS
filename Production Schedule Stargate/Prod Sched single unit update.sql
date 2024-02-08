USE BWSdb
GO

DECLARE @line NVARCHAR(MAX);
DECLARE @date DATETIME;

SELECT
	--@date = [Available Date]
	--,@line = [JobAvailableLine]
	*
FROM
	[OrdersV2]
WHERE
	[SGQuote] = 'SG101443'
;

SELECT
	[P].[JobStartLine]
	,*
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
WHERE
	[SGQuote] = 'SG101443'
;

SELECT
	*
FROM
	[OrdersV2]
WHERE
	--[JobAvailableLine] = @line
	--AND
	[Available Date] = @date
	

BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = '2024-04-02'
	,[JobAvailableScheduled] = GETDATE()
WHERE
	[SGQuote] = 'SG101443'
;

UPDATE
	[Stargatedb].[dbo].[dtProductionScheduleV2]
SET
	[JobFinishDate] = '2024-04-02'
WHERE
	[SGQuote] = 'SG101443'
;

ROLLBACK;
COMMIT;