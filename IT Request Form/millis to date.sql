DECLARE @s BIGINT;
SELECT
    --@s = 7884000000000 -- millis
    --@s = 1648252100000 -- millis
	--@s = 34278000
	--@s = 120678000000 -- epoch
	@s = 120712278000 -- epoch
    --@s = 78
--SELECT
--    @s AS [Seconds]
--  , CONVERT(TIME, DATEADD(SECOND, @s, 0)) AS [Date];

SELECT
	@s AS [Seconds]
	, dateadd(ms, @s / 86400000, (@s / 86400000) + 25567) AS [Date];