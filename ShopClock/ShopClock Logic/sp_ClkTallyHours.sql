USE SysproCompanyA
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ClkTallyHours]
	@sd DATETIME, @ed DATETIME, @empNum BIGINT = NULL, @by_transaction BIT = 1
AS 
BEGIN 

	DECLARE @Src TABLE ([EmployeeNumber] BIGINT, [EmployeeName] NVARCHAR(200), [StartDate] DATETIME, [EndDate] DATETIME, [HrsWorked] FLOAT);
	IF @empNum IS NOT NULL BEGIN
		INSERT INTO @Src
		SELECT 
			[EmployeeNumber],
			[EmployeeName],
			@sd AS [StartDate],
			@ed AS [EndDate],
			ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
		FROM
			[ClkTransaction]
		WHERE
			[EmployeeNumber] = CAST(@empNum AS NVARCHAR)
			AND [InTimeFromShopClk] BETWEEN @sd AND @ed
		GROUP BY
			[EmployeeNumber], [EmployeeName]
		ORDER BY
			[EmployeeNumber];
		IF @by_transaction = 1 BEGIN
			SELECT 
				[TransactionID],
				[JobNumber],
				[ClkTransaction].[EmployeeNumber],
				[ClkTransaction].[EmployeeName],
				[LoggedOn],
				[InTimeFromShopClk],
				[LoggedOff],
				[OutTimeFromShopClk],
				(CASE WHEN [OutTimeFromShopClk] IS NULL THEN 0 ELSE 1 END) AS [PlaceHolder],
				[@Src].[HrsWorked]
			FROM
				[ClkTransaction]
			INNER JOIN
				@Src
			ON
				[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
			WHERE
				[ClkTransaction].[EmployeeNumber] = @empNum
				AND [InTimeFromShopClk] BETWEEN @sd AND @ed
			ORDER BY
				[PlaceHolder], [LoggedOn], [LoggedOff];
		END
		ELSE BEGIN
			SELECT 
				[ClkTransaction].[EmployeeNumber],
				[ClkTransaction].[EmployeeName],
				[@Src].[HrsWorked]
			FROM
				[ClkTransaction]
			INNER JOIN
				@Src
			ON
				[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
			WHERE
				[ClkTransaction].[EmployeeNumber] = @empNum
				AND [InTimeFromShopClk] BETWEEN  @sd AND @ed
			GROUP BY
				[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked]
			ORDER BY
				[ClkTransaction].[EmployeeNumber]
		END
	END
	ELSE BEGIN
		INSERT INTO @Src
		SELECT 
			[EmployeeNumber],
			[EmployeeName],
			@sd AS [StartDate],
			@ed AS [EndDate],
			ROUND(((60 * (SUM(DATEPART(HOUR, [OutTimeFromShopClk] - [InTimeFromShopClk])))) + SUM(DATEPART(MINUTE, [OutTimeFromShopClk] - [InTimeFromShopClk]))) / 60.0, 2) AS [HrsWorked]
		FROM
			[ClkTransaction]
		WHERE
			[InTimeFromShopClk] BETWEEN @sd AND @ed
		GROUP BY
			[EmployeeNumber], [EmployeeName]
		ORDER BY
			[EmployeeNumber];

		IF @by_transaction = 1 BEGIN
			SELECT 
				[TransactionID],
				[JobNumber],
				[ClkTransaction].[EmployeeNumber],
				[ClkTransaction].[EmployeeName],
				[LoggedOn],
				[InTimeFromShopClk],
				[LoggedOff],
				[OutTimeFromShopClk],
				(CASE WHEN [LoggedOff] IS NULL THEN 0 ELSE 1 END) AS [PlaceHolder],
				[@Src].[HrsWorked]
			FROM
				[ClkTransaction]
			INNER JOIN
				@Src
			ON
				[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
			WHERE
				[InTimeFromShopClk] BETWEEN  @sd AND @ed
			ORDER BY
				[PlaceHolder], [LoggedOn], [LoggedOff];
		END
		ELSE BEGIN
			SELECT 
				[ClkTransaction].[EmployeeNumber],
				[ClkTransaction].[EmployeeName],
				[@Src].[HrsWorked]
			FROM
				[ClkTransaction]
			INNER JOIN
				@Src
			ON
				[@Src].[EmployeeNumber] = [ClkTransaction].[EmployeeNumber]
			WHERE
				[InTimeFromShopClk] BETWEEN  @sd AND @ed
			GROUP BY
				[ClkTransaction].[EmployeeNumber], [ClkTransaction].[EmployeeName], [@Src].[HrsWorked]
			ORDER BY
				[ClkTransaction].[EmployeeNumber]
		END
	END
END