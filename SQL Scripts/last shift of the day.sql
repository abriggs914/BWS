USE SysproCompanyA
GO

--CREATE VIEW [dbo].[v_ClkTransaction ShiftsOverNight]
--AS

--SELECT 
--	*
--FROM 
--	[ClkTransaction]
--WHERE
--	[BWSdb].[dbo].[Datify](YEAR([LoggedOn]), MONTH([LoggedOn]), DAY([LoggedOn]), DEFAULT, DEFAULT, DEFAULT)
--	<>
--	[BWSdb].[dbo].[Datify](YEAR([LoggedOff]), MONTH([LoggedOff]), DAY([LoggedOff]), DEFAULT, DEFAULT, DEFAULT)


----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------

--SET NOCOUNT ON;

DECLARE
	@t
AS TABLE 
(
	[ID] INT IDENTITY(1, 1)
	, [DateCreated] DATETIME DEFAULT GETDATE()
	, [Active] BIT
	, [DateActive] DATETIME
	, [DateInActive] DATETIME
	, [TransactionID] INT
	, [EmployeeName] NVARCHAR(MAX)
	, [EmployeeNumber] INT
	, [LoggedOn] DATETIME
	, [LoggedOff] DATETIME
	, [HrsFromLastLogOn] DECIMAL(14, 3)
)
;

INSERT INTO @t ([TransactionID], [EmployeeName], [EmployeeNumber], [LoggedOn], [LoggedOff]) 
SELECT 
	[A].[TransactionID]
	, [A].[EmployeeName]
	, [A].[EmployeeNumber]
	, [A].[LoggedOn]
	, [A].[LoggedOff]
FROM 
	[ClkTransaction] AS [A]
WHERE
	YEAR([A].[LoggedOn]) = 2021
	--AND 
	--[EmployeeNumber] = 200434
GROUP BY
	[A].[TransactionID]
	, [A].[EmployeeName]
	, [A].[EmployeeNumber]
	, [A].[LoggedOn]
	, [A].[LoggedOff]
ORDER BY
	[EmployeeName]
	, [A].[LoggedOn]
;


--DECLARE @loggedOn AS DATETIME;
DECLARE @loggedOff AS DATETIME;
	
DECLARE @i AS INT;
DECLARE @c AS INT;

SELECT @i = 2;
SELECT @c = COUNT(*) FROM @t;

--SELECT @c AS [#]

WHILE @i <= @c BEGIN 

	--SELECT @loggedOn = [LoggedOn] FROM @t WHERE [ID] = @i;
	SELECT @loggedOff = [LoggedOff] FROM @t WHERE [ID] = @i - 1;

	UPDATE
		@t
	SET
		[HrsFromLastLogOn] = DATEDIFF(SECOND, @loggedOff, [LoggedOn]) / (60.0 * 60)
	WHERE
		[ID] = @i
	;

	SET @i = @i + 1;

	--IF @i =10 BEGIN
	--	SELECT @i =100000000;
	--END

END

--SELECT @c AS [#]
SELECT * FROM @t-- WHERE [HrsFromLastLogOn] >= 8;
SELECT * FROM @t WHERE [HrsFromLastLogOn] >= 8;
--SELECT SUM([HrsFromLastLogOn]) FROM @t