USE SysproCompanyA
GO
/*
SELECT
	*
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] = '200652' AND [LoggedOn] BETWEEN '2022-09-15' AND '2022-09-21'
	*/

DECLARE @tid AS BIGINT;
SELECT @tid = 1509895;

DECLARE @s AS BIGINT;
SELECT @s = 125;

DECLARE @e AS BIGINT;
SELECT @e = 200663;


SELECT
	*
FROM
	[ClkTransaction]
WHERE
	([TransactionID] BETWEEN CAST(@tid - @s AS NVARCHAR(8)) AND CAST(@tid + @s AS NVARCHAR(8)))
	AND ((CASE WHEN @s IS NULL THEN 1 WHEN [EmployeeNumber] = @e THEN 1 ELSE 0 END) > 0)