USE [SysproCompanyA]
GO
/****** Object:  StoredProcedure [dbo].[sp_ClkLabourOverride]    Script Date: 2022-02-16 10:01:20 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ClkLabourOverride]
--DECLARE
	@sd DATETIME, @ed DATETIME
--SET @sd = '2022-02-10'
--SET @ed = '2022-02-10 23:59:59'
AS
BEGIN

DECLARE @T TABLE ([EmployeeNumber] REAL,
				[EmployeeName] NVARCHAR(200),
				[HrsWorked] FLOAT,
				[StartDate] DATETIME,
				[EndDate] DATETIME);

INSERT INTO @T EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0

SELECT
	*
	
	FROM @T
LEFT JOIN
	[ClkShiftEmpAssign]
ON
	[@T].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
LEFT JOIN
	[ClkShiftRoundRules V2]
ON
	[ClkShiftEmpAssign].[ShiftID] = [ClkShiftRoundRules V2].[ShiftID]
LEFT JOIN (
	SELECT
		*
	FROM
		[ClkFrmConfirm]
	WHERE
		[EntryDate] BETWEEN @sd AND @ed
) AS [Src]
ON
	[Src].[EmployeeNumber] = [@T].[EmployeeNumber]
INNER JOIN (
	SELECT 
		[EmployeeNumber],
		MIN([InTimeFromShopClk]) AS [InTimeFromShopClk],
		MAX([OutTimeFromShopClk]) AS [OutTimeFromShopClk]
	FROM
		[ClkTransaction]
	WHERE
		([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
		AND [InTimeFromShopClk] IS NOT NULL
	GROUP BY
		[EmployeeNumber]
		
	) AS [A]
ON
	[A].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
WHERE
	([EntryDate] IS NULL OR [EntryDate] BETWEEN @sd AND @ed)
	AND ([InTimeFromShopClk] BETWEEN @sd AND @ed OR [OutTimeFromShopClk] BETWEEN @sd AND @ed)
	AND [InTimeFromShopClk] IS NOT NULL
END