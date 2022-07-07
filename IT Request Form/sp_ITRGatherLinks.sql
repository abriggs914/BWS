USE BWSdb
GO

CREATE PROCEDURE [dbo].[sp_ITRGatherLinks]
AS BEGIN

	DECLARE @c AS INTEGER;
	DECLARE @reqID AS INTEGER;
	DECLARE @reqIDForward AS INTEGER;
	DECLARE @reqIDBackward AS INTEGER;
	SET @reqID = 0;

	DECLARE @relatedForwardTable AS TABLE ([ID] INT IDENTITY(1, 1), [Parent] INT, [ReqID] INT);
	DECLARE @relatedBackwardTable AS TABLE ([ID] INT IDENTITY(1, 1), [Parent] INT, [ReqID] INT);

	DECLARE @relatedForwardStr AS NVARCHAR(MAX);
	DECLARE @relatedBackwardStr AS NVARCHAR(MAX);

	SELECT @c = COUNT(*) FROM [IT Requests];

	WHILE @reqID < @c BEGIN

		SELECT @reqIDBackward = [LinkPrev] FROM [IT Requests] WHERE [IT Requests].[ITRequestID#] = @reqID;
		SELECT @reqIDForward = [LinkNext] FROM [IT Requests] WHERE [IT Requests].[ITRequestID#] = @reqID;

		WHILE @reqIDBackward IS NOT NULL BEGIN
			INSERT INTO @relatedBackwardTable ([Parent], [ReqID]) VALUES (@reqID, @reqIDBackward);
			SELECT @reqIDBackward = [LinkPrev] FROM [IT Requests] WHERE [IT Requests].[ITRequestID#] = @reqIDBackward;
		END

		WHILE @reqIDForward IS NOT NULL BEGIN
			INSERT INTO @relatedForwardTable ([Parent], [ReqID]) VALUES (@reqID, @reqIDForward);
			SELECT @reqIDForward = [LinkNext] FROM [IT Requests] WHERE [IT Requests].[ITRequestID#] = @reqIDForward;
		END

		SET @reqID = @reqID + 1;
	END

	SELECT '@relatedForwardTable' AS [Table], * FROM @relatedForwardTable
	UNION
	SELECT '@relatedBackwardTable' AS [Table], * FROM @relatedBackwardTable
END