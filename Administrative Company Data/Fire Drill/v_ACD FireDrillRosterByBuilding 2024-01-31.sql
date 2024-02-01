USE [BWSdb]
GO

/****** Object:  View [dbo].[v_ACD FireDrillRosterByBuilding]    Script Date: 2024-01-31 4:06:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--BEGIN TRAN;

--UPDATE
--	[ITR Customers]
--SET
--	[Active] = 0
--WHERE
--	[Name] = 'Ivan Cowperthwaite'

--ROLLBACK;
--COMMIT;


ALTER VIEW [dbo].[v_ACD FireDrillRosterByBuilding] 
AS
SELECT
	ROW_NUMBER() OVER(
		PARTITION BY
			[Name]
		ORDER BY 
			--[LastName]
			--,[FirstName]
			[Name]
			,[LastName]
			,[FirstName]
	) AS [Num]
	,*
FROM (
	SELECT
		[B].[ID]
		,[FDR].[Active] AS [DrillActive]
		,[C].[CustomerID]
		,[B].[Name]
		,[C].[Employee Name]
		,LTRIM(RTRIM(SUBSTRING([C].[Employee Name], 0, CHARINDEX(' ', [C].[Employee Name])))) AS [FirstName]
		,LTRIM(RTRIM(SUBSTRING([C].[Employee Name], CHARINDEX(' ', [C].[Employee Name]), LEN([C].[Employee Name])))) AS [LastName]
	FROM
		[BWSdb].[dbo].[ACD FireDrillRoster] AS [FDR] WITH (NOLOCK)
	LEFT JOIN
		[BWSdb].[dbo].[v_ITRCustomersWithDepartments] AS [C] WITH (NOLOCK)
	ON
		[FDR].[IDITRCustomers] = [C].[CustomerID]
	LEFT JOIN
		[BWSdb].[dbo].[ITI Buildings] AS [B] WITH (NOLOCK)
	ON
		[FDR].[IDBuilding] = [B].[ID]
	WHERE
		([C].[C_Active] = 1)
		AND ([B].[Active] = 1)
		AND ([FDR].[Active] = 1)
) AS [Src]
--ORDER BY
--	[LastName]
--	,[FirstName]
;
GO


