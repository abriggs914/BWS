
-- 2026-01-20
-- Editing and initializing [INV_WarehouseShelfSections_Montana]

BEGIN TRAN;

SELECT
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
WHERE
	[Active] = 1
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X0] = [X0] + 1
WHERE
	[ID] BETWEEN 143 AND 160
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[Y1] = [Y1] - 1
WHERE
	[ID] IN (
		92, 112, 160, 180, 200, 220, 240, 260, 280
	)
;

/*
UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[Y1] = [Y1] + 3
WHERE
	[ID] IN (
		7, 27, 47, 67, 160, 180, 200, 220, 240, 260, 289, 309, 329, 349, 369, 389
	)
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X1] = [X1] + 3
WHERE
	[ID] BETWEEN 103 AND 112
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X0] = [X0] - 4
WHERE
	[ID] BETWEEN 88 AND 92
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[Y1] = [Y1] + 4
WHERE
	[ID] IN (92, 112)
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X1] = [X1] + 4
WHERE
	[ID] BETWEEN 383 AND 389
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X0] = [X0] - 5
WHERE
	[ID] BETWEEN 143 AND 160
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X1] = [X1] + 2
WHERE
	[ID] BETWEEN 243 AND 260
;

UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[X0] = [X0] - 2
WHERE
	[ID] BETWEEN 283 AND 289
;
*/

/*
UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[Y0] = [Y0] - 1
WHERE(
	[ID] IN (
		0, 23, 43, 63, 83, 103, 123, 143, 163 ,183, 203, 223, 243, 283, 303, 323, 343, 363, 383
	))
*/
/*
UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[Active] = 0
WHERE(
	[ID] IN (
		8, 68, 161, 181, 201, 221, 241, 261
	))


UPDATE
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]	
SET
	[Active] = 1
WHERE(
	[ID] IN (
		66
	))
*/
/*
	([ID] IN (
		5, 28, 48, 66, 93,
		113, 162, 182, 202, 222,
		242, 290, 310, 330, 350,
		370, 390
	))
	OR ([ID] BETWEEN 69 AND 73)
	OR ([ID] BETWEEN 123 AND 142)
	OR ([ID] BETWEEN 262 AND 282)
	OR ([ID] BETWEEN 403 AND 422)
	*/
	/*
	([ID] BETWEEN 9 AND 22)
	OR ([ID] BETWEEN 29 AND 42)
	OR ([ID] BETWEEN 49 AND 62)
	OR ([ID] BETWEEN 74 AND 82)
	OR ([ID] BETWEEN 94 AND 102)
	OR ([ID] BETWEEN 114 AND 122)
	OR ([ID] BETWEEN 291 AND 302)
	OR ([ID] BETWEEN 311 AND 322)
	OR ([ID] BETWEEN 331 AND 342)
	OR ([ID] BETWEEN 351 AND 362)
	OR ([ID] BETWEEN 371 AND 382)
	OR ([ID] BETWEEN 391 AND 402)
	OR ([ID] BETWEEN 411 AND 411)
	OR ([ID] > 422)	
	*/
SELECT
	*
FROM
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Montana]
WHERE
	[Active] = 1	
ROLLBACK;
COMMIT;