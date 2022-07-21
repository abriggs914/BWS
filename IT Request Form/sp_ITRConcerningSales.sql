USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ITRConcerningPhones]    Script Date: 2022-07-21 9:02:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Get all non-complete requests that deal with sales.

ALTER PROCEDURE [dbo].[sp_ITRConcerningSales]
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
			[Department] IN (SELECT [DeptID] FROM [Dept] WHERE [Dept] LIKE '%sale%')
			OR [Department] IN (SELECT [DeptID] FROM [Dept] WHERE [Dept] LIKE '%warranty%')

			OR [Comments] LIKE '%sale%'
			OR [Request] LIKE '%sale%'

		) AND [Status] <> 'Complete'
		AND (([RequestDate] BETWEEN @sd AND @ed) OR ([RequestDateOriginal] BETWEEN @sd AND @ed))


END