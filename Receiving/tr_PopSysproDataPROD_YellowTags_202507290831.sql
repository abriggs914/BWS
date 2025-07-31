USE [BWSdb]
GO
/****** Object:  Trigger [dbo].[tr_UpdatePROD_YellowTagsHistory]    Script Date: 2025-07-28 11:37:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-07-29 07:48:00>
-- Description:	<Maintain History Table>
-- =============================================
ALTER TRIGGER [dbo].[tr_PopSysproDataPROD_YellowTags] 
ON [dbo].[PROD_YellowTags]
AFTER INSERT, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;


	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
		DECLARE @wh NVARCHAR(MAX) = '01';

		UPDATE
			[BWSdb].[dbo].[PROD_YellowTags]
		SET
			[Supplier] = [AS].[SupplierName],
			[Description] = ISNULL([IM].[Description], '') + ' *---* ' + ISNULL([IM].[LongDesc], ''),
			[PO] = [Src].[PurchaseOrder]
		FROM 
			[BWSdb].[dbo].[PROD_YellowTags] [YT]
		INNER JOIN
			INSERTED [I]
		ON
			[YT].[ID] = [I].[ID]
		LEFT JOIN
			DELETED [D]
		ON
			[YT].[ID] = [D].[ID]
		INNER JOIN (
			SELECT 
				[MD].[PurchaseOrder],
				[MD].[MStockCode],
				ROW_NUMBER() OVER(
					PARTITION BY
						[MD].[MStockCode]
					ORDER BY
						[MD].[MOrigDueDate] DESC
				) AS [RN]
			FROM [SysproCompanyA].[dbo].[PorMasterDetail] [MD]
			INNER JOIN [BWSdb].[dbo].[PROD_YellowTags] [YT] ON [MD].[MStockCode] = [YT].[StockCode] COLLATE DATABASE_DEFAULT
			WHERE ([MD].[MLastReceiptDat] IS NULL) AND ([MD].[MWarehouse] = @wh) AND ([YT].[Active] = 1)
		) AS [Src]
		ON
			[YT].[StockCode] = [Src].[MStockCode] COLLATE DATABASE_DEFAULT
		LEFT JOIN
			[SysproCompanyA].[dbo].[InvMaster] [IM]
		ON
			[Src].[MStockCode] = [IM].[StockCode]
		LEFT JOIN
			[SysproCompanyA].[dbo].[ApSupplier] [AS]
		ON
			[IM].[Supplier] = [AS].[Supplier]
		WHERE
			([Src].[RN] = 1)
			AND ([YT].[Active] = 1)
		;

	END
END