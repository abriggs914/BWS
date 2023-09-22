USE Stargatedb
GO

-- Data from Python sheduler app

DECLARE @t AS TABLE (
	[ID] INT IDENTITY(0, 1),
	[Q_WO] NVARCHAR(8),
	[SD] DATETIME,
	[Line] NVARCHAR(10)
)
INSERT INTO @t ([Q_WO], [SD], [Line]) VALUES
('SG101359', '2023-10-02', 'ED1'),
('SG101368', '2023-10-03', 'ED1'),
('SG101301', '2023-10-04', 'ED1'),


('SG101301', '2023-10-04', 'ED1'),

('SG101328', '2023-10-16', 'ED1'),
('SG101204', '2023-10-17', 'ED1'),
('SG101302', '2023-10-18', 'ED1'),

('SG101364', '2023-10-23', 'ED1'),
('SG101290', '2023-10-24', 'ED1'),
('SG101367', '2023-10-25', 'ED1'),

('SG101342', '2023-10-30', 'ED1'),
('SG101365', '2023-10-31', 'ED1'),

('SG101284', '2023-10-10', 'WFL'),

('SG101346', '2023-10-24', 'WFL')



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