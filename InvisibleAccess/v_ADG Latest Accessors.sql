USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ADG Latest Accessors]    Script Date: 2023-06-21 10:04:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[v_ADG Latest Accessors]
AS

SELECT
	[A].[WindowsUser] AS [Latest Accessor(s)]
	, [DateCreated] AS [When]
	, [AccessDBID] AS [DBID]
	, [AccessDB] AS [DB]
	, [FormAccessed] AS [On Form]
	, [DestinationForm] AS [Target Form]
	, [LastID] AS [Last ID]
	, (CASE 
		WHEN [DateCreated] >= DATEADD(HOUR, -12, GETDATE()) THEN
			'Today'
		WHEN [DateCreated] >= DATEADD(HOUR, -24, GETDATE()) THEN
			'Yesterday'
		WHEN [DateCreated] >= DATEADD(HOUR, -168, GETDATE()) THEN
			'This Week'
		WHEN [DateCreated] >= DATEADD(HOUR, -336, GETDATE()) THEN
			'Last Week'
		WHEN [DateCreated] >= DATEADD(HOUR, -672, GETDATE()) THEN
			'This Month'
		WHEN [DateCreated] >= DATEADD(HOUR, -1512, GETDATE()) THEN
			'Last Month'
		WHEN [DateCreated] >= DATEADD(HOUR, -4380, GETDATE()) THEN
			'Within Last 6 Months'
		WHEN [DateCreated] >= DATEADD(HOUR, -8760, GETDATE()) THEN
			'This Year'
		WHEN [DateCreated] >= DATEADD(HOUR, -17520, GETDATE()) THEN
			'Within Last 2 Years'
		WHEN [DateCreated] >= DATEADD(HOUR, -43824, GETDATE()) THEN
			'Within last 5 Years'
		ELSE
			'More Than 5 Years'
		END) AS [Last Login Comment]
FROM
	[ADG Events]
INNER JOIN (
	SELECT
		MAX([ID]) AS [LastID]
		, [WindowsUser]
	FROM
		[ADG Events]
	GROUP BY
		[WindowsUser]
) AS [A]
ON
	[ADG Events].[ID] = [LastID]
--ORDER BY
--	[DateCreated] DESC
;
GO


