USE BWSdb
GO

DECLARE @ProdSched AS table
	(
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
		GalvIndicator nvarchar(10)
	)

INSERT INTO @ProdSched
exec [sp_ProductionSchedule V4_Slots] '2022-12-01', '2023-01-12'

SELECT * FROM @ProdSched
ORDER BY
	[Prod Line]