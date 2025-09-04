USE [SysproCompanyA]
GO

/****** Object:  Trigger [dbo].[tr_UpdateSorStatusCodesBoilerPlate]    Script Date: 2025-09-02 09:49:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-09-02 09:49:54>
-- Description:	<Maintain Boilerplate Columns>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateSorStatusCodesBoilerPlate] 
ON [dbo].[SorStatusCodes]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

UPDATE
    [SysproCompanyA].[dbo].[SorStatusCodes]
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
    [SysproCompanyA].[dbo].[SorStatusCodes] [C]
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