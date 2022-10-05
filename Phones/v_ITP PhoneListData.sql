USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ITP PhoneListData]    Script Date: 2022-10-05 11:53:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[v_ITP PhoneListData] AS

SELECT * FROM (

	SELECT 
		[Name] AS [NAME_]
		,ISNULL([Extension], [WorkExtension]) AS [EXT]
		,[DisplayName] AS [POSITION]
		,[WorkPhone] AS [WORK#]
		,[HomePhone] AS [HOME#]
		,[CellPhone] AS [CELL#]
		,[ITP PhoneLines].[Section]
		,[ITP PhoneLines].[SectionOrder]
		--,*
	FROM
		[ITP PhoneLines]
	FULL OUTER JOIN
		[ITR Customers]
	ON
		[ITP PhoneLines].[AssignedTo] = [ITR Customers].[CustomerID]
	--WHERE
	--	[Name] IS NOT NULL
		--AND ([ITP PhoneLines].[Active] = 1 OR [ITR Customers].[Active] = 1)
		--[ITP PhoneLines].[Active] = 1
	WHERE
		((CASE WHEN [Name] IS NOT NULL THEN 1 ELSE 0 END)
		+ (CASE WHEN ISNULL([Extension], [WorkExtension]) IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [DisplayName] IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [WorkPhone] IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [HomePhone] IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [CellPhone] IS NOT NULL THEN 1 ELSE 0 END) 
		> 0)
		AND [ITP PhoneLines].[Active] = 1
	
	UNION

	SELECT
		[Name]
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,[FormOrder]
		,0
	FROM
		[ITP FormSections]
	WHERE
		[Name] NOT IN  ('CEO', 'DATA')

) AS [Src]
--ORDER BY
--	[Section]
--	,[SectionOrder]
;

GO


