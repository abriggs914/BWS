USE Stargatedb
GO

SELECT * FROM dbo.dtSalesPerformance WITH (nolock) INNER JOIN
                         [BWSdb].dbo.OrdersV2 WITH (nolock) ON dbo.dtSalesPerformance.WO# = [BWSdb].dbo.OrdersV2.WO# INNER JOIN
                         [BWSdb].dbo.ProductsV2 WITH (nolock) ON [BWSdb].dbo.OrdersV2.[Model No] = [BWSdb].dbo.ProductsV2.[Model No]

						 
SELECT * FROM [Stargatedb].[dbo].dtSYSPROCustomerInitials
SELECT * FROM [BWSdb].[dbo].[dtSYSPROCustomerInitals]

SELECT * FROM [BWSdb].[dbo].[spv_DealerSalesSummary (Initials)]
SELECT * FROM [Stargatedb].[dbo].[spv_DealerSalesSummary (Initials)]