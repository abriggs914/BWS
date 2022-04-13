USE BWSdb
GO

DECLARE @qs AS TABLE ([ID] INT IDENTITY(1,1), [Quote#] BIGINT)
INSERT INTO @qs VALUES
(26653),
(26791),
(26470)

SELECT 
	[Draw/Part#],
	[Order Options].[Option No],
	[Description],
	* 
FROM
	[Orders]
INNER JOIN
	[Order Options]
ON
	[Orders].[Quote#] = [Order Options].[Quote#]
WHERE
	[Orders].[Quote#] IN (SELECT [Quote#] FROM @qs)
ORDER BY
	[Order Options].[Option No]
;

SELECT 
	[Draw/Part#],
	[Description],
	* 
FROM
	[Orders]
INNER JOIN
	[Custom Work]
ON
	[Orders].[Quote#] = [Custom Work].[Quote#]
WHERE
	[Orders].[Quote#] IN (SELECT [Quote#] FROM @qs)
ORDER BY
	[Custom Work].Quote#
--SELECT * FROM [Options] WHERE [Quote#] IN (SELECT [Quote#] FROM @qs)


--AND ([Description] = 'Add 2nd set of Plank Brackets'

BEGIN TRAN

	SELECT * FROM
		[Custom Work]
	WHERE
		[Quote#] = 26653
		AND ([Description] = 'Add 2nd set of Plank Brackets'
		OR [Draw/Part#] = '99001796')

	UPDATE
		[Custom Work]
	SET
		[Draw/Part#] = '99001796'
	WHERE
		[Quote#] = 26653
		AND [Description] = 'Add 2nd set of Plank Brackets'

	SELECT * FROM
		[Custom Work]
	WHERE
		[Quote#] = 26653
		AND ([Description] = 'Add 2nd set of Plank Brackets'
		OR [Draw/Part#] = '99001796')

ROLLBACK;
COMMIT;