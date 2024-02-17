DECLARE @id INT = 1;

SELECT * FROM  [ITR Customers] WHERE [CustomerID] = @id;

IF OBJECT_ID('tempdb..#ACD_currTable', 'U') IS NOT NULL BEGIN
	DROP TABLE #ACD_currTable
END

IF OBJECT_ID('tempdb..#ACD_insertTable', 'U') IS NOT NULL BEGIN
	DROP TABLE #ACD_insertTable
END

IF OBJECT_ID('tempdb..#ACD_deleteTable', 'U') IS NOT NULL BEGIN
	DROP TABLE #ACD_insertTable
END

IF OBJECT_ID('tempdb..#ACD_diffTable', 'U') IS NOT NULL BEGIN
	DROP TABLE #ACD_diffTable
END

CREATE TABLE #ACD_currTable (
	[CustomerID] [bigint] NULL,
	[Name] [nvarchar](max) NULL,
	[Department] [int] NULL,
	[Company] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[WorkPhone] [nvarchar](50) NULL,
	[WorkExtension] [nvarchar](50) NULL,
	[CellPhone] [nvarchar](50) NULL,
	[HomePhone] [nvarchar](50) NULL,
	[Active] [bit] NULL,
	[DateAdded] [datetime] NULL,
	[LastActive] [datetime] NULL,
	[WorkPhoneLastActive] [datetime] NULL,
	[WorkExtensionLastActive] [datetime] NULL,
	[CellPhoneLastActive] [datetime] NULL,
	[HomePhoneLastActive] [datetime] NULL,
	[WindowsUser] [nvarchar](255) NULL,
	[BirthYear] [int] NULL,
	[BirthMonth] [int] NULL,
	[BirthDay] [int] NULL,
	[HireYear] [int] NULL,
	[HireMonth] [int] NULL,
	[HireDay] [int] NULL,
	[EmpType] [int] NULL,
	[TerminationYear] [int] NULL,
	[TerminationMonth] [int] NULL,
	[TerminationDay] [int] NULL,
	[MiddleName] [nvarchar](max) NULL,
	[IsAPerson] [bit] NULL
)

INSERT INTO #ACD_currTable (
	[CustomerID],
	[Name],
	[Department],
	[Company],
	[Email],
	[WorkPhone],
	[WorkExtension],
	[CellPhone],
	[HomePhone],
	[Active],
	[DateAdded],
	[LastActive],
	[WorkPhoneLastActive],
	[WorkExtensionLastActive],
	[CellPhoneLastActive],
	[HomePhoneLastActive],
	[WindowsUser],
	[BirthYear],
	[BirthMonth],
	[BirthDay],
	[HireYear],
	[HireMonth],
	[HireDay],
	[EmpType],
	[TerminationYear],
	[TerminationMonth],
	[TerminationDay],
	[MiddleName],
	[IsAPerson]
)
SELECT
	[CustomerID],
	[Name],
	[Department],
	[Company],
	[Email],
	[WorkPhone],
	[WorkExtension],
	[CellPhone],
	[HomePhone],
	[Active],
	[DateAdded],
	[LastActive],
	[WorkPhoneLastActive],
	[WorkExtensionLastActive],
	[CellPhoneLastActive],
	[HomePhoneLastActive],
	[WindowsUser],
	[BirthYear],
	[BirthMonth],
	[BirthDay],
	[HireYear],
	[HireMonth],
	[HireDay],
	[EmpType],
	[TerminationYear],
	[TerminationMonth],
	[TerminationDay],
	[MiddleName],
	[IsAPerson]
FROM
	[ITR Customers]
WHERE
	[CustomerID] = @id
;

