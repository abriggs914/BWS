USE [Stargatedb]
GO

/****** Object:  View [dbo].[v_Orders Raw Pricing NPO]    Script Date: 2022-02-11 1:45:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[v_Orders Raw Pricing NPO]
AS
SELECT        [Custom WorkV2].SGQuote, COUNT([Custom WorkV2].SGQuote) AS [# NPOs], SUM(CASE WHEN OrdersV2.[Quote Date] >= 'january 1 2019' AND 
                         [US Sale] = 1 THEN [Custom WorkV2].[US Price] ELSE [Custom WorkV2].Price END * Qty) AS Price, SUM(Cost * Qty) AS Cost, SUM(Weight * Qty) AS [NPO Wt], 
                         SUM(([Machine Shop] + Axles + [Stakes/Bunks] + Beam + GNK + Parts + Line + Blast + Paint + Finish) * Qty) AS TtlNPOHrs
FROM            [BWSdb].dbo.[Custom WorkV2] WITH (nolock) INNER JOIN
                         [BWSdb].dbo.OrdersV2 WITH (nolock) ON [Custom WorkV2].SGQuote = OrdersV2.SGQuote
GROUP BY [Custom WorkV2].SGQuote
UNION ALL
SELECT        OrdersV2.SGQuote, 0, 0, 0, 0, 0
FROM            [BWSdb].[dbo].OrdersV2 WITH (nolock) LEFT OUTER JOIN
                         [Custom Work] WITH (nolock) ON OrdersV2.SGQuote = [Custom Work].SGQuote
WHERE        [Custom Work].SGQuote IS NULL
GO


