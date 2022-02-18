USE SysproCompanyS
GO


BEGIN TRAN;

SELECT * FROM [ClkShiftRoundRules]
SELECT * FROM [ClkShiftRoundRules V2]

INSERT INTO [ClkShiftRoundRules V2] (
	[Name],
	[StartTime],
	[EndTime],
	[Interval],
	[EarlyThreshold],
	[LateThreshold],
	[IncludeLunchSun],
	[IncludeLunchMon],
	[IncludeLunchTue],
	[IncludeLunchWed],
	[IncludeLunchThu],
	[IncludeLunchFri],
	[IncludeLunchSat]
)
SELECT
	[Name],
	[StartTime],
	[EndTime],
	[Interval],
	[Threshold],
	[Threshold],
	[IncludeLunch],
	[IncludeLunch],
	[IncludeLunch],
	[IncludeLunch],
	[IncludeLunch],
	[IncludeLunch],
	[IncludeLunch]
FROM
	[ClkShiftRoundRules]
	
SELECT * FROM [ClkShiftRoundRules]
SELECT * FROM [ClkShiftRoundRules V2]
ROLLBACK;
COMMIT;