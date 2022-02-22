SELECT TOP 100 * FROM [IT Requests] ORDER BY [RequestDate] DESC

BEGIN TRAN;

SELECT [ITRequestID#] FROM [IT Requests] WHERE [RequestedBy] = 'Avery Briggs' AND [RequestDate] BETWEEN DATEADD(DAY, -1, GETDATE()) AND GETDATE()

DELETE FROM 
	[IT Requests]
WHERE
	[ITRequestID#] IN (SELECT [ITRequestID#] FROM [IT Requests] WHERE [RequestedBy] = 'Avery Briggs' AND [RequestDate] BETWEEN DATEADD(DAY, -1, GETDATE()) AND GETDATE())

SELECT [ITRequestID#] FROM [IT Requests] WHERE [RequestedBy] = 'Avery Briggs' AND [RequestDate] BETWEEN DATEADD(DAY, -1, GETDATE()) AND GETDATE()

ROLLBACK
COMMIT;