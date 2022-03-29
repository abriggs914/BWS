USE [BWSdb]
GO

--/****** Object:  View [dbo].[v_SecurityEventsByYearByMonthV1]    Script Date: 2022-03-29 11:21:54 AM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


ALTER PROCEDURE [dbo].[sp_SecurityEventsByYearByMonthAllV1]
	@sd DATETIME=NULL,
	@ed DATETIME=NULL
AS
BEGIN

SET @sd = ISNULL(@sd, (SELECT MIN(LogDate) FROM [SecurityLogV1]));
SET @ed = ISNULL(@ed, (SELECT MAX(LogDate) FROM [SecurityLogV1]));

-- event counts by event by year by month
SELECT
	COUNT([LogID]) AS [# Events]
	,[Year] AS [Year]
	,[Month] AS [Month]
FROM (
	SELECT
	[Month]
	,[B].SeqNo AS [Year]
	FROM (
		SELECT TOP 12
			[SequenceNumbers].[SeqNo] AS [Month]
		FROM
			[SequenceNumbers]
		) AS [A]
		CROSS JOIN (
			SELECT TOP (CASE WHEN YEAR(@ed) - YEAR(@sd) < 1 THEN 1 ELSE YEAR(@ed) - YEAR(@sd) END)
				[SeqNo]
			FROM
				[BWSdb].[dbo].[SequenceNumbers]
			WHERE
				[SeqNo] >= YEAR(@sd)
		) AS [B]
	WHERE
		YEAR(@sd) <= [B].[SeqNo] AND [B].[SeqNo] <= YEAR(@ed)
) AS [C]
LEFT JOIN
	[BWSdb].[dbo].[SecurityLogV1]
ON
	MONTH([LogDate]) = [Month]
	AND YEAR([LogDate]) = [Year]
GROUP BY
	[Month]
	,[Year]
END


