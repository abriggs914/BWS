-- 2026-02-09
-- INV_WarehouseLayout_MontanaShelves init


BEGIN TRAN;

INSERT INTO [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves] ([Section], [ShelfSectionID], [Shelf], [ShelfRow]) VALUES
--('A', 92, 'WH4A1A', 6)
('A', 92, 'WH4A1C', 6)


SELECT SCOPE_IDENTITY()


ROLLBACK;
COMMIT;