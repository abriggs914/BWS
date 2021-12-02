USE BWSdb
GO

EXEC [dbo].[sp_ITRequestPersonnelTotals] @sd='2021-01-01', @ed='2021-12-31'
EXEC [dbo].[sp_ITRequestPersonnelTotals] @sd='2022-01-01', @ed='2021-12-31'