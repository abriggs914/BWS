USE BWSdb
GO

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
WHERE
	[Row#] > 1
ORDER BY
	[Option No]
;


BEGIN TRAN;

SELECT * FROM [Budget Options V2] ORDER BY [Option No];

DELETE
FROM
	[Budget Options V2]
WHERE
	[ID#] IN (SELECT [ID] FROM @invalid_ids)
;

SELECT * FROM [Budget Options V2] ORDER BY [Option No];

ROLLBACK;
COMMIT;
