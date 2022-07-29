USE BWSdb
GO

SELECT * FROM [Employees] ORDER BY [Date Hired]
SELECT * FROM [Employees - Salary] ORDER BY [Date Hired]

DECLARE @result AS TABLE ([ID] INT IDENTITY(1, 1), [Date] DATETIME, [#] INT, [#H] INT, [#S] INT)
DECLARE @d1 AS DATETIME;
DECLARE @d2 AS DATETIME;
DECLARE @dt AS DATETIME;

--SELECT @d1 = MIN([Date Hired]) FROM (SELECT MIN([Date Hired]) FROM [Employees] UNION SELECT MIN([Date Hired]) FROM [Employees - Salary])

--SELECT MIN([Date Hired]) FROM (SELECT MIN([Date Hired]) AS [Date Hired] FROM [Employees] UNION SELECT MIN([Date Hired]) FROM [Employees - Salary]) AS [Src]
SELECT @d1 = MIN([Date Hired]) FROM (SELECT MIN([Date Hired]) AS [Date Hired] FROM [Employees] UNION SELECT MIN([Date Hired]) FROM [Employees - Salary]) AS [Src];
SELECT @d2 = MAX([Date Hired]) FROM (SELECT MAX([Date Hired]) AS [Date Hired] FROM [Employees] UNION SELECT MAX([Date Hired]) FROM [Employees - Salary]) AS [Src];
SELECT @dt = @d1;

WHILE @dt <= @d2 BEGIN

	INSERT INTO @result ([Date], [#], [#H], [#S])
	
	SELECT 
		[Src1].[Date]
		,COUNT(*)
		,COUNT([Src1].[1st Name])
		,COUNT([Src2].[1st Name])
	FROM
	(SELECT
		@dt AS [Date]
		,*
	FROM
		[Employees]
	WHERE
		[Date Hired] <= @dt AND ([Terminated] IS NULL OR [Terminated] >= @dt)
	) AS [Src1]
	INNER JOIN (
		SELECT
			@dt AS [Date]
			,*
		FROM
			[Employees - Salary]
		WHERE
			[Date Hired] <= @dt AND ([Terminated] IS NULL OR [Terminated] >= @dt)
	) AS [Src2]
	ON 
		[Src1].[Date] = [Src2].[Date]
	GROUP BY
		[Src1].[Date]


	--SELECT
	--	@dt
	--	,COUNT([Src1].[1st Name]) AS [Hourly]
	--	,COUNT([Src2].[1st Name]) AS [Salary]
	--FROM ((
	--	SELECT
	--		*
	--	FROM
	--		[Employees]
	--	WHERE
	--		[Date Hired] <= @dt AND ([Terminated] IS NULL OR [Terminated] >= @dt)
	--) AS [Src1]
	--INNER JOIN (
	--	SELECT
	--		*
	--	FROM
	--		[Employees - Salary]
	--	WHERE
	--		[Date Hired] <= @dt AND ([Terminated] IS NULL OR [Terminated] >= @dt)
	--) AS [Src2]
	--) AS [SSrc]
	SET @dt = DATEADD(DAY, 1, @dt)

END

SELECT * FROM @result ORDER BY [Date]
