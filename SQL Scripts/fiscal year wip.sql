USE [BWSdb]
GO

DECLARE
	@a BIT = 0,	@b BIT = 0,	@c BIT = 0,
	@d BIT = 0,	@e BIT = 0,	@f BIT = 0,
	@g BIT = 0,	@h BIT = 0,	@i BIT = 0,
	@j BIT = 0,	@k BIT = 0, @l BIT = 0,
	@m BIT = 0,	@n BIT = 0
;

SELECT
	 @h = 1
;

IF @a = 1 BEGIN
	SELECT
		[ITRCustomerID]
		,[Theme]
		,[AutoLockOwnRequests]
		,[AutoSeeOwnRequests]
	FROM
		[dbo].[ITR Settings]
	;
END
	
IF @b = 1 BEGIN
	SELECT TOP 50
		*
	FROM
		[SysproCompanyA].[dbo].[BomControl]
	;
END
IF @c = 1 BEGIN
	SELECT TOP 50
		*
	FROM
		[SysproCompanyA].[dbo].[ApControl]
	;
END
IF @d = 1 BEGIN
	SELECT TOP 50
		*
	FROM
		[SysproCompanyA].[dbo].[InvControl]
	;
END
IF @e = 1 BEGIN
	SELECT TOP 50
		*
	FROM
		[SysproCompanyA].[dbo].[ArControl]
	;
END
IF @f = 1 BEGIN
	SELECT TOP 50
		*
	FROM
		[SysproCompanyA].[dbo].[ArcControl]
	;
END
IF @g = 1 BEGIN
	SELECT TOP 50000000
		*
	FROM
		[SysproCompanyA].[dbo].[ArcMaster]
	;
END
IF @h = 1 BEGIN
	SELECT
		*
	FROM
		[SysproCompanyA].[dbo].[v_Fiscal Summary – Expenses]
	;
END


SELECT
	0 AS [FiscalYear], '2023-11-30' AS [StartDate], '2022-12-01' AS [EndDate]
UNION SELECT
	1, '2022-11-30', '2021-12-01'
UNION SELECT
	2, '2021-11-30', '2020-12-01'