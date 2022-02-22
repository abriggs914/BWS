USE BWSdb
GO

DECLARE @userName NVARCHAR(250);
SET @userName = 'Avery Briggs';
DECLARE @priorityLevel INT;
SET @priorityLevel = 0;
DECLARE @status NVARCHAR(250);
SET @status = NULL;
SELECT * FROM [IT Requests]
SELECT COUNT(*) AS [# Queued] FROM [IT Requests] WHERE LOWER([RequestedBy]) = LOWER(@userName) AND [Priority] = @priorityLevel AND LOWER([Status]) = 'queued'
SELECT COUNT(*) AS [# In Progress] FROM [IT Requests] WHERE LOWER([RequestedBy]) = LOWER(@userName) AND [Priority] = @priorityLevel AND LOWER([Status]) = 'in progress'

SELECT * FROM [IT Requests] WHERE LOWER((CASE WHEN [Status] IS NULL THEN '' ELSE [Status] END)) = LOWER((CASE WHEN @status IS NULL THEN '' ELSE @status END)) AND LOWER([RequestedBy]) = LOWER(@userName) AND [Priority] = @priorityLevel

SELECT * FROM [IT Requests] WHERE LOWER([RequestedBy]) = LOWER(@userName) AND [Priority] = @priorityLevel
SELECT * FROM [IT Requests] WHERE LOWER((CASE WHEN [Status] IS NULL THEN '' ELSE [Status] END)) = LOWER(@status) AND [Priority] = @priorityLevel
SELECT * FROM [IT Requests] WHERE LOWER((CASE WHEN [Status] IS NULL THEN '' ELSE [Status] END)) = LOWER(@status) AND LOWER([RequestedBy]) = LOWER(@userName)


-- Select 
SELECT * FROM [IT Requests] WHERE LOWER([Status]) NOT LIKE '%complete%' AND LOWER([RequestedBy]) = LOWER(@userName) AND [Priority] = @priorityLevel

-- Count how many requests are in the specific status category for a given user
SELECT COUNT(*) FROM [IT Requests] WHERE LOWER([Status]) LIKE LOWER('%' + @status + '%') AND LOWER([RequestedBy]) = LOWER(@userName) AND [RequestedBy] = @userName AND LOWER([Status]) NOT LIKE '%complete%'