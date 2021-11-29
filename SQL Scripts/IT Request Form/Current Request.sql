SELECT 1 AS ph, SUM([SRC].AssignedJamesID) AS AssignedJamesID, SUM([SRC].AssignedJames) AS AssignedJames, SUM([SRC].AssignedJamieID) AS AssignedJamieID, SUM([SRC].AssignedJamie) AS AssignedJamie, SUM([SRC].AssignedAveryID) AS AssignedAveryID, SUM([SRC].AssignedAvery) AS AssignedAvery
FROM (
	SELECT
		1 AS [ph],
		[ITRequestID#] AS AssignedJamesID,
		[ITRequestID#] AS AssignedJames,
		0 AS AssignedJamieID,
		0 AS AssignedJamie,
		0 AS AssignedAveryID,
		0 AS AssignedAvery
	FROM 
		[IT Requests]
	INNER JOIN 
		[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Personnel].[ITPersonID#] = 2
UNION
	SELECT
		1 AS [ph],
		0 AS AssignedJamesID,
		0 AS AssignedJames,
		[ITRequestID#] AS AssignedJamieID,
		[ITRequestID#] AS AssignedJamie,
		0 AS AssignedAveryID,
		0 AS AssignedAvery
	FROM
		[IT Requests] 
	INNER JOIN
		[IT Personnel]
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Personnel].[ITPersonID#] = 3
UNION
	SELECT
		1 AS [ph],
		0 AS AssignedJamesID, 
		0 AS AssignedJames, 
		0 AS AssignedJamieID,
		0 AS AssignedJamie, 
		[ITRequestID#] AS AssignedAveryID, 
		[ITRequestID#] AS AssignedAvery 
	FROM
		[IT Requests]
	INNER JOIN
		[IT Personnel] 
	ON
		[IT Requests].[ITPersonAssignedID] = [IT Personnel].[ITPersonID#]
	WHERE
		[IT Personnel].[ITPersonID#] = 4
)  AS SRC
GROUP BY [ph];

SELECT * FROM [IT Requests]