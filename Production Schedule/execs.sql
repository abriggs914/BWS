USE BWSdb
GO

DECLARE @sd AS DATETIME, @ed AS DATETIME;
SET @sd = '2021-10-01';
SET @ed = '2021-10-31';

DECLARE @T2 AS TABLE (
	[GroupID] INT,
	[LO] INT,
	[Prod Line] NVARCHAR(MAX),
	[Prod Date] DATETIME,
	[Quote#] INT,
	[WO#] INT,
	[InputField1] NVARCHAR(MAX),
	[InputField2] NVARCHAR(MAX),
	[GN WO#] NVARCHAR(MAX),
	[Other] NVARCHAR(MAX),
	[Other WO#] INT,
	[Beam WO#] NVARCHAR(MAX),
	[Steel Kit WO#] NVARCHAR(MAX),
	[JobStartDate] NVARCHAR(MAX),
	[Reviewed] BIT,
	[NoNPOs] INT,
	[Stock/Sold] NVARCHAR(MAX),
	[Slot/Quote] INT,
	[Slot#] INT,
	[NoDays] INT,
	[HighRiskUnit] BIT,
	[IsGalvanized] BIT
)
;

DECLARE @LineOrder AS TABLE ([ID] INT IDENTITY(1,1), [Line] NVARCHAR(20));
INSERT INTO @LineOrder ([Line]) VALUES
('GNK1'),
('GNK2'),
('TBF'),
('PBF'),
('B1'),
('B2'),
('B3'),
('B4'),
('TS1'),
('TS2'),
('TS3'),
('T1'),
('T2'),
('T3'),
('T4'),
('T5'),
('T6'),
('T7'),
('T8'),
('T9'),
('T10'),
('T11')

INSERT INTO @T2
EXEC [sp_ProductionSchedule V4_Slots] @sd, @ed;

SELECT * FROM @T2 ORDER BY [Prod Date], [GroupID]
SELECT * FROM @T2 ORDER BY [InputField2]

SELECT * FROM @T2 WHERE [InputField1] IS NOT NULL AND [InputField2] IS NOT NULL ORDER BY [InputField2]