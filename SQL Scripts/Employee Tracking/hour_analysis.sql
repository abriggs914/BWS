USE BWSdb
GO

DECLARE @B_ONE BIT = 0;

IF @B_ONE = 1 BEGIN
	SELECT * FROM [Employees] ORDER BY [2nd Name], [1st Name]
	SELECT * FROM [Sales Staff] ORDER BY [Sales Person]
	SELECT * FROM [Design StaffV2] ORDER BY [Staff]
	SELECT * FROM [Design BOM Staff]

	SELECT * FROM  [SysproCompanyA].[dbo].[BomEmployee]
END


DECLARE @TODAY AS DATETIME;
SET @TODAY = '2021-07-27 2:23 PM'
SELECT
	*
FROM
	[dtProductionSchedule]
WHERE
	[Prod Date 1] < @TODAY
ORDER BY
	[Prod Date 1] DESC


SELECT * FROM [SysproCompanyA].[dbo].[BomEmployee]

SELECT * FROM [SysproCompanyA].[dbo].[ClkTransaction]