USE Stargatedb
GO

BEGIN TRAN;

	SELECT
		[ID]
		,[DateCreated]
		,[CreatedBy]
		,[Job]
		,[Line]
		,[Date]
	FROM
		[PDS_WarrantyUnits]

	INSERT INTO [PDS_WarrantyUnits] ([Job])
	SELECT 
		[Job]
	FROM 
		[SysproCompanyS].[dbo].[WipMaster] [W]
	FULL JOIN
		[BWSdb].[dbo].[OrdersV2] AS [O]
	ON
		RIGHT(ISNULL([W].[StockDescription], '    '), 4) COLLATE DATABASE_DEFAULT = RIGHT(ISNULL([O].[Serial Number], '    '), 4)
	WHERE
	--(
		(LEFT([W].[Job], 1) = '3')
		--OR (ISNULL([JobClassification], '') = 'WAR'))
		AND (ISNULL([W].[StockDescription], '') <> '')
		AND ([O].[SGQuote] IS NOT NULL)
		
	SELECT
		[ID]
		,[DateCreated]
		,[CreatedBy]
		,[Job]
		,[Line]
		,[Date]
	FROM
		[PDS_WarrantyUnits]
		
ROLLBACK;
COMMIT;