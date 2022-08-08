USE BWSdb
GO


-- individual counts
-- 1, 5, 10, 25, 50, 100, 150, 200...

	-- Resolve Counts
	-- request was completed SUCCESSFULLY

-- Respond with a yes / no answer to whether or not a requester has crossed a threshold.

--ALTER PROCEDURE [dbo].[sp_ITRCheckMerit]
--	@names AS NVARCHAR(MAX)=NULL
--	,@type AS NVARCHAR(MAX)=NULL
--	,@gt_1 AS BIT = 0
--	,@gt_5 AS BIT = 0
--	,@gt_10 AS BIT = 0
--	,@gt_25 AS BIT = 0
--	,@gt_50 AS BIT = 0
--	,@gt_100 AS BIT = 0
--	,@gt_200 AS BIT = 0
--	,@gt_250 AS BIT = 0
--	,@gt_500 AS BIT = 0
--	,@gt_750 AS BIT = 0
--	,@gt_1000 AS BIT = 0
--	,@gt_1500 AS BIT = 0
--	,@gt_2000 AS BIT = 0
--	,@gt_2500 AS BIT = 0
--	,@isM25 AS BIT = 0
--	,@isM50 AS BIT = 0
--	,@isM100 AS BIT = 0
--AS
--BEGIN

DECLARE @ITRMerit AS TABLE ([ID] INT IDENTITY(1, 1), [Clause] NVARCHAR(MAX), [Merit] NVARCHAR(MAX));

INSERT INTO @ITRMerit ([Clause], [Merit]) VALUES 
('WHERE [RequestedBy] LIKE ''%XXXXX%'' YYYYYGROUP BY [RequestedBy] HAVING COUNT(*) >= ZZZZZWWWWW', 'For opening new requests of a specific type.')

