USE BWSdb

GO


-- 2023-10-17 Delete a model copied in error by yassin


BEGIN TRAN;


SELECT
	*
FROM
	[ProductsV2]
WHERE [Model No] LIKE '%ED2X-V2%'


DELETE FROM 
	[ProductsV2]
WHERE [Model No] LIKE '%ED2X-V2%'



SELECT
	*
FROM
	[ProductsV2]
WHERE [Model No] LIKE '%ED2X-V2%'

ROLLBACK;
COMMIT;