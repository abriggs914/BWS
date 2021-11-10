USE SysproCompanyA
GO

EXEC [dbo].[sp_ClkTallyHours] @empNum=200102, @sd='2021-11-01', @ed='2021-11-05';
EXEC [dbo].[sp_ClkTallyHours] @empNum=200102, @sd='2021-11-01', @ed='2021-11-05', @by_transaction=0;
EXEC [dbo].[sp_ClkTallyHours] @sd='2021-11-01', @ed='2021-11-05';
EXEC [dbo].[sp_ClkTallyHours] @sd='2021-11-01', @ed='2021-11-05', @by_transaction=0;

EXEC [dbo].[sp_ClkTallyHours] @empNum=200103, @sd='2021-11-01', @ed='2021-11-05';

SELECT
	*
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] LIKE '200102'
	AND [InTimeFromShopClk] BETWEEN '2021-11-01' AND '2021-11-05'


EXEC [dbo].[sp_ClkLabourOverride] @sd='2021-11-09', @ed='2021-11-10'