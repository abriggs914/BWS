USE SysproCompanyA
GO

--EXEC [sp_ClkLabourOverride] @sd='2022-03-12', @ed='2022-03-12 23:59:59'

DECLARE @i AS INTEGER;
DECLARE @j AS INTEGER;
DECLARE @c AS INTEGER;

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;

SET @sd = '2022-03-12';
SET @ed = DATEADD(HOUR, 23, DATEADD(MINUTE, 59, DATEADD(SECOND, 59, @sd)));

SELECT @sd AS [@sd], @ed AS [@ed]
EXEC [sp_ClkLabourOverride] @sd=@sd, @ed=@ed

SET @i = 0;
SET @j = 0;
SET @c = 5;

--SELECT DATEADD(DAY, 1, '2022-03-15');

WHILE @i < @c BEGIN
	--PRINT 'A @sd: ' + CAST(@sd AS NVARCHAR(MAX));
	--PRINT 'A @ed: ' + CAST(@ed AS NVARCHAR(MAX));
	EXEC [sp_ClkLabourOverride]	@sd=@sd, @ed=@ed;
	SET @sd = DATEADD(DAY, 1, @sd);
	SET @ed = DATEADD(DAY, 1, @ed);
	--PRINT 'B @sd: ' + CAST(@sd AS NVARCHAR(MAX));
	--PRINT 'B @ed: ' + CAST(@ed AS NVARCHAR(MAX)) + ', i: ' + CAST(@i AS NVARCHAR(MAX));
	SET @i = @i + 1;
END
