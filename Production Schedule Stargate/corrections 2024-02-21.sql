USE BWSdb
GO

-- Updates 2024-02-21

DECLARE @vinceTables20240221 TABLE (
	[ID] INT IDENTITY(0, 1)
	,[Quote] NVARCHAR(MAX)
	,[WO] NVARCHAR(MAX)
	,[Date] DATETIME
	,[Line] NVARCHAR(MAX)
	,[Rev] NVARCHAR(MAX)
	,[SchedPath] NVARCHAR(MAX)
);

INSERT INTO @vinceTables20240221 ([Quote], [WO], [Date], [Line], [Rev], [SchedPath]) VALUES

-- March
('SG101492', NULL, '2024-03-01', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101480', NULL, '2024-03-04', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101456', NULL, '2024-03-05', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101457', NULL, '2024-03-06', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101493', NULL, '2024-03-07', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101548', NULL, '2024-03-08', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101505', NULL, '2024-03-11', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101402', NULL, '2024-03-12', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101305', NULL, '2024-03-13', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101547', NULL, '2024-03-14', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101494', NULL, '2024-03-15', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101506', NULL, '2024-03-18', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101567', NULL, '2024-03-19', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101458', NULL, '2024-03-20', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101530', NULL, '2024-03-21', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101459', NULL, '2024-03-22', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101507', NULL, '2024-03-25', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101568', NULL, '2024-03-26', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101539', NULL, '2024-03-27', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101414', NULL, '2024-03-28', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
('SG101460', NULL, '2024-03-29', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),

-- April
('SG101495', NULL, '2024-04-01', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101430', NULL, '2024-04-02', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101566', NULL, '2024-04-03', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101453', NULL, '2024-04-04', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101565', NULL, '2024-04-05', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101509', NULL, '2024-04-08', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101454', NULL, '2024-04-09', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101415', NULL, '2024-04-10', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101534', NULL, '2024-04-11', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101510', NULL, '2024-04-15', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101523', NULL, '2024-04-16', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101496', NULL, '2024-04-18', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101306', NULL, '2024-04-19', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101512', NULL, '2024-04-22', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101455', NULL, '2024-04-25', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101551', NULL, '2024-04-26', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),
('SG101450', NULL, '2024-04-29', 'ED', 'Rev12', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev12.pdf'),

--May
('SG101476', NULL, '2024-05-02', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101369', NULL, '2024-05-06', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101477', NULL, '2024-05-07', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101552', NULL, '2024-05-10', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101522', NULL, '2024-05-14', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101134', NULL, '2024-05-17', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101527', NULL, '2024-05-21', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101133', NULL, '2024-05-22', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101451', NULL, '2024-05-23', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101452', NULL, '2024-05-24', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101528', NULL, '2024-05-27', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101541', NULL, '2024-05-28', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101468', NULL, '2024-05-29', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101529', NULL, '2024-05-30', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),
('SG101540', NULL, '2024-05-31', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev10.pdf'),

-- June
('SG101444', NULL, '2024-06-03', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101531', NULL, '2024-06-05', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101549', NULL, '2024-06-07', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101461', NULL, '2024-06-10', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101532', NULL, '2024-06-11', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101332', NULL, '2024-06-14', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101542', NULL, '2024-06-17', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101331', NULL, '2024-06-18', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf'),
('SG101441', NULL, '2024-06-24', 'ED', 'Rev07', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(06)June_End Dump-Rev07.pdf')


----- DOUBLE CHECK THESE ONES

--('SG101508', NULL, '2024-03-28', 'ED', 'Rev09', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-21\PRODUCTION CALENDAR 2024_(03)March_End Dump-Rev09.pdf'),
--('SG101443', NULL, '2024-04-02', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
--('SG101453', NULL, '2024-04-04', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
--('SG101511', NULL, '2024-04-17', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
--('SG101525', NULL, '2024-04-24', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),
--('SG101526', NULL, '2024-04-30', 'ED', 'Rev10', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(04)April_End Dump-Rev10.pdf'),

--('SG101442', NULL, '2024-05-01', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),
--('SG101435', NULL, '2024-05-03', 'ED', 'Rev08', N'\\nas1\domain user home folders\ABriggs\Quick files\Junk\Production Schedule Correction 2024-01-30\2024-02-08\PRODUCTION CALENDAR 2024_(05)May_End Dump-Rev08.pdf'),


DECLARE @sd DATETIME;
DECLARE @ed DATETIME;

SELECT
	@sd=MIN([Date]),
	@ed=MAX([Date])
FROM
	@vinceTables20240221
;

SELECT
	@sd [StartDate]
	,@ed [EndDate]
;

SELECT
	'These quotes are on the Stargate production schedule but not on Vince''s new schedule' 
	,*
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2] [D]
RIGHT JOIN
	@vinceTables20240221 [V]
ON
	[D].[SGQuote] = [V].[Quote]
WHERE
	([V].[Quote] IS NULL)
	AND ([D].[JobFinishDate] BETWEEN @sd AND @ed)
;

SELECT
	'These quotes are on the BWS orders table but not on Vince''s new schedule' 
	,*
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
RIGHT JOIN
	@vinceTables20240221 [V]
ON
	[O].[SGQuote] = [V].[Quote]
WHERE
	([V].[Quote] IS NULL)
	AND ([O].[Available Date] BETWEEN @sd AND @ed)
;


SELECT
	'These Quote''s are in duplicate on Vince''s schedule.'
	,[Quote]
FROM
	@vinceTables20240221
WHERE
	[Quote] IS NOT NULL
GROUP BY
	[Quote]
HAVING
	COUNT(*) > 1
;

SELECT
	'These WO''s are in duplicate on Vince''s schedule.'
	[WO]
FROM
	@vinceTables20240221
WHERE
	[WO] IS NOT NULL
GROUP BY
	[WO]
HAVING
	COUNT(*) > 1
;

SELECT
	'These Date''s and Lines have more than 1 entry on Vince''s schedule.',
	[Date],
	[Line],
	COUNT(*) AS [C]
FROM
	@vinceTables20240221
GROUP BY
	[Date],
	[Line]
HAVING
	COUNT(*) > 1
;

SELECT
	ROW_NUMBER() OVER(
		PARTITION BY
			[Line]
			,[Date]
		ORDER BY
			[ID]
	) AS [Rn]
	,*
FROM
	@vinceTables20240221
;

SELECT
	'Active STG Prod Lines'
	,*
FROM
	[Stargatedb].[dbo].[Prod Lines]
WHERE
	[Active] = 1
;

UPDATE
	@vinceTables20240221
SET
	[Line] = [Src].[Line] + CAST([Src].[Rn] AS NVARCHAR(MAX))
FROM (
	SELECT
		ROW_NUMBER() OVER(
			PARTITION BY
				[Line]
				,[Date]
			ORDER BY
				[ID]
		) AS [Rn]
		,*
	FROM
		@vinceTables20240221
) AS [Src]
INNER JOIN
	@vinceTables20240221 [V]
ON
	ISNULL([V].[Quote], '') = ISNULL([Src].[Quote], '')
	AND ISNULL([V].[WO], '') = ISNULL([Src].[WO], '')
;

SELECT
	'Pre-Orders and dtProductionSchedule Update'
	,*
FROM
	@vinceTables20240221
;

BEGIN TRAN;

	SELECT
		'Before'
		,*
	FROM
		[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
	INNER JOIN
		@vinceTables20240221 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([P].[SGQuote], '')
	;

	SELECT
		'Before'
		,*
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	INNER JOIN
		@vinceTables20240221 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([O].[SGQuote], '')
	;

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[JobAvailableLine] = [Line]
		,[Available Date] = [Date]
		,[JobAvailableScheduled] = GETDATE()
		,[JobAvailableScheduledBy] = 'vincef via abriggs'
	FROM
		@vinceTables20240221 [V]
	INNER JOIN
		[BWSdb].[dbo].[OrdersV2] [O]
	ON
		ISNULL([V].[Quote], '') = ISNULL([O].[SGQuote], '')
	;

	UPDATE
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	SET
		[JobStartLine] = [Line]
		,[JobFinishDate] = [Date]
	FROM
		@vinceTables20240221 [V]
	INNER JOIN
		[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
	ON
		ISNULL([V].[Quote], '') = ISNULL([P].[SGQuote], '')
	;

	SELECT
		'After'
		,*
	FROM
		[Stargatedb].[dbo].[dtProductionScheduleV2] [P]
	INNER JOIN
		@vinceTables20240221 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([P].[SGQuote], '')
	;

	SELECT
		'After'
		,*
	FROM
		[BWSdb].[dbo].[OrdersV2] [O]
	INNER JOIN
		@vinceTables20240221 [V]
	ON
		ISNULL([V].[Quote], '') = ISNULL([O].[SGQuote], '')
	;

ROLLBACK;
COMMIT;


SELECT
	*
FROM
	[OrdersV2] [O]
WHERE
	[O].[JobAvailableLine] = 'WF2'


SELECT
	*
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2] [D]
WHERE
	[D].[JobStartLine] = 'WF2'

BEGIN TRAN;

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[JobAvailableLine] = 'WFL'
	WHERE
		[JobAvailableLine] = 'WF1'

	UPDATE
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	SET
		[JobStartLine] = 'WFL'
	WHERE
		[JobStartLine] = 'WF1'

	UPDATE
		[BWSdb].[dbo].[OrdersV2]
	SET
		[JobAvailableLine] = 'TPL'
	WHERE
		[JobAvailableLine] = 'WF2'

	UPDATE
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	SET
		[JobStartLine] = 'TPL'
	WHERE
		[JobStartLine] = 'WF2'

ROLLBACK;
COMMIT;