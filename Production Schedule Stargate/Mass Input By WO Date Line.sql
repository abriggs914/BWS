USE Stargatedb
GO

DECLARE @c TABLE (
	[W] NVARCHAR(MAX),
	[Date] DATETIME,
	[Line] NVARCHAR(MAX)
);

INSERT INTO @c ([W], [Date], [Line]) VALUES
('10001480', '2024-05-31', 'WFL')



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
	[D].[WO#] = [C].[W]

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
	[O].[WO#] = [C].[W]

ROLLBACK;
COMMIT;
