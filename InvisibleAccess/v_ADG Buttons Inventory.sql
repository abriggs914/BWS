USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ADG Buttons Inventory]    Script Date: 2023-06-21 10:01:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_ADG Buttons Inventory]
AS

SELECT
	[AccessDB]
	, [AccessDBID]
	, [FormAccessed]
	, [CtlClicked]
	, [OpensForm]
	, [DestinationForm]
	, COUNT(*) AS [NumAccesses]
	, MAX([ID]) AS [LastID]
FROM
	[ADG Events]
GROUP BY
	[AccessDB]
	, [AccessDBID]
	, [FormAccessed]
	, [CtlClicked]
	, [OpensForm]
	, [DestinationForm]
;
GO


