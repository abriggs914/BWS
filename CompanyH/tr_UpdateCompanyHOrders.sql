-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Avery Briggs>
-- Create date: <2024-12-03>
-- Description:	<Copy orders to CompanyH>
-- =============================================
ALTER TRIGGER [dbo].[tr_UpdateCompanyHOrders]
   ON  [BWSdb].[dbo].[Orders]
   AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() > 1 BEGIN
		RETURN;
	END

    -- DELETE rows in DestinationTable that are deleted in SourceTable
    DELETE FROM
		[C]
    FROM
		[CompanyH].[dbo].[Orders] [C]
	INNER JOIN
		DELETED [D]
	ON 
		[C].[BWSdbQuoteNumber] = CAST([D].[Quote#] AS NVARCHAR(25))
	;

	 -- INSERT new rows into DestinationTable
    INSERT INTO
		[CompanyH].[dbo].[Orders]
	(
		[CompanyID]
        ,[WONumber]
        ,[ProductID]
        ,[SalesPersonID]
        ,[DealerID]
        ,[DealerBranchID]
        ,[DealerSalesPersonID]
        ,[DateQuote]
        ,[DateOrder]
        ,[DateDeclined]
        ,[DateAvailable]
        ,[DateDelivery]
        ,[DateRequestedDelivery]
        ,[DateFinish]
        ,[DatePurchaseOrder]
        ,[DateShipped]
        ,[DateRegistered]
        ,[DateInService]
        ,[DateInvoice]
        ,[PromoDrawing]
        ,[SpecialInstructions]
        ,[SerialNumber]
        ,[PurchaseOrder]
        ,[Notes]
        ,[EngNotes]
        ,[AdditionalPricingInfo]
        ,[InternalSalesComment]
        ,[Price]
        ,[USSale]
        ,[HighRiskUnit]
        ,[Width]
        ,[Spread]
        ,[Tare]
        ,[GVWR]
		,[BWSdbQuoteNumber]
	)
    SELECT
		0
        ,[I].[WO#]
        ,[I].[ProductID]
        ,[I].[Sale PersonID]
        ,[I].[DealerID]
        ,[I].[DealerBranchID]
        ,[I].[DealerSalesPersonID]
        ,[I].[Quote Date]
        ,[I].[Order Date]
        ,[I].[Date Declined]
        ,[I].[Available Date]
        ,[I].[Delivery Date]
        ,[I].[Requested Delivery Date]
        ,[I].[Finish Date]
        ,[I].[PO Date]
        ,[I].[Shipped Date]
        ,[I].[Date Registered]
        ,[I].[Date In Service]
        ,[I].[Invoice Date]
        ,[I].[Prom Drawing]
        ,[I].[Special Instructions]
        ,CAST([I].[Serial Number] AS NVARCHAR(17))
        ,[I].[Purchase Order]
        ,[I].[Notes]
        ,[I].[EngNotes V2]
        ,[I].[AdditionalPricingInfo]
        ,[I].[InternalSalesComment]
        ,[I].[Price]
        ,[I].[US Sale]
        ,[I].[HighRiskUnit]
        ,[I].[Width]
        ,[I].[Spread]
        ,[I].[Tare]
        ,[I].[GVWR]
		,CAST([I].[Quote#] AS NVARCHAR(25))
    FROM 
		INSERTED [I]
    WHERE NOT EXISTS (
        SELECT 
			1
		FROM
			[CompanyH].[dbo].[Orders] [D]
        WHERE
			[D].[BWSdbQuoteNumber] = CAST([I].[Quote#] AS NVARCHAR(25))
    );
	
    -- UPDATE rows in DestinationTable with changes from SourceTable
	UPDATE 
		[D]
    SET 
		[D].[CompanyID] = 0
        ,[D].[WONumber] = [I].[WO#]
        ,[D].[ProductID] = [I].[ProductID]
        ,[D].[SalesPersonID] = [I].[Sale PersonID]
        ,[D].[DealerID] = [I].[DealerID]
        ,[D].[DealerBranchID] = [I].[DealerBranchID]
        ,[D].[DealerSalesPersonID] = [I].[DealerSalesPersonID]
        ,[D].[DateQuote] = [I].[Quote Date]
        ,[D].[DateOrder] = [I].[Order Date]
        ,[D].[DateDeclined] = [I].[Date Declined]
        ,[D].[DateAvailable] = [I].[Available Date]
        ,[D].[DateDelivery] = [I].[Delivery Date]
        ,[D].[DateRequestedDelivery] = [I].[Requested Delivery Date]
        ,[D].[DateFinish] = [I].[Finish Date]
        ,[D].[DatePurchaseOrder] = [I].[PO Date]
        ,[D].[DateShipped] = [I].[Shipped Date]
        ,[D].[DateRegistered] = [I].[Date Registered]
        ,[D].[DateInService] = [I].[Date In Service]
        ,[D].[DateInvoice] = [I].[Invoice Date]
        ,[D].[PromoDrawing] = [I].[Prom Drawing]
        ,[D].[SpecialInstructions] = [I].[Special Instructions]
        ,[D].[SerialNumber] = [I].[Serial Number]
        ,[D].[PurchaseOrder] = [I].[Purchase Order]
        ,[D].[Notes] = [I].[Notes]
        ,[D].[EngNotes] = [I].[EngNotes V2]
        ,[D].[AdditionalPricingInfo] = [I].[AdditionalPricingInfo]
        ,[D].[InternalSalesComment] = [I].[InternalSalesComment]
        ,[D].[Price] = [I].[Price]
        ,[D].[USSale] = [I].[US Sale]
        ,[D].[HighRiskUnit] = [I].[HighRiskUnit]
        ,[D].[Width] = [I].[Width]
        ,[D].[Spread] = [I].[Spread]
        ,[D].[Tare] = [I].[Tare]
        ,[D].[GVWR] = [I].[GVWR]
		,[D].[BWSdbQuoteNumber] = [I].[Quote#]
    FROM 
		[CompanyH].[dbo].[Orders] [D]
    INNER JOIN 
		INSERTED I 
	ON 
		[D].[BWSdbQuoteNumber] = CAST([I].[Quote#] AS NVARCHAR(25));

END
GO
