DECLARE @sd DATETIME = '2025-01-14';
DECLARE @ed DATETIME = '2025-06-30';

SELECT
	Production.[Prod Date],
	Orders.[Quote#],
	Orders.[WO#],
	Orders.[Model No],
	Orders.Width,
	Orders.Spread,
	[Sales Staff].[Sales Person],
	Orders.[Slot#],
	Orders.[WO Reviewed]
FROM (
	[BWSdb].[dbo].[Sales Staff]
INNER JOIN 
	[BWSdb].[dbo].[Orders]
ON
	[Sales Staff].[ID-SaleStaff]=Orders.[Sale PersonID]
)
INNER JOIN
	[BWSdb].[dbo].[Production]
ON 
	Orders.[Quote#]=Production.[Quote#]
WHERE (
	(
		(Production.[Prod Date]) Between @sd And @ed
	)
	And (
		(Orders.[WO Reviewed])=0 Or (Orders.[WO Reviewed]) Is Null
	)
)
ORDER BY
	[Model No]
	,[Prod Date]
	,[Quote#]
;


SELECT Production.[Prod Date], Orders.[Quote#], Orders.[wo#], Orders.[model no], Orders.width, Orders.spread, [Sales Staff].[Sales Person], Orders.[slot#], Orders.[WO Reviewed]
FROM (Orders INNER JOIN Production ON Orders.[Quote#] = Production.[Quote#]) INNER JOIN [Sales Staff] ON Orders.[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
--WHERE ((IIf([wo reviewed] Is Null,1,IIf([wo reviewed]=0,1,0))) = 1) AND (((Production.[Prod Date]) Between '2025-01-14 12:53:30 PM' And '2025-07-14 12:53:30 PM'));
WHERE (((CASE WHEN [wo reviewed] Is Null THEN 1 ELSE (CASE WHEN [wo reviewed]=0 THEN 1 ELSE 0 END) END)) = 1) AND (((Production.[Prod Date]) Between '2025-01-14 12:53:30 PM' And '2025-07-14 12:53:30 PM'));

exec [BWSdb].[dbo].sp_QuickRef_ListSimilarQuotes 31008

SELECT TOP 100
	*
FROM
	[Order Standards]
ORDER BY
	(CASE WHEN [Quote#] = 31009 THEN 0 ELSE 1 END)
;
SELECT TOP 100
	*
FROM
	[Order Options]
ORDER BY
	(CASE WHEN [Quote#] = 31009 THEN 0 ELSE 1 END)
;
SELECT TOP 100
	*
FROM
	[Custom Work]
ORDER BY
	(CASE WHEN [Quote#] = 31009 THEN 0 ELSE 1 END)
;