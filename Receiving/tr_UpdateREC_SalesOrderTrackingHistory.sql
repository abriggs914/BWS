USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateREC_SalesOrderTrackingHistory]    Script Date: 2025-10-15 11:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2025-10-15 11:55:49>
-- Description:	<Maintain History Table>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateREC_SalesOrderTrackingHistory] 
ON [dbo].[REC_SalesOrderTracking]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO
        [BWSdb].[dbo].[hist_REC_SalesOrderTracking]
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
        [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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
        [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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
        [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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
        [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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
        [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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
        [BWSdb].[dbo].[REC_SalesOrderTracking] [C]
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
            WHEN ([D].[SalesOrder] IS NULL) AND ([C].[SalesOrder] IS NOT NULL) THEN 'SalesOrder'
            WHEN ([I].[SalesOrder] IS NULL) AND ([D].[SalesOrder] IS NOT NULL) THEN 'SalesOrder'
            WHEN [D].[SalesOrder] <> [C].[SalesOrder] THEN 'SalesOrder'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[SalesOrder] IS NULL) AND ([C].[SalesOrder] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[SalesOrder] IS NULL) AND ([D].[SalesOrder] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[SalesOrder] <> [C].[SalesOrder] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[SalesOrder] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[SalesOrder] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[SalesOrder] IS NULL) AND ([C].[SalesOrder] IS NOT NULL) THEN 1
            WHEN ([I].[SalesOrder] IS NULL) AND ([D].[SalesOrder] IS NOT NULL) THEN 1
            WHEN [D].[SalesOrder] <> [I].[SalesOrder] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[RequestDate] IS NULL) AND ([C].[RequestDate] IS NOT NULL) THEN 'RequestDate'
            WHEN ([I].[RequestDate] IS NULL) AND ([D].[RequestDate] IS NOT NULL) THEN 'RequestDate'
            WHEN [D].[RequestDate] <> [C].[RequestDate] THEN 'RequestDate'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[RequestDate] IS NULL) AND ([C].[RequestDate] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[RequestDate] IS NULL) AND ([D].[RequestDate] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[RequestDate] <> [C].[RequestDate] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[RequestDate] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[RequestDate] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[RequestDate] IS NULL) AND ([C].[RequestDate] IS NOT NULL) THEN 1
            WHEN ([I].[RequestDate] IS NULL) AND ([D].[RequestDate] IS NOT NULL) THEN 1
            WHEN [D].[RequestDate] <> [I].[RequestDate] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[StartDate] IS NULL) AND ([C].[StartDate] IS NOT NULL) THEN 'StartDate'
            WHEN ([I].[StartDate] IS NULL) AND ([D].[StartDate] IS NOT NULL) THEN 'StartDate'
            WHEN [D].[StartDate] <> [C].[StartDate] THEN 'StartDate'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[StartDate] IS NULL) AND ([C].[StartDate] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[StartDate] IS NULL) AND ([D].[StartDate] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[StartDate] <> [C].[StartDate] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[StartDate] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[StartDate] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[StartDate] IS NULL) AND ([C].[StartDate] IS NOT NULL) THEN 1
            WHEN ([I].[StartDate] IS NULL) AND ([D].[StartDate] IS NOT NULL) THEN 1
            WHEN [D].[StartDate] <> [I].[StartDate] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[CompleteDate] IS NULL) AND ([C].[CompleteDate] IS NOT NULL) THEN 'CompleteDate'
            WHEN ([I].[CompleteDate] IS NULL) AND ([D].[CompleteDate] IS NOT NULL) THEN 'CompleteDate'
            WHEN [D].[CompleteDate] <> [C].[CompleteDate] THEN 'CompleteDate'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[CompleteDate] IS NULL) AND ([C].[CompleteDate] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[CompleteDate] IS NULL) AND ([D].[CompleteDate] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[CompleteDate] <> [C].[CompleteDate] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[CompleteDate] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[CompleteDate] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[CompleteDate] IS NULL) AND ([C].[CompleteDate] IS NOT NULL) THEN 1
            WHEN ([I].[CompleteDate] IS NULL) AND ([D].[CompleteDate] IS NOT NULL) THEN 1
            WHEN [D].[CompleteDate] <> [I].[CompleteDate] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[ShipDate] IS NULL) AND ([C].[ShipDate] IS NOT NULL) THEN 'ShipDate'
            WHEN ([I].[ShipDate] IS NULL) AND ([D].[ShipDate] IS NOT NULL) THEN 'ShipDate'
            WHEN [D].[ShipDate] <> [C].[ShipDate] THEN 'ShipDate'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[ShipDate] IS NULL) AND ([C].[ShipDate] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[ShipDate] IS NULL) AND ([D].[ShipDate] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[ShipDate] <> [C].[ShipDate] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[ShipDate] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[ShipDate] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[ShipDate] IS NULL) AND ([C].[ShipDate] IS NOT NULL) THEN 1
            WHEN ([I].[ShipDate] IS NULL) AND ([D].[ShipDate] IS NOT NULL) THEN 1
            WHEN [D].[ShipDate] <> [I].[ShipDate] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Printed] IS NULL) AND ([C].[Printed] IS NOT NULL) THEN 'Printed'
            WHEN ([I].[Printed] IS NULL) AND ([D].[Printed] IS NOT NULL) THEN 'Printed'
            WHEN [D].[Printed] <> [C].[Printed] THEN 'Printed'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Printed] IS NULL) AND ([C].[Printed] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Printed] IS NULL) AND ([D].[Printed] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Printed] <> [C].[Printed] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Printed] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Printed] AS NVARCHAR(MAX)) AS [ValueAfter]
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
    WHERE 
        (CASE
            WHEN ([D].[Printed] IS NULL) AND ([C].[Printed] IS NOT NULL) THEN 1
            WHEN ([I].[Printed] IS NULL) AND ([D].[Printed] IS NOT NULL) THEN 1
            WHEN [D].[Printed] <> [I].[Printed] THEN 1
            ELSE 0
        END) > 0                        


END