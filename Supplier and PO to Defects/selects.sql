USE BWSdb
GO
SELECT
	*
FROM
	[Defects_Print]
ORDER BY
	[Input Date] DESC
;

SELECT
	*
FROM
	[Defects_Print_Problems]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[TblSupplierClass]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[EftApSupplier]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[EftCshSupplier]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[InvAltSupplier]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[InvAppManfSupplier]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[SrqSupplier]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[SrqSupplierTrans]
;


--------------------


SELECT
	*
FROM
	[SysproCompanyA].[dbo].[ApSupplier]
ORDER BY
	[SupShortName]
;

SELECT DISTINCT
	[Supplier],
	[SupShortName]
FROM
	[SysproCompanyA].[dbo].[ApSupplier]
ORDER BY
	[SupShortName]
;

SELECT TOP 5000
	*
FROM
	[SysproCompanyA].[dbo].[PorMasterDetail]
ORDER BY
	[TimeStamp] DESC
;
