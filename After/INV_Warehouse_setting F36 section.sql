BEGIN TRAN;


UPDATE
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
SET

	[ShelfRow] = (
		CASE 
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'A' THEN 9
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'B' THEN 8
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'C' THEN 7
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'D' THEN 6
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'E' THEN 5
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'F' THEN 4
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'G' THEN 3
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'H' THEN 2
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'I' THEN 1
			WHEN SUBSTRING(UPPER([Shelf]), 4, 1) = 'J' THEN 0
			WHEN RIGHT(UPPER([Shelf]), 3) = 'TOP' THEN 10
			ELSE NULL
		END
	)
WHERE
	UPPER(LEFT([Shelf], 3)) = 'F36'

ROLLBACK;
COMMIT;