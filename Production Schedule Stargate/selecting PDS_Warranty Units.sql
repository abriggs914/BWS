USE BWSdb
GO


SELECT
	*
FROM
	[IT Requests]


USE Stargatedb
GO


SELECT * FROM
	[PDS_WarrantyUnits] [A]
INNER JOIN (
	SELECT
		*,
		ROW_NUMBER() OVER(
			PARTITION BY
				[Job]
			ORDER BY
				[DateCreated], [ID]
		) AS [N]
	FROM
		[PDS_WarrantyUnits]
) [B]
ON
	[A].[Job] = [B].[Job]
	AND [A].[ID] = [B].[ID]
ORDER BY
	[A].[Job]
	,[N]
--WHERE
--	[N] > 1

SELECT
	[ID]
	,[DateCreated]
	,[CreatedBy]
	,[Job]
	,[Line]
	,[Date]
FROM
	[PDS_WarrantyUnits]

BEGIN TRAN;

DELETE [A] FROM
	[PDS_WarrantyUnits] [A]
INNER JOIN (
	SELECT
		*,
		ROW_NUMBER() OVER(
			PARTITION BY
				[Job]
			ORDER BY
				[DateCreated]
		) AS [N]
	FROM
		[PDS_WarrantyUnits]
) [B]
ON
	[A].[Job] = [B].[Job]
	AND [A].[ID] = [B].[ID]
WHERE
	[N] > 1

ROLLBACK;
COMMIT;



SELECT* FROM

[SysproCompanyS].[dbo].[WipMaster] [W]
	WHERE
		--[W].[Job] IS NULL
	 LEFT([W].[Job], 1) = '3'

	 
SELECT* FROM
		[Stargatedb].[dbo].[PDS_WarrantyUnits]

SELECT
	*
FROM
WHERE
	[SCHEMA_ID] = 0