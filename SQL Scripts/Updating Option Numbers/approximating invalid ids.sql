USE BWSdb
GO

--SELECT * FROM [Options V2_FactoryLines]
--SELECT * FROM [Options_FactoryLinesV2] WHERE [CompanyID] = 1
--SELECT * FROM [Options_SpecLinesV2] WHERE [CompanyID] = 1


--SELECT [Option No] FROM [Budget Options V2] ORDER BY [Option No]
--SELECT COUNT([Option No]) FROM [Budget Options V2] WHERE [Option No] IS NOT NULL
--SELECT COUNT(DISTINCT [Option No]) FROM [Budget Options V2] WHERE [Option No] IS NOT NULL

--SELECT * FROM [OptionsV2] ORDER BY [Option No]
--SELECT * FROM [Budget Options V2] ORDER BY [Option No]




--SELECT
--	*
--FROM
--	[Budget Options V2]



DECLARE @Double_Entry_Options TABLE ([Option No] VARCHAR(50));
INSERT INTO @Double_Entry_Options
SELECT
	[Option No]
FROM
	[Budget Options V2]
WHERE
	[CompanyID] = 1
GROUP BY
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY
	[Option No]
;



SELECT
	[Option No]
FROM
	[OptionsV2]
WHERE
	[CompanyID] = 1
GROUP BY
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY
	[Option No]
;

SELECT
	[Option No]
FROM
	[OptionsV2]
WHERE
	[CompanyID] = 1
GROUP BY
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY
	[Option No]
;





SELECT * FROM @Double_Entry_Options;


-- Create a table of invalid option IDs
DECLARE @invalid_ids AS TABLE (
	[Row#] INT,
	[ID] BIGINT,
	[Option No] VARCHAR(50)
);
INSERT INTO @invalid_ids
SELECT
	ROW_NUMBER() OVER (
		PARTITION BY [A].[Option No]
		ORDER BY [A].[Option No], [ID#]
	) AS [Row#],
	[ID#],
	[A].[Option No]
FROM
	@Double_Entry_Options AS [A]
INNER JOIN	
	[Budget Options V2]
ON
	[A].[Option No] = [Budget Options V2].[Option No]
ORDER BY
	[A].[Option No], [ID#]
;

SELECT
	*
FROM
	@invalid_ids
;


DECLARE @ids_to_cut AS TABLE ([ID] BIGINT);
INSERT INTO @ids_to_cut
SELECT
	[ID]
FROM
	@invalid_ids
WHERE
	[Row#] > 1
ORDER BY
	[Option No]
;

SELECT
	[ID]
FROM
	@ids_to_cut
ORDER BY
	[ID]

	
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------

DECLARE @all_option_ids AS TABLE ([ID] BIGINT, [Option No] VARCHAR(50));
INSERT INTO @all_option_ids
SELECT
	[ID#],
	[Option No]
FROM
	[OptionsV2] WITH (NOLOCK)
;

SELECT
	[ID#]
FROM
	[Budget Options V2] WITH (NOLOCK)
WHERE
	[Option No] NOT IN (SELECT [Option No] FROM @all_option_ids)
ORDER BY
	[ID#]


SELECT
	[Option No]
FROM
	[Options]
GROUP BY
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY
	[Option No]


SELECT
	[Option No]
FROM
	[Options]
GROUP BY
	[Option No]
HAVING
	COUNT([Option No]) > 1
ORDER BY
	[Option No]