-- Data pulled directly from the production scheduler program 2024-01-30 1223
DECLARE @p TABLE(
	[ID] INT IDENTITY(0, 1)
	,[Quote] NVARCHAR(MAX)
	,[ProgramLine] NVARCHAR(MAX)
	,[ProgramDate] DATETIME
)
;

INSERT INTO @p ([Quote], [ProgramDate], [ProgramLine]) VALUES
('SG101434', '2024-02-05', 'ED1'),
('SG101433', '2024-02-05', 'TPL'),
('SG101403', '2024-02-06', 'ED1'),
('SG101437', '2024-02-07', 'ED1'),
('SG101397', '2024-02-07', 'ED2'),
('SG101497', '2024-02-06', 'TPL'),

('SG101438', '2024-02-12', 'ED1'),
('SG101407', '2024-02-13', 'ED1'),
('SG101440', '2024-02-14', 'ED1'),
('SG101426', '2024-02-14', 'WFL'),
('SG101435', '2024-02-12', 'TPL'),
('SG101498', '2024-02-13', 'TPL'),
('SG101427', '2024-02-14', 'TPL'),

('SG101411', '2024-02-20', 'ED1'),
('SG101305', '2024-02-21', 'ED1'),
('SG101428', '2024-02-22', 'WFL'),
('SG101436', '2024-02-20', 'TPL'),
('SG101499', '2024-02-21', 'TPL'),
('SG101375', '2024-02-22', 'TPL'),

('SG101513', '2024-02-26', 'ED1'),
('SG101429', '2024-02-27', 'ED1'),
('SG101386', '2024-02-28', 'ED1'),
('SG101376', '2024-02-28', 'WFL'),
('SG101500', '2024-02-27', 'TPL'),
('SG101423', '2024-02-28', 'TPL'),

('SG101456', '2024-03-04', 'ED1'),
('SG101457', '2024-03-06', 'ED1'),
('SG101480', '2024-03-04', 'TPL'),
('SG101501', '2024-03-06', 'TPL'),
('SG101379', '2024-03-07', 'TPL'),
('SG101378', '2024-03-07', 'WFL'),

('SG101402', '2024-03-11', 'ED1'),
('SG101306', '2024-03-13', 'ED1'),
('SG101505', '2024-03-11', 'TPL'),
('SG101502', '2024-03-13', 'TPL'),

('SG101458', '2024-03-18', 'ED1'),
('SG101459', '2024-03-20', 'ED1'),
('SG101506', '2024-03-18', 'TPL'),
('SG101503', '2024-03-20', 'TPL'),

('SG101414', '2024-03-25', 'ED1'),
('SG101460', '2024-03-26', 'ED1'),
('SG101507', '2024-03-25', 'TPL'),
('SG101504', '2024-03-27', 'TPL'),
('SG101508', '2024-03-28', 'TPL'),

('SG101415', '2024-04-09', 'ED1'),
('SG101492', '2024-04-10', 'ED1'),
('SG101370', '2024-04-09', 'TPL'),
('SG101509', '2024-04-08', 'TPL'),

('SG101493', '2024-04-15', 'ED1'),
('SG101430', '2024-04-16', 'ED1'),
('SG101494', '2024-04-17', 'ED1'),
('SG101510', '2024-04-05', 'TPL'),
('SG101511', '2024-04-17', 'TPL'),

('SG101454', '2024-04-22', 'ED1'),
('SG101455', '2024-04-24', 'ED1'),
('SG101512', '2024-04-22', 'TPL'),

('SG101450', '2024-04-29', 'ED1'),
('SG101476', '2024-05-01', 'ED1'),
('SG101442', '2024-05-01', 'TPL'),

('SG101477', '2024-05-07', 'ED1'),

('SG101495', '2024-05-13', 'ED1'),
('SG101496', '2024-05-15', 'ED1'),
('SG101443', '2024-05-13', 'TPL'),

('SG101451', '2024-05-21', 'ED1'),
('SG101452', '2024-05-27', 'ED1'),
('SG101453', '2024-05-29', 'ED1'),

('SG101444', '2024-06-03', 'TPL'),

('SG101461', '2024-06-10', 'TPL'),

('SG101462', '2024-06-17', 'TPL'),

('SG101441', '2024-06-24', 'TPL')
;

