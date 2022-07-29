USE BWSdb
GO

SELECT * FROM [Employees] ORDER BY [Date Hired]
SELECT * FROM [Employees - Salary] ORDER BY [Date Hired]

DECLARE @result AS TABLE ([ID] INT IDENTITY(1, 1), [Date] DATETIME, [#] INT)
DECLARE @d1 AS DATETIME;
DECLARE @d2 AS DATETIME;
DECLARE @dt AS DATETIME;

--SELECT @d1 = MIN([Date Hired]) FROM (SELECT MIN([Date Hired]) FROM [Employees] UNION SELECT MIN([Date Hired]) FROM [Employees - Salary])

--SELECT MIN([Date Hired]) FROM (SELECT MIN([Date Hired]) AS [Date Hired] FROM [Employees] UNION SELECT MIN([Date Hired]) FROM [Employees - Salary]) AS [Src]
SELECT @d1 = MIN([Date Hired]) FROM (SELECT MIN([Date Hired]) AS [Date Hired] FROM [Employees] UNION SELECT MIN([Date Hired]) FROM [Employees - Salary]) AS [Src];
SELECT @d2 = MAX([Date Hired]) FROM (SELECT MAX([Date Hired]) AS [Date Hired] FROM [Employees] UNION SELECT MAX([Date Hired]) FROM [Employees - Salary]) AS [Src];
SELECT @dt = @d1;

WHILE @dt <= @d2 BEGIN

	INSERT INTO @result ([Date], [#])
	SELECT
		@dt
		,COUNT(*) AS [Hourly]
	FROM (
		SELECT
			*
		FROM
			[Employees]
		WHERE
			[Date Hired] <= @dt AND ([Terminated] IS NULL OR [Terminated] >= @dt)
	) AS [Src]
	SET @dt = DATEADD(DAY, 1, @dt)

END

SELECT * FROM @result ORDER BY [Date]
