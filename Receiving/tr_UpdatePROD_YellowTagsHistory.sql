USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdatePROD_YellowTagsHistory]    Script Date: 2025-07-28 11:06:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-07-28 11:06:00>
-- Description:	<Maintain History Table>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdatePROD_YellowTagsHistory] 
ON [dbo].[PROD_YellowTags]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO
        [BWSdb].[dbo].[hist_PROD_YellowTags]
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
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[WO] IS NULL) AND ([C].[WO] IS NOT NULL) THEN 'WO'
            WHEN ([I].[WO] IS NULL) AND ([D].[WO] IS NOT NULL) THEN 'WO'
            WHEN [D].[WO] <> [C].[WO] THEN 'WO'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[WO] IS NULL) AND ([C].[WO] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[WO] IS NULL) AND ([D].[WO] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[WO] <> [C].[WO] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[WO] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[WO] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[WO] IS NULL) AND ([C].[WO] IS NOT NULL) THEN 1
            WHEN ([I].[WO] IS NULL) AND ([D].[WO] IS NOT NULL) THEN 1
            WHEN [D].[WO] <> [I].[WO] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[StockCode] IS NULL) AND ([C].[StockCode] IS NOT NULL) THEN 'StockCode'
            WHEN ([I].[StockCode] IS NULL) AND ([D].[StockCode] IS NOT NULL) THEN 'StockCode'
            WHEN [D].[StockCode] <> [C].[StockCode] THEN 'StockCode'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[StockCode] IS NULL) AND ([C].[StockCode] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[StockCode] IS NULL) AND ([D].[StockCode] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[StockCode] <> [C].[StockCode] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[StockCode] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[StockCode] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[StockCode] IS NULL) AND ([C].[StockCode] IS NOT NULL) THEN 1
            WHEN ([I].[StockCode] IS NULL) AND ([D].[StockCode] IS NOT NULL) THEN 1
            WHEN [D].[StockCode] <> [I].[StockCode] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Description] IS NULL) AND ([C].[Description] IS NOT NULL) THEN 'Description'
            WHEN ([I].[Description] IS NULL) AND ([D].[Description] IS NOT NULL) THEN 'Description'
            WHEN [D].[Description] <> [C].[Description] THEN 'Description'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Description] IS NULL) AND ([C].[Description] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Description] IS NULL) AND ([D].[Description] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Description] <> [C].[Description] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Description] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Description] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[Description] IS NULL) AND ([C].[Description] IS NOT NULL) THEN 1
            WHEN ([I].[Description] IS NULL) AND ([D].[Description] IS NOT NULL) THEN 1
            WHEN [D].[Description] <> [I].[Description] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[QtyMissing] IS NULL) AND ([C].[QtyMissing] IS NOT NULL) THEN 'QtyMissing'
            WHEN ([I].[QtyMissing] IS NULL) AND ([D].[QtyMissing] IS NOT NULL) THEN 'QtyMissing'
            WHEN [D].[QtyMissing] <> [C].[QtyMissing] THEN 'QtyMissing'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[QtyMissing] IS NULL) AND ([C].[QtyMissing] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[QtyMissing] IS NULL) AND ([D].[QtyMissing] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[QtyMissing] <> [C].[QtyMissing] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[QtyMissing] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[QtyMissing] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[QtyMissing] IS NULL) AND ([C].[QtyMissing] IS NOT NULL) THEN 1
            WHEN ([I].[QtyMissing] IS NULL) AND ([D].[QtyMissing] IS NOT NULL) THEN 1
            WHEN [D].[QtyMissing] <> [I].[QtyMissing] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Supplier] IS NULL) AND ([C].[Supplier] IS NOT NULL) THEN 'Supplier'
            WHEN ([I].[Supplier] IS NULL) AND ([D].[Supplier] IS NOT NULL) THEN 'Supplier'
            WHEN [D].[Supplier] <> [C].[Supplier] THEN 'Supplier'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Supplier] IS NULL) AND ([C].[Supplier] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Supplier] IS NULL) AND ([D].[Supplier] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Supplier] <> [C].[Supplier] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Supplier] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Supplier] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[Supplier] IS NULL) AND ([C].[Supplier] IS NOT NULL) THEN 1
            WHEN ([I].[Supplier] IS NULL) AND ([D].[Supplier] IS NOT NULL) THEN 1
            WHEN [D].[Supplier] <> [I].[Supplier] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[PO] IS NULL) AND ([C].[PO] IS NOT NULL) THEN 'PO'
            WHEN ([I].[PO] IS NULL) AND ([D].[PO] IS NOT NULL) THEN 'PO'
            WHEN [D].[PO] <> [C].[PO] THEN 'PO'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[PO] IS NULL) AND ([C].[PO] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[PO] IS NULL) AND ([D].[PO] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[PO] <> [C].[PO] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[PO] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[PO] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[PO] IS NULL) AND ([C].[PO] IS NOT NULL) THEN 1
            WHEN ([I].[PO] IS NULL) AND ([D].[PO] IS NOT NULL) THEN 1
            WHEN [D].[PO] <> [I].[PO] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Notes] IS NULL) AND ([C].[Notes] IS NOT NULL) THEN 'Notes'
            WHEN ([I].[Notes] IS NULL) AND ([D].[Notes] IS NOT NULL) THEN 'Notes'
            WHEN [D].[Notes] <> [C].[Notes] THEN 'Notes'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Notes] IS NULL) AND ([C].[Notes] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Notes] IS NULL) AND ([D].[Notes] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Notes] <> [C].[Notes] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Notes] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Notes] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[PROD_YellowTags] [C]
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
            WHEN ([D].[Notes] IS NULL) AND ([C].[Notes] IS NOT NULL) THEN 1
            WHEN ([I].[Notes] IS NULL) AND ([D].[Notes] IS NOT NULL) THEN 1
            WHEN [D].[Notes] <> [I].[Notes] THEN 1
            ELSE 0
        END) > 0                        


END