DECLARE @t TABLE(
	[ID] INT IDENTITY(0, 1)
	,[Quote] NVARCHAR(MAX)
	,[Date] DATETIME
	,[Line] NVARCHAR(MAX)
	,[PLine] NVARCHAR(MAX)
	,[PDate] DATETIME
)
;
INSERT INTO @t ([Quote], [Date], [Line]) VALUES 
('SG101431', '2024-02-05', 'ED1'),
('SG101434', '2024-02-06', 'ED2'),
('SG101403', '2024-02-07', 'ED'),
('SG101437', '2024-02-08', 'ED'),
('SG101397', '2024-02-09', 'ED'),
('SG101432', '2024-02-12', 'ED'),
('SG101438', '2024-02-13', 'ED'),
('SG101407', '2024-02-14', 'ED'),
('SG101440', '2024-02-15', 'ED'),
('SG101433', '2024-02-16', 'ED'),
('SG101435', '2024-02-20', 'ED'),
('SG101411', '2024-02-21', 'ED'),
('SG101304', '2024-02-22', 'ED'),
('SG101436', '2024-02-23', 'ED'),
('SG101513', '2024-02-26', 'ED'),
('SG101515', '2024-02-27', 'ED'),
('SG101412', '2024-02-28', 'ED'),
('SG101204', '2024-02-29', 'ED'),

('SG101497', '2024-02-06', 'WF'),
('SG101498', '2024-02-13', 'WF'),
('SG101499', '2024-02-20', 'WF'),
('SG101500', '2024-02-27', 'WF'),

('SG101480', '2024-03-04', 'ED'),
('SG101456', '2024-03-05', 'ED'),
('SG101457', '2024-03-06', 'ED'),
('SG101505', '2024-03-11', 'ED'),
('SG101402', '2024-03-12', 'ED'),
('SG101305', '2024-03-13', 'ED'),
('SG101506', '2024-03-18', 'ED'),
('SG101458', '2024-03-19', 'ED'),
('SG101530', '2024-03-20', 'ED'),
('SG101459', '2024-03-21', 'ED'),
('SG101539', '2024-03-22', 'ED'),
('SG101507', '2024-03-25', 'ED'),
('SG101414', '2024-03-26', 'ED'),
('SG101460', '2024-03-27', 'ED'),
('SG101508', '2024-03-28', 'ED'),

('SG101501', '2024-03-05', 'WF'),
('SG101502', '2024-03-12', 'WF'),
('SG101___', '2024-03-19', 'WF'),
('SG______', '2024-03-21', 'WF'),
('SG101503', '2024-03-26', 'WF'),

('SG101430', '2024-04-01', 'ED'),
('SG101306', '2024-04-05', 'ED'),
('SG101509', '2024-04-08', 'ED'),
('SG101523', '2024-04-09', 'ED'),
('SG101415', '2024-04-10', 'ED'),
('SG101492', '2024-04-11', 'ED'),
('SG101510', '2024-04-15', 'ED'),
('SG101493', '2024-04-16', 'ED'),
('SG101511', '2024-04-17', 'ED'),
('SG101494', '2024-04-18', 'ED'),
('SG101512', '2024-04-22', 'ED'),
('SG101454', '2024-04-23', 'ED'),
('SG101525', '2024-04-24', 'ED'),
('SG101455', '2024-04-25', 'ED'),
('SG101450', '2024-04-29', 'ED'),
('SG101526', '2024-04-30', 'ED'),

('SG101521', '2024-04-09', 'WF'),
('SG101370', '2024-04-11', 'WF'),

('SG101442', '2024-05-01', 'ED'),
('SG101476', '2024-05-02', 'ED'),
('SG101477', '2024-05-07', 'ED'),
('SG101443', '2024-05-13', 'ED'),
('SG101495', '2024-05-14', 'ED'),
('SG101522', '2024-05-15', 'ED'),
('SG101496', '2024-05-16', 'ED'),
('SG101527', '2024-05-21', 'ED'),
('SG101451', '2024-05-22', 'ED'),
('SG101452', '2024-05-24', 'ED'),
('SG101528', '2024-05-27', 'ED'),
('SG101453', '2024-05-29', 'ED'),
('SG101529', '2024-05-30', 'ED'),

('SG101444', '2024-06-03', 'ED'),
('SG101531', '2024-06-05', 'ED'),
('SG101461', '2024-06-10', 'ED'),
('SG101532', '2024-06-11', 'ED'),
('SG101462', '2024-06-17', 'ED'),
('SG101441', '2024-06-24', 'ED')
;

UPDATE
	@t
SET
	[PDate] = [ProgramDate]
	,[PLine] = [ProgramLine]
FROM
	@t [T]
INNER JOIN
	@p [P]
ON
	[T].[Quote] = [P].[Quote]
;

SELECT COUNT(*) AS [TTL From Excel] FROM @t
SELECT COUNT(*) AS [TTLUniqueQuotesExcel] FROM (SELECT [Quote] FROM @t GROUP BY [Quote]) AS [Src]
SELECT COUNT(*) AS [TTL From Python] FROM @p
SELECT COUNT(*) AS [TTLUniqueQuotesPython] FROM (SELECT [Quote] FROM @p GROUP BY [Quote]) AS [Src]

