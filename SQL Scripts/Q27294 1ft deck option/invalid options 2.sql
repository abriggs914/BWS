USE BWSdb
GO

DECLARE @models AS TABLE ([ID] INT IDENTITY(1, 1), [Model No] NVARCHAR(MAX));
INSERT INTO @models ([Model No])
SELECT DISTINCT
	[Products].[Model No]
FROM
	[Products]
INNER JOIN
	[Options]
ON
	[Products].[Model No] = [Options].[Model No]
WHERE
	[Obsolete] = 0
	AND [Non-Current] = 0
GROUP BY
	[Class],
	[Products].[Model No],
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY 
	[Model No]
;

SELECT * FROM @models



DECLARE @dblOptions AS TABLE ([ID] INT IDENTITY(1, 1), [Model No] NVARCHAR(MAX), [Option No] NVARCHAR(MAX), [Description] NVARCHAR(MAX));

DECLARE	@modelno nvarchar(50);
DECLARE @compid int;
DECLARE @n AS INT;
DECLARE @i AS INT;
SELECT @n = COUNT(*) FROM @models
SET @i = 1;

WHILE @i < @n BEGIN

	SELECT @modelno = [Model No] FROM @models WHERE [ID] = @i;
	SET @compid = 0;

	INSERT INTO @dblOptions ([Model No], [Option No], [Description])
	SELECT
		[Model No],
		[Option No],
		[Description]
	FROM
		[Budget Options V2]
	WHERE
		[Model No] LIKE @modelno
		AND [Obsolete] = 0
	GROUP BY
		[Model No],
		[Option No],
		[Description]
	HAVING
		COUNT([Option No]) > 1
	ORDER BY
		[Option No]
		
	SET @i = @i + 1;
END

SELECT * FROM @dblOptions