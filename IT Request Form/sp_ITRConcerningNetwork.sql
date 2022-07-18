USE BWSdb
GO

-- Get all non-complete requests that deal with phones.
-- Use the results to prepare a list of items for a service call to Bob.
-- Designed to save from calling for each individual task.

CREATE PROCEDURE [dbo].[sp_ITRConcerningNetwork]
	@sd AS DATETIME = NULL,
	@ed AS DATETIME = NULL
AS
BEGIN

	IF @sd IS NULL BEGIN
		SELECT @sd = MIN([RequestDate]) FROM [IT Requests]
	END

	IF @ed IS NULL BEGIN
		SELECT @ed = MAX([RequestDate]) FROM [IT Requests]
	END

	SELECT
		*
	FROM
		[IT Requests]
	WHERE
		(
			[RequestSubType] LIKE '%Wi-Fi (Network)%'
			OR [Comments] LIKE '%Wi-Fi (Network)%'
			OR [Request] LIKE '%Wi-Fi (Network)%'
			OR [Comments] LIKE '%dale craig%'
			OR [Request] LIKE '%dale craig%'
		) AND [Status] <> 'Complete'
		AND (([RequestDate] BETWEEN @sd AND @ed) OR ([RequestDateOriginal] BETWEEN @sd AND @ed))


END