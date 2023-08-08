USE BWSdb
GO

DECLARE @requester AS NVARCHAR(MAX) = 'Lori Piper';

SELECT
	*
FROM
	[IT Requests]
WHERE
	[RequestedBy] = @requester
	AND ISNULL([SeenByRequester], DATEADD(MINUTE, -3, [RequestDateOriginal])) < DATEADD(MINUTE, -2, [LastStatusUpdate])
;

SELECT
	*
FROM
	[IT Requests]
WHERE
	ISNULL([SeenByRequester], DATEADD(MINUTE, -3, [RequestDateOriginal])) < DATEADD(MINUTE, -2, [LastStatusUpdate])
;

SELECT
	*
FROM
	[IT Requests]
WHERE
	[SeenByRequester] IS NOT NULL
ORDER BY
	[SeenByRequester] DESC
;

SELECT TOP 5
	*
FROM
	[IT Requests]
ORDER BY	
	[OpenCounter] DESC