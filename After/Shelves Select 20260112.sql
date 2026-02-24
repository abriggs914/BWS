-- 2026-01-12
-- Selects


SELECT [ID]
      ,[DateCreated]
      ,[LastModified]
      ,[Active]
      ,[DateActive]
      ,[DateInActive]
      ,[ParentShelf]
      ,[Section]
      ,[Group]
      ,[X0]
      ,[X1]
      ,[Y0]
      ,[Y1]
  FROM [BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins]


  SELECT [ID]
      ,[DateCreated]
      ,[LastModified]
      ,[Active]
      ,[DateActive]
      ,[DateInActive]
      ,[Section]
      ,[ShelfSectionID]
      ,[Shelf]
      ,[ShelfRow]
  FROM [BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
  
  SELECT [ID]
      ,[DateCreated]
      ,[LastModified]
      ,[Active]
      ,[DateActive]
      ,[DateInActive]
      ,[Section]
      ,[ShelfSectionID]
      ,[Shelf]
      ,[ShelfRow]
  FROM [BWSdb].[dbo].[INV_WarehouseLayout_HawkinsShelves]
	WHERE [Shelf] = 'E15'




SELECT
	
      [ParentShelf]
      ,[Section]
      ,[Group]
      ,[X0]
      ,[X1]
      ,[Y0]
      ,[Y1]
  FROM [BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins]
  GROUP BY
  
      [ParentShelf]
      ,[Section]
      ,[Group]
      ,[X0]
      ,[X1]
      ,[Y0]
      ,[Y1]
	HAVING
		COUNT(*) > 1