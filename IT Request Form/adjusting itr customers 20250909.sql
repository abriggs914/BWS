-- 2025-09-09
-- Adjusting [ITR Customers].[Active]


BEGIN TRAN;

UPDATE
	[BWSdb].[dbo].[ITR Customers]
SET
	[Active] = 0
WHERE
	[CustomerID] IN	(
		276,
		274,
		273,
		272,
		271,
		265,
		240,
		234,
		207,
		106,
		98,
		97,
		94,
		86,
		85,
		84,
		80,
		68,
		57,
		53,
		49,
		36,
		34,
		33,
		21
	)
;

UPDATE
	[BWSdb].[dbo].[ITR Customers]
SET
	[Active] = 1
WHERE
	[CustomerID] IN (
		104,
		7
	)
;

ROLLBACK;
COMMIT;