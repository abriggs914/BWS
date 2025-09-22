USE [SysproCompanyA]
GO

--202509221217 - Avery Briggs - Trigger to automatically insert new Jobs and declared operations into BWSdb table.

CREATE TRIGGER tr_PROD_JobOpIssue_Insert
ON [dbo].[WipJobAllMat]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert new Job + Operation into BWSdb.dbo.PROD_JobOpIssue
    INSERT INTO [BWSdb].[dbo].[PROD_JobOpIssue] (
        Active
        , Job
        , Operation
    )
    SELECT  
        1 AS Active
        , i.Job
        , i.OperationOffset
    FROM inserted i
    WHERE NOT EXISTS (
        SELECT 1
        FROM [BWSdb].[dbo].[PROD_JobOpIssue] t
        WHERE 
			(t.Job COLLATE DATABASE_DEFAULT = i.Job)
			AND (t.Operation = i.OperationOffset)
    );
END
GO
