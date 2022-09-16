DECLARE @i AS INTEGER;
DECLARE @c AS INTEGER;
DECLARE @rb AS NVARCHAR(MAX);

DECLARE @results AS TABLE([ID] INT IDENTITY(1, 1), [RequestedBy] NVARCHAR(MAX), [reqID] INTEGER, [reqIDP] INTEGER);


SELECT @c = MAX([ITRequestID#]) FROM [IT Requests]
SELECT @i = 0;

WHILE @i < @c BEGIN

	SELECT @rb = [RequestedBy] FROM [IT Requests] WHERE [ITRequestID#] = @i;

	INSERT INTO @results ([RequestedBy], [reqID], [reqIDP])
	SELECT
		[RequestedBy]
		, @i
		, COUNT(*)
	FROM
		[IT Requests]
	WHERE
		[ITRequestID#] <= @i
		AND [RequestedBy] = @rb
	GROUP BY
		[RequestedBy]

	SELECT @i = @i + 1;
END

SELECT * FROM @results;

SELECT * FROM [IT Requests] WHERE [LastStatusUpdate] BETWEEN CAST(DATEPART(YEAR, GETDATE()) AS NVARCHAR(4)) + '-' + CAST(DATEPART(MONTH, GETDATE()) AS NVARCHAR(2)) + '-' + CAST(DATEPART(DAY, GETDATE()) AS NVARCHAR(2)) AND GETDATE()