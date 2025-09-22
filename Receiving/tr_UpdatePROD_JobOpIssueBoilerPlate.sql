USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdatePROD_JobOpIssueBoilerPlate]    Script Date: 2025-09-22 12:04:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-09-22 12:04:01>
-- Description:	<Maintain Boilerplate Columns>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdatePROD_JobOpIssueBoilerPlate] 
ON [dbo].[PROD_JobOpIssue]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

UPDATE
    [BWSdb].[dbo].[PROD_JobOpIssue]
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
    [BWSdb].[dbo].[PROD_JobOpIssue] [C]
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