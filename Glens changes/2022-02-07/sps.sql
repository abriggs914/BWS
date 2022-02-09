USE BWSdb
GO


-- trailer and parts figures on the Income Statement (SysproCompanyA -> Admin Menu -> Income Statement)
exec [sp_IncomeStatementV2] '2-7-2022', 0, 0

-- Sales Summary By Dealer report (Sales V4 -> Sales Reports Menu form-> Dealer Sales Summary report)
exec [sp_DealerSalesSummary] '1-1-2022', '1-31-2022', '2-1-2022', '2-28-2022'

USE SysproCompanyA
GO

--Parts Sales Summary report (SysproCompanyA -> Admin Menu -> Parts Sales Summary & Detail)
USE SysproCompanyA
GO
exec [sp_PartsSalesSummary] '1-1-2022', '1-31-2022', '2-1-2022', '2-28-2022'
exec [sp_PartsSalesDetail] '1-1-2020', '12-31-2020', '1-1-2021', '12-31-2021'
USE BWSdb
GO
exec [sp_PartsSalesSummary] '1-1-2022', '1-31-2022', '2-1-2022', '2-28-2022'
exec [sp_PartsSalesDetail] '1-1-2020', '12-31-2020', '1-1-2021', '12-31-2021'
