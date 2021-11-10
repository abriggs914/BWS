USE SysproCompanyA
GO
SELECT * FROM [ClkFrmConfirm]

EXEC [dbo].[sp_ClkTallyHours] @empNum=200326, @sd='2021-11-09', @ed='2021-11-10'

EXEC [dbo].[sp_ClkTallyHours] @empNum=200430, @sd='2021-11-09', @ed='2021-11-10'


EXEC [dbo].[sp_ClkLabourOverride] @sd='2021-11-09', @ed='2021-11-10'


EXEC [dbo].[sp_ClkLabourOverride] @sd='2021-11-09', @ed='2021-11-10'