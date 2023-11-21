
-- Master Procedure

USE BWSdb
GO

CREATE PROCEDURE [sp_SFC_IndividualSalesData]
	@companyID INTEGER = NULL,
	@dealerID INTEGER = NULL,
	@productID INTEGER = NULL,
	@salesPersonID INTEGER = NULL,
	@allCompanies BIT = NULL
AS BEGIN

	--DECLARE @companyID INTEGER = NULL
	--DECLARE @dealerID INTEGER = NULL
	--DECLARE @productID INTEGER = NULL
	--DECLARE @salesPersonID INTEGER = NULL
	--DECLARE @allCompanies BIT = NULL

	----------------------------------------------------------------------------------------------------------------------
	--										Instructions
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	-- CompanyID FILTERING Values:
	--	NULL		-	Both BWS and STG Data combined DEFAULT
	--	 0			-	BWS
	--	 1			-	STG
	-- dealerID GROUPING & FILTERING Values:
	--	NULL		-	All dealers DEFAULT
	--	-1 - -END	-	Filter for this Dealer ID
	--	 0 - END	-	By Dealer
	-- productID GROUPING & FILTERING Values:
	--	NULL		-	All products DEFAULT
	--	-1 - -END	-	Filter for this product ID
	--	 0 - END	-	By Product
	-- salesPersonID GROUPING & FILTERING Values:
	--	NULL		-	All sales people DEFAULT
	--	-1 - -END	-	Filter for this Sales Person ID
	--	 0 - END	-	By Sales People
	-- Use @allCompanies = 1 in order to bypass company grouping

	-- TLDR:
	-- For Company, IDs filter, use NULL for company grouping. Use @allCompanies to bypass grouping.
	-- For the rest, negative IDs FILTER, any positive IDs GROUP, use NULL to omit from grouping.

	----------------------------------------------------------------------------------------------------------------------
	--										Begin Testing
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	--DECLARE 
	--	@test_S INT
	--	,@test_A BIT
	--	,@test_C INT
	--	,@test_P INT
	--	,@test_D INT
	--;

	--SELECT 
	--	@test_C = NULL
	--	,@test_A = NULL
	----	,@test_S = 3
	----	,@test_P = 1535
	----	,@test_D = NULL
	--;

	---- Test data
	--SELECT 
	--	@companyID = @test_C,
	--	@allCompanies = @test_A,
	--	@salesPersonID = @test_S,
	--	@productID = @test_P,
	--	@dealerID = @test_D
	--;

	----------------------------------------------------------------------------------------------------------------------

									-- Testing

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	---- All data no groupings -- 0
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = NULL,	@dealerID = NULL;  -- 27
	---- All data grouped by dealer -- 1
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = NULL,	@dealerID = 291;  -- 33
	---- All data filtered by dealer -- 2
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = NULL,	@dealerID = -291;  -- 30
	---- All data grouped by product -- 3
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = 1535,	@dealerID = NULL;  -- 29
	---- All data grouped by product and dealer -- 4
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = 1535,	@dealerID = 291;  -- 35
	---- All data grouped by product, filtered by dealer -- 5
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = 1535,	@dealerID = -291;  -- 32
	---- All data filtered by product -- 6
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = -1535,	@dealerID = NULL;  -- 28
	---- All data grouped by dealer filtered by product -- 7
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = -1535,	@dealerID = 291;  -- 34
	---- All data filtered by product and dealer -- 8
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = NULL,	@productID = -1535,	@dealerID = -291;  -- 31
	---- All data grouped by sales person -- 9
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = NULL,	@dealerID = NULL;  -- 45
	---- All data grouped by sales person and dealer -- 10
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = NULL,	@dealerID = 291;  -- 51
	---- All data grouped by sales person, filtered by dealer -- 11
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = NULL,	@dealerID = -291;  -- 48
	---- All data grouped by sales person and product -- 12
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = 1535,	@dealerID = NULL;  -- 47
	---- All data grouped by sales person, product, and dealer -- 13
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = 1535,	@dealerID = 291;  -- 53
	---- All data grouped by sales person and product filtered by dealer -- 14
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = 1535,	@dealerID = -291;  -- 50
	---- All data grouped by sales person, filtered by product -- 15
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = -1535,	@dealerID = NULL;  -- 46
	---- All data grouped by sales person and dealer, filtered by product -- 16
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = -1535,	@dealerID = 291;  -- 52
	---- All data grouped by sales person, filtered by dealer and product -- 17
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = 3,		@productID = -1535,	@dealerID = -291;  -- 49
	---- All data filtered by sales person -- 18
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = NULL,	@dealerID = NULL;  -- 36
	---- All data grouped by dealer, filtered by sales person -- 19
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = NULL,	@dealerID = 291;  -- 42
	---- All data filtered by sales person and dealer -- 20
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = NULL,	@dealerID = -291;  -- 39
	---- All data grouped by product, filtered by sales person -- 21
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = 1535,	@dealerID = NULL;  -- 38
	---- All data grouped by dealer and product, filtered by sales person -- 22
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = 1535,	@dealerID = 291;  -- 44
	---- All data grouped by product, filtered by sales person and dealer -- 23
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = 1535,	@dealerID = -291;  -- 41
	---- All data filtered by sales person and product -- 24
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = -1535,	@dealerID = NULL;  -- 37
	---- All data grouped by dealer, filtered by sales person and product -- 25
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = -1535,	@dealerID = 291;  -- 43
	---- All data filtered by sales person, dealer, and product -- 26
	--SELECT @allCompanies = 0, @companyID = NULL,	@salesPersonID = -3,	@productID = -1535,	@dealerID = -291;  -- 40

	--SELECT 
	--	'Start' AS [T],
	--	@allCompanies AS [A],
	--	@companyID AS [C],
	--	@dealerID AS [D],
	--	@productID AS [P],
	--	@salesPersonID AS [SP]

	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------

	IF ISNULL(@allCompanies, 0) = 1 BEGIN
		-- All data without company grouping
		IF @salesPersonID IS NULL BEGIN
				-- Dealer 
				IF @dealerID IS NULL BEGIN
					-- Product
					IF @productID IS NULL BEGIN
						-- All Data no groupings
						SELECT
							0 AS [Qid],
							NumQuotesPrepared,
							NumInvalidQuotes,
							NumSoldDeliveredUnits,
							NumUnitsOnOrder,
							NumQuotesOutToDealer,
							NumCancelledQuotes,
							NumCancelledOrders,
							100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
							100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
							100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
							100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
							100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
							100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
						FROM (
							SELECT
								SUM([NumQuotesPrepared]) AS NumQuotesPrepared
								,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
								,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
								,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
								,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
								,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
								,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
							FROM (
								SELECT
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.Orders AS O

								UNION

								SELECT
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.OrdersV2 AS O2
							) AS [SrcA]
						) AS SrcB
						--WHERE
						--	(CASE
						--		WHEN ISNULL(@companyID, -1) = -1 THEN 1
						--		WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
						--		ELSE (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
						--	END) = 1
					END
					ELSE BEGIN
						IF @productID < 0 BEGIN
							-- Filter for this product
							SELECT
								1 AS [Qid],
								[ProductID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[ProductID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[ProductID] = ABS(@productID)
									GROUP BY
										[ProductID]

									UNION

									SELECT
										[ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[ProductID] = ABS(@productID)
									GROUP BY
										[ProductID]
								) AS [SrcA]
								GROUP BY
									[ProductID]
							) AS SrcB
						END
						ELSE BEGIN
							-- Group By ProductID
							SELECT
								2 AS [Qid],
								[ProductID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[ProductID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[ProductID] AS [ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[O].[ProductID]

									UNION

									SELECT
										[ProductID] AS [ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[O2].[ProductID]
								) AS [SrcA]
							GROUP BY
								[ProductID]
							) AS SrcB
						END
					END
				END
				ELSE BEGIN
					-- dealerID not NULL
					IF @dealerID < 0 BEGIN
						-- Filter for this dealer
						IF @productID IS NULL BEGIN
						-- All product data for this dealer
							SELECT
								3 AS [Qid],
								[DealerID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[DealerID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[O].[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[DealerID] = ABS(@dealerID)
									GROUP BY
										[O].[DealerID]

									UNION

									SELECT
										[O2].[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[DealerID] = ABS(@dealerID)
									GROUP BY
										[O2].[DealerID]
								) AS [SrcA]
								GROUP BY
									[DealerID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product and this dealer
								SELECT
									4 AS [Qid],
									[ProductID],
									[DealerID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[ProductID],
											[DealerID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[ProductID],
											[DealerID]
									) AS [SrcA]
								GROUP BY
									[DealerID]
									,[ProductID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID, filter by dealer
								SELECT
									5 AS [Qid],
									[ProductID],
									[DealerID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[ProductID]
											,[O].[DealerID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[ProductID]
											,[O2].[DealerID]
									) AS [SrcA]
								GROUP BY
									[ProductID]
									,[DealerID]
								) AS SrcB
							END
						END
					END
					ELSE BEGIN
						-- Group by Dealer
						IF @productID IS NULL BEGIN
							-- Filter by dealer
							SELECT
								6 AS [Qid],
								[DealerID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[DealerID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[DealerID]

									UNION

									SELECT
										[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[DealerID]
								) AS [SrcA]
								GROUP BY
									[DealerID]
							) AS SrcB
						END
						ELSE BEGIN
							-- productID is not NULL
							IF @productID < 0 BEGIN
								-- Filter by dealer, product, group by sales person
								SELECT
									7 AS [Qid],
									[DealerID],
									[ProductID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[DealerID]
										,[ProductID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
											AND [O].[ProductID] = ABS(@productID)
										GROUP BY
											[DealerID]
											,[ProductID]

										UNION

										SELECT
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
											AND [O2].[ProductID] = ABS(@productID)
										GROUP BY
											[DealerID]
											,[ProductID]
									) AS [SrcA]
									GROUP BY
										[DealerID]
										,[ProductID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group by dealer and product
								SELECT
									8 AS [Qid],
									[DealerID],
									[ProductID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[DealerID]
										,[ProductID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										--WHERE
										--	[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[DealerID]
											,[ProductID]

										UNION

										SELECT
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										--WHERE
										--	[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[DealerID]
											,[ProductID]
									) AS [SrcA]
									GROUP BY
										[DealerID]
										,[ProductID]
								) AS SrcB
							END
						END
					END
				END
			END
		ELSE BEGIN
			-- @salesPersonID is not NULL
			IF @salesPersonID < 0 BEGIN
				-- Filter by @salesPersonID
				IF @dealerID IS NULL BEGIN
					-- Product
					IF @productID IS NULL BEGIN
						-- All Data no groupings filter by sales person
						SELECT
							9 AS [Qid],
							[Sale PersonID],
							NumQuotesPrepared,
							NumInvalidQuotes,
							NumSoldDeliveredUnits,
							NumUnitsOnOrder,
							NumQuotesOutToDealer,
							NumCancelledQuotes,
							NumCancelledOrders,
							100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
							100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
							100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
							100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
							100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
							100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
						FROM (
							SELECT
								[Sale PersonID]
								,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
								,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
								,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
								,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
								,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
								,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
								,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
							FROM (
								SELECT
									[Sale PersonID],
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.Orders AS O
								WHERE
									[O].[Sale PersonID] = ABS(@salesPersonID)
								GROUP BY
									[Sale PersonID]

								UNION

								SELECT
									[Sale PersonID],
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.OrdersV2 AS O2
								WHERE
									[O2].[Sale PersonID] = ABS(@salesPersonID)
								GROUP BY
									[Sale PersonID]
							) AS [SrcA]
							GROUP BY
								[Sale PersonID]
						) AS SrcB
					END
					ELSE BEGIN
						IF @productID < 0 BEGIN
							-- Filter for this product filter by sales person
							SELECT
								10 AS [Qid],
								[ProductID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[ProductID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[ProductID] = ABS(@productID)
										AND [O].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[ProductID]
										,[Sale PersonID]

									UNION

									SELECT
										[ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[ProductID] = ABS(@productID)
										AND [O2].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[ProductID]
										,[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[ProductID]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							-- Group By ProductID filter by sales person
							SELECT
								11 AS [Qid],
								[ProductID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[ProductID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[ProductID] AS [ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[O].[ProductID]
										,[Sale PersonID]

									UNION

									SELECT
										[ProductID] AS [ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[O2].[ProductID]
										,[Sale PersonID]
								) AS [SrcA]
							GROUP BY
								[ProductID]
								,[Sale PersonID]
							) AS SrcB
						END
					END
				END
				ELSE BEGIN
					-- dealerID not NULL
					IF @dealerID < 0 BEGIN
						-- Filter for this dealer
						IF @productID IS NULL BEGIN
						-- All product data for this dealer and sales person
							SELECT
								12 AS [Qid],
								[DealerID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[DealerID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[O].[DealerID],
										[O].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[DealerID] = ABS(@dealerID)
										AND [O].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[O].[DealerID]
										,[O].[Sale PersonID]

									UNION

									SELECT
										[O2].[DealerID],
										[O2].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[DealerID] = ABS(@dealerID)
										AND [O2].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[O2].[DealerID]
										,[O2].[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[DealerID]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product and this dealer and this sales person
								SELECT
									13 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[DealerID] = ABS(@dealerID)
											AND [O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[DealerID] = ABS(@dealerID)
											AND [O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID filter by DealerID and sales person
								SELECT
									14 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[Sale PersonID] = ABS(@salesPersonID)
											AND [O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[ProductID]
											,[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[Sale PersonID] = ABS(@salesPersonID)
											AND [O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[ProductID]
											,[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[ProductID]
									,[DealerID]
									,[Sale PersonID]
								) AS SrcB
							END
						END
					END
					ELSE BEGIN
						-- group by dealer
						IF @productID IS NULL BEGIN
						-- All product data for this dealer and sales person
							SELECT
								15 AS [Qid],
								[DealerID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[DealerID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[O].[DealerID],
										[O].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										--[O].[DealerID] = ABS(@dealerID)
										--AND 
										[O].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[O].[DealerID]
										,[O].[Sale PersonID]

									UNION

									SELECT
										[O2].[DealerID],
										[O2].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										--[O2].[DealerID] = ABS(@dealerID)
										--AND 
										[O2].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[O2].[DealerID]
										,[O2].[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[DealerID]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- filter for this product and this sales person, group by dealer
								SELECT
									16 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID, DealerID filter by sales person
								SELECT
									17 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[ProductID]
											,[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[ProductID]
											,[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[ProductID]
									,[DealerID]
									,[Sale PersonID]
								) AS SrcB
							END
						END
					END
				END
			END
			ELSE BEGIN
				-- Group by SalesPersonID 
				IF @dealerID IS NULL BEGIN
					-- Product
					IF @productID IS NULL BEGIN
						-- All Data no group by sales person
						SELECT
							18 AS [Qid],
							[Sale PersonID],
							NumQuotesPrepared,
							NumInvalidQuotes,
							NumSoldDeliveredUnits,
							NumUnitsOnOrder,
							NumQuotesOutToDealer,
							NumCancelledQuotes,
							NumCancelledOrders,
							100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
							100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
							100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
							100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
							100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
							100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
						FROM (
							SELECT
								[Sale PersonID]
								,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
								,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
								,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
								,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
								,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
								,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
								,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
							FROM (
								SELECT
									[Sale PersonID],
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.Orders AS O
								GROUP BY
									[Sale PersonID]

								UNION

								SELECT
									[Sale PersonID],
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.OrdersV2 AS O2
								GROUP BY
									[Sale PersonID]
							) AS [SrcA]
							GROUP BY
								[Sale PersonID]
						) AS SrcB
					END
					ELSE BEGIN
						IF @productID < 0 BEGIN
							-- Filter for this product filter by sales person
							SELECT
								19 AS [Qid],
								[ProductID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[ProductID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[ProductID] = ABS(@productID)
									GROUP BY
										[ProductID]
										,[Sale PersonID]

									UNION

									SELECT
										[ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[ProductID] = ABS(@productID)
									GROUP BY
										[ProductID]
										,[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[ProductID]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							-- Group By ProductID filter by sales person
							SELECT
								20 AS [Qid],
								[ProductID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[ProductID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[ProductID] AS [ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[O].[ProductID]
										,[Sale PersonID]

									UNION

									SELECT
										[ProductID] AS [ProductID],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[O2].[ProductID]
										,[Sale PersonID]
								) AS [SrcA]
							GROUP BY
								[ProductID]
								,[Sale PersonID]
							) AS SrcB
						END
					END
				END
				ELSE BEGIN
					-- dealerID not NULL
					IF @dealerID < 0 BEGIN
						-- Filter for this dealer
						IF @productID IS NULL BEGIN
						-- All product data for this dealer grouped by sales person
							SELECT
								21 AS [Qid],
								[DealerID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[DealerID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[O].[DealerID],
										[O].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[DealerID] = ABS(@dealerID)
									GROUP BY
										[O].[DealerID]
										,[O].[Sale PersonID]

									UNION

									SELECT
										[O2].[DealerID],
										[O2].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[DealerID] = ABS(@dealerID)
									GROUP BY
										[O2].[DealerID]
										,[O2].[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[DealerID]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product and this dealer group by sales person
								SELECT
									22 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID and sales person filter by dealer
								SELECT
									23 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[ProductID]
											,[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[ProductID]
											,[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[ProductID]
									,[DealerID]
									,[Sale PersonID]
								) AS SrcB
							END
						END
					END
					ELSE BEGIN
						-- Group by dealer
						IF @productID IS NULL BEGIN
						-- All product data for this dealer grouped by sales person
							SELECT
								24 AS [Qid],
								[DealerID],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[DealerID]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										[O].[DealerID],
										[O].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[O].[DealerID]
										,[O].[Sale PersonID]

									UNION

									SELECT
										[O2].[DealerID],
										[O2].[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[O2].[DealerID]
										,[O2].[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[DealerID]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product and this dealer group by sales person
								SELECT
									25 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]

										UNION

										SELECT
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID],
											[DealerID],
											[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID and DealerID and sales person
								SELECT
									26 AS [Qid],
									[ProductID],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[ProductID]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[O].[ProductID]
											,[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[DealerID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[O2].[ProductID]
											,[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[ProductID]
									,[DealerID]
									,[Sale PersonID]
								) AS SrcB
							END
						END
					END
				END
			END
		END
	END
	ELSE BEGIN
		-- Group and or Filter By Company
		IF @companyID IS NULL BEGIN
			-- BWS + STG Data
			IF @salesPersonID IS NULL BEGIN
					-- Dealer 
					IF @dealerID IS NULL BEGIN
						-- Product
						IF @productID IS NULL BEGIN
							-- All Data no groupings
							SELECT
								27 AS [Qid],
								[OGTable],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
								) AS [SrcA]
								GROUP BY
									[OGTable]
							) AS SrcB
							--WHERE
							--	(CASE
							--		WHEN ISNULL(@companyID, -1) = -1 THEN 1
							--		WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
							--		ELSE (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
							--	END) = 1
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product
								SELECT
									28 AS [Qid],
									[OGTable],
									[ProductID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID
								SELECT
									29 AS [Qid],
									[OGTable],
									[ProductID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID] AS [ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[O].[ProductID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID] AS [ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[O2].[ProductID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
								) AS SrcB
							END
						END
					END
					ELSE BEGIN
						-- dealerID not NULL
						IF @dealerID < 0 BEGIN
							-- Filter for this dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer
								SELECT
									30 AS [Qid],
									[OGTable],
									[DealerID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[DealerID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[DealerID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
								) AS SrcB
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer
									SELECT
										31 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[ProductID],
												[DealerID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[ProductID],
												[DealerID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[ProductID]
									) AS SrcB
								END
								ELSE BEGIN
									-- Group By ProductID, filter by dealer
									SELECT
										32 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
									) AS SrcB
								END
							END
						END
						ELSE BEGIN
							-- Group by Dealer
							IF @productID IS NULL BEGIN
								-- Filter by dealer
								SELECT
									33 AS [Qid],
									[OGTable],
									[DealerID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[DealerID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[DealerID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
								) AS SrcB
							END
							ELSE BEGIN
								-- productID is not NULL
								IF @productID < 0 BEGIN
									-- Filter by dealer, product, group by sales person
									SELECT
										34 AS [Qid],
										[OGTable],
										[DealerID],
										[ProductID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[DealerID]
											,[ProductID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[DealerID],
												[ProductID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[DealerID] = ABS(@dealerID)
												AND [O].[ProductID] = ABS(@productID)
											GROUP BY
												[DealerID]
												,[ProductID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[DealerID],
												[ProductID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[DealerID] = ABS(@dealerID)
												AND [O2].[ProductID] = ABS(@productID)
											GROUP BY
												[DealerID]
												,[ProductID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[DealerID]
											,[ProductID]
									) AS SrcB
								END
								ELSE BEGIN
									-- Group by dealer and product
									SELECT
										35 AS [Qid],
										[OGTable],
										[DealerID],
										[ProductID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[DealerID]
											,[ProductID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[DealerID],
												[ProductID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											--WHERE
											--	[O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[DealerID]
												,[ProductID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[DealerID],
												[ProductID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											--WHERE
											--	[O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[DealerID]
												,[ProductID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[DealerID]
											,[ProductID]
									) AS SrcB
								END
							END
						END
					END
				END
			ELSE BEGIN
				-- @salesPersonID is not NULL
				IF @salesPersonID < 0 BEGIN
					-- Filter by @salesPersonID
					IF @dealerID IS NULL BEGIN
						-- Product
						IF @productID IS NULL BEGIN
							-- All Data no groupings filter by sales person
							SELECT
								36 AS [Qid],
								[OGTable],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[Sale PersonID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product filter by sales person
								SELECT
									37 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID filter by sales person
								SELECT
									38 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
									,[Sale PersonID]
								) AS SrcB
							END
						END
					END
					ELSE BEGIN
						-- dealerID not NULL
						IF @dealerID < 0 BEGIN
							-- Filter for this dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer and sales person
								SELECT
									39 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
											AND [O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
											AND [O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer and this sales person
									SELECT
										40 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[DealerID] = ABS(@dealerID)
												AND [O].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[DealerID] = ABS(@dealerID)
												AND [O2].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								END
								ELSE BEGIN
									-- Group By ProductID filter by DealerID and sales person
									SELECT
										41 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[Sale PersonID] = ABS(@salesPersonID)
												AND [O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[Sale PersonID] = ABS(@salesPersonID)
												AND [O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
								END
							END
						END
						ELSE BEGIN
							-- group by dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer and sales person
								SELECT
									42 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											--[O].[DealerID] = ABS(@dealerID)
											--AND 
											[O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											--[O2].[DealerID] = ABS(@dealerID)
											--AND 
											[O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- filter for this product and this sales person, group by dealer
									SELECT
										43 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								END
								ELSE BEGIN
									-- Group By ProductID, DealerID filter by sales person
									SELECT
										44 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
								END
							END
						END
					END
				END
				ELSE BEGIN
					-- Group by SalesPersonID 
					IF @dealerID IS NULL BEGIN
						-- Product
						IF @productID IS NULL BEGIN
							-- All Data no group by sales person
							SELECT
								45 AS [Qid],
								[OGTable],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[Sale PersonID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[Sale PersonID]
							) AS SrcB
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product filter by sales person
								SELECT
									46 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								-- Group By ProductID filter by sales person
								SELECT
									47 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[O].[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[O2].[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
									,[Sale PersonID]
								) AS SrcB
							END
						END
					END
					ELSE BEGIN
						-- dealerID not NULL
						IF @dealerID < 0 BEGIN
							-- Filter for this dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer grouped by sales person
								SELECT
									48 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer group by sales person
									SELECT
										49 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								END
								ELSE BEGIN
									-- Group By ProductID and sales person filter by dealer
									SELECT
										50 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
								END
							END
						END
						ELSE BEGIN
							-- Group by dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer grouped by sales person
								SELECT
									51 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer group by sales person
									SELECT
										52 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								END
								ELSE BEGIN
									-- Group By ProductID and DealerID and sales person
									SELECT
										53 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
								END
							END
						END
					END
				END
			END
		END
		ELSE BEGIN
			-- Group by Company
			IF @salesPersonID IS NULL BEGIN
				-- Dealer 
				IF @dealerID IS NULL BEGIN
					-- Product
					IF @productID IS NULL BEGIN
						-- All Data no groupings
						SELECT
							54 AS [Qid],
							[OGTable],
							NumQuotesPrepared,
							NumInvalidQuotes,
							NumSoldDeliveredUnits,
							NumUnitsOnOrder,
							NumQuotesOutToDealer,
							NumCancelledQuotes,
							NumCancelledOrders,
							100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
							100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
							100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
							100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
							100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
							100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
						FROM (
							SELECT
								[OGTable]
								,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
								,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
								,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
								,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
								,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
								,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
								,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
							FROM (
								SELECT
									'Orders' AS [OGTable],
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.Orders AS O

								UNION

								SELECT
									'OrdersV2' AS [OGTable],
									COUNT(*) AS NumQuotesPrepared,
									SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
									SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
								FROM
									dbo.OrdersV2 AS O2
							) AS [SrcA]
							GROUP BY
								[OGTable]
						) AS SrcB
						WHERE
							(CASE
								WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
								WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
								ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
							END) = 1
					END
					ELSE BEGIN
						IF @productID < 0 BEGIN
							-- Filter for this product
							SELECT
								55 AS [Qid],
								[OGTable],
								[ProductID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[ProductID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[ProductID] = ABS(@productID)
									GROUP BY
										[ProductID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[ProductID] = ABS(@productID)
									GROUP BY
										[ProductID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
							) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
						END
						ELSE BEGIN
							-- Group By ProductID
							SELECT
								56 AS [Qid],
								[OGTable],
								[ProductID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[ProductID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[ProductID] AS [ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[O].[ProductID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[ProductID] AS [ProductID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[O2].[ProductID]
								) AS [SrcA]
							GROUP BY
								[OGTable]
								,[ProductID]
							) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
						END
					END
				END
				ELSE BEGIN
					-- dealerID not NULL
					IF @dealerID < 0 BEGIN
						-- Filter for this dealer
						IF @productID IS NULL BEGIN
						-- All product data for this dealer
							SELECT
								57 AS [Qid],
								[OGTable],
								[DealerID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[DealerID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[O].[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[DealerID] = ABS(@dealerID)
									GROUP BY
										[O].[DealerID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[O2].[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[DealerID] = ABS(@dealerID)
									GROUP BY
										[O2].[DealerID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[DealerID]
							) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product and this dealer
								SELECT
									58 AS [Qid],
									[OGTable],
									[ProductID],
									[DealerID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[DealerID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[ProductID],
											[DealerID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[ProductID],
											[DealerID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[DealerID]
									,[ProductID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								-- Group By ProductID, filter by dealer
								SELECT
									59 AS [Qid],
									[OGTable],
									[ProductID],
									[DealerID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[DealerID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[ProductID]
											,[O].[DealerID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[DealerID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[ProductID]
											,[O2].[DealerID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
									,[DealerID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
						END
					END
					ELSE BEGIN
						-- Group by Dealer
						IF @productID IS NULL BEGIN
							-- Filter by dealer
							SELECT
								60 AS [Qid],
								[OGTable],
								[DealerID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[DealerID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[DealerID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[DealerID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[DealerID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[DealerID]
							) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
						END
						ELSE BEGIN
							-- productID is not NULL
							IF @productID < 0 BEGIN
								-- Filter by dealer, product, group by sales person
								SELECT
									61 AS [Qid],
									[OGTable],
									[DealerID],
									[ProductID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[ProductID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
											AND [O].[ProductID] = ABS(@productID)
										GROUP BY
											[DealerID]
											,[ProductID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
											AND [O2].[ProductID] = ABS(@productID)
										GROUP BY
											[DealerID]
											,[ProductID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[ProductID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								-- Group by dealer and product
								SELECT
									62 AS [Qid],
									[OGTable],
									[DealerID],
									[ProductID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[ProductID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										--WHERE
										--	[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[DealerID]
											,[ProductID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[DealerID],
											[ProductID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										--WHERE
										--	[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[DealerID]
											,[ProductID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[ProductID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
						END
					END
				END
			END
			ELSE BEGIN
				-- @salesPersonID is not NULL
				IF @salesPersonID < 0 BEGIN
					-- Filter by @salesPersonID
					IF @dealerID IS NULL BEGIN
						-- Product
						IF @productID IS NULL BEGIN
							-- All Data no groupings filter by sales person
							SELECT
								63 AS [Qid],
								[OGTable],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									WHERE
										[O].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[Sale PersonID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									WHERE
										[O2].[Sale PersonID] = ABS(@salesPersonID)
									GROUP BY
										[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[Sale PersonID]
							) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product filter by sales person
								SELECT
									64 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
											AND [O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
											AND [O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								-- Group By ProductID filter by sales person
								SELECT
									65 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
									,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
						END
					END
					ELSE BEGIN
						-- dealerID not NULL
						IF @dealerID < 0 BEGIN
							-- Filter for this dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer and sales person
								SELECT
									66 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
											AND [O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
											AND [O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer and this sales person
									SELECT
										67 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[DealerID] = ABS(@dealerID)
												AND [O].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[DealerID] = ABS(@dealerID)
												AND [O2].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
								END
								ELSE BEGIN
									-- Group By ProductID filter by DealerID and sales person
									SELECT
										68 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[Sale PersonID] = ABS(@salesPersonID)
												AND [O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[Sale PersonID] = ABS(@salesPersonID)
												AND [O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
								END
							END
						END
						ELSE BEGIN
							-- group by dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer and sales person
								SELECT
									69 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											--[O].[DealerID] = ABS(@dealerID)
											--AND 
											[O].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											--[O2].[DealerID] = ABS(@dealerID)
											--AND 
											[O2].[Sale PersonID] = ABS(@salesPersonID)
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- filter for this product and this sales person, group by dealer
									SELECT
										70 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
								END
								ELSE BEGIN
									-- Group By ProductID, DealerID filter by sales person
									SELECT
										71 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[Sale PersonID] = ABS(@salesPersonID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
									WHERE
										(CASE
											WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
											WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
											ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
										END) = 1
								END
							END
						END
					END
				END
				ELSE BEGIN
					-- Group by SalesPersonID 
					IF @dealerID IS NULL BEGIN
						-- Product
						IF @productID IS NULL BEGIN
							-- All Data no group by sales person
							SELECT
								72 AS [Qid],
								[OGTable],
								[Sale PersonID],
								NumQuotesPrepared,
								NumInvalidQuotes,
								NumSoldDeliveredUnits,
								NumUnitsOnOrder,
								NumQuotesOutToDealer,
								NumCancelledQuotes,
								NumCancelledOrders,
								100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
								100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
								100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
								100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
								100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
								100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
							FROM (
								SELECT
									[OGTable]
									,[Sale PersonID]
									,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
									,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
									,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
									,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
									,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
									,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
									,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
								FROM (
									SELECT
										'Orders' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.Orders AS O
									GROUP BY
										[Sale PersonID]

									UNION

									SELECT
										'OrdersV2' AS [OGTable],
										[Sale PersonID],
										COUNT(*) AS NumQuotesPrepared,
										SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
										SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
									FROM
										dbo.OrdersV2 AS O2
									GROUP BY
										[Sale PersonID]
								) AS [SrcA]
								GROUP BY
									[OGTable]
									,[Sale PersonID]
							) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
						END
						ELSE BEGIN
							IF @productID < 0 BEGIN
								-- Filter for this product filter by sales person
								SELECT
									73 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[ProductID] = ABS(@productID)
										GROUP BY
											[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								-- Group By ProductID filter by sales person
								SELECT
									74 AS [Qid],
									[OGTable],
									[ProductID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[ProductID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[O].[ProductID]
											,[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[ProductID] AS [ProductID],
											[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[O2].[ProductID]
											,[Sale PersonID]
									) AS [SrcA]
								GROUP BY
									[OGTable]
									,[ProductID]
									,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
						END
					END
					ELSE BEGIN
						-- dealerID not NULL
						IF @dealerID < 0 BEGIN
							-- Filter for this dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer grouped by sales person
								SELECT
									75 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										WHERE
											[O].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										WHERE
											[O2].[DealerID] = ABS(@dealerID)
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer group by sales person
									SELECT
										76 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
												AND [O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
												AND [O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
								END
								ELSE BEGIN
									-- Group By ProductID and sales person filter by dealer
									SELECT
										77 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[DealerID] = ABS(@dealerID)
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
								WHERE
									(CASE
										WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
										WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
										ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
									END) = 1
								END
							END
						END
						ELSE BEGIN
							-- Group by dealer
							IF @productID IS NULL BEGIN
							-- All product data for this dealer grouped by sales person
								SELECT
									78 AS [Qid],
									[OGTable],
									[DealerID],
									[Sale PersonID],
									NumQuotesPrepared,
									NumInvalidQuotes,
									NumSoldDeliveredUnits,
									NumUnitsOnOrder,
									NumQuotesOutToDealer,
									NumCancelledQuotes,
									NumCancelledOrders,
									100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
									100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
									100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
									100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
									100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
									100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
								FROM (
									SELECT
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
										,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
										,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
										,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
										,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
										,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
										,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
										,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
									FROM (
										SELECT
											'Orders' AS [OGTable],
											[O].[DealerID],
											[O].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.Orders AS O
										GROUP BY
											[O].[DealerID]
											,[O].[Sale PersonID]

										UNION

										SELECT
											'OrdersV2' AS [OGTable],
											[O2].[DealerID],
											[O2].[Sale PersonID],
											COUNT(*) AS NumQuotesPrepared,
											SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
											SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
										FROM
											dbo.OrdersV2 AS O2
										GROUP BY
											[O2].[DealerID]
											,[O2].[Sale PersonID]
									) AS [SrcA]
									GROUP BY
										[OGTable]
										,[DealerID]
										,[Sale PersonID]
								) AS SrcB
							WHERE
								(CASE
									WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
									WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
									ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
								END) = 1
							END
							ELSE BEGIN
								IF @productID < 0 BEGIN
									-- Filter for this product and this dealer group by sales person
									SELECT
										79 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											WHERE
												[O].[ProductID] = ABS(@productID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											WHERE
												[O2].[ProductID] = ABS(@productID)
											GROUP BY
												[ProductID],
												[DealerID],
												[Sale PersonID]
										) AS [SrcA]
										GROUP BY
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
									) AS SrcB
									WHERE
										(CASE
											WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
											WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
											ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
										END) = 1
								END
								ELSE BEGIN
									-- Group By ProductID and DealerID and sales person

									--SELECT 'HERE'

									SELECT
										80 AS [Qid],
										[OGTable],
										[ProductID],
										[DealerID],
										[Sale PersonID],
										NumQuotesPrepared,
										NumInvalidQuotes,
										NumSoldDeliveredUnits,
										NumUnitsOnOrder,
										NumQuotesOutToDealer,
										NumCancelledQuotes,
										NumCancelledOrders,
										100 * (NumInvalidQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctInvalidQuotes,
										100 * (NumSoldDeliveredUnits + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctSoldDeliveredUnits,
										100 * (NumUnitsOnOrder + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctUnitsOnOrder,
										100 * (NumQuotesOutToDealer + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctQuotesOutToDealer,
										100 * (NumCancelledQuotes + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledQuotes,
										100 * (NumCancelledOrders + 0.0) / (CASE WHEN [NumQuotesPrepared] = 0 THEN 1 ELSE [NumQuotesPrepared] END) AS PctCancelledOrders
									FROM (
										SELECT
											[OGTable]
											,[ProductID]
											,[DealerID]
											,[Sale PersonID]
											,SUM([NumQuotesPrepared]) AS NumQuotesPrepared
											,SUM([NumInvalidQuotes]) AS [NumInvalidQuotes]
											,SUM([NumSoldDeliveredUnits]) AS [NumSoldDeliveredUnits]
											,SUM([NumUnitsOnOrder]) AS [NumUnitsOnOrder]
											,SUM([NumQuotesOutToDealer]) AS [NumQuotesOutToDealer]
											,SUM([NumCancelledQuotes]) AS [NumCancelledQuotes]
											,SUM([NumCancelledOrders]) AS [NumCancelledOrders]
										FROM (
											SELECT
												'Orders' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NOT NULL) AND ([O].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O].[Quote Date] IS NOT NULL) AND ([O].[Date Declined] IS NOT NULL) AND ([O].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.Orders AS O
											GROUP BY
												[O].[ProductID]
												,[O].[DealerID]
												,[O].[Sale PersonID]

											UNION

											SELECT
												'OrdersV2' AS [OGTable],
												[ProductID],
												[DealerID],
												[Sale PersonID],
												COUNT(*) AS NumQuotesPrepared,
												SUM(CASE WHEN ([O2].[Quote Date] IS NULL) THEN 1 ELSE 0 END) AS NumInvalidQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumSoldDeliveredUnits,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NOT NULL) AND ([O2].[Delivery Date] IS NULL) THEN 1 ELSE 0 END) AS NumUnitsOnOrder,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumQuotesOutToDealer,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NULL) THEN 1 ELSE 0 END) AS NumCancelledQuotes,
												SUM(CASE WHEN ([O2].[Quote Date] IS NOT NULL) AND ([O2].[Date Declined] IS NOT NULL) AND ([O2].[Order Date] IS NOT NULL) THEN 1 ELSE 0 END) AS NumCancelledOrders
											FROM
												dbo.OrdersV2 AS O2
											GROUP BY
												[O2].[ProductID]
												,[O2].[DealerID]
												,[O2].[Sale PersonID]
										) AS [SrcA]
									GROUP BY
										[OGTable]
										,[ProductID]
										,[DealerID]
										,[Sale PersonID]
									) AS SrcB
									WHERE
										(CASE
											WHEN ABS(@companyID) = 0 THEN (CASE WHEN [OGTable] = 'Orders' THEN 1 ELSE 0 END)
											WHEN ABS(@companyID) = 1 THEN (CASE WHEN [OGTable] = 'OrdersV2' THEN 1 ELSE 0 END)
											ELSE 0 -- UNSURE WHAT TO DO WITH THIS COMPANY
										END) = 1
								END
							END
						END
					END
				END
			END
		END
	END
END