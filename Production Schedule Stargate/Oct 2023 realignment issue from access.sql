USE Stargatedb
GO

-- Data from broken access schedule 2023-09-20

DECLARE @t AS TABLE (
	[ID] INT IDENTITY(0, 1),
	[Q_WO] NVARCHAR(8),
	[SD] DATETIME,
	[Offset] INT
)
INSERT INTO @t ([Q_WO], [SD], [Offset]) VALUES
('10001337', '2023-10-03', -5),

('SG101328', '2023-10-06', -5),
('10001325', '2023-10-10', -5),
('10001333', '2023-10-11', -5),

('SG101364', '2023-10-16', -5),
('10001330', '2023-10-17', -5),
('SG101367', '2023-10-18', -5),

('SG101342', '2023-10-23', -5),
('SG101365', '2023-10-24', -5),
('SG101315', '2023-10-25', -5),

('SG101335', '2023-10-30', -5),
('10001357', '2023-10-31', -5),

('10001319', '2023-10-02', -5),
('SG101346', '2023-10-17', -5)


SELECT
	[O].[Available Date]
	,*
	,DATEDIFF(SECOND, [SD], [Available Date])
FROM
	@t
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O]
ON
	[@t].[Q_WO] = CAST([O].[WO#] AS NVARCHAR(8))
	OR [@t].[Q_WO] = [O].[SGQuote]
ORDER BY
	[O].[Available Date]