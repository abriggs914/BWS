USE BWSdb
GO
/*
SELECT * FROM [Calendar]-- ORDER BY [Date]
SELECT * FROM [Calendar] ORDER BY [Date]
*/

DECLARE @missing TABLE ([Date] DATETIME);

DECLARE @i DATETIME = '1900-01-01';
DECLARE @c INT = 0;

WHILE @i <= '2040-12-31' BEGIN

	--SELECT @c = COUNT(*) FROM [Calendar] WHERE (YEAR([Date]) = YEAR(@i)) AND MONTH([Date]) = MONTH(@i) AND DAY([Date]) = DAY(@i)
	SELECT @c = COUNT(*) FROM [Calendar] WHERE [Date] = @i;

	IF @c = 0 BEGIN
		INSERT INTO @missing ([Date]) SELECT @i;
	END
	SELECT @i = DATEADD(DAY, 1, @i);

END

SELECT * FROM @missing;
/*
SELECT
	*
FROM
	[Calendar]
WHERE
	[Date] = '1950-12-31'
	OR [Date] = '2010-12-31'
	*/