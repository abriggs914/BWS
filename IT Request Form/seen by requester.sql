USE BWSdb
GO

DECLARE @requester AS NVARCHAR(MAX) = 'Avery Briggs';

SELECT
	*
FROM
	[IT Requests]
WHERE
	[RequestedBy] = @requester
	AND ISNULL([SeenByRequester], DATEADD(MINUTE, -3, [RequestDateOriginal])) < DATEADD(MINUTE, -2, [LastStatusUpdate])