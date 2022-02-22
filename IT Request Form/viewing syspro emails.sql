USE BWSdb
GO

DECLARE @SRC TABLE ([EMP#] INT, [Name] NVARCHAR(MAX), [Email] NVARCHAR(250))

INSERT INTO @SRC
EXEC [dbo].[sp_EmployeeEmails]


SELECT * FROM @SRC





--SELECT * FROm [IT Requests]


--USE Sysprodb
--GO
--SELECT * FROM dbo.AdmOperator