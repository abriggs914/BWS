USE BWSdb
GO


SELECT * FROM [IT Requests]

DECLARE @hpy AS INTEGER;
SET @hpy = 2000;

-- Approximating median

DECLARE @T TABLE ([ID] INT IDENTITY(1, 1), [Val] FLOAT, [Date] DATETIME);
INSERT INTO @T
SELECT (CASE WHEN [Salary] IS NULL THEN [Annual] / @hpy ELSE (CASE WHEN [Salary] > 10000 THEN [Salary] / @hpy ELSE [Salary] END) END), [Date] FROM [Payroll] ORDER BY [Date] DESC;
--INSERT INTO @T ([Val], [Date]) VALUES
--	(4.12, '2019-03-29'),
--	(9.36, '2019-04-28'),
--	(4.17, '2019-05-28'),
--	(5.76, '2019-06-28'),
--	(5.49, '2019-07-05'),
--	(3.33, '2020-09-06'),
--	(1.27, '2020-09-09'),
--	(9.54, '2020-09-10'),
--	(6.88, '2020-09-11'),
--	(4.12, '2021-11-29'),
--	(9.36, '2021-11-28'),
--	(4.17, '2020-11-28'),
--	(5.76, '2020-10-28'),
--	(5.49, '2021-11-05'),
--	(3.33, '2020-11-16'),
--	(1.27, '2020-11-17'),
--	(9.54, '2020-11-18'),
--	(6.88, '2020-11-19')
--;

SELECT * FROM @T
	
DECLARE @years TABLE ([ID] INT IDENTITY(1, 1), [Year] INT);
INSERT INTO @years
SELECT YEAR([Date]) FROM @T GROUP BY YEAR([Date]);

DECLARE @medians TABLE ([ID] INT IDENTITY(1, 1), [Year] INT, [A] FLOAT, [B] FLOAT);

DECLARE @c1 as INTEGER;
DECLARE @c2 as INTEGER;
DECLARE @lh as INTEGER;
DECLARE @rh as INTEGER;
DECLARE @i AS INTEGER;
SET @i = 0;
SELECT @c1 = COUNT(*) FROM @years;
SELECT @c2 = COUNT(*) FROM @YEARS;
IF @c2 % 2 = 1 BEGIN
	SET @c2 = @c2 - 1;
	SET @c2 = @c2 / 2;
END
WHILE @i < @c1 BEGIN

	SET @lh = ((
				(SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2)
				+ (CASE WHEN (SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) % 2 = 1 THEN 1 ELSE 0 END)
				);
	IF @lh < 0 BEGIN
		SET @lh = 0;
	END

	SET @rh = ((
				(SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2)
				+ (CASE WHEN (SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) % 2 = 1 THEN 1 ELSE 0 END)
				);
	IF @rh < 0 BEGIN
		SET @rh = 0;
	END

	INSERT INTO @medians ([Year], [A], [B]) 
		SELECT 
		--(
		--(SELECT MAX([Val]) * 10000 AS [Val] FROM (SELECT TOP ((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]), [Val]) AS TopHalf)
		--+ (SELECT MIN([Val]) * 10000 AS [Val] FROM (SELECT TOP (((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) + (CASE WHEN (SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) % 2 = 1 THEN -1 ELSE 0 END)) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]) DESC, [Val] DESC) AS BottomHalf)
		--) / 2 AS [Median]),
		(SELECT [Year] FROM @years WHERE [ID] = @i + 1),
		(SELECT MAX([Val]) * @hpy AS [Val] FROM 
			(SELECT TOP (@lh)
				[Val] FROM
				@T 
				WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]), [Val]) AS [A]),
		(SELECT MIN([Val]) * @hpy AS [Val] FROM 
			(SELECT TOP (@rh)
				[Val] FROM
				@T 
				WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]) DESC, [Val] DESC) AS [B])
	
	SET @i = @i + 1;

END
;

SELECT * FROM @T;
SELECT * FROM @years
SELECT @c1 AS [C1], @c2 AS [C2]
SELECT [Year], CAST(([A] + [B]) / 2 AS MONEY) AS [Median Annual Salary] FROM @medians

