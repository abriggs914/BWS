USE [BWSdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ITREstimateLabour]    Script Date: 2023-05-08 4:32:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_ITREstimateLabour]
	@company NVARCHAR(MAX)=NULL
	, @department INT=NULL
	, @requestType NVARCHAR(MAX)=NULL
	, @requestSubType NVARCHAR(MAX)=NULL
	
AS
BEGIN

	DECLARE @t_id AS INT;
	DECLARE @t_ans AS NVARCHAR(1);

	------ TESTING --
	
	--DECLARE @company NVARCHAR(MAX);
	--DECLARE @department AS INT; --NVARCHAR(MAX);
	--DECLARE @requestType AS NVARCHAR(MAX);
	--DECLARE @requestSubType AS NVARCHAR(MAX);
	
	---- Use this for direct injection testing.
	----SET @company = NULL;
	----SET @department = NULL;
	------SET @department = 12;
	----SET @requestType = 'Hardware';
	----SET @requestSubType = 'Computer';

	--DECLARE @tt AS TABLE (
	--	[ID] INT IDENTITY(0, 1),
	--	[qid] NVARCHAR(1),
	--	[comp] NVARCHAR(MAX),
	--	[dept] INT,
	--	[reqt] NVARCHAR(MAX),
	--	[rqst] NVARCHAR(MAX)
	--)

	--INSERT INTO @tt ([qid], [comp], [dept], [reqt], [rqst]) VALUES
	--('A', NULL, NULL, NULL, NULL),
	--('B', NULL, NULL, NULL, 'Computer'),
	--('C', NULL, NULL, 'Hardware', NULL),
	--('D', NULL, NULL, 'Hardware', 'Computer'),

	--('E', NULL, 12, NULL, NULL),
	--('F', NULL, 12, NULL, 'Computer'),
	--('G', NULL, 12, 'Hardware', NULL),
	--('H', NULL, 12, 'Hardware', 'Computer'),

	--('I', 'BWS', NULL, NULL, NULL),
	--('J', 'BWS', NULL, NULL, 'Computer'),
	--('K', 'BWS', NULL, 'Hardware', NULL),
	--('L', 'BWS', NULL, 'Hardware', 'Computer'),

	--('M', 'BWS', 12, NULL, NULL),
	--('N', 'BWS', 12, NULL, 'Computer'),
	--('O', 'BWS', 12, 'Hardware', NULL),
	--('P', 'BWS', 12, 'Hardware', 'Computer')
	--;
	

	--SELECT @t_id = 8;
	--SELECT @t_ans = [qid] FROM @tt WHERE [ID] = @t_id;

	--SELECT
	--	@company = [comp],
	--	@department = [dept],
	--	@requestType = [reqt],
	--	@requestSubType = [rqst]
	--FROM
	--	@tt
	--WHERE
	--	[ID] = @t_id
	--;

	-------------------

	IF @department < 0 BEGIN
		SELECT @department = NULL;
	END

	DECLARE @ttl_hours_act AS FLOAT;
	DECLARE @ttl_hours_bud AS FLOAT;
	DECLARE @ttl_requests AS INTEGER;

	SELECT 
		@ttl_requests = COUNT(*)
		, @ttl_hours_act = SUM([LabourActual])
		, @ttl_hours_bud = SUM([LabourEstimate])
	FROM 
		[IT Requests];


	DECLARE @in_comp AS BIT;
	DECLARE @in_dept AS BIT;
	DECLARE @in_reqt AS BIT;
	DECLARE @in_srqt AS BIT;
	
	SELECT
		@in_comp = (CASE WHEN @company IS NULL THEN 0 ELSE 1 END)
		, @in_dept = (CASE WHEN @department IS NULL THEN 0 ELSE 1 END)
		, @in_reqt = (CASE WHEN @requestType IS NULL THEN 0 ELSE 1 END)
		, @in_srqt = (CASE WHEN @requestSubType IS NULL THEN 0 ELSE 1 END)
	;

	--SELECT
	--	@t_ans AS [Expected Qid]
	--	, @in_comp AS [@in_comp]
	--	, @in_dept AS [@in_dept]
	--	, @in_reqt AS [@in_reqt]
	--	, @in_srqt AS [@in_sqrt]
	--;

	IF @in_comp = 0 AND @in_dept = 0 AND @in_reqt = 0 AND @in_srqt = 0 BEGIN
		-- A
		SELECT
			'A' AS [qid]
			, NULL AS [ID]
			, 'All' AS [Company]
			, 'All' AS [Dept]
			, 'All' AS [RequestType]
			, 'All' AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM
			[IT Requests]
		;
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			----, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			----, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			----, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			----, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 0 AND @in_dept = 0 AND @in_reqt = 0 AND @in_srqt = 1 BEGIN
		-- B
		SELECT
			'B' AS [qid]
			, NULL AS [ID]
			, 'All' AS [Company]
			, 'All' AS [Dept]
			, 'All' AS [RequestType]
			, @requestSubType AS [RequestSubType]
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM
			[IT Requests]
		WHERE
			[RequestSubType] = @requestSubType
		;
		--	, @ttl_requests AS [# Reqs]
		--	, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
		--	, ROUND(@ttl_hours_act, 2) AS [Act]
		--	, ROUND(@ttl_hours_bud, 2) AS [Bud]
		--	, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
		--	, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
		--	, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
		--	, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
		--	, @ttl_requests AS [Total Requests]
		--	, ROUND(@ttl_hours_act, 2) AS [Total Actual]
		--	, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
		--FROM 
		--	[IT Requests]

	END
	IF @in_comp = 0 AND @in_dept = 0 AND @in_reqt = 1 AND @in_srqt = 0 BEGIN
		-- C
		SELECT
			'C' AS [qid]
			, NULL AS [ID]
			, 'All' AS [Company]
			, 'All' AS [Dept]
			, @requestType AS [RequestType]
			, 'All' AS [RequestSubType]
		
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM
			[IT Requests]
		WHERE
			[RequestType] = @requestType
		--	, @ttl_requests AS [# Reqs]
		--	, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
		--	, ROUND(@ttl_hours_act, 2) AS [Act]
		--	, ROUND(@ttl_hours_bud, 2) AS [Bud]
		--	, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
		--	, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
		--	, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
		--	, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
		--	, @ttl_requests AS [Total Requests]
		--	, ROUND(@ttl_hours_act, 2) AS [Total Actual]
		--	, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
		--FROM 
		--	[IT Requests]

	END
	IF @in_comp = 0 AND @in_dept = 0 AND @in_reqt = 1 AND @in_srqt = 1 BEGIN
		-- D
		SELECT
			'D' AS [qid]
			, NULL AS [ID]
			, 'All' AS [Company]
			, 'All' AS [Dept]
			, @requestType AS [RequestType]
			, @requestSubType AS [RequestSubType]
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]

			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
		FROM 
			[IT Requests]
		WHERE
			[RequestType] = @requestType
			AND [RequestSubType] = @requestSubType

	END
	IF @in_comp = 0 AND @in_dept = 1 AND @in_reqt = 0 AND @in_srqt = 0 BEGIN
		-- E
		SELECT
			'E' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, 'All' AS [Company]
			, @department AS [Dept]
			, 'All' AS [RequestType]
			, 'All' AS [RequestSubType]

			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Department] = @department
		--	, @ttl_requests AS [# Reqs]
		--	, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
		--	, ROUND(@ttl_hours_act, 2) AS [Act]
		--	, ROUND(@ttl_hours_bud, 2) AS [Bud]
		--	, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
		--	, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
		--	, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
		--	, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
		--	, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
		--	, @ttl_requests AS [Total Requests]
		--	, ROUND(@ttl_hours_act, 2) AS [Total Actual]
		--	, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
		--FROM 
		--	[IT Requests]

	END
	IF @in_comp = 0 AND @in_dept = 1 AND @in_reqt = 0 AND @in_srqt = 1 BEGIN
		-- F
		SELECT
			'F' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, 'All' AS [Company]
			, @department AS [Dept]
			, 'All' AS [RequestType]
			, @requestSubType AS [RequestSubType]

			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Department] = @department
			AND [RequestSubType] = @requestSubType

			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 0 AND @in_dept = 1 AND @in_reqt = 1 AND @in_srqt = 0 BEGIN
		-- G
		SELECT
			'G' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, 'All' AS [Company]
			, @department AS [Dept]
			, @requestType AS [RequestType]
			, 'All' AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Department] = @department
			AND [RequestType] = @requestType

			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 0 AND @in_dept = 1 AND @in_reqt = 1 AND @in_srqt = 1 BEGIN
		-- H
		SELECT
			'H' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, 'All' AS [Company]
			, @department AS [Dept]
			, @requestType AS [RequestType]
			, @requestSubType AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Department] = @department
			AND [RequestType] = @requestType
			AND [RequestSubType] = @requestSubType
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	
	IF @in_comp = 1 AND @in_dept = 0 AND @in_reqt = 0 AND @in_srqt = 0 BEGIN
		-- I
		SELECT
			'I' AS [qid]
			, NULL AS [ID]
			, @company AS [Company]
			, 'All' AS [Dept]
			, 'All' AS [RequestType]
			, 'All' AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		WHERE
			[Company] = @company
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	END
	IF @in_comp = 1 AND @in_dept = 0 AND @in_reqt = 0 AND @in_srqt = 1 BEGIN
		-- J
		SELECT
			'J' AS [qid]
			, NULL AS [ID]
			, @company AS [Company]
			, 'All' AS [Dept]
			, 'All' AS [RequestType]
			, @requestSubType AS [RequestSubType]

			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		WHERE
			[Company] = @company
			AND [RequestSubType] = @requestSubType
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	END
	IF @in_comp = 1 AND @in_dept = 0 AND @in_reqt = 1 AND @in_srqt = 0 BEGIN
		-- K
		SELECT
		'K' AS [qid]
			, NULL AS [ID]
			, @company AS [Company]
			, 'All' AS [Dept]
			, @requestType AS [RequestType]
			, 'All' AS [RequestSubType]

			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		WHERE
			[Company] = @company
			AND [RequestType] = @requestType
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 1 AND @in_dept = 0 AND @in_reqt = 1 AND @in_srqt = 1 BEGIN
		-- L
		SELECT
			'L' AS [qid]
			, NULL AS [ID]
			, @company AS [Company]
			, 'All' AS [Dept]
			, @requestType AS [RequestType]
			, @requestSubType AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
		FROM 
			[IT Requests]
		WHERE
			[Company] = @company
			AND [RequestType] = @requestType
			AND [RequestSubType] = @requestSubType

	END
	IF @in_comp = 1 AND @in_dept = 1 AND @in_reqt = 0 AND @in_srqt = 0 BEGIN
		-- M
		SELECT
			'M' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, @company AS [Company]
			, @department AS [Dept]
			, 'All' AS [RequestType]
			, 'All' AS [RequestSubType]

			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Company] = @company
			AND [Department] = @department
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 1 AND @in_dept = 1 AND @in_reqt = 0 AND @in_srqt = 1 BEGIN
		-- N
		SELECT
			'N' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, @company AS [Company]
			, @department AS [Dept]
			, 'All' AS [RequestType]
			, @requestSubType AS [RequestSubType]

			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Company] = @company
			AND [Department] = @department
			AND [RequestSubType] = @requestSubType
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 1 AND @in_dept = 1 AND @in_reqt = 1 AND @in_srqt = 0 BEGIN
		-- O
		SELECT
			'O' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, @company AS [Company]
			, @department AS [Dept]
			, @requestType AS [RequestType]
			, 'All' AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Company] = @company
			AND [Department] = @department
			AND [RequestType] = @requestType
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END
	IF @in_comp = 1 AND @in_dept = 1 AND @in_reqt = 1 AND @in_srqt = 1 BEGIN
		-- P
		SELECT
			'P' AS [qid]
			, MIN([Dept].[DeptID]) AS [ID]
			, @company AS [Company]
			, @department AS [Dept]
			, @requestType AS [RequestType]
			, @requestSubType AS [RequestSubType]
			
			, COUNT(*) AS [# Reqs]
			, @ttl_requests AS [Tot Reqs]
			, @ttl_hours_act AS [Tot Act]
			, @ttl_hours_bud AS [Tot Bud]
			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			, SUM([LabourActual]) AS [Act]
			, SUM([LabourEstimate]) AS [Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN SUM([LabourEstimate]) = 0 THEN 1 ELSE SUM([LabourEstimate]) END), 2)
			AS [Act / Bud]
			, ROUND(SUM([LabourActual]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Act / Req]
			, ROUND(SUM([LabourEstimate]) / (
				CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END), 2) AS [Bud / Req]

			, ROUND(100 * SUM([LabourActual]) / @ttl_hours_act, 2) AS [% Total Act]
			, ROUND(100 * SUM([LabourEstimate]) / @ttl_hours_bud, 2) AS [% Total Bud]
		FROM 
			[IT Requests]
		LEFT JOIN
			[BWSdb].[dbo].[Dept]
		ON
			[IT Requests].[Department] = [Dept].[DeptID]
		WHERE
			[Company] = @company
			AND [Department] = @department
			AND [RequestType] = @requestType
			AND [RequestSubType] = @requestSubType
			--, @ttl_requests AS [# Reqs]
			--, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
			--, ROUND(@ttl_hours_act, 2) AS [Act]
			--, ROUND(@ttl_hours_bud, 2) AS [Bud]
			--, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
			--, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
			--, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
			--, @ttl_requests AS [Total Requests]
			--, ROUND(@ttl_hours_act, 2) AS [Total Actual]
			--, ROUND(@ttl_hours_bud, 2) AS [Total Budget]

	END

END

	--IF @company IS NULL BEGIN
	--	IF @department IS NULL BEGIN
	--		SELECT
	--			NULL AS [ID]
	--			, 'All' AS [Company]
	--			, 'All' AS [Dept]
	--			, 'All' AS [RequestType]
	--			, 'All' AS [RequestSubType]
	--			, @ttl_requests AS [# Reqs]
	--			, CAST(ROUND(100 * ((@ttl_requests + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--			, ROUND(@ttl_hours_act, 2) AS [Act]
	--			, ROUND(@ttl_hours_bud, 2) AS [Bud]
	--			, ROUND(@ttl_hours_act / @ttl_requests, 2) AS [Act / Req]
	--			, ROUND(@ttl_hours_bud / @ttl_requests, 2) AS [Bud / Req]
	--			, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Bud]
	--			, ROUND(100 * @ttl_hours_act / @ttl_hours_act, 2) AS [% Total Act vs Ttl Act]
	--			, ROUND(100 * @ttl_hours_bud / @ttl_hours_bud, 2) AS [% Total Bud vs Ttl Bud]
	--			, ROUND(100 * @ttl_hours_act / @ttl_hours_bud, 2) AS [% Total Act vs Ttl Bud]
	--			, ROUND(100 * @ttl_hours_bud / @ttl_hours_act, 2) AS [% Total Bud vs Ttl Act]
	--			, @ttl_requests AS [Total Requests]
	--			, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--			, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--		END
	--		ELSE BEGIN
	--			SELECT
	--				MIN([Dept].[DeptID]) AS [ID]
	--				, [Dept].[Dept]
	--				, 'All' AS [RequestType]
	--				, COUNT(*) AS [# Reqs]
	--				, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--				, @ttl_requests AS [Total Requests]
	--				, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--				, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--			FROM 
	--				[BWSdb].[dbo].[IT Requests] 
	--			LEFT JOIN
	--				[BWSdb].[dbo].[Dept]
	--			ON
	--				[IT Requests].[Department] = [Dept].[DeptID]
	--			WHERE
	--				[Company] = @company
	--				AND
	--				[Department] = @department
	--				AND (1 = (CASE WHEN @requestType IS NULL THEN 1 WHEN [RequestType] = @requestType THEN 1 ELSE 0 END))
	--			GROUP BY
	--				[Dept].[Dept]
	--			ORDER BY
	--				[# Reqs] DESC
				
	--		END
	--END
	--ELSE BEGIN

	--	IF @department IS NULL BEGIN

	--		SELECT
	--			-1 AS [ID]
	--			, @company AS [Company]
	--			, 'ALL' AS [Dept]
	--			, COUNT(*) AS [# Reqs]
	--			, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--			, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--			, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--			, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--			, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--			, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--			, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--			, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--			, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--			, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--			, @ttl_requests AS [Total Requests]
	--			, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--			, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--		FROM 
	--			[BWSdb].[dbo].[IT Requests]
	--		WHERE
	--			[Company] = @company
	--		ORDER BY
	--			[# Reqs] DESC

		
	--		--FROM 
	--		---	[BWSdb].[dbo].[IT Requests]
	--	END
	--	ELSE BEGIN
	--		IF @requestType IS NULL AND @requestSubType IS NULL BEGIN
	--			SELECT
	--				MIN([Dept].[DeptID]) AS [ID]
	--				, [Dept].[Dept]
	--				, COUNT(*) AS [# Reqs]
	--				, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--				, @ttl_requests AS [Total Requests]
	--				, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--				, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--			FROM 
	--				[BWSdb].[dbo].[IT Requests] 
	--			LEFT JOIN
	--				[BWSdb].[dbo].[Dept]
	--			ON
	--				[IT Requests].[Department] = [Dept].[DeptID]
	--			WHERE
	--				[Company] = @company
	--				AND
	--				[Department] = @department
	--			GROUP BY
	--				[Dept].[Dept]
	--			ORDER BY
	--				[# Reqs] DESC
	--		END
	--		ELSE IF @requestType IS NOT NULL AND @requestSubType IS NULL BEGIN
	--		SELECT
	--				MIN([Dept].[DeptID]) AS [ID]
	--				, [Dept].[Dept]
	--				, [RequestType]
	--				, COUNT(*) AS [# Reqs]
	--				, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--				, @ttl_requests AS [Total Requests]
	--				, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--				, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--			FROM 
	--				[BWSdb].[dbo].[IT Requests] 
	--			LEFT JOIN
	--				[BWSdb].[dbo].[Dept]
	--			ON
	--				[IT Requests].[Department] = [Dept].[DeptID]
	--			WHERE
	--				[Company] = @company
	--				AND
	--				[Department] = @department
	--				AND (1 = (CASE WHEN @requestType IS NULL THEN 1 WHEN [RequestType] = @requestType THEN 1 ELSE 0 END))
	--			GROUP BY
	--				[Dept].[Dept]
	--				, [RequestType]
	--			ORDER BY
	--				[# Reqs] DESC
	--		END
	--		ELSE IF @requestType IS NULL AND @requestSubType IS NOT NULL BEGIN
	--			SELECT
	--				MIN([Dept].[DeptID]) AS [ID]
	--				, [Dept].[Dept]
	--				, [RequestSubType]
	--				, COUNT(*) AS [# Reqs]
	--				, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--				, @ttl_requests AS [Total Requests]
	--				, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--				, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--			FROM 
	--				[BWSdb].[dbo].[IT Requests] 
	--			LEFT JOIN
	--				[BWSdb].[dbo].[Dept]
	--			ON
	--				[IT Requests].[Department] = [Dept].[DeptID]
	--			WHERE
	--				[Company] = @company
	--				AND
	--				[Department] = @department
	--				AND (1 = (CASE WHEN @requestSubType IS NULL THEN 1 WHEN [RequestSubType] = @requestSubType THEN 1 ELSE 0 END))
	--			GROUP BY
	--				[Dept].[Dept]
	--				, [RequestSubType]
	--			ORDER BY
	--				[# Reqs] DESC
	--		END
	--		ELSE BEGIN
	--			SELECT
	--				MIN([Dept].[DeptID]) AS [ID]
	--				, [Dept].[Dept]
	--				, [RequestType]
	--				, [RequestSubType]
	--				, COUNT(*) AS [# Reqs]
	--				, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--				, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--				, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--				, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--				, @ttl_requests AS [Total Requests]
	--				, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--				, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--			FROM 
	--				[BWSdb].[dbo].[IT Requests] 
	--			LEFT JOIN
	--				[BWSdb].[dbo].[Dept]
	--			ON
	--				[IT Requests].[Department] = [Dept].[DeptID]
	--			WHERE
	--				[Company] = @company
	--				AND
	--				[Department] = @department
	--				AND (1 = (CASE WHEN @requestType IS NULL THEN 1 WHEN [RequestType] = @requestType THEN 1 ELSE 0 END))
	--				AND (1 = (CASE WHEN @requestSubType IS NULL THEN 1 WHEN [RequestSubType] = @requestSubType THEN 1 ELSE 0 END))
	--			GROUP BY
	--				[Dept].[Dept]
	--				, [RequestType]
	--				, [RequestSubType]
	--			ORDER BY
	--				[# Reqs] DESC
	--		END
	--	END
	--END



	-- 2022-09-07
	--SELECT
	--	MIN([Dept].[DeptID]) AS [ID]
	--	, [Dept].[Dept]
	--	, [RequestType]
	--	, [RequestSubType]
	--	, COUNT(*) AS [# Reqs]
	--	, CAST(ROUND(100 * ((COUNT(*) + 0.0) / @ttl_requests), 2) AS DECIMAL(16, 2)) AS [% Ttl Reqs]
	--	, ROUND(SUM(ISNULL([LabourActual], 0)), 2) AS [Act]
	--	, ROUND(SUM(ISNULL([LabourEstimate], 0)), 2) AS [Bud]
	--	, ROUND(SUM(ISNULL([LabourActual], 0)) / COUNT(*), 2) AS [Act / Req]
	--	, ROUND(SUM(ISNULL([LabourEstimate], 0)) / COUNT(*), 2) AS [Bud / Req]
	--	, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / SUM(ISNULL([LabourEstimate], 0)), 2) AS [% Total Bud]
	--	, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Act vs Ttl Act]
	--	, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Bud vs Ttl Bud]
	--	, ROUND(100 * SUM(ISNULL([LabourActual], 0)) / ISNULL(@ttl_hours_bud, 0), 2) AS [% Total Act vs Ttl Bud]
	--	, ROUND(100 * SUM(ISNULL([LabourEstimate], 0)) / ISNULL(@ttl_hours_act, 0), 2) AS [% Total Bud vs Ttl Act]
	--	, @ttl_requests AS [Total Requests]
	--	, ROUND(@ttl_hours_act, 2) AS [Total Actual]
	--	, ROUND(@ttl_hours_bud, 2) AS [Total Budget]
	--FROM 
	--	[IT Requests] 
	--LEFT JOIN
	--	[Dept]
	--ON
	--	[IT Requests].[Department] = [Dept].[DeptID]
	--WHERE
	--	[Department] = @department
	--	AND (1 = (CASE WHEN @requestType IS NULL THEN 1 WHEN [RequestType] = @requestType THEN 1 ELSE 0 END))
	--	AND (1 = (CASE WHEN @requestSubType IS NULL THEN 1 WHEN [RequestSubType] = @requestSubType THEN 1 ELSE 0 END))
	--GROUP BY
	--	[Dept].[Dept]
	--	, [RequestType]
	--	, [RequestSubType]
	--ORDER BY
	--	[# Reqs] DESC



--END



-- -- Top 5 highest issued requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [LabourActual] IS NOT NULL ORDER BY [LabourActual] DESC

-- -- Bottom 5 highest budgeted requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [LabourEstimate] IS NOT NULL ORDER BY [LabourEstimate]

-- -- Bottom 5 highest issued requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [LabourActual] IS NOT NULL ORDER BY [LabourActual]


-- -- Top 5 most revisited requests
--SELECT TOP 5 * FROM [IT Requests] WHERE [OpenCounter] IS NOT NULL ORDER BY [OpenCounter] DESC