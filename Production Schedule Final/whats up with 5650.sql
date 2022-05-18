USE BWSdb
GO

DECLARE @t AS TABLE	(
		GroupID int,
		LO int,
		[Prod Line] nvarchar(255),
		[Prod Date] datetime,
		Quote# int,
		WO# int,
		InputField1 nvarchar(50),
		InputField2 nvarchar(50),
		[GN WO#] nvarchar(50),
		Other nvarchar(255),
		[Other WO#] int,
		[Beam WO#] nvarchar(50),
		[Steel Kit WO#] nvarchar(50),
		JobStartDate nvarchar(50),
		Reviewed bit,
		NoNPOs int,
		[Stock/Sold] nvarchar(10),
		[Slot/Quote] int default(0),
		[Slot#] int,
		NoDays int default(1),
		HighRiskUnit bit default(0),
		IsGavlanized bit default(0),
		[Serial] NVARCHAR(MAX),
		[Beam Date] DATETIME
	)

INSERT INTO @t
EXEC [dbo].[sp_ProductionScheduleEdit V4_Slots] @sd='2022-04-01', @ed='2022-06-30';

SELECT * FROM @t WHERE [WO#] = '10015650'