USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateINV_WarehouseLayout_LegendHistory]    Script Date: 2026-01-07 08:41:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-07 08:41:55>
-- Description:	<Maintain History Table>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateINV_WarehouseLayout_LegendHistory] 
ON [dbo].[INV_WarehouseLayout_Legend]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO
        [BWSdb].[dbo].[hist_INV_WarehouseLayout_Legend]
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
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
            WHEN ([D].[Key] IS NULL) AND ([C].[Key] IS NOT NULL) THEN 'Key'
            WHEN ([I].[Key] IS NULL) AND ([D].[Key] IS NOT NULL) THEN 'Key'
            WHEN [D].[Key] <> [C].[Key] THEN 'Key'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Key] IS NULL) AND ([C].[Key] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Key] IS NULL) AND ([D].[Key] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Key] <> [C].[Key] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Key] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Key] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
            WHEN ([D].[Key] IS NULL) AND ([C].[Key] IS NOT NULL) THEN 1
            WHEN ([I].[Key] IS NULL) AND ([D].[Key] IS NOT NULL) THEN 1
            WHEN [D].[Key] <> [I].[Key] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Value] IS NULL) AND ([C].[Value] IS NOT NULL) THEN 'Value'
            WHEN ([I].[Value] IS NULL) AND ([D].[Value] IS NOT NULL) THEN 'Value'
            WHEN [D].[Value] <> [C].[Value] THEN 'Value'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Value] IS NULL) AND ([C].[Value] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Value] IS NULL) AND ([D].[Value] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Value] <> [C].[Value] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Value] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Value] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
            WHEN ([D].[Value] IS NULL) AND ([C].[Value] IS NOT NULL) THEN 1
            WHEN ([I].[Value] IS NULL) AND ([D].[Value] IS NOT NULL) THEN 1
            WHEN [D].[Value] <> [I].[Value] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[IsPath] IS NULL) AND ([C].[IsPath] IS NOT NULL) THEN 'IsPath'
            WHEN ([I].[IsPath] IS NULL) AND ([D].[IsPath] IS NOT NULL) THEN 'IsPath'
            WHEN [D].[IsPath] <> [C].[IsPath] THEN 'IsPath'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[IsPath] IS NULL) AND ([C].[IsPath] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[IsPath] IS NULL) AND ([D].[IsPath] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[IsPath] <> [C].[IsPath] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[IsPath] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[IsPath] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
            WHEN ([D].[IsPath] IS NULL) AND ([C].[IsPath] IS NOT NULL) THEN 1
            WHEN ([I].[IsPath] IS NULL) AND ([D].[IsPath] IS NOT NULL) THEN 1
            WHEN [D].[IsPath] <> [I].[IsPath] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[BG] IS NULL) AND ([C].[BG] IS NOT NULL) THEN 'BG'
            WHEN ([I].[BG] IS NULL) AND ([D].[BG] IS NOT NULL) THEN 'BG'
            WHEN [D].[BG] <> [C].[BG] THEN 'BG'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[BG] IS NULL) AND ([C].[BG] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[BG] IS NULL) AND ([D].[BG] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[BG] <> [C].[BG] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[BG] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[BG] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
            WHEN ([D].[BG] IS NULL) AND ([C].[BG] IS NOT NULL) THEN 1
            WHEN ([I].[BG] IS NULL) AND ([D].[BG] IS NOT NULL) THEN 1
            WHEN [D].[BG] <> [I].[BG] THEN 1
            ELSE 0
        END) > 0                        
                        
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[FG] IS NULL) AND ([C].[FG] IS NOT NULL) THEN 'FG'
            WHEN ([I].[FG] IS NULL) AND ([D].[FG] IS NOT NULL) THEN 'FG'
            WHEN [D].[FG] <> [C].[FG] THEN 'FG'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[FG] IS NULL) AND ([C].[FG] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[FG] IS NULL) AND ([D].[FG] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[FG] <> [C].[FG] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[FG] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[FG] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[INV_WarehouseLayout_Legend] [C]
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
            WHEN ([D].[FG] IS NULL) AND ([C].[FG] IS NOT NULL) THEN 1
            WHEN ([I].[FG] IS NULL) AND ([D].[FG] IS NOT NULL) THEN 1
            WHEN [D].[FG] <> [I].[FG] THEN 1
            ELSE 0
        END) > 0                        
                        

END