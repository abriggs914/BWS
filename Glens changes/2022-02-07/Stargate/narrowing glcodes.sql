

	SELECT * FROM [SysproCompanyS].[dbo].[GenMaster] ORDER BY [GlCode]
	SELECT * FROM [SysproCompanyA].[dbo].[GenMaster] ORDER BY [GlCode]

	SELECT
		[A].[GlCode],
		[B].[GlCode],
		[A].[Description]
	FROM
		[SysproCompanyS].[dbo].[GenMaster] AS [A]
	INNER JOIN
		[SysproCompanyA].[dbo].[GenMaster] AS [B]
	ON 
		[A].[Description] = [B].[Description]
	ORDER BY 
		[A].[GlCode]



	SELECT * FROM [SysproCompanyS].[dbo].[GenMaster] WHERE LOWER([Description]) LIKE '%part%' ORDER BY [GlCode]
	SELECT * FROM [SysproCompanyA].[dbo].[GenMaster] WHERE [GlCode] IN ('4505', '4510', '5095') ORDER BY [GlCode]