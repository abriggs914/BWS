USE SysproCompanyA
GO

DECLARE @sd AS DATETIME = '2022-02-10';
DECLARE @ed AS DATETIME = '2022-02-15';

EXEC [dbo].[sp_ClkTallyHours] @empNum=200102, @sd=@sd, @ed=@ed;
EXEC [dbo].[sp_ClkTallyHours] @empNum=200102, @sd=@sd, @ed=@ed, @by_transaction=0;
EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed;
EXEC [dbo].[sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0;

EXEC [dbo].[sp_ClkTallyHours] @empNum=200103, @sd=@sd, @ed=@ed;

SELECT
	*
FROM
	[ClkTransaction]
WHERE
	[EmployeeNumber] LIKE '200102'
	AND [InTimeFromShopClk] BETWEEN @sd AND @ed


EXEC [dbo].[sp_ClkLabourOverride] @sd=@sd, @ed=@ed