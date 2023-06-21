USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ADG User Access Log]    Script Date: 2023-06-21 10:00:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[v_ADG User Access Log] AS

SELECT
	CAST((CAST(YEAR([DateCreated]) AS NVARCHAR(4)) + ' - ' +
	CAST(MONTH([DateCreated]) AS NVARCHAR(4)) + ' - ' +
	CAST(DAY([DateCreated]) AS NVARCHAR(4))) AS DATETIME) AS [Date]
	, [WindowsUser]
	, [AccessDB]
	, [AccessDBID]
	, COUNT(*) AS [NumAccesses]
FROM
	[ADG Events]
GROUP BY
	[WindowsUser]
	, [AccessDB]
	, [AccessDBID]
	, YEAR([DateCreated])
	, MONTH([DateCreated])
	, DAY([DateCreated])
;
GO


