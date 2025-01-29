USE [BWSdb]
GO

/****** Object:  Trigger [dbo].[tr_UpdateWSOM_MeetingNotesHistory]    Script Date: 2025-01-28 16:14:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-01-28 16:14:49>
-- Description:	<Maintain History Table>
-- =============================================
CREATE TRIGGER [dbo].[tr_UpdateWSOM_MeetingNotesHistory] 
ON [dbo].[WSOM_MeetingNotes]
AFTER INSERT, DELETE, UPDATE
AS 
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

	INSERT INTO
        [BWSdb].[dbo].[hist_WSOM_MeetingNotes]
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
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[MeetingID] IS NULL) AND ([C].[MeetingID] IS NOT NULL) THEN 'MeetingID'
            WHEN ([I].[MeetingID] IS NULL) AND ([D].[MeetingID] IS NOT NULL) THEN 'MeetingID'
            WHEN [D].[MeetingID] <> [C].[MeetingID] THEN 'MeetingID'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[MeetingID] IS NULL) AND ([C].[MeetingID] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[MeetingID] IS NULL) AND ([D].[MeetingID] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[MeetingID] <> [C].[MeetingID] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[MeetingID] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[MeetingID] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[MeetingID] IS NULL) AND ([C].[MeetingID] IS NOT NULL) THEN 1
            WHEN ([I].[MeetingID] IS NULL) AND ([D].[MeetingID] IS NOT NULL) THEN 1
            WHEN [D].[MeetingID] <> [I].[MeetingID] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[Quote] IS NULL) AND ([C].[Quote] IS NOT NULL) THEN 'Quote'
            WHEN ([I].[Quote] IS NULL) AND ([D].[Quote] IS NOT NULL) THEN 'Quote'
            WHEN [D].[Quote] <> [C].[Quote] THEN 'Quote'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[Quote] IS NULL) AND ([C].[Quote] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[Quote] IS NULL) AND ([D].[Quote] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[Quote] <> [C].[Quote] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[Quote] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[Quote] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[Quote] IS NULL) AND ([C].[Quote] IS NOT NULL) THEN 1
            WHEN ([I].[Quote] IS NULL) AND ([D].[Quote] IS NOT NULL) THEN 1
            WHEN [D].[Quote] <> [I].[Quote] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[IssueDescription] IS NULL) AND ([C].[IssueDescription] IS NOT NULL) THEN 'IssueDescription'
            WHEN ([I].[IssueDescription] IS NULL) AND ([D].[IssueDescription] IS NOT NULL) THEN 'IssueDescription'
            WHEN [D].[IssueDescription] <> [C].[IssueDescription] THEN 'IssueDescription'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[IssueDescription] IS NULL) AND ([C].[IssueDescription] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[IssueDescription] IS NULL) AND ([D].[IssueDescription] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[IssueDescription] <> [C].[IssueDescription] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[IssueDescription] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[IssueDescription] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[IssueDescription] IS NULL) AND ([C].[IssueDescription] IS NOT NULL) THEN 1
            WHEN ([I].[IssueDescription] IS NULL) AND ([D].[IssueDescription] IS NOT NULL) THEN 1
            WHEN [D].[IssueDescription] <> [I].[IssueDescription] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[DateResolved] IS NULL) AND ([C].[DateResolved] IS NOT NULL) THEN 'DateResolved'
            WHEN ([I].[DateResolved] IS NULL) AND ([D].[DateResolved] IS NOT NULL) THEN 'DateResolved'
            WHEN [D].[DateResolved] <> [C].[DateResolved] THEN 'DateResolved'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[DateResolved] IS NULL) AND ([C].[DateResolved] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[DateResolved] IS NULL) AND ([D].[DateResolved] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[DateResolved] <> [C].[DateResolved] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[DateResolved] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[DateResolved] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[DateResolved] IS NULL) AND ([C].[DateResolved] IS NOT NULL) THEN 1
            WHEN ([I].[DateResolved] IS NULL) AND ([D].[DateResolved] IS NOT NULL) THEN 1
            WHEN [D].[DateResolved] <> [I].[DateResolved] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[ResolutionDetails] IS NULL) AND ([C].[ResolutionDetails] IS NOT NULL) THEN 'ResolutionDetails'
            WHEN ([I].[ResolutionDetails] IS NULL) AND ([D].[ResolutionDetails] IS NOT NULL) THEN 'ResolutionDetails'
            WHEN [D].[ResolutionDetails] <> [C].[ResolutionDetails] THEN 'ResolutionDetails'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[ResolutionDetails] IS NULL) AND ([C].[ResolutionDetails] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[ResolutionDetails] IS NULL) AND ([D].[ResolutionDetails] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[ResolutionDetails] <> [C].[ResolutionDetails] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[ResolutionDetails] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[ResolutionDetails] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[ResolutionDetails] IS NULL) AND ([C].[ResolutionDetails] IS NOT NULL) THEN 1
            WHEN ([I].[ResolutionDetails] IS NULL) AND ([D].[ResolutionDetails] IS NOT NULL) THEN 1
            WHEN [D].[ResolutionDetails] <> [I].[ResolutionDetails] THEN 1
            ELSE 0
        END) > 0                        

	UNION ALL

    SELECT
        TRIGGER_NESTLEVEL(),
        [C].[ID],
        NULL,
        (CASE
            WHEN ([D].[ResolvedBy] IS NULL) AND ([C].[ResolvedBy] IS NOT NULL) THEN 'ResolvedBy'
            WHEN ([I].[ResolvedBy] IS NULL) AND ([D].[ResolvedBy] IS NOT NULL) THEN 'ResolvedBy'
            WHEN [D].[ResolvedBy] <> [C].[ResolvedBy] THEN 'ResolvedBy'
            ELSE NULL
        END) AS [ModifiedColumn],
        (CASE
            WHEN ([D].[ResolvedBy] IS NULL) AND ([C].[ResolvedBy] IS NOT NULL) THEN 'INSERT'
            WHEN ([I].[ResolvedBy] IS NULL) AND ([D].[ResolvedBy] IS NOT NULL) THEN 'DELETE'
            WHEN [D].[ResolvedBy] <> [C].[ResolvedBy] THEN 'UPDATE'
            ELSE NULL
        END) AS [Modification],
        CAST([D].[ResolvedBy] AS NVARCHAR(MAX)) AS [ValueBefore],
        CAST([I].[ResolvedBy] AS NVARCHAR(MAX)) AS [ValueAfter]
    FROM
        [BWSdb].[dbo].[WSOM_MeetingNotes] [C]
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
            WHEN ([D].[ResolvedBy] IS NULL) AND ([C].[ResolvedBy] IS NOT NULL) THEN 1
            WHEN ([I].[ResolvedBy] IS NULL) AND ([D].[ResolvedBy] IS NOT NULL) THEN 1
            WHEN [D].[ResolvedBy] <> [I].[ResolvedBy] THEN 1
            ELSE 0
        END) > 0                        


END