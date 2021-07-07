USE BWSdb
GO

DECLARE @ModelName VARCHAR(15);
DECLARE @99Num VARCHAR(8);


-- Adjusted Options
/*
SET @ModelName = '48et2xp';
SET @99Num = '99000082';
*/
/*
SET @ModelName = '53et2x';
SET @99Num = '99000081';
*/


SELECT
	[ID#], [Model No], [Option No], [Price], [Sections], [Description], [Draw/Part#], [Obsolete]
FROM
	[Options]
WHERE
	[Model No] LIKE @ModelName
	AND [Draw/Part#] LIKE @99Num
;

IF (
	SELECT
		SUM(CONVERT(INT, [Obsolete]))
	FROM
		[Options]
	WHERE
		[Model No] LIKE @ModelName
		AND [Draw/Part#] LIKE @99Num
	) = 1 BEGIN
		UPDATE
			[Options]
		SET
			[Obsolete] = 0
		WHERE
			[Model No] LIKE @ModelName
			AND [Draw/Part#] LIKE @99Num
		;

		SELECT
			[ID#], [Model No], [Option No], [Price], [Sections], [Description], [Draw/Part#], [Obsolete]
		FROM
			[Options]
		WHERE
			[Model No] LIKE @ModelName
			AND [Draw/Part#] LIKE @99Num
		;
END
;

