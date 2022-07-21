USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ITRConcerningPhones]    Script Date: 2022-07-21 9:02:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Get all non-complete requests that deal with engineering.

ALTER PROCEDURE [dbo].[sp_ITRConcerningEngineering]
	@sd AS DATETIME = NULL,
	@ed AS DATETIME = NULL
AS
BEGIN

	------ TESTING ----
	
	--DECLARE	@sd AS DATETIME = NULL;
	--DECLARE @ed AS DATETIME = NULL;
	--SET @sd = '2021-01-01';
	--SET @ed = GETDATE();

	-------------------

	IF @sd IS NULL BEGIN
		SELECT @sd = MIN([RequestDate]) FROM [IT Requests]
	END

	IF @ed IS NULL BEGIN
		SELECT @ed = MAX([RequestDate]) FROM [IT Requests]
	END

	SELECT
		*
	FROM
		[IT Requests]
	WHERE
		(
			[Department] IN (SELECT [DeptID] FROM [Dept] WHERE [Dept] LIKE '%engineering%')
			OR [RequestSubType] LIKE '%iventor%'
			OR [RequestSubType] LIKE '%sgvault%'
			OR [RequestSubType] LIKE '%solidworks%'
			OR [RequestSubType] LIKE '%espresso%'

			OR [Comments] LIKE '%iventor%'
			OR [Request] LIKE '%iventor%'

			OR [Comments] LIKE '%sgvault%'
			OR [Request] LIKE '%sgvault%'

			OR [Comments] LIKE '%solidworks%'
			OR [Request] LIKE '%solidworks%'

			OR [Comments] LIKE '%espresso%'
			OR [Request] LIKE '%espresso%'

		) AND [Status] <> 'Complete'
		AND (([RequestDate] BETWEEN @sd AND @ed) OR ([RequestDateOriginal] BETWEEN @sd AND @ed))


END