DECLARE @sd DATETIME =
	CAST(YEAR(GETDATE()) AS NVARCHAR(4)) 
	+ '-' + RIGHT('00' + CAST(MONTH(GETDATE()) AS NVARCHAR(2)), 2)
	+ '-' + RIGHT('00' + CAST(DAY(GETDATE()) AS NVARCHAR(2)), 2)
DECLARE @ed DATETIME = DATEADD(DAY, 7, @sd)
DECLARE @nd INTEGER = 1;

DECLARE @lines TABLE ([ID] INT IDENTITY(0, 1), [Line] NVARCHAR(MAX));
DECLARE @dates TABLE ([ID] INT IDENTITY(0, 1), [Date] DATETIME);

INSERT INTO @lines VALUES
('ED1'),
('ED2'),
('WFL'),
('TPL'),
('WAR')

DECLARE @i DATETIME;
SELECT @i = @sd

WHILE @i <= DATEADD(DAY, @nd, @ed) BEGIN
	INSERT INTO @dates VALUES (@i)
	SELECT @i = DATEADD(DAY, 1, @i)
END


SELECT
	'Investigation1' AS [Txt],
	[O].[SGQuote],
	[O].[JobAvailableLine],
	[O].[Available Date],
	[O].[Decline/Rejected],
	[SysproCompanyS].[dbo].[GetNthBusinessDay]([O].[Available Date], @nd) AS [NewDate],
	(CASE
		WHEN [SrcA].[SGQuote] IS NULL THEN 0
		ELSE 1
	END) AS [Found]
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	@lines [L]
ON
	[O].[JobAvailableLine] = [L].[Line]
INNER JOIN
	@dates [D]
ON
	[O].[Available Date] = [D].[Date]
FULL OUTER JOIN (
	SELECT
		*
	FROM
		[BWSdb].[dbo].[OrdersV2]
	WHERE
		[SGQuote] IN (
			'SG101674',
			'SG101625',
			'SG101607',
			'SG101594',
			'SG101589'
		)
) AS [SrcA]
ON
	[O].[SGQuote] = [SrcA].[SGQuote]
ORDER BY
	[O].[Available Date] DESC


SELECT
	'Investigation2' AS [Txt],
	[O].[SGQuote],
	[O].[JobStartLine],
	[O].[JobFinishDate],
	[SysproCompanyS].[dbo].[GetNthBusinessDay]([O].[JobFinishDate], @nd) AS [NewDate],
	(CASE
		WHEN [SrcA].[SGQuote] IS NULL THEN 0
		ELSE 1
	END) AS [Found]
FROM
	[Stargatedb].[dbo].[dtProductionScheduleV2] [O]
INNER JOIN
	@lines [L]
ON
	[O].[JobStartLine] = [L].[Line]
INNER JOIN
	@dates [D]
ON
	[O].[JobFinishDate] = [D].[Date]
FULL OUTER JOIN (
	SELECT
		*
	FROM
		[Stargatedb].[dbo].[dtProductionScheduleV2]
	WHERE
		[SGQuote] IN (
			'SG101674',
			'SG101625',
			'SG101607',
			'SG101594',
			'SG101589'
		)
) AS [SrcA]
ON
	[O].[SGQuote] = [SrcA].[SGQuote]
ORDER BY
	[O].[JobFinishDate] DESC


SELECT
	'Double Booked Quotes' AS [Txt],
	[O1].[SGQuote] AS [1SGQuote],
	[O1].[JobAvailableLine] AS [1JobAvailableLine],
	[O1].[Available Date] AS [1Available Date],
	
	[O2].[SGQuote] AS [2SGQuote],
	[O2].[JobAvailableLine] AS [2JobAvailableLine],
	[O2].[Available Date] AS [2Available Date]
FROM
	[BWSdb].[dbo].[OrdersV2] [O1]
INNER JOIN
	[BWSdb].[dbo].[OrdersV2] [O2]
ON
	([O1].[Available Date] = [O2].[Available Date])
	AND ([O1].[JobAvailableLine] = [O2].[JobAvailableLine])
WHERE
	[O1].[SGQuote] <> [O2].[SGQuote]

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[OrdersV2]
SET
	[JobAvailableLine] = NULL
WHERE
	[SGQuote] = 'SG101370'

ROLLBACK;
COMMIT;
*/