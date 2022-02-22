USE BWSdb
GO

ALTER PROCEDURE [dbo].[sp_ITRequestAssignmentList]
	@sd AS DATETIME,
	@ed AS DATETIME,
	@u AS BIT = 1,
	@q AS BIT = 0,
	@p AS BIT = 0,
	@c AS BIT = 0,
	@n AS BIT = 0,
	@d AS BIT = 0

AS
BEGIN

--DECLARE @sd AS DATETIME;
--DECLARE @ed AS DATETIME;
--DECLARE @u AS BIT; -- Include unassigned jobs
--DECLARE @c AS BIT; -- Complete
--DECLARE @q AS BIT; -- Queued
--DECLARE @p AS BIT; -- In Progess
--DECLARE @d AS BIT; -- Declined
--DECLARE @n AS BIT; -- Incomplete
--SET @sd = '2021-11-22';
--SET @ed = '2021-12-03 23:59';
--SET @u = 1;
--SET @c = 1;
--SET @q = 0;
--SET @p = 0;
--SET @d = 0;
--SET @n = 0;

DECLARE @var NVARCHAR(MAX);
DECLARE @valid TABLE ([val] NVARCHAR(MAX));
IF @c = 1 BEGIN
	INSERT INTO @valid ([val]) VALUES ('Complete');
END
IF @q = 1 BEGIN
	INSERT INTO @valid ([val]) VALUES ('Queued');
END
IF @p = 1 BEGIN
	INSERT INTO @valid ([val]) VALUES ('In Progress');
END
IF @d = 1 BEGIN
	INSERT INTO @valid ([val]) VALUES ('Declined');
END
IF @n = 1 BEGIN
	INSERT INTO @valid ([val]) VALUES ('Incomplete');
END
IF CAST(@q AS INT) + CAST(@p AS INT) + CAST(@c AS INT) + CAST(@n AS INT) + CAST(@d AS INT) = 0 BEGIN
	INSERT INTO @valid ([Val]) VALUES ('Complete'), ('Queued'), ('In Progress'), ('Declined'), ('Incomplete')
END

IF @u = 1 BEGIN

	SELECT 
		(CASE WHEN [Name] IS NULL THEN 1 ELSE 0 END) AS [ph],
		(CASE WHEN [Name] IS NULL THEN 'Unassigned' ELSE [Name] END) AS [Name],
		[ITRequestID#],
		[Status],
		[Directory],
		[RequestDate],
		GETDATE() AS [Today],
		[StartDate],
		[CompletionDate],
		(CASE WHEN [CompletionDate] IS NULL THEN GETDATE() ELSE [CompletionDate] END) AS [C],
		DATEDIFF(DAY, [StartDate], (CASE WHEN [CompletionDate] IS NULL THEN GETDATE() ELSE [CompletionDate] END)) + 1 AS [DaysAssigned],
		DATEDIFF(DAY, [RequestDate], (CASE WHEN [CompletionDate] IS NULL THEN GETDATE() ELSE [CompletionDate] END)) AS [DaysOld]
	FROM
		[IT Requests]
	LEFT JOIN
		[IT Personnel]
	ON
		[ITPersonAssignedID] = [ITPersonID#]
	WHERE
		[Status] IN  (SELECT [val] FROM @valid)
		AND ((((1 = (CASE WHEN @c = 1 THEN 0 ELSE 1 END)) OR [CompletionDate] BETWEEN @sd AND @ed OR [StartDate] BETWEEN @sd AND @ed OR [RequestDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @d = 1 THEN 0 ELSE 1 END)) OR [CompletionDate] BETWEEN @sd AND @ed OR [StartDate] BETWEEN @sd AND @ed OR [RequestDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @n = 1 THEN 0 ELSE 1 END)) OR [CompletionDate] BETWEEN @sd AND @ed OR [StartDate] BETWEEN @sd AND @ed OR [RequestDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @p = 1 THEN 0 ELSE 1 END)) OR [StartDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @q = 1 THEN 0 ELSE 1 END))	OR [RequestDate] BETWEEN @sd AND @ed)))

	ORDER BY
		[ph], [Name], [Status], [ITRequestID#]
END
ELSE BEGIN
	SELECT 
		(CASE WHEN [Name] IS NULL THEN 1 ELSE 0 END) AS [ph],
		[Name],
		[ITRequestID#],
		[Status],
		[Directory],
		[StartDate],
		[CompletionDate],
		DATEDIFF(DAY, [StartDate], (CASE WHEN [CompletionDate] IS NULL THEN GETDATE() ELSE [CompletionDate] END)) + 1 AS [DaysAssigned],
		DATEDIFF(DAY, [RequestDate], (CASE WHEN [CompletionDate] IS NULL THEN GETDATE() ELSE [CompletionDate] END)) AS [DaysOld]
	FROM
		[IT Requests]
	INNER JOIN
		[IT Personnel]
	ON
		[ITPersonAssignedID] = [ITPersonID#]
	WHERE
		[Status] IN  (SELECT [val] FROM @valid)
		AND ((((1 = (CASE WHEN @c = 1 THEN 0 ELSE 1 END)) OR [CompletionDate] BETWEEN @sd AND @ed OR [StartDate] BETWEEN @sd AND @ed OR [RequestDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @d = 1 THEN 0 ELSE 1 END)) OR [CompletionDate] BETWEEN @sd AND @ed OR [StartDate] BETWEEN @sd AND @ed OR [RequestDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @n = 1 THEN 0 ELSE 1 END)) OR [CompletionDate] BETWEEN @sd AND @ed OR [StartDate] BETWEEN @sd AND @ed OR [RequestDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @p = 1 THEN 0 ELSE 1 END)) OR [StartDate] BETWEEN @sd AND @ed)
		AND ((1 = (CASE WHEN @q = 1 THEN 0 ELSE 1 END))	OR [RequestDate] BETWEEN @sd AND @ed)))
	ORDER BY
		[ph], [Name], [Status], [ITRequestID#]
END

END