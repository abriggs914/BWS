USE [SysproCompanyA]
GO

EXEC [dbo].[sp_ClkLabourOverride] @sd='2022-02-12', @ed='2022-02-12 23:59:59'

EXEC [dbo].[sp_ClkLabourOverride] 
@sd = '2022-02-15', @ed = '2022-02-15 23:59:59'

EXEC [dbo].[sp_ClkTallyHours] 
@sd = '2022-02-15', @ed = '2022-02-15 23:59:59'