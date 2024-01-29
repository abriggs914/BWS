USE BWSdb
GO


ALTER VIEW [v_ACD FireDrillRosterByBuilding] 
AS
SELECT
	ROW_NUMBER() OVER(
		ORDER BY 
			[LastName]
			,[FirstName]
	) AS [Num]
	,*
FROM (
	SELECT
		[B].[ID]
		,[C].[CustomerID]
		,[B].[Name]
		,[C].[Employee Name]
		,LTRIM(RTRIM(SUBSTRING([C].[Employee Name], 0, CHARINDEX(' ', [C].[Employee Name])))) AS [FirstName]
		,LTRIM(RTRIM(SUBSTRING([C].[Employee Name], CHARINDEX(' ', [C].[Employee Name]), LEN([C].[Employee Name])))) AS [LastName]
	FROM
		[BWSdb].[dbo].[ACD FireDrillRoster] AS [FDR] WITH (NOLOCK)
	INNER JOIN
		[BWSdb].[dbo].[v_ITRCustomersWithDepartments] AS [C] WITH (NOLOCK)
	ON
		[FDR].[IDITRCustomers] = [C].[CustomerID]
	INNER JOIN
		[BWSdb].[dbo].[ITI Buildings] AS [B] WITH (NOLOCK)
	ON
		[FDR].[IDBuilding] = [B].[ID]
	WHERE
		([C].[C_Active] = 1)
		AND ([B].[Active] = 1)
		AND ([FDR].[Active] = 1)
) AS [Src]
;
