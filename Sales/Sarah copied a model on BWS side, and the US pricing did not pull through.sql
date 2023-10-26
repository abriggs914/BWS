
-- Sarah copied a model on BWS side, and the US pricing did not pull through.

USE BWSdb
GO

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

SELECT TOP 5
	*
FROM
	[Products]
ORDER BY
	[IDTrailer] DESC
;

SELECT
	'Options' AS [T],
	*
FROM
	[Options]
WHERE
	[Model No] IN (@lastModelName, @copiedModel)
;

SELECT
	'Standards' AS [T],
	*
FROM
	[Standards]
WHERE
	[Model No] IN (@lastModelName, @copiedModel)
;

SELECT
	'Budget Options' AS [T],
	*
FROM
	[Budget Options]
WHERE
	[Model No] IN (@lastModelName, @copiedModel)
;