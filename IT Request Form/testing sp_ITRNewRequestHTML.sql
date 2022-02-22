
DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
DECLARE @persons AS NVARCHAR(MAX);
DECLARE @subject AS NVARCHAR(255);
DECLARE @body AS NVARCHAR(MAX);

DECLARE @itr_id AS NVARCHAR(6);
SELECT @itr_id = [ITRequestID#] FROM [IT Requests] WHERE [ITRequestID#] = 195;

DECLARE @src AS TABLE ([Body] NVARCHAR(MAX));
INSERT INTO @src
EXEC [dbo].[sp_ITRNewRequestHTML] @tid=@itr_id
SELECT @itr_id = CAST(@itr_id AS NVARCHAR(6))

-- Enter Recipients
SELECT @persons = 'q0y9o8w7x8v5o6b0@bwsmanufacturingltd.slack.com'; -- Avery
SELECT @persons = @persons + ';' + 'v6l2a8z0e8u7x0k9@bwsmanufacturingltd.slack.com'; -- James
SELECT @persons = @persons + ';' + 'o8u2z7g5f5h2z5o0@bwsmanufacturingltd.slack.com'; -- Jamie

-- Set Subject and Body
SET @subject = 'New IT Request #' + RIGHT('000000' + @itr_id, 6);
SELECT @body = [Body] FROM @src

SELECT @body AS [Body]