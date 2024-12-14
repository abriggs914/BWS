


SELECT
	[PL].*
FROM
	[BWSdb].[dbo].[ITP PhoneLines] [PL]
ORDER BY
	[PL].[Extension]
;

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ITP PhoneLines]
SET
	[Active] = 0,
	[AssignedTo] = NULL
WHERE
	[ID] = 37
	--[Extension] IS NULL
	--[ID] IN (
	--	48,49,50,51,52,53,54,55,56,57,58,59,1,
	--	7,16,18,27,32,34,43
	--)

ROLLBACK;
COMMIT;
*/
/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ITR Customers]
SET
	[Active] = 0
WHERE
	[CustomerID] IN (
		230,51,5,95,205,145,45,7,197,208,66,146,104,75,250,35
	)

ROLLBACK;
COMMIT;
*/
SELECT
	[IC].*
FROM
	[BWSdb].[dbo].[ITR Customers] [IC]
ORDER BY
	[IC].[Name]
;

SELECT
	*
FROM
	[BWSdb].[dbo].[v_ITP PhoneListData]

SELECT
	[IC].[CustomerID],
	[IC].[Name],
	[IC].[WorkExtension]
FROM
	[BWSdb].[dbo].[ITR Customers] [IC]
ORDER BY
	[IC].[Name]
;

SELECT
	[PL].*
	,[IC].*
FROM
	[BWSdb].[dbo].[ITP PhoneLines] [PL]
FULL JOIN
	[BWSdb].[dbo].[ITR Customers] [IC]
ON
	[PL].[AssignedTo] = [IC].[CustomerID]
ORDER BY
	[PL].[Extension]
;

SELECT
	[Extension]
FROM
	[BWSdb].[dbo].[ITP PhoneLines]
--GROUP BY
--	[Extension]
--HAVING
--	COUNT([Extension]) > 1
ORDER BY
	[Extension]

/*
BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ITR Customers]
SET
	[WorkExtension] = NULL
WHERE

ROLLBACK;
COMMIT;
*/