CREATE TABLE #ACD_insertTable (
	[CustomerID] [bigint] NULL,
	[Name] [nvarchar](max) NULL,
	[Department] [int] NULL,
	[Company] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[WorkPhone] [nvarchar](50) NULL,
	[WorkExtension] [nvarchar](50) NULL,
	[CellPhone] [nvarchar](50) NULL,
	[HomePhone] [nvarchar](50) NULL,
	[Active] [bit] NULL,
	[DateAdded] [datetime] NULL,
	[LastActive] [datetime] NULL,
	[WorkPhoneLastActive] [datetime] NULL,
	[WorkExtensionLastActive] [datetime] NULL,
	[CellPhoneLastActive] [datetime] NULL,
	[HomePhoneLastActive] [datetime] NULL,
	[WindowsUser] [nvarchar](255) NULL,
	[BirthYear] [int] NULL,
	[BirthMonth] [int] NULL,
	[BirthDay] [int] NULL,
	[HireYear] [int] NULL,
	[HireMonth] [int] NULL,
	[HireDay] [int] NULL,
	[EmpType] [int] NULL,
	[TerminationYear] [int] NULL,
	[TerminationMonth] [int] NULL,
	[TerminationDay] [int] NULL,
	[MiddleName] [nvarchar](max) NULL,
	[IsAPerson] [bit] NULL
)

INSERT INTO #ACD_insertTable (
	[CustomerID],
	[Name],
	[Department],
	[Company],
	[Email],
	[WorkPhone],
	[WorkExtension],
	[CellPhone],
	[HomePhone],
	[Active],
	[DateAdded],
	[LastActive],
	[WorkPhoneLastActive],
	[WorkExtensionLastActive],
	[CellPhoneLastActive],
	[HomePhoneLastActive],
	[WindowsUser],
	[BirthYear],
	[BirthMonth],
	[BirthDay],
	[HireYear],
	[HireMonth],
	[HireDay],
	[EmpType],
	[TerminationYear],
	[TerminationMonth],
	[TerminationDay],
	[MiddleName],
	[IsAPerson]
)
SELECT
	[CustomerID],
	[Name],
	[Department],
	[Company],
	[Email],
	[WorkPhone],
	[WorkExtension],
	[CellPhone],
	[HomePhone],
	[Active],
	[DateAdded],
	[LastActive],
	[WorkPhoneLastActive],
	[WorkExtensionLastActive],
	[CellPhoneLastActive],
	[HomePhoneLastActive],
	[WindowsUser],
	[BirthYear],
	[BirthMonth],
	[BirthDay],
	[HireYear],
	[HireMonth],
	[HireDay],
	[EmpType],
	[TerminationYear],
	[TerminationMonth],
	[TerminationDay],
	[MiddleName],
	[IsAPerson]
FROM
	[ITR Customers]
WHERE
	[CustomerID] = @id
;

UPDATE
	#ACD_insertTable
SET
	[MiddleName] = 'NEW MIDDLE NAME'
	,[Email] = 'abriggs914@gmail.com'
WHERE
	[CustomerID] = @id
;

SELECT [MiddleName] FROM #ACD_currTable
SELECT [MiddleName] FROM #ACD_insertTable

---------------------------------------------
	   

CREATE TABLE #ACD_diffTable (
	[ID] INT IDENTITY(0, 1),
	[PKID] INT,
	[Column] NVARCHAR(MAX),
	[ValueBefore] NVARCHAR(MAX),
	[ValueAfter] NVARCHAR(MAX)
);

DECLARE @columnsTable AS TABLE (
	[ID] INT IDENTITY(0, 1),
	[Column] NVARCHAR(MAX)
);

--SELECT 
--	[C].[COLUMN_NAME],
--	[C].[DATA_TYPE]
--FROM INFORMATION_SCHEMA.COLUMNS [C]
--WHERE ([TABLE_NAME] = 'Orders')


INSERT INTO @columnsTable ([Column])
SELECT [COLUMN_NAME]
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE ([TABLE_NAME] = 'ITR Customers')
	AND ([DATA_TYPE]) NOT IN (
		'ntext',
		'timestamp',
		'image'
	)
	
