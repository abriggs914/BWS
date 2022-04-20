USE [SysproCompanyS]
GO
/****** Object:  StoredProcedure [dbo].[sp_ClkTallyHours]    Script Date: 2022-04-19 11:16:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- All calls are prioritized by P = (sd=ed) > empNum > transaction# > date
-- i.e. iff @by_transaction = 1 then ignore @by_date else apply @by_date iff applicable

--ALTER PROCEDURE [dbo].[sp_ClkTallyHours]
DECLARE
	@sd DATETIME, @ed DATETIME, @empNum NVARCHAR(MAX) = NULL, @by_transaction BIT = 1, @by_date BIT = 0
SET @sd = '2022-03-11';
SET @ed = '2022-03-17 23:59:59';
SET @by_transaction = 0;
SET @by_date = 1;

SELECT [TransactionID], [LoggedOn], [LoggedOff], [InTimeFromShopClk], [OutTimeFromShopClk] FROM [ClkTransaction]
WHERE
	[InTimeFromShopClk] BETWEEN @sd AND @ed
	AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
	AND [EmployeeNumber] = '300003'
ORDER BY
	[InTimeFromShopClk]
;

SELECT 
	[EmployeeName],
	[EmployeeNumber],
	SUM([Hrs]) AS [Hrs],
	CAST(CAST(YEAR([Day]) AS NVARCHAR(4)) + '-' + CAST(MONTH([Day]) AS NVARCHAR(2)) + '-' + CAST(DAY([Day]) AS NVARCHAR(4)) AS DATETIME) AS [Day]
FROM (
	SELECT
		[EmployeeName],
		[EmployeeNumber],
		[TransactionID],
		SUM(DATEDIFF(SECOND, [InTimeFromShopClk], (
			CASE WHEN DATEPART(DAY, [OutTimeFromShopClk]) = DATEPART(DAY, [InTimeFromShopClk]) THEN
				[OutTimeFromShopClk]
			ELSE DATEADD(HOUR, 23 - DATEPART(HOUR, [InTimeFromShopClk]), DATEADD(MINUTE, 59 - DATEPART(MINUTE, [InTimeFromShopClk]), DATEADD(SECOND, 59 - DATEPART(SECOND, [InTimeFromShopClk]), [InTimeFromShopClk]))) END))
		) / 60 / 60 AS [Hrs],
		MIN([InTimeFromShopClk]) AS [Day]
	FROM
		[ClkTransaction]
	WHERE
		[InTimeFromShopClk] BETWEEN @sd AND @ed
		AND [OutTimeFromShopClk] BETWEEN @sd AND @ed
		AND [EmployeeNumber] = '300003'
	GROUP BY
		[EmployeeName],
		[EmployeeNumber],
		[TransactionID]
) AS [Src]
GROUP BY
	[EmployeeName],
	[EmployeeNumber],
	YEAR([Day]), MONTH([Day]), DAY([Day])
ORDER BY
	[Day]
;