SELECT
	'Quotes not in both',
	[P].[Quote] AS [PythonQuote],
	[T].[Quote] AS [ExcelQuote]
FROM
	@p [P]
FULL OUTER JOIN
	@t [T]
ON
	[P].[Quote] = [T].[Quote]
WHERE
	([P].[Quote] IS NULL)
	OR ([T].[Quote] IS NULL)

SELECT
	'Excel data inner join on orders and production data'
	,[T].*
	,[O2].[Available Date]
	,[O2].[JobAvailableLine]
	,[O2].[JobAvailableLine]
	,[O2].[JobAvailableScheduled]
	,[O2].[JobAvailableScheduledBy]
	,[DP2].[JobStartLine]
	,[DP2].[JobStartDate]
FROM
	@t AS [T]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O2]
ON
	[T].[Quote] = [O2].[SGQuote]
INNER JOIN
	[Stargatedb].[dbo].[dtProductionScheduleV2] AS [DP2]
ON
	[T].[Quote] = [DP2].[SGQuote]
ORDER BY
	[Available Date]

SELECT
	'Quotes only in excel'
	,*
	,CHARINDEX('_', [T].[Quote])
FROM
	@t [T]
LEFT JOIN
	@p [P]
ON
	[T].[Quote] = [P].[Quote]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] AS [O2]
ON
	[T].[Quote] = [O2].[SGQuote]
INNER JOIN
	[Stargatedb].[dbo].[dtProductionScheduleV2] AS [DP2]
ON
	[T].[Quote] = [DP2].[SGQuote]
WHERE
	([P].[Quote] IS NULL)
	AND (CHARINDEX('_', [T].[Quote]) = 0)

BEGIN TRAN

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[JobAvailableLine] = NULL
	,[JobAvailableScheduled] = NULL
	,[JobAvailableScheduledBy] = NULL
	,[Available Date] = NULL
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
INNER JOIN
	@p [P]
ON
	[O2].[SGQuote] = [P].[Quote]
LEFT JOIN
	@t [T]
ON
	[T].[Quote] = [P].[Quote]
INNER JOIN
	[Stargatedb].[dbo].[dtProductionScheduleV2] AS [DP2]
ON
	[P].[Quote] = [DP2].[SGQuote]
WHERE
	([T].[Quote] IS NULL)
	AND (CHARINDEX('_', [P].[Quote]) = 0)

SELECT *
FROM
	[BWSdb].[dbo].[OrdersV2] [O2]
INNER JOIN
	@p [P]
ON
	[O2].[SGQuote] = [P].[Quote]
LEFT JOIN
	@t [T]
ON
	[T].[Quote] = [P].[Quote]
INNER JOIN
	[Stargatedb].[dbo].[dtProductionScheduleV2] AS [DP2]
ON
	[P].[Quote] = [DP2].[SGQuote]
WHERE
	([T].[Quote] IS NULL)
	AND (CHARINDEX('_', [P].[Quote]) = 0)

ROLLBACK;
COMMIT;

--BEGIN TRAN;


--UPDATE
--	[BWSdb].[dbo].[OrdersV2]
--SET
--	[Available Date] = [Date]
--	,[JobAvailableLine] = [Line]
--	,[JobAvailableScheduled] = GETDATE()
--	,[JobAvailableScheduledBy] = 'vincef via abriggs'
--FROM
--	[BWSdb].[dbo].[OrdersV2] [O2]
--INNER JOIN
--	@t [T]
--ON
--	[O2].[SGQuote] = [T].[Quote]
--LEFT JOIN
--	@p [P]
--ON
--	[T].[Quote] = [P].[Quote]
--WHERE
--	([P].[Quote] IS NULL)
--	AND (CHARINDEX('_', [T].[Quote]) = 0)
--;

--UPDATE
--	[Stargatedb].[dbo].[dtProductionScheduleV2]
--SET
--	[JobStartLine] = [Line]
--FROM
--	[Stargatedb].[dbo].[dtProductionScheduleV2] [D2]
--INNER JOIN
--	@t [T]
--ON
--	[D2].[SGQuote] = [T].[Quote]
--LEFT JOIN
--	@p [P]
--ON
--	[T].[Quote] = [P].[Quote]
--WHERE
--	([P].[Quote] IS NULL)
--	AND (CHARINDEX('_', [T].[Quote]) = 0)
--;

--SELECT
--	'Quotes only in excel'
--	,*
--	,CHARINDEX('_', [T].[Quote])
--FROM
--	@t [T]
--LEFT JOIN
--	@p [P]
--ON
--	[T].[Quote] = [P].[Quote]
--WHERE
--	([P].[Quote] IS NULL)
--	AND (CHARINDEX('_', [T].[Quote]) = 0)

--ROLLBACK;
--COMMIT;