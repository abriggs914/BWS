USE BWSdb
GO

/*
SELECT
	*
FROM
	[Products]
WHERE [Model] LIKE
	CASE WHEN ([Model] LIKE '%20%') THEN
		1
	ELSE
		0
	END
*/

EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-28',
	@SlotStatus = 0
;
EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-28',
	@SlotStatus = 1
;
EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-28',
	@SlotStatus = 2
;
EXEC [sp_GetSlotReport]
	@StartDate = '2021-06-28'
;