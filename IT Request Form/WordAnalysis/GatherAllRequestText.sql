USE BWSdb
GO


	
DECLARE @r_text AS NVARCHAR(MAX);
DECLARE @r_comm AS NVARCHAR(MAX);
DECLARE @a AS INTEGER; -- Increment requests by
DECLARE @i AS INTEGER; -- looping requests
DECLARE @c AS INTEGER; -- upperbound requests
DECLARE @unknown AS NVARCHAR(MAX);


SELECT
	@a = 1
	--,@minWordLen = 3
	,@unknown = 'UNKNOWN'
	,@i = MIN([ITRequestID#])
	,@c = MAX([ITRequestID#])
FROM
	[IT Requests]
;

DECLARE @allText AS NVARCHAR(MAX) = '';

WHILE @i < @c BEGIN
	
	SELECT @allText = @allText + ' ' + LTRIM(RTRIM(ISNULL([Request], '') + ' ' + ISNULL([Comments], ''))) FROM [IT Requests] WHERE [ITRequestID#] = @i

	SELECT @i = @i + 1;

END

select @allText as [aLLtEXT]