DECLARE @T TABLE ([ID] INT IDENTITY(1, 1), [Val] FLOAT, [Date] DATETIME);

INSERT INTO @T ([Val], [Date]) VALUES
	(4.12, '2019-03-29'),
	(9.36, '2019-04-28'),
	(4.17, '2019-05-28'),
	(5.76, '2019-06-28'),
	(5.49, '2019-07-05'),
	(3.33, '2020-09-06'),
	(1.27, '2020-09-09'),
	(9.54, '2020-09-10'),
	(6.88, '2020-09-11'),
	(4.12, '2021-11-29'),
	(9.36, '2021-11-28'),
	(4.17, '2020-11-28'),
	(5.76, '2020-10-28'),
	(5.49, '2021-11-05'),
	(3.33, '2020-11-16'),
	(1.27, '2020-11-17'),
	(9.54, '2020-11-18'),
	(6.88, '2020-11-19')
;
	
DECLARE @years TABLE ([ID] INT IDENTITY(1, 1), [Year] INT);
INSERT INTO @years
SELECT YEAR([Date]) FROM @T GROUP BY YEAR([Date]);

DECLARE @medians TABLE ([ID] INT IDENTITY(1, 1), [Median] FLOAT, [Year] INT);

DECLARE @c1 as INTEGER;
DECLARE @c2 as INTEGER;
DECLARE @i AS INTEGER;
SET @i = 0;
SELECT @c1 = COUNT(*) FROM @years;
SELECT @c2 = @C1;
IF @c2 % 2 = 1 BEGIN
	SET @c2 = @c2 - 1;
END
SET @c2 = @c2 / 2;

SELECT TOP 50 PERCENT [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY [Date]
SELECT TOP 50 PERCENT [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY [Date] DESC

(SELECT MAX([Val]) FROM (SELECT TOP 50 PERCENT [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY [Date]) AS TopHalf)
		(SELECT MAX([Val]) FROM (SELECT TOP 50 PERCENT [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY [Date] DESC) AS BottomHalf)

SELECT TOP (@i) * FROM @T

SELECT TOP (@c2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY [Date]
SELECT TOP (@c2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY [Date] DESC

SELECT @c1 AS [C1], @c2 AS [C2];

SELECT ((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) AS [H]
SELECT TOP ((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]), [Val]
SELECT TOP ((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]) DESC, [Val] DESC
SELECT (((SELECT MAX([Val]) FROM (SELECT TOP ((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]), [Val]) AS TopHalf)
		+ (SELECT MIN([Val]) FROM (SELECT TOP ((SELECT COUNT(*) FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1)) / 2) [Val] FROM @T WHERE YEAR([Date]) = (SELECT [Year] FROM @years WHERE [ID] = @i + 1) ORDER BY YEAR([Date]) DESC, [Val] DESC) AS BottomHalf)
		) / 2) AS [Median]