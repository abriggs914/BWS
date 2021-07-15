USE BWSdb
GO

SELECT * FROM [Defects_Print]
SELECT * FROM [Defects_Print_Problems]

BEGIN TRAN;
SELECT * FROM [Defects_Print]
UPDATE [Defects_Print]
SET [ProblemID] = 7
WHERE [Defect] LIKE '%finish%'
SELECT * FROM [Defects_Print]

BEGIN TRAN;
DROP TABLE [Defects_Print_Problems]

ROLLBACK;
COMMIT;
GO