-- 2026-01-12
-- Selects


SELECT TOP (1000) [ID]
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


  SELECT TOP (1000) [ID]
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
