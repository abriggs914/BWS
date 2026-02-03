SELECT
	[SSH].[Active] AS [SSH_Active],
	[SSH].[ParentShelf],
	[SSH].[ID] AS [SSH_ID],
	[HS].[ID] AS [HS_ID],
	[SSH].[Section] AS [SSH_Section],
	[SSH].[Group],
	[SSH].[x0],
	[SSH].[x1],
	[SSH].[y0],
	[SSH].[y1],
	[HS].[Active] AS [HS_Active],
	[HS].[Shelf],
	[HS].[ShelfRow],
	[HS].[Section] AS [HS_Section]
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves] [HS]
INNER JOIN
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins] [SSH]
ON
	[HS].[ShelfSectionID] = [SSH].[ID]
WHERE
	[SSH].[ID] IN (74, 75, 76)
ORDER BY
	--[Group]
	[Shelf]

SELECT
	[SSH].[Active] AS [SSH_Active],
	[SSH].[ParentShelf],
	[SSH].[ID] AS [SSH_ID],
	[HS].[ID] AS [HS_ID],
	[SSH].[Section] AS [SSH_Section],
	[SSH].[Group],
	[SSH].[x0],
	[SSH].[x1],
	[SSH].[y0],
	[SSH].[y1],
	[HS].[Active] AS [HS_Active],
	[HS].[Shelf],
	[HS].[ShelfRow],
	[HS].[Section] AS [HS_Section]
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves] [HS]
INNER JOIN
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins] [SSH]
ON
	[HS].[ShelfSectionID] = [SSH].[ID]
WHERE
	[HS].[ID] IN (74, 75, 76)
ORDER BY
	--[Group]
	[Shelf]



SELECT
	[SSH].[Active] AS [SSH_Active],
	[SSH].[ParentShelf],
	[SSH].[ID] AS [SSH_ID],
	[HS].[ID] AS [HS_ID],
	[SSH].[Section] AS [SSH_Section],
	[SSH].[Group],
	[SSH].[x0],
	[SSH].[x1],
	[SSH].[y0],
	[SSH].[y1],
	[HS].[Active] AS [HS_Active],
	[HS].[Shelf],
	[HS].[ShelfRow],
	[HS].[Section] AS [HS_Section]
FROM
	[BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves] [HS]
INNER JOIN
	[BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins] [SSH]
ON
	[HS].[ShelfSectionID] = [SSH].[ID]
ORDER BY
	--[Group]
	[Shelf]


	SELECT
		*
	FROM
		[INV_WarehouseShelfSections_Hawkins]
	WHERE
		[ID] = 75




	SELECT
		*
	FROM
	
	[INV_WarehouseLayout_HawkinsShelves]
WHERE
	[ShelfSectionID] = 75

	/*
BEGIN TRAN;

UPDATE
	
		[INV_WarehouseShelfSections_Hawkins]
SET
	[Active] = 0
	WHERE
		[ID] = 75
	

ROLLBACK;
COMMIT;
*/
