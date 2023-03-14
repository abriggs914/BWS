USE BWSdb
GO


-- mismatch options. These options are non-obsolete on one table but not the other.


CREATE VIEW [v_SDR_OptionsComparison] AS
SELECT
	*
FROM (

	SELECT 
		[P].[Non-Current] AS [Products NonCurrent]
		, [P].[Proposed] AS [Products Proposed]
		, [BO].[Obsolete] AS [Budget Options Obsolete]
		, [O].[Obsolete] AS [Options Obsolete]
		, [O].[Start Date]
		, [O].[End Date]
		, [BO].[Bud_Date_Opt]
		, [Class]
		, [BO].[Model No] AS [Budget Options ModelNo]
		, [BO].[Option No] AS [Budget Options OptionNo]
		, [O].[Option No] AS [Options OptionNo]
		, [O].[Description] AS [Options Description]
		, [BO].[Description] AS [Budget Options Description]
		, [O].[Price] AS [Options Price]
		, (CASE WHEN [O].[Obsolete] <> [BO].[Obsolete] THEN 1 ELSE 0 END) AS [Mismatch Obsolete]
		, (CASE WHEN [O].[Description] <> [BO].[Description] THEN 1 ELSE 0 END) AS [Mismatch Description]
	FROM
		[Budget Options] AS [BO]
	FULL OUTER JOIN 
		[Options] AS [O]
	--ON
	--	[BO].[Option No] = [O].[Option No]
	ON
		[BO].[Model No] = [O].[Model No]
		AND [BO].[Description] = [O].[Description]
	INNER JOIN 
		[Products] AS [P]
	ON
		[O].[Model No] = [P].[Model No]
) AS [Sub]
--WHERE
--	--[Mismatch Description] = 1
--	[Mismatch Obsolete] = 1

--ORDER BY
--	ISNULL([Sub].[End Date],
--		ISNULL([Sub].[Bud_Date_Opt],
--			ISNULL([Sub].[End Date], 
--				ISNULL([Sub].[Start Date], 
--					ISNULL([Sub].[Bud_Date_Opt], [Sub].[Start Date])
--	)))) DESC

;

GO