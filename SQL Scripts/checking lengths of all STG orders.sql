
DECLARE @result AS TABLE (
	[ID] INT IDENTITY(0, 1)
	, [SGQuote] NVARCHAR(MAX)
	, [Input] NVARCHAR(MAX)
	, [Ft Part] INTEGER
	, [In Part] INTEGER
	, [Ft Tot] DECIMAL(14, 7)				
	, [In Tot] INTEGER
);

DECLARE @i AS INTEGER = 0;
DECLARE @c AS INTEGER;
DECLARE @q AS NVARCHAR(MAX);

SELECT @c = COUNT(*) FROM [OrdersV2]

WHILE @i < @c BEGIN
	SELECT @q = [SGQuote] FROM [OrdersV2] WHERE [OrdersV2].[OrderID] = @i;
	PRINT 'SGQuote: <' + @q + '>';
	--INSERT INTO @result ([Input], [Ft Part], [In Part], [Ft Tot], [In Tot])
	EXEC [sp_OverallLengthStg] @q, 0;
	UPDATE
		@result
	SET
		[SGQuote] = @q
	WHERE
		[ID] = @i
	;
	SELECT @i = @i + 1;
END


--SELECT * FROM @result