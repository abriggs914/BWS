USE BWSdb
GO

-- Quote 24545 is a special case. It must be manually removed from Deliver Date Review Report, and Dealer Status Report

SELECT Dealers.[COMPANY NAME], Orders.[Quote#], Orders.[WO#], Orders.[Model No], Orders.[Serial Number], Orders.[Purchase Order] AS PO, [v_Order Book Detail_All].[Payment Terms] AS Terms, Orders.[PO Date], Orders.[Order Date], Orders.[Requested Delivery Date], Production.[Date Completed], Orders.[Shipped Date], Orders.[Date Declined], Orders.Price AS [Base Price], [v_Order Book Detail_All].[Options Price] AS Options, [v_Order Book Detail_All].[NPO Price] AS Custom, [v_Order Book Detail_All].[Gross Price], Orders.[Volume Discount], [v_Order Book Detail_All].[Vol Dis] AS [Vol Disc], Orders.[Program Discount], [v_Order Book Detail_All].[Pro Dis] AS [Pro Disc], [v_Order Book Detail_All].[Selling Price] AS [Net Price], Production.[Prod Date], Products.Days, Products.GN AS GN1, Products.Paint, Products.Finish AS Fin, ([Days]+Products.GN+[Paint]+[Products].[Finish]) AS [Prod Days], Orders.[Finish Date], Orders.[Available Date], Orders.[Delivery Date]
FROM (((Products INNER JOIN (Orders INNER JOIN Dealers ON Orders.DealerID = Dealers.ID) ON Products.[Model No] = Orders.[Model No]) INNER JOIN [v_Order Book Detail_All] ON Orders.[Quote#] = [v_Order Book Detail_All].[Quote#]) INNER JOIN Production ON Orders.[Quote#] = Production.[Quote#])
WHERE (((Orders.[PO Date]) Is Not Null) AND ((Production.[Date Completed]) Is Null) AND ((Orders.[Shipped Date]) Is Null) AND ((Orders.[Date Declined]) Is Null)) and Dealers.[COMPANY NAME] LIKE '%Star%' and [Orders].WO# is NULL
ORDER BY [Serial Number], Dealers.[COMPANY NAME];

SELECT Dealers.[COMPANY NAME], Orders.[Quote#], Orders.[WO#], Orders.[Model No], Orders.[Serial Number], Orders.[Purchase Order] AS PO, [v_Order Book Detail_All].[Payment Terms] AS Terms, Orders.[PO Date], Orders.[Order Date], Orders.[Requested Delivery Date], Production.[Date Completed], Orders.[Shipped Date], Orders.[Date Declined], Orders.Price AS [Base Price], [v_Order Book Detail_All].[Options Price] AS Options, [v_Order Book Detail_All].[NPO Price] AS Custom, [v_Order Book Detail_All].[Gross Price], Orders.[Volume Discount], [v_Order Book Detail_All].[Vol Dis] AS [Vol Disc], Orders.[Program Discount], [v_Order Book Detail_All].[Pro Dis] AS [Pro Disc], [v_Order Book Detail_All].[Selling Price] AS [Net Price], Production.[Prod Date], Products.Days, Products.GN AS GN1, Products.Paint, Products.Finish AS Fin, ([Days]+Products.GN+[Paint]+[Products].[Finish]) AS [Prod Days], Orders.[Finish Date], Orders.[Available Date], Orders.[Delivery Date]
FROM (((Products INNER JOIN (Orders INNER JOIN Dealers ON Orders.DealerID = Dealers.ID) ON Products.[Model No] = Orders.[Model No]) INNER JOIN [v_Order Book Detail_All] ON Orders.[Quote#] = [v_Order Book Detail_All].[Quote#]) INNER JOIN Production ON Orders.[Quote#] = Production.[Quote#])
WHERE  Dealers.[COMPANY NAME] LIKE '%Star%' and [Orders].WO# is NULL
ORDER BY [Serial Number], Dealers.[COMPANY NAME];

USE SysproCompanyA
GO

SELECT * FROM [WipMaster] WHERE [StockCode] LIKE '%8960%'