DECLARE @col NVARCHAR(MAX);
DECLARE @val_c NVARCHAR(MAX);
DECLARE @val_i NVARCHAR(MAX);
DECLARE @val_d NVARCHAR(MAX);
	
DECLARE @localSQL NVARCHAR(MAX) = '';
DECLARE @i INT = 0;
DECLARE @c INT = 0;

SELECT @c = COUNT(*) FROM @columnsTable;

--INSERT INTO #ACD_diffTable (
--	[PKID],
--	[Column],
--	[ValueBefore],
--	[ValueAfter]
--)
--	SELECT
--		[C].[CustomerID],
--		'CustomerID',
--		[C].[CustomerID],
--		[I].[CustomerID]
--	FROM 
--		#ACD_insertTable AS [I]
--	INNER JOIN
--		[ITR Customers] AS [C]
--	ON
--		[I].[CustomerID] = [C].[CustomerID]


--SELECT
--	'THISONE',
--	[C].[CustomerID],
--	'MiddleName',
--	CAST([C].[MiddleName] AS NVARCHAR(MAX)),
--	CAST([I].[MiddleName] AS NVARCHAR(MAX))
--FROM
--	#ACD_insertTable AS [I]
--INNER JOIN
--	[ITR Customers] AS [C]
--ON
--	[I].[CustomerID] = [C].[CustomerID]
--WHERE
--	CAST(ISNULL([C].[MiddleName], '') AS NVARCHAR(MAX)) <> CAST(ISNULL([I].[MiddleName], '') AS NVARCHAR(MAX));

SELECT
	'THISONE',
	[C].[CustomerID],
	'CustomerID',
	CAST([C].[CustomerID] AS NVARCHAR(MAX)),
	CAST([I].[CustomerID] AS NVARCHAR(MAX))
FROM
	#ACD_insertTable AS [I] 
INNER JOIN 
	[ITR Customers] AS [C]
ON
	[I].[CustomerID] = [C].[CustomerID]
WHERE
	LTRIM(RTRIM(CAST(ISNULL([C].[CustomerID], '') AS NVARCHAR(MAX)))) 
	<> LTRIM(RTRIM(CAST(ISNULL([I].[CustomerID], '') AS NVARCHAR(MAX))));

SELECT
	'PreResult'
	,*
FROM
	#ACD_diffTable
;

WHILE @i < @c BEGIN

	SELECT @col = [Column] FROM @columnsTable WHERE [ID] = @i;
	--EXEC [sp_executesql] 'SELECT [' + @col  + '] FROM [ITR Customers] INNER JOIN [INSERTED] [I] ON []'
	SELECT @localSQL = 'INSERT INTO #ACD_diffTable ([PKID], [Column], [ValueBefore], [ValueAfter]) ';
	SELECT @localSQL = @localSQL + 'SELECT [C].[CustomerID], ''' + @col + ''', CAST([C].[' + @col + '] AS NVARCHAR(MAX)), CAST([I].[' + @col + '] AS NVARCHAR(MAX)) ';
	SELECT @localSQL = @localSQL + 'FROM #ACD_insertTable AS [I] INNER JOIN [ITR Customers] AS [C] ON [I].[CustomerID] = [C].[CustomerID] ';
	SELECT @localSQL = @localSQL + 'WHERE LTRIM(RTRIM(CAST(ISNULL([C].[' + @col + '], '''') AS NVARCHAR(MAX)))) <> LTRIM(RTRIM(CAST(ISNULL([I].[' + @col + '], '''') AS NVARCHAR(MAX))));'
	EXEC [sp_executesql] @localSQL

	SELECT
		@val_i = [ValueAfter]
		,@val_d = [ValueBefore]
	FROM
		#ACD_diffTable
	WHERE
		[ID] = @i
	;

	--SELECT @col, @val_d, @val_i, @localSQL;
	SELECT @i = @i + 1;

END

SELECT
	'EndResult'
	,*
FROM
	#ACD_diffTable
;