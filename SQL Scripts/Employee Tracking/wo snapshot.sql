Use BWSdb
GO

DECLARE @CN AS VARCHAR(50);
SET @CN = '%demountable%';

SELECT
	[ID]
FROM
	[Dealers]
WHERE
	[COMPANY NAME] LIKE @CN
;

SELECT
	[COMPANY NAME],
	[Serial Number],
	*
FROM
	[Orders]
INNER JOIN
	[Dealers]
ON
	[Dealers].[ID] = [Orders].[DealerID]
WHERE
	[COMPANY NAME] LIKE @CN
;