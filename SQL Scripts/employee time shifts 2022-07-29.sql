USE SysproCompanyA
GO

-- Power was out and people could nto log into shopclock.
-- take the first transaction for each of the listed employees and set thir start time back to the set time.

DECLARE @sd AS DATETIME = '2022-07-29';
DECLARE @ed AS DATETIME = '2022-07-29 15:00';

SELECT
	MIN([TransactionID]) AS [FirstTran]
	,[EmployeeName]
	,MIN([LoggedOn]) AS [MinLoggedOn]
	,MAX([LoggedOff]) AS [MaxLoggedOff]
FROM
	[ClkTransaction]
WHERE
	[LoggedOn] BETWEEN @sd AND @ed
GROUP BY
	[EmployeeName]
ORDER BY
	[EmployeeName]
;

DECLARE @names AS TABLE ([ID] INT IDENTITY(1, 1), [Name] NVARCHAR(MAX), [Hour] INT, [Minute] INT);
INSERT INTO @names ([Name], [Hour], [Minute]) VALUES
--('SMITH, JAMIE', 6, 0),
('EKPE, KALU', 6, 0),
('AMAECHI, ONYINYE', 6, 0),
('SMITH, ERIC', 6, 0),
('DEMERCHANT, MASON', 6, 0),
('CAPSTICK, RICHARD', 6, 0),
('OUELLETTE, NICHOLAS', 6, 0),
('SMITH, ANTON', 6, 0),

('THOMAS, LAWRENCE', 6, 15),
('FOSTER, RON', 6, 15),
('DELEAVEY, RYAN', 6, 15),
('ROBICHAUD, DANIEL', 6, 15),
('GROFF, CALEB', 6, 15),

('SAMAYOA, JOSIAH', 6, 30),
('BIGGAR,MICHAEL', 6, 30),
('PENICHE, LUIS', 6, 30),
('SAMAYOA, JONATHAN', 6, 30),
('', 6, 30),
('', 6, 30),
('', 6, 30),
('CLARK, BRANDON', 6, 30),
('FOSTER, PAUL', 6, 30),
('BRIDEAU, LUCAS', 6, 30),

('BROAD, RILEY', 7, 0),
('MCHATTEN, JONATHAN', 7, 0),
('MCADAM, JOE', 7, 0),
('DERRAH, CLARK', 7, 0),
('', 7, 0),
('BROAD, DUSTIN', 7, 0),
('COTE, JOSH', 7, 0),
('CARTER, MITCHELL', 7, 0),
('BROOKER, KYLE', 7, 0),
('SCHRIVER,GILLIAN', 7, 0),
('HENDERSON, JOHN', 7, 0),
('GALLEA, AARON', 7, 0),
('CALDWELL, ALEXANDER', 7, 0),
('DENNY, MATTHEW', 7, 0),
('GUEST, MIKE', 7, 0),
('GUEST, CAIDEN', 7, 0),
('HAINES, JAYDEN', 7, 0),
('MCHATTEN, MICHAEL', 7, 0),
('MARAZZO,ALEXANDER', 7, 0),
('KENNARD, JORDAN', 7, 0),
('NICHOLSON, SHAWN', 7, 0),
('KILFOIL, LIAM', 7, 0),
('BELL, BRIAN', 7, 0),
('PRIOR, BLAIRE', 7, 0),
('LEVESQUE, ANDREW', 7, 0),
('RITCHIE, MICHAEL', 7, 0),
('BYRNE, BRAEDEN', 7, 0),
('SMITH, KYLE', 7, 0),
('BROOKER, CHAD', 7, 0),
('MONTEITH, TRAVIS', 7, 0),
('DODIA D. SIDDHRAJ', 7, 0),
('JOHNSTON, DECLAN', 7, 0),
('BROAD, AUSTIN', 7, 0),
('LEVESQUE, ZACHARY', 7, 0)



--SELECT [EmployeeName] FROM [ClkTransaction] WHERE [LoggedOn] BETWEEN @sd AND @ed

