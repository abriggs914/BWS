USE BWSdb
GO


-- Add ProductIDs to any orders that do not already have one.

BEGIN TRAN;


SELECT
	*
FROM
	[Orders] AS [O]
WHERE
	[ProductID] IS NULL

UPDATE
	[Orders]
SET
	[ProductID] = [P].[IDTrailer]
FROM
	[Orders] AS [O]
INNER JOIN
	[Products] AS [P]
ON
	[O].[Model No] = [P].[Model No]
WHERE
	[ProductID] IS NULL

SELECT
	*
FROM
	[Orders] AS [O]
WHERE
	[ProductID] IS NULL

ROLLBACK;
COMMIT;