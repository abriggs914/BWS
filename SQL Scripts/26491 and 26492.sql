SELECT        dbo.Dealers.[COMPANY NAME], dbo.Orders.Quote#, dbo.Orders.WO#, dbo.Orders.[Model No], dbo.Orders.[Serial Number], dbo.Orders.[Purchase Order] AS PO, dbo.[v_Order Book Detail_All].[Payment Terms] AS Terms, 
                         dbo.Orders.[PO Date], dbo.Orders.[Order Date], dbo.Orders.[Requested Delivery Date], CASE WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
                         THEN Production.[Date Completed] ELSE v_CompletedJobInfo.ActCompleteDate END AS [Date Completed], dbo.Orders.[Shipped Date], dbo.Orders.[Date Declined], dbo.Orders.Price AS [Base Price], 
                         dbo.[v_Order Book Detail_All].[Options Price] AS Options, dbo.[v_Order Book Detail_All].[NPO Price] AS Custom, dbo.[v_Order Book Detail_All].[Gross Price], dbo.Orders.[Volume Discount], 
                         dbo.[v_Order Book Detail_All].[Vol Dis] AS [Vol Disc], dbo.Orders.[Program Discount], dbo.[v_Order Book Detail_All].[Pro Dis] AS [Pro Disc], dbo.[v_Order Book Detail_All].[Selling Price] AS [Net Price], dbo.Production.[Prod Date], 
                         dbo.Products.Days, dbo.Products.GN AS GN1, dbo.Products.Paint, dbo.Products.Finish AS Fin, dbo.Products.Days + dbo.Products.GN + dbo.Products.Paint + dbo.Products.Finish AS [Prod Days], dbo.Orders.[Finish Date], 
                         dbo.Orders.[Available Date], dbo.Orders.[Delivery Date]
FROM            dbo.Orders WITH (nolock) INNER JOIN
                         dbo.[v_Order Book Detail_All] ON dbo.Orders.Quote# = dbo.[v_Order Book Detail_All].Quote# INNER JOIN
                         dbo.Dealers WITH (nolock) ON dbo.Orders.DealerID = dbo.Dealers.ID INNER JOIN
                         dbo.Products WITH (nolock) ON dbo.Orders.[Model No] = dbo.Products.[Model No] LEFT OUTER JOIN
                         dbo.Production WITH (nolock) ON dbo.Orders.Quote# = dbo.Production.Quote# LEFT OUTER JOIN
                         SysproCompanyA.dbo.v_CompletedJobInfo ON CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job