BEGIN TRAN;
	SELECT
		[Src].*
		,[LoggedOn]
		,[LoggedOff]
		,CAST(
			CAST(DATEPART(YEAR, [LoggedOn]) AS NVARCHAR(4)) + '-' +
			CAST(DATEPART(MONTH, [LoggedOn]) AS NVARCHAR(2)) + '-' +
			CAST(DATEPART(DAY, [LoggedOn]) AS NVARCHAR(2)) + ' ' +
			CAST([Hour] AS NVARCHAR(2)) + ':' +
			CAST([Minute] AS NVARCHAR(2))
		AS DATETIME) AS [NewLogON]
	FROM (

		SELECT 
			[ID]
			,[EmployeeName]
			,[EmployeeNumber]
			,MIN([TransactionID]) AS [First Transaction Today]
			,[Hour]
			,[Minute]
		FROM
			[ClkTransaction]
		INNER JOIN
			@names
		ON
			[ClkTransaction].[EmployeeName] = [Name]
		WHERE
			[EmployeeName] LIKE '%' + (
				SELECT
					[Name]
				FROM
					@names
				WHERE
					LEN([Name]) > 0 AND
					[EmployeeName] LIKE '%' + [Name] + '%'
				) + '%'
			AND [LoggedOn] BETWEEN @sd AND @ed
		GROUP BY
			[ID]
			,[EmployeeName]
			,[EmployeeNumber]
			,[Hour]
			,[Minute]
	) AS [Src]
	INNER JOIN
		[ClkTransaction]
	ON
		[Src].[First Transaction Today] = [ClkTransaction].[TransactionID]
	ORDER BY
		[Src].[ID]



	UPDATE
		[ClkTransaction]
	SET
		[LoggedOn] = [Src2].[NewLogON]
	FROM (
		SELECT
			[Src].*
			,[LoggedOn]
			,[LoggedOff]
			,CAST(
				CAST(DATEPART(YEAR, [LoggedOn]) AS NVARCHAR(4)) + '-' +
				CAST(DATEPART(MONTH, [LoggedOn]) AS NVARCHAR(2)) + '-' +
				CAST(DATEPART(DAY, [LoggedOn]) AS NVARCHAR(2)) + ' ' +
				CAST([Hour] AS NVARCHAR(2)) + ':' +
				CAST([Minute] AS NVARCHAR(2))
			AS DATETIME) AS [NewLogON]
		FROM (

			SELECT 
				[ID]
				,[EmployeeName]
				,[EmployeeNumber]
				,MIN([TransactionID]) AS [First Transaction Today]
				,[Hour]
				,[Minute]
			FROM
				[ClkTransaction]
			INNER JOIN
				@names
			ON
				[ClkTransaction].[EmployeeName] = [Name]
			WHERE
				[EmployeeName] LIKE '%' + (
					SELECT
						[Name]
					FROM
						@names
					WHERE
						LEN([Name]) > 0 AND
						[EmployeeName] LIKE '%' + [Name] + '%'
					) + '%'
				AND [LoggedOn] BETWEEN @sd AND @ed
			GROUP BY
				[ID]
				,[EmployeeName]
				,[EmployeeNumber]
				,[Hour]
				,[Minute]
		) AS [Src]
		INNER JOIN
			[ClkTransaction]
		ON
			[Src].[First Transaction Today] = [ClkTransaction].[TransactionID]
		--ORDER BY
		--	[Src].[ID]
	) AS [Src2]
	WHERE
		[TransactionID] = [First Transaction Today]




	SELECT
		[Src].*
		,[LoggedOn]
		,[LoggedOff]
		,CAST(
			CAST(DATEPART(YEAR, [LoggedOn]) AS NVARCHAR(4)) + '-' +
			CAST(DATEPART(MONTH, [LoggedOn]) AS NVARCHAR(2)) + '-' +
			CAST(DATEPART(DAY, [LoggedOn]) AS NVARCHAR(2)) + ' ' +
			CAST([Hour] AS NVARCHAR(2)) + ':' +
			CAST([Minute] AS NVARCHAR(2))
		AS DATETIME) AS [NewLogON]
	FROM (

		SELECT 
			[ID]
			,[EmployeeName]
			,[EmployeeNumber]
			,MIN([TransactionID]) AS [First Transaction Today]
			,[Hour]
			,[Minute]
		FROM
			[ClkTransaction]
		INNER JOIN
			@names
		ON
			[ClkTransaction].[EmployeeName] = [Name]
		WHERE
			[EmployeeName] LIKE '%' + (
				SELECT
					[Name]
				FROM
					@names
				WHERE
					LEN([Name]) > 0 AND
					[EmployeeName] LIKE '%' + [Name] + '%'
				) + '%'
			AND [LoggedOn] BETWEEN @sd AND @ed
		GROUP BY
			[ID]
			,[EmployeeName]
			,[EmployeeNumber]
			,[Hour]
			,[Minute]
	) AS [Src]
	INNER JOIN
		[ClkTransaction]
	ON
		[Src].[First Transaction Today] = [ClkTransaction].[TransactionID]
	ORDER BY
		[Src].[ID]
ROLLBACK;
COMMIT;