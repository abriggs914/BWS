USE BWSdb
GO


-- individual counts
-- 1, 5, 10, 25, 50, 100, 150, 200...

	-- Resolve Counts
	-- request was completed SUCCESSFULLY

DECLARE @ITRMerit AS TABLE ([ID] INT IDENTITY(1, 1), [Clause] NVARCHAR(MAX));

INSERT INTO @ITRMerit ([Clause]) VALUES 
('WHERE [RequestedBy] LIKE ''%XXXXX%'' GROUP BY [RequestedBy] HAVING COUNT(*) >= 5')

DECLARE @name AS NVARCHAR(MAX);
DECLARE @gt_1 AS BIT = 0;
DECLARE @gt_5 AS BIT = 0;
DECLARE @gt_10 AS BIT = 0;
DECLARE @gt_25 AS BIT = 0;
DECLARE @gt_50 AS BIT = 0;
DECLARE @isM25 AS BIT = 0;
DECLARE @isM50 AS BIT = 0;
DECLARE @isM100 AS BIT = 0;

SET @name = 'avery';

SELECT [RequestedBy], COUNT(*) AS [#] FROM [IT Requests] 
WHERE [RequestedBy] LIKE '%' + @name + '%' GROUP BY [RequestedBy] HAVING COUNT(*) > 