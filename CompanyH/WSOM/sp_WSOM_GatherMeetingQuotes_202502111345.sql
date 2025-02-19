USE [BWSdb]
GO

-- 2025-02-05 
-- Avery Briggs
-- Remodeling of Weekly WO Meeting query

CREATE PROCEDURE [dbo].[sp_WSOM_GatherMeetingQuotes]
	@m_id INT = NULL
AS BEGIN

	--DECLARE @m_id INT = 4
	DECLARE @sd DATETIME;
	DECLARE @ed DATETIME;

	SELECT
		@m_id = ISNULL(@m_id, MAX([ID]))
	FROM
		[BWSdb].[dbo].[WSOM_Meetings]
	;

	SELECT
		@sd = DATEADD(SECOND, -1, [BWSdb].[dbo].[Datify](YEAR([M].[DateMeeting]), MONTH([M].[DateMeeting]), DAY([M].[DateMeeting]), DEFAULT, DEFAULT, DEFAULT))
	FROM
		[BWSdb].[dbo].[WSOM_Meetings] [M]
	;
	SELECT
		@ed = DATEADD(HOUR, 23, DATEADD(MINUTE, 59, DATEADD(SECOND, 62, DATEADD(DAY, 185, @sd))))
	;
	/*
	SELECT
		@m_id [MID]
		,@sd [SD]
		,@ed [ED]
	;
	*/
	SELECT
		*
	FROM (
		SELECT 
			'BWS' AS [Comp],
			[Production].[Prod Date],
			[Orders].[Quote#],
			[Orders].[wo#],
			[Orders].[model No],
			[D].[COMPANY NAME],
			[Orders].[width],
			[Orders].[spread],
			[Sales Staff].[Sales Person],
			[Orders].[slot#],
			Orders.[WO Reviewed],
			[WSOM_Src].[MeetingID],
			[WSOM_Src].[DateMeeting],
			[WSOM_Src].[IssueDescription]
		FROM (
				[BWSdb].[dbo].[Orders] 
			INNER JOIN
				[BWSdb].[dbo].[Production]
			ON
				[Orders].[Quote#] = [Production].[Quote#]
		) 
		INNER JOIN
			[BWSdb].[dbo].[Sales Staff]
		ON 
			[Orders].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
		FULL OUTER JOIN (
			SELECT
				[M].[ID] AS [MeetingID]
				, [M].[DateMeeting]
				, [N].[ID] AS [MeetingNotesID]
				, [N].[Quote]
				, [N].[IssueDescription]
				, [N].[ResolvedBy]
				, [N].[DateResolved]
				, [N].[ResolutionDetails]
			FROM
				[BWSdb].[dbo].[WSOM_Meetings] [M]
			INNER JOIN
				[BWSdb].[dbo].[WSOM_MeetingNotes] [N]
			ON
				[M].[ID] = [N].[MeetingID]
			WHERE
				[MeetingID] <= @m_id
				AND ISNULL([DateResolved], '') = ''
		) AS [WSOM_Src]
		ON
			[Orders].[Quote#] = [WSOM_Src].[Quote]
		LEFT JOIN
			[BWSdb].[dbo].[Dealers] [D]
		ON
			[Orders].[DealerID] = [D].[ID]
		WHERE (
			ISNULL([Orders].[WO Reviewed], 0) = 0)
			AND ([Production].[Prod Date] BETWEEN @sd AND @ed)


		UNION ALL


		SELECT 
			'STG' AS [Comp],
			[ProductionV2].[Prod Date],
			[OrdersV2].[SGQuote],
			[OrdersV2].[wo#],
			[OrdersV2].[model No],
			[D].[COMPANY NAME],
			[OrdersV2].[width],
			[OrdersV2].[spread],
			[Sales Staff].[Sales Person],
			[OrdersV2].[slot#],
			[OrdersV2].[WO Reviewed],
			[WSOM_Src].[MeetingID],
			[WSOM_Src].[DateMeeting],
			[WSOM_Src].[IssueDescription]
		FROM (
				[BWSdb].[dbo].[OrdersV2] 
			INNER JOIN
				[BWSdb].[dbo].[ProductionV2]
			ON
				[OrdersV2].[SGQuote] = [ProductionV2].[SGQuote]
		) 
		INNER JOIN
			[BWSdb].[dbo].[Sales Staff]
		ON 
			[OrdersV2].[Sale PersonID] = [Sales Staff].[ID-SaleStaff]
		FULL OUTER JOIN (
			SELECT
				[M].[ID] AS [MeetingID]
				, [M].[DateMeeting]
				, [N].[ID] AS [MeetingNotesID]
				, [N].[Quote]
				, [N].[IssueDescription]
				, [N].[ResolvedBy]
				, [N].[DateResolved]
				, [N].[ResolutionDetails]
			FROM
				[BWSdb].[dbo].[WSOM_Meetings] [M]
			INNER JOIN
				[BWSdb].[dbo].[WSOM_MeetingNotes] [N]
			ON
				[M].[ID] = [N].[MeetingID]
			WHERE
				[MeetingID] <= @m_id
				AND ISNULL([DateResolved], '') = ''
		) AS [WSOM_Src]
		ON
			[OrdersV2].[SGQuote] = [WSOM_Src].[Quote]
		LEFT JOIN
			[BWSdb].[dbo].[DealersV2] [D]
		ON
			[OrdersV2].[DealerID] = [D].[ID]
		WHERE (
			ISNULL([OrdersV2].[WO Reviewed], 0) = 0)
			AND ([ProductionV2].[Prod Date] BETWEEN @sd AND @ed)
	) AS [Master_Src]
	ORDER BY
		(CASE WHEN [MeetingID] IS NULL THEN 1 ELSE 0 END)
		,[MeetingID]
		,[Prod Date]
		,[Model No]
		,[Quote#]
	;
END