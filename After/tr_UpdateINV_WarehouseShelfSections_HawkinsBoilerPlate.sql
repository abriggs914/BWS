USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateINV_WarehouseShelfSections_HawkinsBoilerPlate]    Script Date: 2026-01-07 14:16:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-07 14:16:33>
-- Description:	<Maintain Boilerplate Columns>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateINV_WarehouseShelfSections_HawkinsBoilerPlate] 
ON [dbo].[INV_WarehouseShelfSections_Hawkins]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

UPDATE
    [BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins]
SET
    [LastModified] = GETDATE()
    , [DateCreated] = ISNULL([C].[DateCreated], GETDATE())
    , [DateActive] = (CASE 
        WHEN ([I].[Active] = 1) AND (([D].[Active] IS NULL) OR ([D].[Active] = 0)) THEN
            GETDATE()
        ELSE
            [C].[DateActive]
        END
    )
    , [DateInActive] = (CASE 
        WHEN ([I].[Active] = 0) AND (([D].[Active] IS NULL) OR ([D].[Active] = 1)) THEN
            GETDATE()
        ELSE
            [C].[DateInActive] 
        END
    )
FROM
    [BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins] [C]
INNER JOIN
    INSERTED [I]
ON
    [C].[ID] = [I].[ID]
LEFT JOIN
    DELETED [D]
ON
    [C].[ID] = [D].[ID]
;
END