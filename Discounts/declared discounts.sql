USE BWSdb
GO

--ALTER VIEW [dbo].[v_DiscountDataProductsDealers]
--AS

SELECT
	[Discounts].[ID] AS [Discounts_ID],
	[Discounts].[DateCreated],
	[Discounts].[Active],
	[Discounts].[DateActive],
	[Discounts].[DateInactive],
	[Discounts].[ProductID],
	[Discounts].[DealerID],
	[Discounts].[Slot],
	[Discounts].[Market],
	[Discounts].[LastUpdated],
	[Discounts].[LastUpdatedBy],

	[Dealers].[ID] AS [Dealers_ID],
	[Dealers].[COMPANY NAME],
	[Dealers].[ADDRESS],
	[Dealers].[CITY],
	[Dealers].[PROVINCE],
	[Dealers].[POSTAL CODE],
	[Dealers].[PHONE],
	[Dealers].[TOLL FREE],
	[Dealers].[FAX],
	[Dealers].[CONTACT],
	[Dealers].[CELL],
	[Dealers].[EMAIL],
	[Dealers].[DEALER NUMBER],
	[Dealers].[CURRENT DEALER],
	[Dealers].[CURRENT DEALER CDN],
	[Dealers].[CURRENT DEALER US],
	[Dealers].[Invoice],
	[Dealers].[Eastern Canada],
	[Dealers].[Eastern US],
	[Dealers].[Central Canada],
	[Dealers].[Central US],
	[Dealers].[Western Canada],
	[Dealers].[Western US],
	[Dealers].[American],
	[Dealers].[Proprietary/Direct/Other],
	[Dealers].[Initials],
	[Dealers].[dealers_timestamp],
	[Dealers].[DataEntryCheck],
	[Dealers].[DataEntryUser],
	[Dealers].[DefaultPayID],
	[Dealers].[SendDealerStatusEmail?],
	[Dealers].[SlotsRequestedPerMonth],
	
	[Products].[IDTrailer],
	[Products].[Class],
	[Products].[Proposed],
	[Products].[Non-Current],
	[Products].[Model],
	[Products].[Model No],
	[Products].[Top Level Part# (SYSPRO)],
	[Products].[Grouping],
	[Products].[Start Date],
	[Products].[End Date],
	[Products].[Price],
	[Products].[Weight],
	[Products].[Make],
	[Products].[NVIS],
	[Products].[Promo Drawing],
	[Products].[Width],
	[Products].[Spread],
	[Products].[Deck Length],
	[Products].[Days],
	[Products].[GN],
	[Products].[Paint],
	[Products].[Finish],
	[Products].[S/NL1],
	[Products].[S/NL2],
	[Products].[S/NT1],
	[Products].[S/NT2],
	[Products].[S/NAxles],
	[Products].[Selection],
	[Products].[EffComDate],
	[Products].[ComRate],
	[Products].[LastCostUpdate],
	[Products].[LCUInitials],
	[Products].[QR_Discount1],
	[Products].[QR_Discount2],
	[Products].[QR_Discount3],
	[Products].[product_timestamp],
	[Products].[QR_ExpectedMargin],
	[Products].[tmpProductsClassesID],
	[Products].[QRUS_Discount1],
	[Products].[QRUS_Discount2],
	[Products].[QRUS_Discount3],
	[Products].[QRUS_ExpectedMargin],
	[Products].[US Price],
	[Products].[Customer],
	[Products].[Top Level Part# (SYSPRO 8)],
	[Products].[Promo Drawing V2]
FROM
	[Discounts]
LEFT JOIN
	[Dealers]
ON
	[DealerID] = [Dealers].[ID]
LEFT JOIN
	[Products]
ON
	[ProductID] = [Products].[IDTrailer]



WHERE [Slot] IS NOT NULL OR [Market] IS NOT NULL
--GO