WHERE       ( (dbo.Orders.DealerID IN
                             (SELECT DISTINCT ID
                               FROM            dbo.Dealers WITH (nolock)
                               WHERE        ([CURRENT DEALER] = 1)))
			AND (dbo.Orders.Quote# IN
                             (SELECT DISTINCT Quote#
                               FROM            dbo.Orders WITH (nolock)
                               WHERE        (FinishedGoodsDealerLocID IS NULL)))
			AND (dbo.Orders.[PO Date] IS NOT NULL)
			AND ((CASE WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
                         THEN Production.[Date Completed] ELSE v_CompletedJobInfo.ActCompleteDate END) IS NULL)
			AND (dbo.Orders.[Shipped Date] IS NULL)
			AND (dbo.Orders.[Date Declined] IS NULL) 
			AND (dbo.Orders.Quote# <> 24545)
			AND 
                         (dbo.Orders.WO# NOT IN (10015030, 10015031, 10015032) OR
                         dbo.Orders.WO# IS NULL)
			OR
                         (dbo.Orders.Quote# IN
                             (SELECT DISTINCT dbo.Orders.Quote#
                               FROM            dbo.Orders WITH (nolock) INNER JOIN
                                                         dbo.Dealers WITH (nolock) ON dbo.Orders.FinishedGoodsDealerLocID = dbo.Dealers.ID
                               WHERE        (dbo.Orders.DealerID IN
                                                             (SELECT DISTINCT ID
                                                               FROM            dbo.Dealers WITH (nolock)
                                                               WHERE        ([CURRENT DEALER] = 1)))
								AND (dbo.Orders.DealerID NOT IN
                                                             (SELECT        ID
                                                               FROM            dbo.Dealers WITH (nolock)
                                                               WHERE        (LEFT([COMPANY NAME], 3) = 'BWS')))))
			AND (dbo.Orders.[PO Date] IS NOT NULL)
			AND ((CASE WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
                         THEN Production.[Date Completed] ELSE v_CompletedJobInfo.ActCompleteDate END) IS NULL)
			AND (dbo.Orders.[Shipped Date] IS NULL)
			AND (dbo.Orders.[Date Declined] IS NULL)
			AND (dbo.Orders.Quote# <> 24545)
			AND 
                         (dbo.Orders.WO# NOT IN (10015030, 10015031, 10015032) OR
                         dbo.Orders.WO# IS NULL)
						 

 ) AND [Orders].[Quote#] IN (26491, 26492, 26941, 26942)
 ORDER BY [Quote#];


 SELECT * FROM 


 dbo.Orders WITH (nolock) INNER JOIN
                         dbo.[v_Order Book Detail_All] ON dbo.Orders.Quote# = dbo.[v_Order Book Detail_All].Quote# INNER JOIN
                         dbo.Dealers WITH (nolock) ON dbo.Orders.DealerID = dbo.Dealers.ID INNER JOIN
                         dbo.Products WITH (nolock) ON dbo.Orders.[Model No] = dbo.Products.[Model No] LEFT OUTER JOIN
                         dbo.Production WITH (nolock) ON dbo.Orders.Quote# = dbo.Production.Quote# LEFT OUTER JOIN
                         SysproCompanyA.dbo.v_CompletedJobInfo ON CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job




 WHERE       ( (dbo.Orders.DealerID IN
                             (SELECT DISTINCT ID
                               FROM            dbo.Dealers WITH (nolock)
                               WHERE        ([CURRENT DEALER] = 1)))
			AND (dbo.Orders.Quote# IN
                             (SELECT DISTINCT Quote#
                               FROM            dbo.Orders WITH (nolock)
                               WHERE        (FinishedGoodsDealerLocID IS NULL)))
			AND (dbo.Orders.[PO Date] IS NOT NULL)
			AND ((CASE WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
                         THEN Production.[Date Completed] ELSE v_CompletedJobInfo.ActCompleteDate END) IS NULL)
			AND (dbo.Orders.[Shipped Date] IS NULL)
			AND (dbo.Orders.[Date Declined] IS NULL) 
			AND (dbo.Orders.Quote# <> 24545)
			AND 
                         (dbo.Orders.WO# NOT IN (10015030, 10015031, 10015032) OR
                         dbo.Orders.WO# IS NULL)
			OR
                         (dbo.Orders.Quote# IN
                             (SELECT DISTINCT dbo.Orders.Quote#
                               FROM            dbo.Orders WITH (nolock) INNER JOIN
                                                         dbo.Dealers WITH (nolock) ON dbo.Orders.FinishedGoodsDealerLocID = dbo.Dealers.ID
                               WHERE        (dbo.Orders.DealerID IN
                                                             (SELECT DISTINCT ID
                                                               FROM            dbo.Dealers WITH (nolock)
                                                               WHERE        ([CURRENT DEALER] = 1)))
								AND (dbo.Orders.DealerID NOT IN
                                                             (SELECT        ID
                                                               FROM            dbo.Dealers WITH (nolock)
                                                               WHERE        (LEFT([COMPANY NAME], 3) = 'BWS')))))
			AND (dbo.Orders.[PO Date] IS NOT NULL)
			AND ((CASE WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
                         THEN Production.[Date Completed] ELSE v_CompletedJobInfo.ActCompleteDate END) IS NULL)
			AND (dbo.Orders.[Shipped Date] IS NULL)
			AND (dbo.Orders.[Date Declined] IS NULL)
			AND (dbo.Orders.Quote# <> 24545)
			AND 
                         (dbo.Orders.WO# NOT IN (10015030, 10015031, 10015032) OR
                         dbo.Orders.WO# IS NULL)
						 

 ) AND [Orders].[Quote#] IN (26491, 26492, 26941, 26942)
;


SELECT        dbo.Dealers.[COMPANY NAME], dbo.Orders.Quote#, dbo.Orders.WO#, dbo.Orders.[Model No], dbo.Orders.[Serial Number], dbo.Orders.[Purchase Order] AS PO, dbo.[v_Order Book Detail_All].[Payment Terms] AS Terms, 
                         dbo.Orders.[PO Date], dbo.Orders.[Order Date], dbo.Orders.[Requested Delivery Date], CASE WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
                         THEN Production.[Date Completed] ELSE v_CompletedJobInfo.ActCompleteDate END AS [Date Completed], dbo.Orders.[Shipped Date], dbo.Orders.[Date Declined], dbo.Orders.Price AS [Base Price], 
                         dbo.[v_Order Book Detail_All].[Options Price] AS Options, dbo.[v_Order Book Detail_All].[NPO Price] AS Custom, dbo.[v_Order Book Detail_All].[Gross Price], dbo.Orders.[Volume Discount], 
                         dbo.[v_Order Book Detail_All].[Vol Dis] AS [Vol Disc], dbo.Orders.[Program Discount], dbo.[v_Order Book Detail_All].[Pro Dis] AS [Pro Disc], dbo.[v_Order Book Detail_All].[Selling Price] AS [Net Price], dbo.Production.[Prod Date], 
                         dbo.Products.Days, dbo.Products.GN AS GN1, dbo.Products.Paint, dbo.Products.Finish AS Fin, dbo.Products.Days + dbo.Products.GN + dbo.Products.Paint + dbo.Products.Finish AS [Prod Days], dbo.Orders.[Finish Date], 
                         dbo.Orders.[Available Date], dbo.Orders.[Delivery Date]
FROM            dbo.Orders WITH (nolock) INNER JOIN
                         dbo.[v_Order Book Detail_All] ON dbo.Orders.Quote# = dbo.[v_Order Book Detail_All].Quote# INNER JOIN
                         dbo.Dealers WITH (nolock) ON dbo.Orders.DealerID = dbo.Dealers.ID INNER JOIN
                         dbo.Products WITH (nolock) ON dbo.Orders.[Model No] = dbo.Products.[Model No] LEFT OUTER JOIN
                         dbo.Production WITH (nolock) ON dbo.Orders.Quote# = dbo.Production.Quote# LEFT OUTER JOIN
                         SysproCompanyA.dbo.v_CompletedJobInfo ON CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job
ORDER BY
	[Orders].[Quote#]
;


SELECT
	'working' AS [Table],
	dbo.Dealers.[COMPANY NAME],
	dbo.Orders.Quote#,
	dbo.Orders.WO#,
	dbo.Orders.[Model No],
	dbo.Orders.[Serial Number],
	dbo.Orders.[Purchase Order] AS PO,
	dbo.[v_Order Book Detail_All].[Payment Terms] AS Terms,
	dbo.Orders.[PO Date],
	dbo.Orders.[Order Date],
	dbo.Orders.[Requested Delivery Date],
	--CASE
	--	WHEN v_CompletedJobInfo.ActCompleteDate IS NULL 
	--	THEN Production.[Date Completed]
	--	ELSE v_CompletedJobInfo.ActCompleteDate
	--END AS [Date Completed],
	dbo.Orders.[Shipped Date],
	dbo.Orders.[Date Declined],
	dbo.Orders.Price AS [Base Price],
	
	dbo.[v_Order Book Detail_All].[Options Price] AS Options,
	dbo.[v_Order Book Detail_All].[NPO Price] AS Custom,
	dbo.[v_Order Book Detail_All].[Gross Price],
	dbo.Orders.[Volume Discount],
	
	dbo.[v_Order Book Detail_All].[Vol Dis] AS [Vol Disc],
	dbo.Orders.[Program Discount],
	dbo.[v_Order Book Detail_All].[Pro Dis] AS [Pro Disc],
	dbo.[v_Order Book Detail_All].[Selling Price] AS [Net Price],
	dbo.Production.[Prod Date],
	
	dbo.Products.Days,
	dbo.Products.GN AS GN1,
	dbo.Products.Paint,
	dbo.Products.Finish AS Fin,
	dbo.Products.Days + dbo.Products.GN + dbo.Products.Paint + dbo.Products.Finish AS [Prod Days],
	dbo.Orders.[Finish Date],
	
	dbo.Orders.[Available Date],
	dbo.Orders.[Delivery Date]
FROM
	dbo.Orders WITH (nolock) 
	INNER JOIN dbo.[v_Order Book Detail_All] ON dbo.Orders.Quote# = dbo.[v_Order Book Detail_All].Quote#
	INNER JOIN dbo.Dealers WITH (nolock) ON dbo.Orders.DealerID = dbo.Dealers.ID
	INNER JOIN dbo.Products WITH (nolock) ON dbo.Orders.[Model No] = dbo.Products.[Model No]
	LEFT OUTER JOIN	dbo.Production WITH (nolock) ON dbo.Orders.Quote# = dbo.Production.Quote#
	--LEFT OUTER JOIN SysproCompanyA.dbo.v_CompletedJobInfo ON CAST(dbo.Orders.WO# AS varchar(20)) = SysproCompanyA.dbo.v_CompletedJobInfo.Job
ORDER BY
	[Orders].[Quote#]
;


