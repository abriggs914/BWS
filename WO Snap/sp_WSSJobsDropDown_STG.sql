USE SysproCompanyS
GO

CREATE PROCEDURE [sp_WSSJobsDropDown_STG] AS BEGIN

	SELECT 
		[Job]
	FROM
		[WipJobAllLab] AS WipJobAllMat_STG
	WHERE
		ISNULL([Job], '') <> ''
	GROUP BY
		[Job]
	UNION
		SELECT
			[WO#]
		FROM
			[BWSdb].[dbo].[OrdersV2]
		LEFT JOIN
			[WipJobAllLab]
		ON
			[WipJobAllLab].[Job] = CAST([OrdersV2].[WO#] AS NVARCHAR(MAX))
		WHERE
			[WipJobAllLab].[Job] IS NULL
			AND [WO#] IS NOT NULL
	ORDER BY
		[Job];

END