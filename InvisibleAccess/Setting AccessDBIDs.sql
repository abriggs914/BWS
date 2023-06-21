USE BWSdb
GO


SELECT
	'ADG Databases' AS [Table],
	*
FROM
	[ADG Databases]
;

BEGIN TRAN;

SELECT
	*
FROM
	[ADG Events]
;

UPDATE
	[ADG Events]
SET
	[AccessDBID] = [A].[ID]
FROM
	[ADG Events]
INNER JOIN
	[ADG Databases] AS [A]
ON
	[ADG Events].[AccessDB] = [A].[Name]
;

SELECT
	*
FROM
	[ADG Events]
;

ROLLBACK;
COMMIT;