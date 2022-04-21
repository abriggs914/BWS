--SELECT 
--	OrdersV2.[WO#],
--	OrdersV2.[Model No],
--	OrdersV2.Width,
--	OrdersV2.Spread,
--	OrdersV2.[Serial Number],
--	DealersV2.[COMPANY NAME],
--	OrdersV2.[Shipped Date],
--	OrdersV2.[Date In Service],
--	OrdersV2.DealerSalesPersonID,
--	DealersV2.ID
--INTO
--	tblCustomersForm
--FROM
--	tblCustomerFormSNParam,
--	DealersV2
--INNER JOIN
--	OrdersV2 ON DealersV2.ID = OrdersV2.DealerID
--WHERE
--	(((OrdersV2.[WO#]) Is Not Null) AND ((OrdersV2.[Serial Number]) Like "*" & [tblCustomerFormSNParam].[PartofSN] & "*"));

SELECT 
	OrdersV2.[WO#],
	OrdersV2.[Model No],
	OrdersV2.Width,
	OrdersV2.Spread,
	OrdersV2.[Serial Number],
	DealersV2.[COMPANY NAME],
	OrdersV2.[Shipped Date],
	OrdersV2.[Date In Service],
	OrdersV2.DealerSalesPersonID,
	DealersV2.ID
INTO
	tblCustomersForm3
SELECT 
	OrdersV2.[WO#],
	OrdersV2.[Model No],
	OrdersV2.Width,
	OrdersV2.Spread,
	OrdersV2.[Serial Number],
	DealersV2.[COMPANY NAME],
	OrdersV2.[Shipped Date],
	OrdersV2.[Date In Service],
	OrdersV2.DealerSalesPersonID,
	DealersV2.ID
FROM
	--tblCustomerFormSNParam,
	DealersV2
INNER JOIN
	OrdersV2 ON DealersV2.ID = OrdersV2.DealerID
WHERE
	--(((OrdersV2.[WO#]) Is Not Null) AND ((OrdersV2.[Serial Number]) Like "*" & [tblCustomerFormSNParam].[PartofSN] & "*"));
	(((OrdersV2.[WO#]) Is Not Null) AND ((OrdersV2.[Serial Number]) Like '*' + '8762' + '*'));

ROLLBACK;

SELECT *
FROM
	tblCustomersForm
WHERE
	[Serial Number] LIKE '*8762*'
SELECT *
FROM
	[OrdersV2]
WHERE
	[Serial Number] LIKE '%8762%'
SELECT *
FROM
	[Orders]
WHERE
	[Serial Number] LIKE '%8762%'

SELECT *
FROM
	[OrdersV2]
WHERE
	[Customer WO#] LIKE '%2S9DS457XNM118762%'
SELECT *
FROM
	[Orders]
WHERE
	[Customer WO#] = '%2S9DS457XNM118762%'


SELECT [Serial Number]
FROM
	[OrdersV2]
ORDER BY
	[Serial Number]
SELECT [Serial Number]
FROM
	[Orders]
ORDER BY
	[Serial Number]


SELECT [Customer WO#] 
FROM
	[OrdersV2]
WHERE
[Customer WO#] IS NOT NULL



SELECT *
FROM
	[OrdersV2]
WHERE
	[Serial Number] LIKE '%8762%'
SELECT *
FROM
	[Orders]
WHERE
	[Serial Number] LIKE '%8762%'
