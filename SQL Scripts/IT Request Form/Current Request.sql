USE BWSdb
GO

-- DOES NOT SHOW REQUESTS THAT HAVE NO PUBLIC DIRECTORY.

DECLARE @c AS BIT; -- Complete
DECLARE @q AS BIT; -- Queued
DECLARE @p AS BIT; -- In Progess
DECLARE @d AS BIT; -- Declined
DECLARE @n AS BIT; -- Incomplete
SET @c = 1;
SET @q = 1;
SET @p = 1;
SET @d = 1;
SET @n = 1;

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

SELECT 
	1 AS ph,
	MIN([SRC].AssignedJamesID) AS AssignedJamesID,
	COALESCE(@var, [SRC].StatusJames) AS StatusJames,
	COALESCE(@var, [SRC].AssignedJames) AS AssignedJames,
	MIN([SRC].AssignedJamieID) AS AssignedJamieID,
	COALESCE(@var, [SRC].StatusJamie) AS StatusJamie,
	COALESCE(@var, [SRC].AssignedJamie) AS AssignedJamie,
	MIN([SRC].AssignedAveryID) AS AssignedAveryID,
	COALESCE(@var, [SRC].StatusAvery) AS StatusAvery,
	COALESCE(@var, [SRC].AssignedAvery) AS AssignedAvery
FROM (
	SELECT
		1 AS [ph],

		[ITRequestID#] AS AssignedJamesID,
		[Status] AS StatusJames,
		[Directory] AS AssignedJames,

		0 AS AssignedJamieID,
		NULL AS StatusJamie,
		NULL AS AssignedJamie,

		0 AS AssignedAveryID,
		NULL AS StatusAvery,
		NULL AS AssignedAvery
	FROM 
		[IT Requests]
	INNER JOIN 
		[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Personnel].[ITPersonID#] = 2 AND
		[Status] IN (SELECT [val] FROM @valid) AND [Directory] IS NOT NULL
UNION
	SELECT
		1 AS [ph],

		0 AS AssignedJamesID,
		NULL AS AssignedJames,
		NULL AS StatusJames,

		[ITRequestID#] AS AssignedJamieID,
		[Status] AS StatusJamie,
		[Directory] AS AssignedJamie,

		0 AS AssignedAveryID,
		NULL AS StatusAvery,
		NULL AS AssignedAvery
	FROM
		[IT Requests] 
	INNER JOIN
		[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Personnel].[ITPersonID#] = 3 AND [Status] IN (SELECT [val] FROM @valid) AND [Directory] IS NOT NULL
UNION
	SELECT
		1 AS [ph],

		0 AS AssignedJamesID, 
		NULL AS StatusJames,
		NULL AS AssignedJames,

		0 AS AssignedJamieID,
		NULL AS StatusJamie,
		NULL AS AssignedJamie, 

		[ITRequestID#] AS AssignedAveryID, 
		[Status] AS StatusAvery,
		[Directory] AS AssignedAvery 

	FROM
		[IT Requests]
	INNER JOIN
		[IT Personnel] 
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Personnel].[ITPersonID#] = 4 AND [Status] IN (SELECT [val] FROM @valid) AND [Directory] IS NOT NULL
)  AS SRC
GROUP BY [ph], [AssignedJames], [AssignedJamie], [AssignedAvery], [StatusJames], [StatusJamie], [StatusAvery];

SELECT * FROM [IT Requests]