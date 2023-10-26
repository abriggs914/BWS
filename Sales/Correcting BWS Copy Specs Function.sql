
USE BWSdb
GO


BEGIN TRAN;


	DECLARE @copiedModel NVARCHAR(MAX) = '35ADG2X51 AGNR';
	DECLARE @lastModelID INT;
	DECLARE @lastModelName NVARCHAR(MAX);

	SELECT TOP 1
		@lastModelID = [IDTrailer]
		, @lastModelName = [Model No]
	FROM
		[Products]
	ORDER BY
		[IDTrailer] DESC
	;


	SELECT
		'A Options' AS [T],
		*
	FROM
		[Options]
	WHERE
		[Model No] IN (@lastModelName, @copiedModel)
	ORDER BY
		[Description]
	;

	UPDATE
		[Options]
	SET
		[US Price] = [A].[US Price]
	FROM (
		SELECT
			[Description]
			, [US Price]
		FROM
			[Options]
		WHERE
			[Model No] = @copiedModel
	) AS [A]
	WHERE
		[Model No] = @lastModelName
		AND [Options].[Description] = [A].[Description]

	SELECT
		'B Options' AS [T],
		*
	FROM
		[Options]
	WHERE
		[Model No] IN (@lastModelName, @copiedModel)
	ORDER BY
		[Description]
	;

ROLLBACK;
COMMIT;