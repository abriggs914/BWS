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
-- Create date: <2024-01-18 12:53:07>
-- Description:	<SQL Trigger to check changes to all columns, and if found, then will create a history record to mark the change>
-- =============================================
CREATE TRIGGER  [dbo].[tr_UpdateOrdersV2History]
   ON [OrdersV2]
   --BEFORE
   AFTER
   --INSTEAD OF
   INSERT
   , DELETE
   , UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF TRIGGER_NESTLEVEL() < 2 BEGIN
	
	    -- Differences Table
	    
		DECLARE @t_to_update AS TABLE 
		(
			[ID] INT IDENTITY(1, 1),
			[Column] NVARCHAR(255),
			[ValueBefore] NVARCHAR(MAX),
			[ValueAfter] NVARCHAR(MAX)
		)
	;
	
	    
	    -- Declarative Statements
	    		DECLARE @old_OrderID AS INT;
		DECLARE @old_SGQuote AS VARCHAR;
		DECLARE @old_Quote_Date AS DATETIME;
		DECLARE @old_Order_Date AS DATETIME;
		DECLARE @old_WO_ AS INT;
		DECLARE @old_Sales_Order_ AS INT;
		DECLARE @old_Model_No AS NVARCHAR(50);
		DECLARE @old_Width AS INT;
		DECLARE @old_Spread AS INT;
		DECLARE @old_DealerID AS INT;
		DECLARE @old_Sale_PersonID AS INT;
		DECLARE @old_Price AS MONEY;
		DECLARE @old_Prom_Drawing AS NVARCHAR(255);
		DECLARE @old_Special_Instructions AS NVARCHAR(MAX);
		DECLARE @old_Date_Declined AS DATETIME;
		DECLARE @old_Decline_Rejected AS INT;
		DECLARE @old_Serial_Number AS NVARCHAR(255);
		DECLARE @old_Available_Date AS DATETIME;
		DECLARE @old_Delivery_Date AS DATETIME;
		DECLARE @old_Requested_Delivery_Date AS DATETIME;
		DECLARE @old_Finish_Date AS DATETIME;
		DECLARE @old_Purchase_Order AS NVARCHAR(255);
		DECLARE @old_PO_Date AS DATETIME;
		DECLARE @old_PayID AS INT;
		DECLARE @old_Volume_Discount AS REAL;
		DECLARE @old_Program_Discount AS REAL;
		DECLARE @old_Discount1_Name AS NVARCHAR(100);
		DECLARE @old_Discount1_Type AS NVARCHAR(50);
		DECLARE @old_Discount1 AS REAL;
		DECLARE @old_Discount2_Name AS NVARCHAR(100);
		DECLARE @old_Discount2_Type AS NVARCHAR(50);
		DECLARE @old_Discount2 AS REAL;
		DECLARE @old_Discount3_Name AS NVARCHAR(100);
		DECLARE @old_Discount3_Type AS NVARCHAR(50);
		DECLARE @old_Discount3 AS REAL;
		DECLARE @old_Est_Pro_Date AS DATETIME;
		DECLARE @old_Notes AS NVARCHAR(MAX);
		DECLARE @old_CarrierID AS INT;
		DECLARE @old_CustID AS INT;
		DECLARE @old_US_Sale AS BIT;
		DECLARE @old_Shipped_Date AS DATETIME;
		DECLARE @old_GL_Override_Date AS DATETIME;
		DECLARE @old_FE_Rate AS MONEY;
		DECLARE @old_PDD AS DATETIME;
		DECLARE @old_Deck_Length AS INT;
		DECLARE @old_Invoice__ AS NVARCHAR(50);
		DECLARE @old_Date_Registered AS DATETIME;
		DECLARE @old_Date_In_Service AS DATETIME;
		DECLARE @old_Invoice_Date AS DATETIME;
		DECLARE @old_Date_Requested AS DATETIME;
		DECLARE @old_GVWR AS INT;
		DECLARE @old_Tare AS INT;
		DECLARE @old_Selection AS BIT;
		DECLARE @old_Warranty AS BIT;
		DECLARE @old_BWSPaid AS BIT;
		DECLARE @old_BWSPaidDate AS DATETIME;
		DECLARE @old_CommPaid AS BIT;
		DECLARE @old_CommPaidDate AS DATETIME;
		DECLARE @old_ModifiedBy AS NVARCHAR(40);
		DECLARE @old_Lead_Date AS DATETIME;
		DECLARE @old_Lead_Source AS NVARCHAR(50);
		DECLARE @old_LeadID AS INT;
		DECLARE @old_DealerBranchID AS INT;
		DECLARE @old_DealerSalesPersonID AS INT;
		DECLARE @old_DataEntryCheck AS INT;
		DECLARE @old_DataEntryUser AS NVARCHAR(100);
		DECLARE @old_FinishedGoodsDealerLocID AS INT;
		DECLARE @old_WO_Reviewed AS BIT;
		DECLARE @old_WO_Review_Date AS DATETIME;
		DECLARE @old_Follow_Up_Date AS DATETIME;
		DECLARE @old_MSOIsDifferent AS BIT;
		DECLARE @old_MSOLocID AS INT;
		DECLARE @old_EstInvDateOverride AS BIT;
		DECLARE @old_Estimated_Invoice_Date AS DATETIME;
		DECLARE @old_AdditionalPricingInfo AS NVARCHAR(MAX);
		DECLARE @old_Slot_ AS INT;
		DECLARE @old_TempModel_ AS BIT;
		DECLARE @old_HighRiskUnit AS BIT;
		DECLARE @old_EngNotes_V2 AS NVARCHAR(MAX);
		DECLARE @old_CompanyID AS INT;
		DECLARE @old_Customer_WO_ AS INT;
		DECLARE @old_PriceSecured AS BIT;
		DECLARE @old_DateSecured AS DATETIME;
		DECLARE @old_SecuredBy AS NVARCHAR(MAX);
		DECLARE @old_InternalSalesComments AS NVARCHAR(MAX);
		DECLARE @old_InternalSalesCommentDate AS DATETIME;
		DECLARE @old_InternalSalesCommenter AS NVARCHAR(255);
		DECLARE @old_DiscountSetDate AS DATETIME;
		DECLARE @old_DiscountSetBy AS NVARCHAR(255);
		DECLARE @old_ProductID AS INT;
		DECLARE @old_DiscountID AS INT;
		DECLARE @old_DateLastQuoteReport AS DATETIME;
		DECLARE @old_JobAvailableLine AS NVARCHAR(MAX);
		DECLARE @old_JobAvailableScheduled AS DATETIME;
		DECLARE @old_JobAvailableScheduledBy AS NVARCHAR(MAX);
		DECLARE @new_OrderID AS INT;
		DECLARE @new_SGQuote AS VARCHAR;
		DECLARE @new_Quote_Date AS DATETIME;
		DECLARE @new_Order_Date AS DATETIME;
		DECLARE @new_WO_ AS INT;
		DECLARE @new_Sales_Order_ AS INT;
		DECLARE @new_Model_No AS NVARCHAR(50);
		DECLARE @new_Width AS INT;
		DECLARE @new_Spread AS INT;
		DECLARE @new_DealerID AS INT;
		DECLARE @new_Sale_PersonID AS INT;
		DECLARE @new_Price AS MONEY;
		DECLARE @new_Prom_Drawing AS NVARCHAR(255);
		DECLARE @new_Special_Instructions AS NVARCHAR(MAX);
		DECLARE @new_Date_Declined AS DATETIME;
		DECLARE @new_Decline_Rejected AS INT;
		DECLARE @new_Serial_Number AS NVARCHAR(255);
		DECLARE @new_Available_Date AS DATETIME;
		DECLARE @new_Delivery_Date AS DATETIME;
		DECLARE @new_Requested_Delivery_Date AS DATETIME;
		DECLARE @new_Finish_Date AS DATETIME;
		DECLARE @new_Purchase_Order AS NVARCHAR(255);
		DECLARE @new_PO_Date AS DATETIME;
		DECLARE @new_PayID AS INT;
		DECLARE @new_Volume_Discount AS REAL;
		DECLARE @new_Program_Discount AS REAL;
		DECLARE @new_Discount1_Name AS NVARCHAR(100);
		DECLARE @new_Discount1_Type AS NVARCHAR(50);
		DECLARE @new_Discount1 AS REAL;
		DECLARE @new_Discount2_Name AS NVARCHAR(100);
		DECLARE @new_Discount2_Type AS NVARCHAR(50);
		DECLARE @new_Discount2 AS REAL;
		DECLARE @new_Discount3_Name AS NVARCHAR(100);
		DECLARE @new_Discount3_Type AS NVARCHAR(50);
		DECLARE @new_Discount3 AS REAL;
		DECLARE @new_Est_Pro_Date AS DATETIME;
		DECLARE @new_Notes AS NVARCHAR(MAX);
		DECLARE @new_CarrierID AS INT;
		DECLARE @new_CustID AS INT;
		DECLARE @new_US_Sale AS BIT;
		DECLARE @new_Shipped_Date AS DATETIME;
		DECLARE @new_GL_Override_Date AS DATETIME;
		DECLARE @new_FE_Rate AS MONEY;
		DECLARE @new_PDD AS DATETIME;
		DECLARE @new_Deck_Length AS INT;
		DECLARE @new_Invoice__ AS NVARCHAR(50);
		DECLARE @new_Date_Registered AS DATETIME;
		DECLARE @new_Date_In_Service AS DATETIME;
		DECLARE @new_Invoice_Date AS DATETIME;
		DECLARE @new_Date_Requested AS DATETIME;
		DECLARE @new_GVWR AS INT;
		DECLARE @new_Tare AS INT;
		DECLARE @new_Selection AS BIT;
		DECLARE @new_Warranty AS BIT;
		DECLARE @new_BWSPaid AS BIT;
		DECLARE @new_BWSPaidDate AS DATETIME;
		DECLARE @new_CommPaid AS BIT;
		DECLARE @new_CommPaidDate AS DATETIME;
		DECLARE @new_ModifiedBy AS NVARCHAR(40);
		DECLARE @new_Lead_Date AS DATETIME;
		DECLARE @new_Lead_Source AS NVARCHAR(50);
		DECLARE @new_LeadID AS INT;
		DECLARE @new_DealerBranchID AS INT;
		DECLARE @new_DealerSalesPersonID AS INT;
		DECLARE @new_DataEntryCheck AS INT;
		DECLARE @new_DataEntryUser AS NVARCHAR(100);
		DECLARE @new_FinishedGoodsDealerLocID AS INT;
		DECLARE @new_WO_Reviewed AS BIT;
		DECLARE @new_WO_Review_Date AS DATETIME;
		DECLARE @new_Follow_Up_Date AS DATETIME;
		DECLARE @new_MSOIsDifferent AS BIT;
		DECLARE @new_MSOLocID AS INT;
		DECLARE @new_EstInvDateOverride AS BIT;
		DECLARE @new_Estimated_Invoice_Date AS DATETIME;
		DECLARE @new_AdditionalPricingInfo AS NVARCHAR(MAX);
		DECLARE @new_Slot_ AS INT;
		DECLARE @new_TempModel_ AS BIT;
		DECLARE @new_HighRiskUnit AS BIT;
		DECLARE @new_EngNotes_V2 AS NVARCHAR(MAX);
		DECLARE @new_CompanyID AS INT;
		DECLARE @new_Customer_WO_ AS INT;
		DECLARE @new_PriceSecured AS BIT;
		DECLARE @new_DateSecured AS DATETIME;
		DECLARE @new_SecuredBy AS NVARCHAR(MAX);
		DECLARE @new_InternalSalesComments AS NVARCHAR(MAX);
		DECLARE @new_InternalSalesCommentDate AS DATETIME;
		DECLARE @new_InternalSalesCommenter AS NVARCHAR(255);
		DECLARE @new_DiscountSetDate AS DATETIME;
		DECLARE @new_DiscountSetBy AS NVARCHAR(255);
		DECLARE @new_ProductID AS INT;
		DECLARE @new_DiscountID AS INT;
		DECLARE @new_DateLastQuoteReport AS DATETIME;
		DECLARE @new_JobAvailableLine AS NVARCHAR(MAX);
		DECLARE @new_JobAvailableScheduled AS DATETIME;
		DECLARE @new_JobAvailableScheduledBy AS NVARCHAR(MAX);
	    
	    -- Assignment Statements
	    		SELECT
			@old_OrderID = [OrderID],
			@old_SGQuote = [SGQuote],
			@old_Quote_Date = [Quote Date],
			@old_Order_Date = [Order Date],
			@old_WO_ = [WO#],
			@old_Sales_Order_ = [Sales Order#],
			@old_Model_No = [Model No],
			@old_Width = [Width],
			@old_Spread = [Spread],
			@old_DealerID = [DealerID],
			@old_Sale_PersonID = [Sale PersonID],
			@old_Price = [Price],
			@old_Prom_Drawing = [Prom Drawing],
			@old_Special_Instructions = [Special Instructions],
			@old_Date_Declined = [Date Declined],
			@old_Decline_Rejected = [Decline/Rejected],
			@old_Serial_Number = [Serial Number],
			@old_Available_Date = [Available Date],
			@old_Delivery_Date = [Delivery Date],
			@old_Requested_Delivery_Date = [Requested Delivery Date],
			@old_Finish_Date = [Finish Date],
			@old_Purchase_Order = [Purchase Order],
			@old_PO_Date = [PO Date],
			@old_PayID = [PayID],
			@old_Volume_Discount = [Volume Discount],
			@old_Program_Discount = [Program Discount],
			@old_Discount1_Name = [Discount1_Name],
			@old_Discount1_Type = [Discount1_Type],
			@old_Discount1 = [Discount1],
			@old_Discount2_Name = [Discount2_Name],
			@old_Discount2_Type = [Discount2_Type],
			@old_Discount2 = [Discount2],
			@old_Discount3_Name = [Discount3_Name],
			@old_Discount3_Type = [Discount3_Type],
			@old_Discount3 = [Discount3],
			@old_Est_Pro_Date = [Est Pro Date],
			@old_Notes = [Notes],
			@old_CarrierID = [CarrierID],
			@old_CustID = [CustID],
			@old_US_Sale = [US Sale],
			@old_Shipped_Date = [Shipped Date],
			@old_GL_Override_Date = [GL Override Date],
			@old_FE_Rate = [FE Rate],
			@old_PDD = [PDD],
			@old_Deck_Length = [Deck Length],
			@old_Invoice__ = [Invoice #],
			@old_Date_Registered = [Date Registered],
			@old_Date_In_Service = [Date In Service],
			@old_Invoice_Date = [Invoice Date],
			@old_Date_Requested = [Date Requested],
			@old_GVWR = [GVWR],
			@old_Tare = [Tare],
			@old_Selection = [Selection],
			@old_Warranty = [Warranty],
			@old_BWSPaid = [BWSPaid],
			@old_BWSPaidDate = [BWSPaidDate],
			@old_CommPaid = [CommPaid],
			@old_CommPaidDate = [CommPaidDate],
			@old_ModifiedBy = [ModifiedBy],
			@old_Lead_Date = [Lead Date],
			@old_Lead_Source = [Lead Source],
			@old_LeadID = [LeadID],
			@old_DealerBranchID = [DealerBranchID],
			@old_DealerSalesPersonID = [DealerSalesPersonID],
			@old_DataEntryCheck = [DataEntryCheck],
			@old_DataEntryUser = [DataEntryUser],
			@old_FinishedGoodsDealerLocID = [FinishedGoodsDealerLocID],
			@old_WO_Reviewed = [WO Reviewed],
			@old_WO_Review_Date = [WO Review Date],
			@old_Follow_Up_Date = [Follow Up Date],
			@old_MSOIsDifferent = [MSOIsDifferent],
			@old_MSOLocID = [MSOLocID],
			@old_EstInvDateOverride = [EstInvDateOverride],
			@old_Estimated_Invoice_Date = [Estimated Invoice Date],
			@old_AdditionalPricingInfo = [AdditionalPricingInfo],
			@old_Slot_ = [Slot#],
			@old_TempModel_ = [TempModel?],
			@old_HighRiskUnit = [HighRiskUnit],
			@old_EngNotes_V2 = [EngNotes V2],
			@old_CompanyID = [CompanyID],
			@old_Customer_WO_ = [Customer WO#],
			@old_PriceSecured = [PriceSecured],
			@old_DateSecured = [DateSecured],
			@old_SecuredBy = [SecuredBy],
			@old_InternalSalesComments = [InternalSalesComments],
			@old_InternalSalesCommentDate = [InternalSalesCommentDate],
			@old_InternalSalesCommenter = [InternalSalesCommenter],
			@old_DiscountSetDate = [DiscountSetDate],
			@old_DiscountSetBy = [DiscountSetBy],
			@old_ProductID = [ProductID],
			@old_DiscountID = [DiscountID],
			@old_DateLastQuoteReport = [DateLastQuoteReport],
			@old_JobAvailableLine = [JobAvailableLine],
			@old_JobAvailableScheduled = [JobAvailableScheduled],
			@old_JobAvailableScheduledBy = [JobAvailableScheduledBy]
		FROM
			DELETED [D]
		;
		SELECT
			@new_OrderID = [OrderID],
			@new_SGQuote = [SGQuote],
			@new_Quote_Date = [Quote Date],
			@new_Order_Date = [Order Date],
			@new_WO_ = [WO#],
			@new_Sales_Order_ = [Sales Order#],
			@new_Model_No = [Model No],
			@new_Width = [Width],
			@new_Spread = [Spread],
			@new_DealerID = [DealerID],
			@new_Sale_PersonID = [Sale PersonID],
			@new_Price = [Price],
			@new_Prom_Drawing = [Prom Drawing],
			@new_Special_Instructions = [Special Instructions],
			@new_Date_Declined = [Date Declined],
			@new_Decline_Rejected = [Decline/Rejected],
			@new_Serial_Number = [Serial Number],
			@new_Available_Date = [Available Date],
			@new_Delivery_Date = [Delivery Date],
			@new_Requested_Delivery_Date = [Requested Delivery Date],
			@new_Finish_Date = [Finish Date],
			@new_Purchase_Order = [Purchase Order],
			@new_PO_Date = [PO Date],
			@new_PayID = [PayID],
			@new_Volume_Discount = [Volume Discount],
			@new_Program_Discount = [Program Discount],
			@new_Discount1_Name = [Discount1_Name],
			@new_Discount1_Type = [Discount1_Type],
			@new_Discount1 = [Discount1],
			@new_Discount2_Name = [Discount2_Name],
			@new_Discount2_Type = [Discount2_Type],
			@new_Discount2 = [Discount2],
			@new_Discount3_Name = [Discount3_Name],
			@new_Discount3_Type = [Discount3_Type],
			@new_Discount3 = [Discount3],
			@new_Est_Pro_Date = [Est Pro Date],
			@new_Notes = [Notes],
			@new_CarrierID = [CarrierID],
			@new_CustID = [CustID],
			@new_US_Sale = [US Sale],
			@new_Shipped_Date = [Shipped Date],
			@new_GL_Override_Date = [GL Override Date],
			@new_FE_Rate = [FE Rate],
			@new_PDD = [PDD],
			@new_Deck_Length = [Deck Length],
			@new_Invoice__ = [Invoice #],
			@new_Date_Registered = [Date Registered],
			@new_Date_In_Service = [Date In Service],
			@new_Invoice_Date = [Invoice Date],
			@new_Date_Requested = [Date Requested],
			@new_GVWR = [GVWR],
			@new_Tare = [Tare],
			@new_Selection = [Selection],
			@new_Warranty = [Warranty],
			@new_BWSPaid = [BWSPaid],
			@new_BWSPaidDate = [BWSPaidDate],
			@new_CommPaid = [CommPaid],
			@new_CommPaidDate = [CommPaidDate],
			@new_ModifiedBy = [ModifiedBy],
			@new_Lead_Date = [Lead Date],
			@new_Lead_Source = [Lead Source],
			@new_LeadID = [LeadID],
			@new_DealerBranchID = [DealerBranchID],
			@new_DealerSalesPersonID = [DealerSalesPersonID],
			@new_DataEntryCheck = [DataEntryCheck],
			@new_DataEntryUser = [DataEntryUser],
			@new_FinishedGoodsDealerLocID = [FinishedGoodsDealerLocID],
			@new_WO_Reviewed = [WO Reviewed],
			@new_WO_Review_Date = [WO Review Date],
			@new_Follow_Up_Date = [Follow Up Date],
			@new_MSOIsDifferent = [MSOIsDifferent],
			@new_MSOLocID = [MSOLocID],
			@new_EstInvDateOverride = [EstInvDateOverride],
			@new_Estimated_Invoice_Date = [Estimated Invoice Date],
			@new_AdditionalPricingInfo = [AdditionalPricingInfo],
			@new_Slot_ = [Slot#],
			@new_TempModel_ = [TempModel?],
			@new_HighRiskUnit = [HighRiskUnit],
			@new_EngNotes_V2 = [EngNotes V2],
			@new_CompanyID = [CompanyID],
			@new_Customer_WO_ = [Customer WO#],
			@new_PriceSecured = [PriceSecured],
			@new_DateSecured = [DateSecured],
			@new_SecuredBy = [SecuredBy],
			@new_InternalSalesComments = [InternalSalesComments],
			@new_InternalSalesCommentDate = [InternalSalesCommentDate],
			@new_InternalSalesCommenter = [InternalSalesCommenter],
			@new_DiscountSetDate = [DiscountSetDate],
			@new_DiscountSetBy = [DiscountSetBy],
			@new_ProductID = [ProductID],
			@new_DiscountID = [DiscountID],
			@new_DateLastQuoteReport = [DateLastQuoteReport],
			@new_JobAvailableLine = [JobAvailableLine],
			@new_JobAvailableScheduled = [JobAvailableScheduled],
			@new_JobAvailableScheduledBy = [JobAvailableScheduledBy]
		FROM
			INSERTED [I]
		;
	
		DECLARE @user NVARCHAR(20);
		DECLARE @activity NVARCHAR(20);

		-- Insert statements for trigger here
		IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'UPDATE';
			SET @user = SYSTEM_USER;
			
		END
		IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted) BEGIN
			SET @activity = 'INSERT';
			SET @user = SYSTEM_USER;
			
		END
		IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted) BEGIN 
			SET @activity = 'DELETE';
			SET @user = SYSTEM_USER;
			
		END
		
		-- Check if new changes
				IF @old_OrderID <> @new_OrderID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'OrderID', CAST(@old_OrderID AS NVARCHAR(MAX)), CAST(@new_OrderID AS NVARCHAR(MAX));
		END
		IF @old_SGQuote <> @new_SGQuote BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'SGQuote', CAST(@old_SGQuote AS NVARCHAR(MAX)), CAST(@new_SGQuote AS NVARCHAR(MAX));
		END
		IF @old_Quote_Date <> @new_Quote_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Quote Date', CAST(@old_Quote_Date AS NVARCHAR(MAX)), CAST(@new_Quote_Date AS NVARCHAR(MAX));
		END
		IF @old_Order_Date <> @new_Order_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Order Date', CAST(@old_Order_Date AS NVARCHAR(MAX)), CAST(@new_Order_Date AS NVARCHAR(MAX));
		END
		IF @old_WO_ <> @new_WO_ BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'WO#', CAST(@old_WO_ AS NVARCHAR(MAX)), CAST(@new_WO_ AS NVARCHAR(MAX));
		END
		IF @old_Sales_Order_ <> @new_Sales_Order_ BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Sales Order#', CAST(@old_Sales_Order_ AS NVARCHAR(MAX)), CAST(@new_Sales_Order_ AS NVARCHAR(MAX));
		END
		IF @old_Model_No <> @new_Model_No BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Model No', CAST(@old_Model_No AS NVARCHAR(MAX)), CAST(@new_Model_No AS NVARCHAR(MAX));
		END
		IF @old_Width <> @new_Width BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Width', CAST(@old_Width AS NVARCHAR(MAX)), CAST(@new_Width AS NVARCHAR(MAX));
		END
		IF @old_Spread <> @new_Spread BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Spread', CAST(@old_Spread AS NVARCHAR(MAX)), CAST(@new_Spread AS NVARCHAR(MAX));
		END
		IF @old_DealerID <> @new_DealerID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DealerID', CAST(@old_DealerID AS NVARCHAR(MAX)), CAST(@new_DealerID AS NVARCHAR(MAX));
		END
		IF @old_Sale_PersonID <> @new_Sale_PersonID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Sale PersonID', CAST(@old_Sale_PersonID AS NVARCHAR(MAX)), CAST(@new_Sale_PersonID AS NVARCHAR(MAX));
		END
		IF @old_Price <> @new_Price BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Price', CAST(@old_Price AS NVARCHAR(MAX)), CAST(@new_Price AS NVARCHAR(MAX));
		END
		IF @old_Prom_Drawing <> @new_Prom_Drawing BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Prom Drawing', CAST(@old_Prom_Drawing AS NVARCHAR(MAX)), CAST(@new_Prom_Drawing AS NVARCHAR(MAX));
		END
		IF @old_Special_Instructions <> @new_Special_Instructions BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Special Instructions', CAST(@old_Special_Instructions AS NVARCHAR(MAX)), CAST(@new_Special_Instructions AS NVARCHAR(MAX));
		END
		IF @old_Date_Declined <> @new_Date_Declined BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Date Declined', CAST(@old_Date_Declined AS NVARCHAR(MAX)), CAST(@new_Date_Declined AS NVARCHAR(MAX));
		END
		IF @old_Decline_Rejected <> @new_Decline_Rejected BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Decline/Rejected', CAST(@old_Decline_Rejected AS NVARCHAR(MAX)), CAST(@new_Decline_Rejected AS NVARCHAR(MAX));
		END
		IF @old_Serial_Number <> @new_Serial_Number BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Serial Number', CAST(@old_Serial_Number AS NVARCHAR(MAX)), CAST(@new_Serial_Number AS NVARCHAR(MAX));
		END
		IF @old_Available_Date <> @new_Available_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Available Date', CAST(@old_Available_Date AS NVARCHAR(MAX)), CAST(@new_Available_Date AS NVARCHAR(MAX));
		END
		IF @old_Delivery_Date <> @new_Delivery_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Delivery Date', CAST(@old_Delivery_Date AS NVARCHAR(MAX)), CAST(@new_Delivery_Date AS NVARCHAR(MAX));
		END
		IF @old_Requested_Delivery_Date <> @new_Requested_Delivery_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Requested Delivery Date', CAST(@old_Requested_Delivery_Date AS NVARCHAR(MAX)), CAST(@new_Requested_Delivery_Date AS NVARCHAR(MAX));
		END
		IF @old_Finish_Date <> @new_Finish_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Finish Date', CAST(@old_Finish_Date AS NVARCHAR(MAX)), CAST(@new_Finish_Date AS NVARCHAR(MAX));
		END
		IF @old_Purchase_Order <> @new_Purchase_Order BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Purchase Order', CAST(@old_Purchase_Order AS NVARCHAR(MAX)), CAST(@new_Purchase_Order AS NVARCHAR(MAX));
		END
		IF @old_PO_Date <> @new_PO_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'PO Date', CAST(@old_PO_Date AS NVARCHAR(MAX)), CAST(@new_PO_Date AS NVARCHAR(MAX));
		END
		IF @old_PayID <> @new_PayID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'PayID', CAST(@old_PayID AS NVARCHAR(MAX)), CAST(@new_PayID AS NVARCHAR(MAX));
		END
		IF @old_Volume_Discount <> @new_Volume_Discount BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Volume Discount', CAST(@old_Volume_Discount AS NVARCHAR(MAX)), CAST(@new_Volume_Discount AS NVARCHAR(MAX));
		END
		IF @old_Program_Discount <> @new_Program_Discount BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Program Discount', CAST(@old_Program_Discount AS NVARCHAR(MAX)), CAST(@new_Program_Discount AS NVARCHAR(MAX));
		END
		IF @old_Discount1_Name <> @new_Discount1_Name BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount1_Name', CAST(@old_Discount1_Name AS NVARCHAR(MAX)), CAST(@new_Discount1_Name AS NVARCHAR(MAX));
		END
		IF @old_Discount1_Type <> @new_Discount1_Type BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount1_Type', CAST(@old_Discount1_Type AS NVARCHAR(MAX)), CAST(@new_Discount1_Type AS NVARCHAR(MAX));
		END
		IF @old_Discount1 <> @new_Discount1 BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount1', CAST(@old_Discount1 AS NVARCHAR(MAX)), CAST(@new_Discount1 AS NVARCHAR(MAX));
		END
		IF @old_Discount2_Name <> @new_Discount2_Name BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount2_Name', CAST(@old_Discount2_Name AS NVARCHAR(MAX)), CAST(@new_Discount2_Name AS NVARCHAR(MAX));
		END
		IF @old_Discount2_Type <> @new_Discount2_Type BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount2_Type', CAST(@old_Discount2_Type AS NVARCHAR(MAX)), CAST(@new_Discount2_Type AS NVARCHAR(MAX));
		END
		IF @old_Discount2 <> @new_Discount2 BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount2', CAST(@old_Discount2 AS NVARCHAR(MAX)), CAST(@new_Discount2 AS NVARCHAR(MAX));
		END
		IF @old_Discount3_Name <> @new_Discount3_Name BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount3_Name', CAST(@old_Discount3_Name AS NVARCHAR(MAX)), CAST(@new_Discount3_Name AS NVARCHAR(MAX));
		END
		IF @old_Discount3_Type <> @new_Discount3_Type BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount3_Type', CAST(@old_Discount3_Type AS NVARCHAR(MAX)), CAST(@new_Discount3_Type AS NVARCHAR(MAX));
		END
		IF @old_Discount3 <> @new_Discount3 BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Discount3', CAST(@old_Discount3 AS NVARCHAR(MAX)), CAST(@new_Discount3 AS NVARCHAR(MAX));
		END
		IF @old_Est_Pro_Date <> @new_Est_Pro_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Est Pro Date', CAST(@old_Est_Pro_Date AS NVARCHAR(MAX)), CAST(@new_Est_Pro_Date AS NVARCHAR(MAX));
		END
		IF @old_Notes <> @new_Notes BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Notes', CAST(@old_Notes AS NVARCHAR(MAX)), CAST(@new_Notes AS NVARCHAR(MAX));
		END
		IF @old_CarrierID <> @new_CarrierID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'CarrierID', CAST(@old_CarrierID AS NVARCHAR(MAX)), CAST(@new_CarrierID AS NVARCHAR(MAX));
		END
		IF @old_CustID <> @new_CustID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'CustID', CAST(@old_CustID AS NVARCHAR(MAX)), CAST(@new_CustID AS NVARCHAR(MAX));
		END
		IF @old_US_Sale <> @new_US_Sale BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'US Sale', CAST(@old_US_Sale AS NVARCHAR(MAX)), CAST(@new_US_Sale AS NVARCHAR(MAX));
		END
		IF @old_Shipped_Date <> @new_Shipped_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Shipped Date', CAST(@old_Shipped_Date AS NVARCHAR(MAX)), CAST(@new_Shipped_Date AS NVARCHAR(MAX));
		END
		IF @old_GL_Override_Date <> @new_GL_Override_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'GL Override Date', CAST(@old_GL_Override_Date AS NVARCHAR(MAX)), CAST(@new_GL_Override_Date AS NVARCHAR(MAX));
		END
		IF @old_FE_Rate <> @new_FE_Rate BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'FE Rate', CAST(@old_FE_Rate AS NVARCHAR(MAX)), CAST(@new_FE_Rate AS NVARCHAR(MAX));
		END
		IF @old_PDD <> @new_PDD BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'PDD', CAST(@old_PDD AS NVARCHAR(MAX)), CAST(@new_PDD AS NVARCHAR(MAX));
		END
		IF @old_Deck_Length <> @new_Deck_Length BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Deck Length', CAST(@old_Deck_Length AS NVARCHAR(MAX)), CAST(@new_Deck_Length AS NVARCHAR(MAX));
		END
		IF @old_Invoice__ <> @new_Invoice__ BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Invoice #', CAST(@old_Invoice__ AS NVARCHAR(MAX)), CAST(@new_Invoice__ AS NVARCHAR(MAX));
		END
		IF @old_Date_Registered <> @new_Date_Registered BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Date Registered', CAST(@old_Date_Registered AS NVARCHAR(MAX)), CAST(@new_Date_Registered AS NVARCHAR(MAX));
		END
		IF @old_Date_In_Service <> @new_Date_In_Service BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Date In Service', CAST(@old_Date_In_Service AS NVARCHAR(MAX)), CAST(@new_Date_In_Service AS NVARCHAR(MAX));
		END
		IF @old_Invoice_Date <> @new_Invoice_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Invoice Date', CAST(@old_Invoice_Date AS NVARCHAR(MAX)), CAST(@new_Invoice_Date AS NVARCHAR(MAX));
		END
		IF @old_Date_Requested <> @new_Date_Requested BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Date Requested', CAST(@old_Date_Requested AS NVARCHAR(MAX)), CAST(@new_Date_Requested AS NVARCHAR(MAX));
		END
		IF @old_GVWR <> @new_GVWR BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'GVWR', CAST(@old_GVWR AS NVARCHAR(MAX)), CAST(@new_GVWR AS NVARCHAR(MAX));
		END
		IF @old_Tare <> @new_Tare BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Tare', CAST(@old_Tare AS NVARCHAR(MAX)), CAST(@new_Tare AS NVARCHAR(MAX));
		END
		IF @old_Selection <> @new_Selection BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Selection', CAST(@old_Selection AS NVARCHAR(MAX)), CAST(@new_Selection AS NVARCHAR(MAX));
		END
		IF @old_Warranty <> @new_Warranty BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Warranty', CAST(@old_Warranty AS NVARCHAR(MAX)), CAST(@new_Warranty AS NVARCHAR(MAX));
		END
		IF @old_BWSPaid <> @new_BWSPaid BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'BWSPaid', CAST(@old_BWSPaid AS NVARCHAR(MAX)), CAST(@new_BWSPaid AS NVARCHAR(MAX));
		END
		IF @old_BWSPaidDate <> @new_BWSPaidDate BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'BWSPaidDate', CAST(@old_BWSPaidDate AS NVARCHAR(MAX)), CAST(@new_BWSPaidDate AS NVARCHAR(MAX));
		END
		IF @old_CommPaid <> @new_CommPaid BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'CommPaid', CAST(@old_CommPaid AS NVARCHAR(MAX)), CAST(@new_CommPaid AS NVARCHAR(MAX));
		END
		IF @old_CommPaidDate <> @new_CommPaidDate BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'CommPaidDate', CAST(@old_CommPaidDate AS NVARCHAR(MAX)), CAST(@new_CommPaidDate AS NVARCHAR(MAX));
		END
		IF @old_ModifiedBy <> @new_ModifiedBy BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'ModifiedBy', CAST(@old_ModifiedBy AS NVARCHAR(MAX)), CAST(@new_ModifiedBy AS NVARCHAR(MAX));
		END
		IF @old_Lead_Date <> @new_Lead_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Lead Date', CAST(@old_Lead_Date AS NVARCHAR(MAX)), CAST(@new_Lead_Date AS NVARCHAR(MAX));
		END
		IF @old_Lead_Source <> @new_Lead_Source BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Lead Source', CAST(@old_Lead_Source AS NVARCHAR(MAX)), CAST(@new_Lead_Source AS NVARCHAR(MAX));
		END
		IF @old_LeadID <> @new_LeadID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'LeadID', CAST(@old_LeadID AS NVARCHAR(MAX)), CAST(@new_LeadID AS NVARCHAR(MAX));
		END
		IF @old_DealerBranchID <> @new_DealerBranchID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DealerBranchID', CAST(@old_DealerBranchID AS NVARCHAR(MAX)), CAST(@new_DealerBranchID AS NVARCHAR(MAX));
		END
		IF @old_DealerSalesPersonID <> @new_DealerSalesPersonID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DealerSalesPersonID', CAST(@old_DealerSalesPersonID AS NVARCHAR(MAX)), CAST(@new_DealerSalesPersonID AS NVARCHAR(MAX));
		END
		IF @old_DataEntryCheck <> @new_DataEntryCheck BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DataEntryCheck', CAST(@old_DataEntryCheck AS NVARCHAR(MAX)), CAST(@new_DataEntryCheck AS NVARCHAR(MAX));
		END
		IF @old_DataEntryUser <> @new_DataEntryUser BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DataEntryUser', CAST(@old_DataEntryUser AS NVARCHAR(MAX)), CAST(@new_DataEntryUser AS NVARCHAR(MAX));
		END
		IF @old_FinishedGoodsDealerLocID <> @new_FinishedGoodsDealerLocID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'FinishedGoodsDealerLocID', CAST(@old_FinishedGoodsDealerLocID AS NVARCHAR(MAX)), CAST(@new_FinishedGoodsDealerLocID AS NVARCHAR(MAX));
		END
		IF @old_WO_Reviewed <> @new_WO_Reviewed BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'WO Reviewed', CAST(@old_WO_Reviewed AS NVARCHAR(MAX)), CAST(@new_WO_Reviewed AS NVARCHAR(MAX));
		END
		IF @old_WO_Review_Date <> @new_WO_Review_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'WO Review Date', CAST(@old_WO_Review_Date AS NVARCHAR(MAX)), CAST(@new_WO_Review_Date AS NVARCHAR(MAX));
		END
		IF @old_Follow_Up_Date <> @new_Follow_Up_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Follow Up Date', CAST(@old_Follow_Up_Date AS NVARCHAR(MAX)), CAST(@new_Follow_Up_Date AS NVARCHAR(MAX));
		END
		IF @old_MSOIsDifferent <> @new_MSOIsDifferent BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'MSOIsDifferent', CAST(@old_MSOIsDifferent AS NVARCHAR(MAX)), CAST(@new_MSOIsDifferent AS NVARCHAR(MAX));
		END
		IF @old_MSOLocID <> @new_MSOLocID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'MSOLocID', CAST(@old_MSOLocID AS NVARCHAR(MAX)), CAST(@new_MSOLocID AS NVARCHAR(MAX));
		END
		IF @old_EstInvDateOverride <> @new_EstInvDateOverride BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'EstInvDateOverride', CAST(@old_EstInvDateOverride AS NVARCHAR(MAX)), CAST(@new_EstInvDateOverride AS NVARCHAR(MAX));
		END
		IF @old_Estimated_Invoice_Date <> @new_Estimated_Invoice_Date BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Estimated Invoice Date', CAST(@old_Estimated_Invoice_Date AS NVARCHAR(MAX)), CAST(@new_Estimated_Invoice_Date AS NVARCHAR(MAX));
		END
		IF @old_AdditionalPricingInfo <> @new_AdditionalPricingInfo BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'AdditionalPricingInfo', CAST(@old_AdditionalPricingInfo AS NVARCHAR(MAX)), CAST(@new_AdditionalPricingInfo AS NVARCHAR(MAX));
		END
		IF @old_Slot_ <> @new_Slot_ BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Slot#', CAST(@old_Slot_ AS NVARCHAR(MAX)), CAST(@new_Slot_ AS NVARCHAR(MAX));
		END
		IF @old_TempModel_ <> @new_TempModel_ BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'TempModel?', CAST(@old_TempModel_ AS NVARCHAR(MAX)), CAST(@new_TempModel_ AS NVARCHAR(MAX));
		END
		IF @old_HighRiskUnit <> @new_HighRiskUnit BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'HighRiskUnit', CAST(@old_HighRiskUnit AS NVARCHAR(MAX)), CAST(@new_HighRiskUnit AS NVARCHAR(MAX));
		END
		IF @old_EngNotes_V2 <> @new_EngNotes_V2 BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'EngNotes V2', CAST(@old_EngNotes_V2 AS NVARCHAR(MAX)), CAST(@new_EngNotes_V2 AS NVARCHAR(MAX));
		END
		IF @old_CompanyID <> @new_CompanyID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'CompanyID', CAST(@old_CompanyID AS NVARCHAR(MAX)), CAST(@new_CompanyID AS NVARCHAR(MAX));
		END
		IF @old_Customer_WO_ <> @new_Customer_WO_ BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'Customer WO#', CAST(@old_Customer_WO_ AS NVARCHAR(MAX)), CAST(@new_Customer_WO_ AS NVARCHAR(MAX));
		END
		IF @old_PriceSecured <> @new_PriceSecured BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'PriceSecured', CAST(@old_PriceSecured AS NVARCHAR(MAX)), CAST(@new_PriceSecured AS NVARCHAR(MAX));
		END
		IF @old_DateSecured <> @new_DateSecured BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DateSecured', CAST(@old_DateSecured AS NVARCHAR(MAX)), CAST(@new_DateSecured AS NVARCHAR(MAX));
		END
		IF @old_SecuredBy <> @new_SecuredBy BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'SecuredBy', CAST(@old_SecuredBy AS NVARCHAR(MAX)), CAST(@new_SecuredBy AS NVARCHAR(MAX));
		END
		IF @old_InternalSalesComments <> @new_InternalSalesComments BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'InternalSalesComments', CAST(@old_InternalSalesComments AS NVARCHAR(MAX)), CAST(@new_InternalSalesComments AS NVARCHAR(MAX));
		END
		IF @old_InternalSalesCommentDate <> @new_InternalSalesCommentDate BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'InternalSalesCommentDate', CAST(@old_InternalSalesCommentDate AS NVARCHAR(MAX)), CAST(@new_InternalSalesCommentDate AS NVARCHAR(MAX));
		END
		IF @old_InternalSalesCommenter <> @new_InternalSalesCommenter BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'InternalSalesCommenter', CAST(@old_InternalSalesCommenter AS NVARCHAR(MAX)), CAST(@new_InternalSalesCommenter AS NVARCHAR(MAX));
		END
		IF @old_DiscountSetDate <> @new_DiscountSetDate BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DiscountSetDate', CAST(@old_DiscountSetDate AS NVARCHAR(MAX)), CAST(@new_DiscountSetDate AS NVARCHAR(MAX));
		END
		IF @old_DiscountSetBy <> @new_DiscountSetBy BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DiscountSetBy', CAST(@old_DiscountSetBy AS NVARCHAR(MAX)), CAST(@new_DiscountSetBy AS NVARCHAR(MAX));
		END
		IF @old_ProductID <> @new_ProductID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'ProductID', CAST(@old_ProductID AS NVARCHAR(MAX)), CAST(@new_ProductID AS NVARCHAR(MAX));
		END
		IF @old_DiscountID <> @new_DiscountID BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DiscountID', CAST(@old_DiscountID AS NVARCHAR(MAX)), CAST(@new_DiscountID AS NVARCHAR(MAX));
		END
		IF @old_DateLastQuoteReport <> @new_DateLastQuoteReport BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'DateLastQuoteReport', CAST(@old_DateLastQuoteReport AS NVARCHAR(MAX)), CAST(@new_DateLastQuoteReport AS NVARCHAR(MAX));
		END
		IF @old_JobAvailableLine <> @new_JobAvailableLine BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'JobAvailableLine', CAST(@old_JobAvailableLine AS NVARCHAR(MAX)), CAST(@new_JobAvailableLine AS NVARCHAR(MAX));
		END
		IF @old_JobAvailableScheduled <> @new_JobAvailableScheduled BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'JobAvailableScheduled', CAST(@old_JobAvailableScheduled AS NVARCHAR(MAX)), CAST(@new_JobAvailableScheduled AS NVARCHAR(MAX));
		END
		IF @old_JobAvailableScheduledBy <> @new_JobAvailableScheduledBy BEGIN
			INSERT INTO @t_to_update ([Column], [ValueBefore], [ValueAfter])
			SELECT 'JobAvailableScheduledBy', CAST(@old_JobAvailableScheduledBy AS NVARCHAR(MAX)), CAST(@new_JobAvailableScheduledBy AS NVARCHAR(MAX));
		END

		
		-- Update the History table for as many changes as were identified
		
    -- Finally iteratively update [dbo].[IT Request History] for each changed value
		
		DECLARE @c AS INT;
		SELECT @c = COUNT(*) FROM @t_to_update;
		
		IF @c > 0 BEGIN

			IF @user IS NULL BEGIN
				SELECT @user = SYSTEM_USER;
			END
		
			DECLARE @i AS INT;
			DECLARE @column AS NVARCHAR(MAX);
			DECLARE @value_before AS NVARCHAR(MAX);
			DECLARE @value_after AS NVARCHAR(MAX);

			SELECT @i = 0;

			WHILE @i < @c BEGIN

				SELECT @i = @i + 1;
				
				SELECT 
					@column = [Column]
					,@value_before = [ValueBefore]
					,@value_after = [ValueAfter]
				FROM
					@t_to_update
				WHERE
					[ID] = @i

				INSERT INTO 
					[dbo].[OrdersV2 History]

				   ([OrderID]
           ,[Action]
           ,[When]
           ,[User]
           ,[Column]
           ,[OldValue]
           ,[NewValue]
           ,[SGQuote]
           ,[Quote Date]
           ,[Order Date]
           ,[WO#]
           ,[Sales Order#]
           ,[Model No]
           ,[Width]
           ,[Spread]
           ,[DealerID]
           ,[Sale PersonID]
           ,[Price]
           ,[Prom Drawing]
           ,[Special Instructions]
           ,[Date Declined]
           ,[Decline/Rejected]
           ,[Serial Number]
           ,[Available Date]
           ,[Delivery Date]
           ,[Requested Delivery Date]
           ,[Finish Date]
           ,[Purchase Order]
           ,[PO Date]
           ,[PayID]
           ,[Volume Discount]
           ,[Program Discount]
           ,[Discount1_Name]
           ,[Discount1_Type]
           ,[Discount1]
           ,[Discount2_Name]
           ,[Discount2_Type]
           ,[Discount2]
           ,[Discount3_Name]
           ,[Discount3_Type]
           ,[Discount3]
           ,[Est Pro Date]
           ,[Notes]
           ,[EngNotes]
           ,[CarrierID]
           ,[CustID]
           ,[US Sale]
           ,[Shipped Date]
           ,[GL Override Date]
           ,[FE Rate]
           ,[PDD]
           ,[Deck Length]
           ,[Invoice #]
           ,[Date Registered]
           ,[Date In Service]
           ,[Invoice Date]
           ,[Date Requested]
           ,[GVWR]
           ,[Tare]
           ,[Selection]
           ,[Warranty]
           ,[BWSPaid]
           ,[BWSPaidDate]
           ,[CommPaid]
           ,[CommPaidDate]
           ,[ModifiedBy]
           ,[Lead Date]
           ,[Lead Source]
           ,[LeadID]
           ,[DealerBranchID]
           ,[DealerSalesPersonID]
           ,[DataEntryCheck]
           ,[DataEntryUser]
           ,[FinishedGoodsDealerLocID]
           ,[WO Reviewed]
           ,[WO Review Date]
           ,[Follow Up Date]
           ,[MSOIsDifferent]
           ,[MSOLocID]
           ,[EstInvDateOverride]
           ,[Estimated Invoice Date]
           ,[AdditionalPricingInfo]
           ,[Slot#]
           ,[TempModel?]
           ,[HighRiskUnit]
           ,[EngNotes V2]
           ,[CompanyID]
           ,[Customer WO#]
           ,[PriceSecured]
           ,[DateSecured]
           ,[SecuredBy]
           ,[InternalSalesComments]
           ,[InternalSalesCommentDate]
           ,[InternalSalesCommenter]
           ,[DiscountSetDate]
           ,[DiscountSetBy]
           ,[ProductID]
           ,[DiscountID]
           ,[DateLastQuoteReport]
           ,[JobAvailableLine]
           ,[JobAvailableScheduled]
           ,[JobAvailableScheduledBy])
        SELECT
			[OrderID]
			,@activity
           ,GETDATE()
           ,@user
			,@column
			,@value_before
			,@value_after
           ,[SGQuote]
           ,[Quote Date]
           ,[Order Date]
           ,[WO#]
           ,[Sales Order#]
           ,[Model No]
           ,[Width]
           ,[Spread]
           ,[DealerID]
           ,[Sale PersonID]
           ,[Price]
           ,[Prom Drawing]
           ,[Special Instructions]
           ,[Date Declined]
           ,[Decline/Rejected]
           ,[Serial Number]
           ,[Available Date]
           ,[Delivery Date]
           ,[Requested Delivery Date]
           ,[Finish Date]
           ,[Purchase Order]
           ,[PO Date]
           ,[PayID]
           ,[Volume Discount]
           ,[Program Discount]
           ,[Discount1_Name]
           ,[Discount1_Type]
           ,[Discount1]
           ,[Discount2_Name]
           ,[Discount2_Type]
           ,[Discount2]
           ,[Discount3_Name]
           ,[Discount3_Type]
           ,[Discount3]
           ,[Est Pro Date]
           ,[Notes]
           ,[EngNotes]
           ,[CarrierID]
           ,[CustID]
           ,[US Sale]
           ,[Shipped Date]
           ,[GL Override Date]
           ,[FE Rate]
           ,[PDD]
           ,[Deck Length]
           ,[Invoice #]
           ,[Date Registered]
           ,[Date In Service]
           ,[Invoice Date]
           ,[Date Requested]
           ,[GVWR]
           ,[Tare]
           ,[Selection]
           ,[Warranty]
           ,[BWSPaid]
           ,[BWSPaidDate]
           ,[CommPaid]
           ,[CommPaidDate]
           ,[ModifiedBy]
           ,[Lead Date]
           ,[Lead Source]
           ,[LeadID]
           ,[DealerBranchID]
           ,[DealerSalesPersonID]
           ,[DataEntryCheck]
           ,[DataEntryUser]
           ,[FinishedGoodsDealerLocID]
           ,[WO Reviewed]
           ,[WO Review Date]
           ,[Follow Up Date]
           ,[MSOIsDifferent]
           ,[MSOLocID]
           ,[EstInvDateOverride]
           ,[Estimated Invoice Date]
           ,[AdditionalPricingInfo]
           ,[Slot#]
           ,[TempModel?]
           ,[HighRiskUnit]
           ,[EngNotes V2]
           ,[CompanyID]
           ,[Customer WO#]
           ,[PriceSecured]
           ,[DateSecured]
           ,[SecuredBy]
           ,[InternalSalesComments]
           ,[InternalSalesCommentDate]
           ,[InternalSalesCommenter]
           ,[DiscountSetDate]
           ,[DiscountSetBy]
           ,[ProductID]
           ,[DiscountID]
           ,[DateLastQuoteReport]
           ,[JobAvailableLine]
           ,[JobAvailableScheduled]
           ,[JobAvailableScheduledBy]
				FROM
					[OrdersV2]
				WHERE 
					[OrderID] = ISNULL(@new_OrderID, @old_OrderID)

			END
		END
    

	END
END
GO
    