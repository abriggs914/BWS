USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateREC_SalesOrderTrackingBoilerPlate]    Script Date: 2025-10-15 11:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2025-10-15 11:55:49>
-- Description:	<Maintain Boilerplate Columns>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateREC_SalesOrderTrackingBoilerPlate] 
ON [dbo].[REC_SalesOrderTracking]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

UPDATE
    [BWSdb].[dbo].[REC_SalesOrderTracking]
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
    [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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