DECLARE @results AS TABLE([ID] INT IDENTITY(1, 1), [RequestedBy] NVARCHAR(MAX), [#] INT, [SQL] NVARCHAR(MAX), [Success] BIT);
DECLARE @spl_names AS TABLE ([ID] INT, [Name] NVARCHAR(MAX));

DECLARE @tr AS INT;
SELECT  @tr = COUNT(*) FROM [IT Requests];
DECLARE @name AS NVARCHAR(MAX);
DECLARE @clause AS NVARCHAR(MAX);
DECLARE @nc AS NVARCHAR(MAX);
DECLARE @mc AS NVARCHAR(MAX);
DECLARE @hc AS NVARCHAR(MAX);

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- TESTING --
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

DECLARE @names AS NVARCHAR(MAX);
DECLARE @type AS NVARCHAR(MAX);
SET @names = 'caleb;avery';
SET @type = 'software';
SET @type = NULL;

DECLARE @gt_1 AS BIT = 0;
DECLARE @gt_5 AS BIT = 0;
DECLARE @gt_10 AS BIT = 0;
DECLARE @gt_25 AS BIT = 0;
DECLARE @gt_50 AS BIT = 0;
DECLARE @gt_100 AS BIT = 0;
DECLARE @gt_200 AS BIT = 1;
DECLARE @gt_250 AS BIT = 0;
DECLARE @gt_500 AS BIT = 0;
DECLARE @gt_750 AS BIT = 0;
DECLARE @gt_1000 AS BIT = 0;
DECLARE @gt_1500 AS BIT = 0;
DECLARE @gt_2000 AS BIT = 0;
DECLARE @gt_2500 AS BIT = 0;

DECLARE @isM25 AS BIT = 0;
DECLARE @isM50 AS BIT = 0;
DECLARE @isM100 AS BIT = 0;

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
-- END TESTING--
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

INSERT INTO @spl_names
SELECT * FROM [split_string_idx](@names, ';');

IF @gt_2500 = 1 BEGIN
	SELECT @nc = '2500';
END
ELSE IF @gt_2000 = 1 BEGIN
	SELECT @nc = '2000';
END
ELSE IF @gt_1500 = 1 BEGIN
	SELECT @nc = '1500';
END
ELSE IF @gt_1000 = 1 BEGIN
	SELECT @nc = '1000';
END
ELSE IF @gt_750 = 1 BEGIN
	SELECT @nc = '750';
END
ELSE IF @gt_500 = 1 BEGIN
	SELECT @nc = '500';
END
ELSE IF @gt_250 = 1 BEGIN
	SELECT @nc = '250';
END
ELSE IF @gt_200 = 1 BEGIN
	SELECT @nc = '200';
END
ELSE IF @gt_100 = 1 BEGIN
	SELECT @nc = '100';
END
ELSE IF @gt_50 = 1 BEGIN
	SELECT @nc = '50';
END
ELSE IF @gt_25 = 1 BEGIN
	SELECT @nc = '25';
END
ELSE IF @gt_10 = 1 BEGIN
	SELECT @nc = '10';
END
ELSE IF @gt_5 = 1 BEGIN
	SELECT @nc = '5';
END
ELSE IF @gt_1 = 1 BEGIN
	SELECT @nc = '1';
END
ELSE BEGIN
	SELECT @nc = CAST(@tr AS NVARCHAR(MAX));
END

IF @isM100 = 1 BEGIN
	SELECT @mc = '100';
END
ELSE IF @isM50 = 1 BEGIN
	SELECT @mc = '50';
END
ELSE IF @isM25 = 1 BEGIN
	SELECT @mc = '25';
END
ELSE BEGIN
	SELECT @mc = '';
END

DECLARE @i INT;
DECLARE @j INT;
DECLARE @c1 INT;
DECLARE @c2 INT;
DECLARE @r1 INT;
DECLARE @r2 INT;
DECLARE @c_no_h INT;
DECLARE @prefix AS NVARCHAR(MAX);
DECLARE @type_suffix AS NVARCHAR(MAX);
DECLARE @sql AS NVARCHAR(MAX);
SET @prefix = 'SELECT [RequestedBy], COUNT(*) AS [#] FROM [IT Requests]';
SET @type_suffix = 'AND [RequestType] LIKE ''%YYYYY%''';

SET @i = 1;
SELECT @c1 = COUNT(*) FROM @ITRMerit;
SELECT @c2 = COUNT(*) FROM @spl_names;

WHILE @i <= @c1 BEGIN
	SELECT @clause = [Clause] FROM @ITRMerit WHERE [ID] = @i;
	IF @type IS NOT NULL BEGIN
		SELECT @clause = REPLACE(@clause, 'YYYYY', REPLACE(@type_suffix, 'YYYYY', @type) + ' ')
	END
	ELSE BEGIN
		SELECT @clause = REPLACE(@clause, 'YYYYY', '')
	END
	IF LEN(@mc) > 0 BEGIN
		SELECT @hc = ' OR COUNT(*) % ' + @mc + ' = 0';
	END
	ELSE BEGIN
		SELECT @hc = '';
	END
	SELECT @clause = REPLACE(@clause, 'WWWWW', @hc)

	SELECT @j = 0;
	WHILE @j < @c2 BEGIN
		SELECT @name = [Name] FROM @spl_names WHERE [ID] = @j;
		SELECT @sql = (@prefix + ' ' + REPLACE(REPLACE(@clause, 'XXXXX', @name), 'ZZZZZ', @nc));
		--SELECT @sql AS [SQL], @name AS [Name], (@i * @c2) + @j AS [X];
		SELECT @r1 = COUNT(*) FROM @results;
		INSERT INTO @results ([RequestedBy], [#])
		--VALUES ('A', 1)
		EXEC (@sql);

		SELECT @r2 = COUNT(*) FROM @results;
		UPDATE
			@results
		SET
			[SQL] = @sql
			,[Success] = 1
		WHERE
			[ID] BETWEEN @r1 + 1 AND @r2
		IF @r1 = @r2 BEGIN
			INSERT INTO @results ([RequestedBy], [#], [SQL], [Success]) VALUES (@name, 0, @sql, 0);
		END
		SELECT @j = @j + 1;
	END
	SET @i = @i + 1;
END

-- Final Select
SELECT * FROM @results
--END