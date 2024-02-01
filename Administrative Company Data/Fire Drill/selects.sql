USE BWSdb
GO

SELECT
	[R_CustomerID]
	,*
FROM
	[v_ACDAllCustomersFireDrill]
;

SELECT
	*
FROM
	[v_ACD FireDrillRosterByBuilding]
;

SELECT
	*
FROM
	[ITI Buildings]
;

SELECT
	*
FROM
	[ITR Customers]
;

SELECT
	*
FROM
	[ITR Customers]
WHERE
	[CustomerID] = 150
;

SELECT
	*
FROM
	[ITR Customers]
WHERE
	[Name] LIKE '%GLEN%'
;

SELECT
	*
FROM
	[ACD FireDrillRoster]
ORDER BY
	[IDITRCustomers]
;

SELECT
	COUNT(*) AS [C]
	,[IDITRCustomers]
FROM
	[ACD FireDrillRoster]
--WHERE
	--[Active] = 1
GROUP BY
	[IDITRCustomers]
HAVING
	COUNT(*) > 1
ORDER BY
	[IDITRCustomers]

;

BEGIN TRAN;

DELETE FROM 
--UPDATE
	[ACD FireDrillRoster]
--SET
--	[Active] = 0
WHERE
	--[ID] IN (60, 62, 63)
	--[ID] = 62
	--[IDITRCustomers] IN (146, 150, 155, 195, 205)
	[ID] IN (63, 51, 52, 62, 56, 60, 61)
--ORDER BY
--	[IDITRCustomers]
--	,[ID]


ROLLBACK;
COMMIT;