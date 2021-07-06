USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ProductionSlotsvsForecastRpt 2]    Script Date: 6/29/2021 9:52:05 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery Briggs>
-- Create date: <2021-06-29>
-- Description:	<Generate the Dealer Slots VS Forecast report.>
--=============================================

ALTER PROCEDURE [dbo].[sp_ProductionSlotsvsForecastRpt 2] 
	-- Add the parameters for the stored procedure here
	@sd DATETIME,
	@ss INT = 2
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @m1 DATETIME = DATEADD(mm, DATEDIFF(mm, 0, @sd), 0);

	DECLARE @m2 DATETIME = DATEADD(MONTH, 1, @m1),
			@m3 DATETIME = DATEADD(MONTH, 2, @m1),
			@m4 DATETIME = DATEADD(MONTH, 3, @m1),
			@m5 DATETIME = DATEADD(MONTH, 4, @m1),
			@m6 DATETIME = DATEADD(MONTH, 5, @m1),
			@m7 DATETIME = DATEADD(MONTH, 6, @m1),
			@m8 DATETIME = DATEADD(MONTH, 7, @m1),
			@m9 DATETIME = DATEADD(MONTH, 8, @m1),
			@m10 DATETIME = DATEADD(MONTH, 9, @m1),
			@m11 DATETIME = DATEADD(MONTH, 10, @m1),
			@m12 DATETIME = DATEADD(MONTH, 11, @m1)
	;
	
	-- Only allow queries of at most 1 year prior or 1 year in the future.
	DECLARE @MinDate DATETIME = DATEADD(MONTH, -12, GETDATE());
	DECLARE @MaxDate DATETIME = DATEADD(MONTH, 12, GETDATE());

	IF @sd < @MinDate BEGIN
		SET @sd = @MinDate
		SET @MaxDate = DATEADD(MONTH, 11, @sd)
	END
	IF @sd > @MaxDate BEGIN
		SET @sd = @MaxDate
		SET @MinDate = DATEADD(MONTH, -11, @sd)
	END

	SET @MinDate = @sd
	SET @MaxDate = DATEADD(MONTH, 11, @sd)

	
	CREATE TABLE #T (
		[COMPANY NAME] VARCHAR(50),
		[Slot Type] VARCHAR(50),
		[GROUPING] INT,
		[Label] VARCHAR(50),
		[Initials] VARCHAR(10),
		[LabelTtl] VARCHAR(50),
		[Slot Status] INT,
		[Month #] INT,
		[January] INT,
		[February] INT,
		[March] INT,
		[April] INT,
		[May] INT,
		[June] INT,
		[July] INT,
		[August] INT,
		[September] INT,
		[October] INT,
		[November] INT,
		[December] INT
	);

	INSERT INTO
		#T
	EXEC
		[dbo].[sp_GetSlotReport]
			@StartDate = @sd,
			@EndDate = @MaxDate,
			@SlotStatus = @ss
	;

	-- NULL Record to keep report creation from throwing an error.
	IF (SELECT COUNT(1) FROM #T) = 0
		INSERT INTO
			#T (
				[COMPANY NAME],
				[Slot Type],
				[GROUPING],
				[Label],
				[Initials],
				[LabelTtl],
				[Slot Status],
				[Month #],
				[January],
				[February],
				[March],
				[April],
				[May],
				[June],
				[July],
				[August],
				[September],
				[October],
				[November],
				[December]
			)
		VALUES ('', '', 0, '', '', '', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

	SELECT
		'All ' + (
			CASE
				WHEN @ss = 0 THEN 'Unassigned '
				WHEN @ss = 1 THEN 'Assigned '
				ELSE ''
			END
		) + 'Production Slots VS. Forecast Report Beginning: ' AS [RptGroupName],
		@sd AS [Start Date],
		[COMPANY NAME],
		[GROUPING],
		[Label],
		[Initials],
		[LabelTtl],
		[Slot Type],
		(
			SUM(CASE WHEN [January] IS NULL THEN 0 ELSE [January] END) + 
			SUM(CASE WHEN [February] IS NULL THEN 0 ELSE [February] END) +
			SUM(CASE WHEN [March] IS NULL THEN 0 ELSE [March] END) +
			SUM(CASE WHEN [April] IS NULL THEN 0 ELSE [April] END) +
			SUM(CASE WHEN [May] IS NULL THEN 0 ELSE [May] END) +
			SUM(CASE WHEN [June] IS NULL THEN 0 ELSE [June] END) +
			SUM(CASE WHEN [July] IS NULL THEN 0 ELSE [July] END) +
			SUM(CASE WHEN [August] IS NULL THEN 0 ELSE [August] END) +
			SUM(CASE WHEN [September] IS NULL THEN 0 ELSE [September] END) +
			SUM(CASE WHEN [October] IS NULL THEN 0 ELSE [October] END) +
			SUM(CASE WHEN [November] IS NULL THEN 0 ELSE [November] END) +
			SUM(CASE WHEN [December] IS NULL THEN 0 ELSE [December] END)
		) AS [Sum],
		@m1 AS Month1Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m1) THEN [January]
			WHEN 2 = MONTH(@m1) THEN [February]
			WHEN 3 = MONTH(@m1) THEN [March]
			WHEN 4 = MONTH(@m1) THEN [April]
			WHEN 5 = MONTH(@m1) THEN [May]
			WHEN 6 = MONTH(@m1) THEN [June]
			WHEN 7 = MONTH(@m1) THEN [July]
			WHEN 8 = MONTH(@m1) THEN [August]
			WHEN 9 = MONTH(@m1) THEN [September]
			WHEN 10 = MONTH(@m1) THEN [October]
			WHEN 11 = MONTH(@m1) THEN [November]
			WHEN 12 = MONTH(@m1) THEN [December]
			ELSE 0
			END
		) AS Month1Slots,
		@m2 AS Month2Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m2) THEN [January]
			WHEN 2 = MONTH(@m2) THEN [February]
			WHEN 3 = MONTH(@m2) THEN [March]
			WHEN 4 = MONTH(@m2) THEN [April]
			WHEN 5 = MONTH(@m2) THEN [May]
			WHEN 6 = MONTH(@m2) THEN [June]
			WHEN 7 = MONTH(@m2) THEN [July]
			WHEN 8 = MONTH(@m2) THEN [August]
			WHEN 9 = MONTH(@m2) THEN [September]
			WHEN 10 = MONTH(@m2) THEN [October]
			WHEN 11 = MONTH(@m2) THEN [November]
			WHEN 12 = MONTH(@m2) THEN [December]
			ELSE 0
			END
		) AS Month2Slots,
		@m3 AS Month3Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m3) THEN [January]
			WHEN 2 = MONTH(@m3) THEN [February]
			WHEN 3 = MONTH(@m3) THEN [March]
			WHEN 4 = MONTH(@m3) THEN [April]
			WHEN 5 = MONTH(@m3) THEN [May]
			WHEN 6 = MONTH(@m3) THEN [June]
			WHEN 7 = MONTH(@m3) THEN [July]
			WHEN 8 = MONTH(@m3) THEN [August]
			WHEN 9 = MONTH(@m3) THEN [September]
			WHEN 10 = MONTH(@m3) THEN [October]
			WHEN 11 = MONTH(@m3) THEN [November]
			WHEN 12 = MONTH(@m3) THEN [December]
			ELSE 0
			END
		) AS Month3Slots,
		@m4 AS Month4Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m4) THEN [January]
			WHEN 2 = MONTH(@m4) THEN [February]
			WHEN 3 = MONTH(@m4) THEN [March]
			WHEN 4 = MONTH(@m4) THEN [April]
			WHEN 5 = MONTH(@m4) THEN [May]
			WHEN 6 = MONTH(@m4) THEN [June]
			WHEN 7 = MONTH(@m4) THEN [July]
			WHEN 8 = MONTH(@m4) THEN [August]
			WHEN 9 = MONTH(@m4) THEN [September]
			WHEN 10 = MONTH(@m4) THEN [October]
			WHEN 11 = MONTH(@m4) THEN [November]
			WHEN 12 = MONTH(@m4) THEN [December]
			ELSE 0
			END
		) AS Month4Slots,
		@m5 AS Month5Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m5) THEN [January]
			WHEN 2 = MONTH(@m5) THEN [February]
			WHEN 3 = MONTH(@m5) THEN [March]
			WHEN 4 = MONTH(@m5) THEN [April]
			WHEN 5 = MONTH(@m5) THEN [May]
			WHEN 6 = MONTH(@m5) THEN [June]
			WHEN 7 = MONTH(@m5) THEN [July]
			WHEN 8 = MONTH(@m5) THEN [August]
			WHEN 9 = MONTH(@m5) THEN [September]
			WHEN 10 = MONTH(@m5) THEN [October]
			WHEN 11 = MONTH(@m5) THEN [November]
			WHEN 12 = MONTH(@m5) THEN [December]
			ELSE 0
			END
		) AS Month5Slots,
		@m6 AS Month6Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m6) THEN [January]
			WHEN 2 = MONTH(@m6) THEN [February]
			WHEN 3 = MONTH(@m6) THEN [March]
			WHEN 4 = MONTH(@m6) THEN [April]
			WHEN 5 = MONTH(@m6) THEN [May]
			WHEN 6 = MONTH(@m6) THEN [June]
			WHEN 7 = MONTH(@m6) THEN [July]
			WHEN 8 = MONTH(@m6) THEN [August]
			WHEN 9 = MONTH(@m6) THEN [September]
			WHEN 10 = MONTH(@m6) THEN [October]
			WHEN 11 = MONTH(@m6) THEN [November]
			WHEN 12 = MONTH(@m6) THEN [December]
			ELSE 0
			END
		) AS Month6Slots,
		@m7 AS Month7Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m7) THEN [January]
			WHEN 2 = MONTH(@m7) THEN [February]
			WHEN 3 = MONTH(@m7) THEN [March]
			WHEN 4 = MONTH(@m7) THEN [April]
			WHEN 5 = MONTH(@m7) THEN [May]
			WHEN 6 = MONTH(@m7) THEN [June]
			WHEN 7 = MONTH(@m7) THEN [July]
			WHEN 8 = MONTH(@m7) THEN [August]
			WHEN 9 = MONTH(@m7) THEN [September]
			WHEN 10 = MONTH(@m7) THEN [October]
			WHEN 11 = MONTH(@m7) THEN [November]
			WHEN 12 = MONTH(@m7) THEN [December]
			ELSE 0
			END
		) AS Month7Slots,
		@m8 AS Month8Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m8) THEN [January]
			WHEN 2 = MONTH(@m8) THEN [February]
			WHEN 3 = MONTH(@m8) THEN [March]
			WHEN 4 = MONTH(@m8) THEN [April]
			WHEN 5 = MONTH(@m8) THEN [May]
			WHEN 6 = MONTH(@m8) THEN [June]
			WHEN 7 = MONTH(@m8) THEN [July]
			WHEN 8 = MONTH(@m8) THEN [August]
			WHEN 9 = MONTH(@m8) THEN [September]
			WHEN 10 = MONTH(@m8) THEN [October]
			WHEN 11 = MONTH(@m8) THEN [November]
			WHEN 12 = MONTH(@m8) THEN [December]
			ELSE 0
			END
		) AS Month8Slots,
		@m9 AS Month9Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m9) THEN [January]
			WHEN 2 = MONTH(@m9) THEN [February]
			WHEN 3 = MONTH(@m9) THEN [March]
			WHEN 4 = MONTH(@m9) THEN [April]
			WHEN 5 = MONTH(@m9) THEN [May]
			WHEN 6 = MONTH(@m9) THEN [June]
			WHEN 7 = MONTH(@m9) THEN [July]
			WHEN 8 = MONTH(@m9) THEN [August]
			WHEN 9 = MONTH(@m9) THEN [September]
			WHEN 10 = MONTH(@m9) THEN [October]
			WHEN 11 = MONTH(@m9) THEN [November]
			WHEN 12 = MONTH(@m9) THEN [December]
			ELSE 0
			END
		) AS Month9Slots,
		@m10 AS Month10Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m10) THEN [January]
			WHEN 2 = MONTH(@m10) THEN [February]
			WHEN 3 = MONTH(@m10) THEN [March]
			WHEN 4 = MONTH(@m10) THEN [April]
			WHEN 5 = MONTH(@m10) THEN [May]
			WHEN 6 = MONTH(@m10) THEN [June]
			WHEN 7 = MONTH(@m10) THEN [July]
			WHEN 8 = MONTH(@m10) THEN [August]
			WHEN 9 = MONTH(@m10) THEN [September]
			WHEN 10 = MONTH(@m10) THEN [October]
			WHEN 11 = MONTH(@m10) THEN [November]
			WHEN 12 = MONTH(@m10) THEN [December]
			ELSE 0
			END
		) AS Month10Slots,
		@m11 AS Month11Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m11) THEN [January]
			WHEN 2 = MONTH(@m11) THEN [February]
			WHEN 3 = MONTH(@m11) THEN [March]
			WHEN 4 = MONTH(@m11) THEN [April]
			WHEN 5 = MONTH(@m11) THEN [May]
			WHEN 6 = MONTH(@m11) THEN [June]
			WHEN 7 = MONTH(@m11) THEN [July]
			WHEN 8 = MONTH(@m11) THEN [August]
			WHEN 9 = MONTH(@m11) THEN [September]
			WHEN 10 = MONTH(@m11) THEN [October]
			WHEN 11 = MONTH(@m11) THEN [November]
			WHEN 12 = MONTH(@m11) THEN [December]
			ELSE 0
			END
		) AS Month11Slots,
		@m12 AS Month12Date,
		SUM(CASE 
			WHEN 1 = MONTH(@m12) THEN [January]
			WHEN 2 = MONTH(@m12) THEN [February]
			WHEN 3 = MONTH(@m12) THEN [March]
			WHEN 4 = MONTH(@m12) THEN [April]
			WHEN 5 = MONTH(@m12) THEN [May]
			WHEN 6 = MONTH(@m12) THEN [June]
			WHEN 7 = MONTH(@m12) THEN [July]
			WHEN 8 = MONTH(@m12) THEN [August]
			WHEN 9 = MONTH(@m12) THEN [September]
			WHEN 10 = MONTH(@m12) THEN [October]
			WHEN 11 = MONTH(@m12) THEN [November]
			WHEN 12 = MONTH(@m12) THEN [December]
			ELSE 0
			END
		) AS Month12Slots
		FROM
			#T
		GROUP BY
			[#T].[COMPANY NAME],
			[#T].[GROUPING],
			[#T].[Label],
			[#T].[Initials],
			[#T].[LabelTtl],
			[Slot Type]
	END
GO


/*
sum(CASE WHEN [Month #] = MONTH(@m1) THEN 1 ELSE 0 end) AS Month1Slots,
	@m2 AS Month2Date,
	sum(CASE WHEN [Month #] = MONTH(@m2) THEN 1 ELSE 0 end) AS Month2Slots,
	@m3 AS Month3Date,
	sum(CASE WHEN [Month #] = MONTH(@m3) THEN 1 ELSE 0 end) AS Month3Slots,
	@m4 AS Month4Date,
	sum(CASE WHEN [Month #] = MONTH(@m4) THEN 1 ELSE 0 end) AS Month4Slots,
	@m5 AS Month5Date,
	sum(CASE WHEN [Month #] = MONTH(@m5) THEN 1 ELSE 0 end) AS Month5Slots,
	@m6 AS Month6Date,
	sum(CASE WHEN [Month #] = MONTH(@m6) THEN 1 ELSE 0 end) AS Month6Slots,
	@m7 AS Month7Date,
	sum(CASE WHEN [Month #] = MONTH(@m7) THEN 1 ELSE 0 end) AS Month7Slots,
	@m8 AS Month8Date,
	sum(CASE WHEN [Month #] = MONTH(@m8) THEN 1 ELSE 0 end) AS Month8Slots,
	@m9 AS Month9Date,
	sum(CASE WHEN [Month #] = MONTH(@m9) THEN 1 ELSE 0 end) AS Month9Slots,
	@m10 AS Month10Date,
	sum(CASE WHEN [Month #] = MONTH(@m10) THEN 1 ELSE 0 end) AS Month10Slots,
	@m11 AS Month11Date,
	sum(CASE WHEN [Month #] = MONTH(@m11) THEN 1 ELSE 0 end) AS Month11Slots,
	@m12 AS Month12Date,
	sum(CASE WHEN [Month #] = MONTH(@m12) THEN 1 ELSE 0 end) AS Month12Slots
*/

/*

	(CASE 
		WHEN [Month #] = MONTH(@m1) THEN sum([January])
		WHEN [Month #] = MONTH(@m2) THEN sum([February])
		WHEN [Month #] = MONTH(@m3) THEN sum([March])
		WHEN [Month #] = MONTH(@m4) THEN sum([April])
		WHEN [Month #] = MONTH(@m5) THEN sum([May])
		WHEN [Month #] = MONTH(@m6) THEN sum([June])
		WHEN [Month #] = MONTH(@m7) THEN sum([July])
		WHEN [Month #] = MONTH(@m8) THEN sum([August])
		WHEN [Month #] = MONTH(@m9) THEN sum([September])
		WHEN [Month #] = MONTH(@m10) THEN sum([October])
		WHEN [Month #] = MONTH(@m11) THEN sum([November])
		WHEN [Month #] = MONTH(@m12) THEN sum([December])
		ELSE 0
	end) AS Month1Slots,
*/

/*
SUM(CASE 
		WHEN [Month #] = MONTH(@m1) THEN [January]
		WHEN [Month #] = MONTH(@m2) THEN [February]
		WHEN [Month #] = MONTH(@m3) THEN [March]
		WHEN [Month #] = MONTH(@m4) THEN [April]
		WHEN [Month #] = MONTH(@m5) THEN [May]
		WHEN [Month #] = MONTH(@m6) THEN [June]
		WHEN [Month #] = MONTH(@m7) THEN [July]
		WHEN [Month #] = MONTH(@m8) THEN [August]
		WHEN [Month #] = MONTH(@m9) THEN [September]
		WHEN [Month #] = MONTH(@m10) THEN [October]
		WHEN [Month #] = MONTH(@m11) THEN [November]
		WHEN [Month #] = MONTH(@m12) THEN [December]
		ELSE 0
	end) AS Month1Slots,
*/

/*

	SUM(CASE 
		WHEN [Month #] = MONTH(@m1) THEN 1
		WHEN [Month #] = MONTH(@m2) THEN 1
		WHEN [Month #] = MONTH(@m3) THEN 1
		WHEN [Month #] = MONTH(@m4) THEN 1
		WHEN [Month #] = MONTH(@m5) THEN 1
		WHEN [Month #] = MONTH(@m6) THEN 1
		WHEN [Month #] = MONTH(@m7) THEN 1
		WHEN [Month #] = MONTH(@m8) THEN 1
		WHEN [Month #] = MONTH(@m9) THEN 1
		WHEN [Month #] = MONTH(@m10) THEN 1
		WHEN [Month #] = MONTH(@m11) THEN 1
		WHEN [Month #] = MONTH(@m12) THEN 1
		ELSE 0
	end) AS Month1Slots,
*/


/*
USE [BWSdb]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery Briggs>
-- Create date: <2021-06-29>
-- Description:	<Generate the Dealer Slots VS Forecast report.>
--=============================================

ALTER PROCEDURE [dbo].[sp_ProductionSlotsvsForecastRpt 2] 
	-- Add the parameters for the stored procedure here
	@sd DATETIME,
	@ss INT = 2
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #T (
		[COMPANY NAME] VARCHAR(50),
		[Slot Type] VARCHAR(50),
		[GROUPING] INT,
		[Label] VARCHAR(50),
		[Initials] VARCHAR(10),
		[LabelTtl] VARCHAR(50),
		[Slot Status] INT,
		[Month #] INT,
		[January] INT,
		[February] INT,
		[March] INT,
		[April] INT,
		[May] INT,
		[June] INT,
		[July] INT,
		[August] INT,
		[September] INT,
		[October] INT,
		[November] INT,
		[December] INT 
	)

	INSERT INTO #T EXEC [dbo].[sp_GetSlotReport] @StartDate = @sd, @SlotStatus = @ss
	SELECT
		*
	FROM
		#T
END
GO
*/