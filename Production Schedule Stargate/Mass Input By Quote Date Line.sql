USE Stargatedb
GO

DECLARE @c TABLE (
	[Q] NVARCHAR(MAX),
	[Date] DATETIME,
	[Line] NVARCHAR(MAX)
);

INSERT INTO @c ([Q], [Date], [Line]) VALUES
--('SG101675', '2024-08-01', 'ED1')
--('SG101673', '2024-08-07', 'ED1')
--('SG101674', '2024-09-11', 'ED1')
--('SG101653', '2024-08-06', 'ED1')
('SG101688', '2024-08-28', 'ED1')



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
