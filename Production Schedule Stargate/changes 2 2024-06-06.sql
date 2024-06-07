USE Stargatedb
GO

DECLARE @changes TABLE (
	[ID] INT IDENTITY(0, 1)
	,[Q] NVARCHAR(MAX)
	,[L] NVARCHAR(MAX)
	,[D] DATETIME
)
INSERT INTO @changes ([Q], [L], [D]) VALUES

('SG101691', 'TPL', '2024-07-15'),
('SG101692', 'TPL', '2024-07-18'),
('SG101441', 'TPL', '2024-06-13'),
				
('30000265', 'WAR', '2024-06-05'),
('30000263', 'WAR', '2024-06-07'),
('30000264', 'WAR', '2024-06-11'),
('30000240', 'WAR', '2024-06-06'),
('30000245', 'WAR', '2024-06-10'),
							
('30000237', 'WAR', '2024-06-12'),
('30000241', 'WAR', '2024-06-14'),
('30000242', 'WAR', '2024-06-19')

SELECT* 
FROM 
	[dtProductionScheduleV2] [D]
INNER JOIN
	@changes [C]
ON
	[D].[SGQuote] = [C].[Q]
SELECT* 
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	@changes [C]
ON
	[O].[SGQuote] = [C].[Q]

SELECT *
FROM 
	[PDS_WarrantyUnits] [W]
INNER JOIN
	@changes [C]
ON
	[W].[Job] = [C].[Q]


BEGIN TRAN;

UPDATE
	[PDS_WarrantyUnits]
SET
	[Line] = [C].[L]
	,[Date] = [C].[D]
FROM 
	[PDS_WarrantyUnits] [W]
INNER JOIN
	@changes [C]
ON
	[W].[Job] = [C].[Q]
/*
UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[Available Date] = [C].[D]
	,[JobAvailableLine] = [C].[L]
	,[JobAvailableScheduled] = GETDATE()
	,[JobAvailableScheduledBy] = 'cbg'
FROM 
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	@changes [C]
ON
	[O].[SGQuote] = [C].[Q]
*/
ROLLBACK;
COMMIT;
