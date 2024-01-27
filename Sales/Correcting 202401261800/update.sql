USE BWSdb
GO

SELECT
*
FROM
	[Custom WorkV2]
WHERE
	[Description] LIKE '%DELETE%'


BEGIN TRAN;

DECLARE @NPO_ID INT = 9644;
SELECT
*
FROM
	[Custom WorkV2]
WHERE
	[ID] = @NPO_ID

UPDATE
	[Custom WorkV2]
SET
	[Description] = 'DELETE THIS, SET @ ' + CAST(GETDATE() AS NVARCHAR(MAX))
	,[Weight] = [Qty] + 1
	,[Price] = [Price] + 1
	--,[] = [Qty] + 1
	,[Cost] = [Cost] + 1
	,[Labour Cost] = [Labour Cost] + 1
	,[Made In Material] = [Made In Material] + 1
	,[Bought Out Material] = [Bought Out Material] + 1
	,[Steel Kit] = [Steel Kit] + 1
	,[Axles] = [Axles] + 1
	,[Step 1] = [Step 1] + 1
	,[Step 2] = [Step 2] + 1
	,[Blast] = [Blast] + 1
	,[Paint] = [Paint] + 1
	,[Finish - GNK] = [Finish - GNK] + 1
	,[Final Assembly] = [Final Assembly] + 1
	,[Tire Assembly] = [Tire Assembly] + 1
	,[Shipping] = [Shipping] + 1
WHERE
	[ID] = @NPO_ID
;

SELECT
*
FROM
	[Custom WorkV2]
WHERE
	[ID] = @NPO_ID

ROLLBACK;
COMMIT;