USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateREC_EventsHistory]    Script Date: 2025-06-30 08:40:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-06-30 08:40:00>
-- Description:	<Maintain History Table>
-- =============================================
ALTER TRIGGER [dbo].[tr_UpdateREC_EventsHistory] 
ON [dbo].[REC_Events]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO
        [BWSdb].[dbo].[hist_REC_Events]
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
        [BWSdb].[dbo].[REC_Events] [C]
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
        [BWSdb].[dbo].[REC_Events] [C]
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
        [BWSdb].[dbo].[REC_Events] [C]
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
        [BWSdb].[dbo].[REC_Events] [C]
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
        [BWSdb].[dbo].[REC_Events] [C]
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
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[DateEvent] IS NULL) AND ([C].[DateEvent] IS NOT NULL) THEN 'DateEvent'
            WHEN ([I].[DateEvent] IS NULL) AND ([D].[DateEvent] IS NOT NULL) THEN 'DateEvent'
            WHEN [D].[DateEvent] <> [C].[DateEvent] THEN 'DateEvent'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[DateEvent] IS NULL) AND ([C].[DateEvent] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[DateEvent] IS NULL) AND ([D].[DateEvent] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[DateEvent] <> [C].[DateEvent] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[DateEvent] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[DateEvent] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[DateEvent] IS NULL) AND ([C].[DateEvent] IS NOT NULL) THEN 1
            WHEN ([I].[DateEvent] IS NULL) AND ([D].[DateEvent] IS NOT NULL) THEN 1
            WHEN [D].[DateEvent] <> [I].[DateEvent] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[TimeEvent] IS NULL) AND ([C].[TimeEvent] IS NOT NULL) THEN 'TimeEvent'
            WHEN ([I].[TimeEvent] IS NULL) AND ([D].[TimeEvent] IS NOT NULL) THEN 'TimeEvent'
            WHEN [D].[TimeEvent] <> [C].[TimeEvent] THEN 'TimeEvent'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[TimeEvent] IS NULL) AND ([C].[TimeEvent] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[TimeEvent] IS NULL) AND ([D].[TimeEvent] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[TimeEvent] <> [C].[TimeEvent] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[TimeEvent] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[TimeEvent] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[TimeEvent] IS NULL) AND ([C].[TimeEvent] IS NOT NULL) THEN 1
            WHEN ([I].[TimeEvent] IS NULL) AND ([D].[TimeEvent] IS NOT NULL) THEN 1
            WHEN [D].[TimeEvent] <> [I].[TimeEvent] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Contact] IS NULL) AND ([C].[Contact] IS NOT NULL) THEN 'Contact'
            WHEN ([I].[Contact] IS NULL) AND ([D].[Contact] IS NOT NULL) THEN 'Contact'
            WHEN [D].[Contact] <> [C].[Contact] THEN 'Contact'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Contact] IS NULL) AND ([C].[Contact] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Contact] IS NULL) AND ([D].[Contact] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Contact] <> [C].[Contact] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Contact] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Contact] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[Contact] IS NULL) AND ([C].[Contact] IS NOT NULL) THEN 1
            WHEN ([I].[Contact] IS NULL) AND ([D].[Contact] IS NOT NULL) THEN 1
            WHEN [D].[Contact] <> [I].[Contact] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Job] IS NULL) AND ([C].[Job] IS NOT NULL) THEN 'Job'
            WHEN ([I].[Job] IS NULL) AND ([D].[Job] IS NOT NULL) THEN 'Job'
            WHEN [D].[Job] <> [C].[Job] THEN 'Job'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Job] IS NULL) AND ([C].[Job] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Job] IS NULL) AND ([D].[Job] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Job] <> [C].[Job] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Job] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Job] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[Job] IS NULL) AND ([C].[Job] IS NOT NULL) THEN 1
            WHEN ([I].[Job] IS NULL) AND ([D].[Job] IS NOT NULL) THEN 1
            WHEN [D].[Job] <> [I].[Job] THEN 1
            ELSE 0
        END) > 0           
		
	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Qty] IS NULL) AND ([C].[Qty] IS NOT NULL) THEN 'Qty'
            WHEN ([I].[Qty] IS NULL) AND ([D].[Qty] IS NOT NULL) THEN 'Qty'
            WHEN [D].[Qty] <> [C].[Qty] THEN 'Qty'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Qty] IS NULL) AND ([C].[Qty] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Qty] IS NULL) AND ([D].[Qty] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Qty] <> [C].[Qty] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Qty] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Qty] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[Qty] IS NULL) AND ([C].[Qty] IS NOT NULL) THEN 1
            WHEN ([I].[Qty] IS NULL) AND ([D].[Qty] IS NOT NULL) THEN 1
            WHEN [D].[Qty] <> [I].[Qty] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[UOM] IS NULL) AND ([C].[UOM] IS NOT NULL) THEN 'UOM'
            WHEN ([I].[UOM] IS NULL) AND ([D].[UOM] IS NOT NULL) THEN 'UOM'
            WHEN [D].[UOM] <> [C].[UOM] THEN 'UOM'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[UOM] IS NULL) AND ([C].[UOM] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[UOM] IS NULL) AND ([D].[UOM] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[UOM] <> [C].[UOM] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[UOM] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[UOM] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[UOM] IS NULL) AND ([C].[UOM] IS NOT NULL) THEN 1
            WHEN ([I].[UOM] IS NULL) AND ([D].[UOM] IS NOT NULL) THEN 1
            WHEN [D].[UOM] <> [I].[UOM] THEN 1
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
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[DateIssued] IS NULL) AND ([C].[DateIssued] IS NOT NULL) THEN 'DateIssued'
            WHEN ([I].[DateIssued] IS NULL) AND ([D].[DateIssued] IS NOT NULL) THEN 'DateIssued'
            WHEN [D].[DateIssued] <> [C].[DateIssued] THEN 'DateIssued'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[DateIssued] IS NULL) AND ([C].[DateIssued] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[DateIssued] IS NULL) AND ([D].[DateIssued] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[DateIssued] <> [C].[DateIssued] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[DateIssued] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[DateIssued] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[DateIssued] IS NULL) AND ([C].[DateIssued] IS NOT NULL) THEN 1
            WHEN ([I].[DateIssued] IS NULL) AND ([D].[DateIssued] IS NOT NULL) THEN 1
            WHEN [D].[DateIssued] <> [I].[DateIssued] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[TimeIssued] IS NULL) AND ([C].[TimeIssued] IS NOT NULL) THEN 'TimeIssued'
            WHEN ([I].[TimeIssued] IS NULL) AND ([D].[TimeIssued] IS NOT NULL) THEN 'TimeIssued'
            WHEN [D].[TimeIssued] <> [C].[TimeIssued] THEN 'TimeIssued'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[TimeIssued] IS NULL) AND ([C].[TimeIssued] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[TimeIssued] IS NULL) AND ([D].[TimeIssued] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[TimeIssued] <> [C].[TimeIssued] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[TimeIssued] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[TimeIssued] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[TimeIssued] IS NULL) AND ([C].[TimeIssued] IS NOT NULL) THEN 1
            WHEN ([I].[TimeIssued] IS NULL) AND ([D].[TimeIssued] IS NOT NULL) THEN 1
            WHEN [D].[TimeIssued] <> [I].[TimeIssued] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[IssueComplete] IS NULL) AND ([C].[IssueComplete] IS NOT NULL) THEN 'IssueComplete'
            WHEN ([I].[IssueComplete] IS NULL) AND ([D].[IssueComplete] IS NOT NULL) THEN 'IssueComplete'
            WHEN [D].[IssueComplete] <> [C].[IssueComplete] THEN 'IssueComplete'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[IssueComplete] IS NULL) AND ([C].[IssueComplete] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[IssueComplete] IS NULL) AND ([D].[IssueComplete] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[IssueComplete] <> [C].[IssueComplete] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[IssueComplete] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[IssueComplete] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[IssueComplete] IS NULL) AND ([C].[IssueComplete] IS NOT NULL) THEN 1
            WHEN ([I].[IssueComplete] IS NULL) AND ([D].[IssueComplete] IS NOT NULL) THEN 1
            WHEN [D].[IssueComplete] <> [I].[IssueComplete] THEN 1
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
        [BWSdb].[dbo].[REC_Events] [C]
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

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[RecEventType] IS NULL) AND ([C].[RecEventType] IS NOT NULL) THEN 'RecEventType'
            WHEN ([I].[RecEventType] IS NULL) AND ([D].[Notes] IS NOT NULL) THEN 'RecEventType'
            WHEN [D].[RecEventType] <> [C].[RecEventType] THEN 'RecEventType'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[RecEventType] IS NULL) AND ([C].[RecEventType] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[RecEventType] IS NULL) AND ([D].[RecEventType] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[RecEventType] <> [C].[RecEventType] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[RecEventType] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[RecEventType] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[REC_Events] [C]
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
            WHEN ([D].[RecEventType] IS NULL) AND ([C].[RecEventType] IS NOT NULL) THEN 1
            WHEN ([I].[RecEventType] IS NULL) AND ([D].[RecEventType] IS NOT NULL) THEN 1
            WHEN [D].[RecEventType] <> [I].[RecEventType] THEN 1
            ELSE 0
        END) > 0                   


END