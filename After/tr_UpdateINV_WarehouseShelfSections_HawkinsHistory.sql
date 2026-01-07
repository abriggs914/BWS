USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateINV_WarehouseShelfSections_HawkinsHistory]    Script Date: 2026-01-07 14:16:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-07 14:16:33>
-- Description:	<Maintain History Table>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateINV_WarehouseShelfSections_HawkinsHistory] 
ON [dbo].[INV_WarehouseShelfSections_Hawkins]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO
        [BWSdb].[dbo].[hist_INV_WarehouseShelfSections_Hawkins]
    (
        [NestLevel],
        [ModifiedID],
        [ModifiedBy],
        [ModifiedColumn],
        [Modification],
        [ValueBefore],
        [ValueAfter]
    )
    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[ID] IS NULL) AND ([C].[ID] IS NOT NULL) THEN 'ID'
            WHEN ([I].[ID] IS NULL) AND ([D].[ID] IS NOT NULL) THEN 'ID'
            WHEN [D].[ID] <> [C].[ID] THEN 'ID'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[ID] IS NULL) AND ([C].[ID] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[ID] IS NULL) AND ([D].[ID] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[ID] <> [C].[ID] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[ID] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[ID] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[ID] IS NULL) AND ([C].[ID] IS NOT NULL) THEN 1
            WHEN ([I].[ID] IS NULL) AND ([D].[ID] IS NOT NULL) THEN 1
            WHEN [D].[ID] <> [I].[ID] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[DateCreated] IS NULL) AND ([C].[DateCreated] IS NOT NULL) THEN 'DateCreated'
            WHEN ([I].[DateCreated] IS NULL) AND ([D].[DateCreated] IS NOT NULL) THEN 'DateCreated'
            WHEN [D].[DateCreated] <> [C].[DateCreated] THEN 'DateCreated'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[DateCreated] IS NULL) AND ([C].[DateCreated] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[DateCreated] IS NULL) AND ([D].[DateCreated] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[DateCreated] <> [C].[DateCreated] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[DateCreated] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[DateCreated] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[DateCreated] IS NULL) AND ([C].[DateCreated] IS NOT NULL) THEN 1
            WHEN ([I].[DateCreated] IS NULL) AND ([D].[DateCreated] IS NOT NULL) THEN 1
            WHEN [D].[DateCreated] <> [I].[DateCreated] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[LastModified] IS NULL) AND ([C].[LastModified] IS NOT NULL) THEN 'LastModified'
            WHEN ([I].[LastModified] IS NULL) AND ([D].[LastModified] IS NOT NULL) THEN 'LastModified'
            WHEN [D].[LastModified] <> [C].[LastModified] THEN 'LastModified'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[LastModified] IS NULL) AND ([C].[LastModified] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[LastModified] IS NULL) AND ([D].[LastModified] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[LastModified] <> [C].[LastModified] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[LastModified] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[LastModified] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[LastModified] IS NULL) AND ([C].[LastModified] IS NOT NULL) THEN 1
            WHEN ([I].[LastModified] IS NULL) AND ([D].[LastModified] IS NOT NULL) THEN 1
            WHEN [D].[LastModified] <> [I].[LastModified] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Active] IS NULL) AND ([C].[Active] IS NOT NULL) THEN 'Active'
            WHEN ([I].[Active] IS NULL) AND ([D].[Active] IS NOT NULL) THEN 'Active'
            WHEN [D].[Active] <> [C].[Active] THEN 'Active'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Active] IS NULL) AND ([C].[Active] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Active] IS NULL) AND ([D].[Active] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Active] <> [C].[Active] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Active] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Active] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[Active] IS NULL) AND ([C].[Active] IS NOT NULL) THEN 1
            WHEN ([I].[Active] IS NULL) AND ([D].[Active] IS NOT NULL) THEN 1
            WHEN [D].[Active] <> [I].[Active] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[DateActive] IS NULL) AND ([C].[DateActive] IS NOT NULL) THEN 'DateActive'
            WHEN ([I].[DateActive] IS NULL) AND ([D].[DateActive] IS NOT NULL) THEN 'DateActive'
            WHEN [D].[DateActive] <> [C].[DateActive] THEN 'DateActive'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[DateActive] IS NULL) AND ([C].[DateActive] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[DateActive] IS NULL) AND ([D].[DateActive] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[DateActive] <> [C].[DateActive] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[DateActive] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[DateActive] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[DateActive] IS NULL) AND ([C].[DateActive] IS NOT NULL) THEN 1
            WHEN ([I].[DateActive] IS NULL) AND ([D].[DateActive] IS NOT NULL) THEN 1
            WHEN [D].[DateActive] <> [I].[DateActive] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[DateInActive] IS NULL) AND ([C].[DateInActive] IS NOT NULL) THEN 'DateInActive'
            WHEN ([I].[DateInActive] IS NULL) AND ([D].[DateInActive] IS NOT NULL) THEN 'DateInActive'
            WHEN [D].[DateInActive] <> [C].[DateInActive] THEN 'DateInActive'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[DateInActive] IS NULL) AND ([C].[DateInActive] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[DateInActive] IS NULL) AND ([D].[DateInActive] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[DateInActive] <> [C].[DateInActive] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[DateInActive] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[DateInActive] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[DateInActive] IS NULL) AND ([C].[DateInActive] IS NOT NULL) THEN 1
            WHEN ([I].[DateInActive] IS NULL) AND ([D].[DateInActive] IS NOT NULL) THEN 1
            WHEN [D].[DateInActive] <> [I].[DateInActive] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[ParentShelf] IS NULL) AND ([C].[ParentShelf] IS NOT NULL) THEN 'ParentShelf'
            WHEN ([I].[ParentShelf] IS NULL) AND ([D].[ParentShelf] IS NOT NULL) THEN 'ParentShelf'
            WHEN [D].[ParentShelf] <> [C].[ParentShelf] THEN 'ParentShelf'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[ParentShelf] IS NULL) AND ([C].[ParentShelf] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[ParentShelf] IS NULL) AND ([D].[ParentShelf] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[ParentShelf] <> [C].[ParentShelf] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[ParentShelf] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[ParentShelf] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[ParentShelf] IS NULL) AND ([C].[ParentShelf] IS NOT NULL) THEN 1
            WHEN ([I].[ParentShelf] IS NULL) AND ([D].[ParentShelf] IS NOT NULL) THEN 1
            WHEN [D].[ParentShelf] <> [I].[ParentShelf] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Section] IS NULL) AND ([C].[Section] IS NOT NULL) THEN 'Section'
            WHEN ([I].[Section] IS NULL) AND ([D].[Section] IS NOT NULL) THEN 'Section'
            WHEN [D].[Section] <> [C].[Section] THEN 'Section'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Section] IS NULL) AND ([C].[Section] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Section] IS NULL) AND ([D].[Section] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Section] <> [C].[Section] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Section] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Section] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[Section] IS NULL) AND ([C].[Section] IS NOT NULL) THEN 1
            WHEN ([I].[Section] IS NULL) AND ([D].[Section] IS NOT NULL) THEN 1
            WHEN [D].[Section] <> [I].[Section] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Group] IS NULL) AND ([C].[Group] IS NOT NULL) THEN 'Group'
            WHEN ([I].[Group] IS NULL) AND ([D].[Group] IS NOT NULL) THEN 'Group'
            WHEN [D].[Group] <> [C].[Group] THEN 'Group'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Group] IS NULL) AND ([C].[Group] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Group] IS NULL) AND ([D].[Group] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Group] <> [C].[Group] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Group] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Group] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[Group] IS NULL) AND ([C].[Group] IS NOT NULL) THEN 1
            WHEN ([I].[Group] IS NULL) AND ([D].[Group] IS NOT NULL) THEN 1
            WHEN [D].[Group] <> [I].[Group] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[X0] IS NULL) AND ([C].[X0] IS NOT NULL) THEN 'X0'
            WHEN ([I].[X0] IS NULL) AND ([D].[X0] IS NOT NULL) THEN 'X0'
            WHEN [D].[X0] <> [C].[X0] THEN 'X0'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[X0] IS NULL) AND ([C].[X0] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[X0] IS NULL) AND ([D].[X0] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[X0] <> [C].[X0] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[X0] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[X0] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[X0] IS NULL) AND ([C].[X0] IS NOT NULL) THEN 1
            WHEN ([I].[X0] IS NULL) AND ([D].[X0] IS NOT NULL) THEN 1
            WHEN [D].[X0] <> [I].[X0] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[X1] IS NULL) AND ([C].[X1] IS NOT NULL) THEN 'X1'
            WHEN ([I].[X1] IS NULL) AND ([D].[X1] IS NOT NULL) THEN 'X1'
            WHEN [D].[X1] <> [C].[X1] THEN 'X1'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[X1] IS NULL) AND ([C].[X1] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[X1] IS NULL) AND ([D].[X1] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[X1] <> [C].[X1] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[X1] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[X1] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[X1] IS NULL) AND ([C].[X1] IS NOT NULL) THEN 1
            WHEN ([I].[X1] IS NULL) AND ([D].[X1] IS NOT NULL) THEN 1
            WHEN [D].[X1] <> [I].[X1] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Y0] IS NULL) AND ([C].[Y0] IS NOT NULL) THEN 'Y0'
            WHEN ([I].[Y0] IS NULL) AND ([D].[Y0] IS NOT NULL) THEN 'Y0'
            WHEN [D].[Y0] <> [C].[Y0] THEN 'Y0'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Y0] IS NULL) AND ([C].[Y0] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Y0] IS NULL) AND ([D].[Y0] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Y0] <> [C].[Y0] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Y0] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Y0] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[Y0] IS NULL) AND ([C].[Y0] IS NOT NULL) THEN 1
            WHEN ([I].[Y0] IS NULL) AND ([D].[Y0] IS NOT NULL) THEN 1
            WHEN [D].[Y0] <> [I].[Y0] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Y1] IS NULL) AND ([C].[Y1] IS NOT NULL) THEN 'Y1'
            WHEN ([I].[Y1] IS NULL) AND ([D].[Y1] IS NOT NULL) THEN 'Y1'
            WHEN [D].[Y1] <> [C].[Y1] THEN 'Y1'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Y1] IS NULL) AND ([C].[Y1] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Y1] IS NULL) AND ([D].[Y1] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Y1] <> [C].[Y1] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Y1] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Y1] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[Y1] IS NULL) AND ([C].[Y1] IS NOT NULL) THEN 1
            WHEN ([I].[Y1] IS NULL) AND ([D].[Y1] IS NOT NULL) THEN 1
            WHEN [D].[Y1] <> [I].[Y1] THEN 1
            ELSE 0
        END) > 0                        
                        

END