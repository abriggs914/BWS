USE Stargatedb
GO

DECLARE @c TABLE (
	[Q] NVARCHAR(MAX),
	[Date] DATETIME,
	[Line] NVARCHAR(MAX)
);

INSERT INTO @c ([Q], [Date], [Line]) VALUES
('SG101661', '2024-09-17', 'ED1')



BEGIN TRAN;

UPDATE
	[D]
	--[dtProductionScheduleV2]
SET
	[JobFinishDate] = [C].[Date]
	,[JobStartLine] = [C].[Line]
FROM 
	[dtProductionScheduleV2] [D]
INNER JOIN
	@c [C]
ON	
	[D].[SGQuote] = [C].[Q]

UPDATE
	[O]
	--[dtProductionScheduleV2]
SET
	[Available Date] = [C].[Date],
	[JobAvailableLine] = [C].[Line],
	[JobAvailableScheduled] = GETDATE(),
	[JobAvailableScheduledBy] = 'abriggs'

FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	@c [C]
ON	
	[O].[SGQuote] = [C].[Q]

ROLLBACK;
COMMIT;
