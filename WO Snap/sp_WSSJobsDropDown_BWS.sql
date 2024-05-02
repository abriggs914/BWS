USE SysproCompanyA
GO

ALTER PROCEDURE [sp_WSSJobsDropDown_BWS] AS BEGIN

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
			CAST([WO#] AS NVARCHAR(MAX))
		FROM
			[BWSdb].[dbo].[Orders]
		LEFT JOIN
			[WipJobAllLab]
		ON
			[WipJobAllLab].[Job] = CAST([Orders].[WO#] AS NVARCHAR(MAX))
		WHERE
			[WipJobAllLab].[Job] IS NULL
			AND [WO#] IS NOT NULL
	ORDER BY
		[Job];

END