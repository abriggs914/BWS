USE BWSdb
GO

DECLARE @og_data AS TABLE (
	[row_num] INT,
	[RaiseID] INT,
	[Emp#] REAL,
	[Date] DATETIME,
	[STS] NVARCHAR(MAX),
	[Salary] FLOAT,
	[Annual] MONEY,
	[Bonus%] FLOAT,
	[Dep Life] FLOAT,
	[Health] FLOAT,
	[Dental] FLOAT,
	[Vacation%] FLOAT,
	[RRSP%] FLOAT,
	[Absent] FLOAT,
	[Late] FLOAT,
	[Leave Early] FLOAT,
	[NQ] BIT,
	[Reason] NVARCHAR(MAX),
	[2nd Name] NVARCHAR(MAX),
	[1st Name] NVARCHAR(MAX),
	[Hourly/Salary] NVARCHAR(MAX),
	[Comments] NVARCHAR(MAX)
)

INSERT INTO @og_data
	SELECT
		ROW_NUMBER() OVER (
			PARTITION BY [2nd Name], [1st Name]
			ORDER BY [Date]
		) AS row_num, *
	FROM 
		[Payroll]

DECLARE @emp_ids AS TABLE ([ID] INT IDENTITY(1, 1), [EmpID] BIGINT);

INSERT INTO @emp_ids
SELECT DISTINCT [Emp#] FROM @og_data GROUP BY [Emp#] ORDER BY [Emp#]

DECLARE @emp_dat AS TABLE (
	[row_num] INT,
	[Emp#] BIGINT,
	[Date] DATETIME,
	[2nd Name] NVARCHAR(MAX),
	[1st Name] NVARCHAR(MAX),
	[Salary] FLOAT,
	[Annual] FLOAT,
	[Vacation] FLOAT,
	[RRSP] FLOAT,
	[DSalary] FLOAT,
	[DAnnual] FLOAT,
	[DDate] FLOAT,
	[Salary / 8760 Hrs] FLOAT,
	[Annnual / 8760 Hrs] FLOAT
)

DECLARE @sub_emp_dat AS TABLE (
	[row_num] INT,
	[Emp#] BIGINT,
	[Date] DATETIME,
	[2nd Name] NVARCHAR(MAX),
	[1st Name] NVARCHAR(MAX),
	[Salary] FLOAT,
	[Annual] FLOAT,
	[Vacation] FLOAT,
	[RRSP] FLOAT,
	[DSalary] FLOAT,
	[DAnnual] FLOAT,
	[DDate] FLOAT,
	[Salary / 8760 Hrs] FLOAT,
	[Annnual / 8760 Hrs] FLOAT
)

DECLARE @c AS INT;
DECLARE @cs AS INT;
DECLARE @i AS INT;
DECLARE @j AS INT;
DECLARE @a AS INT;
DECLARE @b AS INT;
DECLARE @d1 AS DATETIME;
DECLARE @d2 AS DATETIME;
DECLARE @emp AS BIGINT;
SELECT @c = COUNT(*) FROM @emp_ids;
SELECT @i = 0;

WHILE @i < @c BEGIN
	DELETE FROM @sub_emp_dat;
	SELECT @emp = [EmpID] FROM @emp_ids WHERE [ID] = @i;
	PRINT '@emp: ' + CAST(@emp AS NVARCHAR(MAX));
	INSERT INTO
		@sub_emp_dat
	SELECT 
		[row_num],
		[Emp#],
		[Date],
		[2nd Name],
		[1st Name],
		[Salary],
		[Annual],
		[Vacation%],
		[RRSP%],
		NULL,
		NULL,
		NULL,
		[Salary] / 8760,
		[Annual] / 8760
	FROM
		@og_data
	WHERE
		[Emp#] = @emp
	ORDER BY
		[row_num]
	SELECT @cs = COUNT(*) FROM @sub_emp_dat;
	SET @j = 1;
	WHILE @j < @cs BEGIN
		SELECT @a = (CASE WHEN [Salary] IS NULL THEN 0 ELSE [Salary] END) FROM @sub_emp_dat WHERE [row_num] = @j
		SELECT @b = (CASE WHEN [Salary] IS NULL THEN 0 ELSE [Salary] END) FROM @sub_emp_dat WHERE [row_num] = @j + 1
		--PRINT 'A: ' + CAST(@a AS NVARCHAR(MAX)) + ', B: ' + CAST(@b AS NVARCHAR(MAX)) + ', J: ' + CAST(@j AS NVARCHAR(MAX))
		UPDATE @sub_emp_dat SET [DSalary] = @b - @a WHERE [row_num] = @j + 1

		SELECT @a = (CASE WHEN [Annual] IS NULL THEN 0 ELSE [Annual] END) FROM @sub_emp_dat WHERE [row_num] = @j
		SELECT @b = (CASE WHEN [Annual] IS NULL THEN 0 ELSE [Annual] END) FROM @sub_emp_dat WHERE [row_num] = @j + 1
		UPDATE @sub_emp_dat SET [DAnnual] = @b - @a WHERE [row_num] = @j + 1

		SELECT @d1 = [Date] FROM @sub_emp_dat WHERE [row_num] = @j
		SELECT @d2 = [Date] FROM @sub_emp_dat WHERE [row_num] = @j + 1
		UPDATE @sub_emp_dat SET [DDate] = DATEDIFF(DAY, @d1, @d2) WHERE [row_num] = @j + 1

		SET @j = @j + 1;
	END
	INSERT INTO @emp_dat
	SELECT * FROM @sub_emp_dat
	SET @i = @i + 1;
END

SELECT * FROM @og_data
SELECT * FROM @emp_ids
SELECT * FROM @emp_dat ORDER BY [2nd Name], [1st Name]
SELECT * FROM @emp_dat WHERE [1st Name] LIKE '%avery%'

-- View raises in 2023
SELECT 2023 AS [RaiseYear], * FROM @emp_dat WHERE YEAR([Date]) = 2023 ORDER BY [DAnnual]
-- View raises in 2022
SELECT 2022 AS [RaiseYear], * FROM @emp_dat WHERE YEAR([Date]) = 2022 ORDER BY [DAnnual]
-- View raises in 2021
SELECT 2021 AS [RaiseYear],  * FROM @emp_dat WHERE YEAR([Date]) = 2021 ORDER BY [DAnnual]
SELECT * FROM @emp_dat ORDER BY [Salary / 8760 Hrs], [Annnual / 8760 Hrs]
