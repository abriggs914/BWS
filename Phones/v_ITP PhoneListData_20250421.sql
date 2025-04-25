USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ITP PhoneListData]    Script Date: 2025-04-22 3:50:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--/****** Object:  View [dbo].[v_ITP PhoneListData]    Script Date: 2022-10-06 11:41:34 AM ******/
-- 202408231349 - Avery Briggs - added [ITR Customers].[Active] = 1 to where clause.
-- 202504221554 - Avery Briggs - Removed the [Name] from the where clause to make it more specific.
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO




ALTER VIEW [dbo].[v_ITP PhoneListData] AS

SELECT * FROM (

	SELECT 
		[Name] AS [NAME_]
		,ISNULL([Extension], [WorkExtension]) AS [EXT]
		,[DisplayName] AS [POSITION]
		,[dbo].[NBPhonify]([WorkPhone], DEFAULT) AS [WORK#]
		,[dbo].[NBPhonify]([HomePhone], DEFAULT) AS [HOME#]
		,[dbo].[NBPhonify]([CellPhone], DEFAULT) AS [CELL#]
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
		(
		--(CASE WHEN [Name] IS NOT NULL THEN 1 ELSE 0 END)
		+ (CASE WHEN ISNULL([Extension], [WorkExtension]) IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [DisplayName] IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [WorkPhone] IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [HomePhone] IS NOT NULL THEN 1 ELSE 0 END) 
		+ (CASE WHEN [CellPhone] IS NOT NULL THEN 1 ELSE 0 END) 
		> 0)
		--AND [ITP PhoneLines].[Active] = 1
		AND [ITR Customers].[Active] = 1
		AND (UPPER([ITR Customers].[Company]) IN ('BWS', 'HUGO'))
	
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

) AS [Src]
	WHERE
		[Name_] NOT IN  ('CEO', 'DATA', 'HEADER')
		--AND [Name_] IS NOT NULL
--ORDER BY
--	[Section]
--	,[SectionOrder]
;

GO


