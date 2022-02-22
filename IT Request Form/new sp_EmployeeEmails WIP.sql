USE BWSdb
GO

DECLARE @SRC TABLE ([Emp#] REAL, [NameFromSyspro] NVARCHAR(250), [1st Name] NVARCHAR(250), [2nd Name] NVARCHAR(250), [Email] NVARCHAR(250));
INSERT INTO @SRC 
SELECT DISTINCT
	[Emp#] AS [Emp#],
	[AdmOperator].[Name] AS [NameFromSyspro],
	LTRIM(RTRIM([dbo].ToProperCase(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END))) AS [1st Name],
	LTRIM(RTRIM((CASE 
		WHEN 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (((SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC))) ELSE [2nd Name] END))) =
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [1st Name] IS NULL THEN (SELECT TOP 1 * FROM [dbo].split_string([Name], ' ')) ELSE [1st Name] END)))
		THEN 
			NULL 
		ELSE 
			[dbo].ToProperCase(LTRIM(RTRIM(CASE WHEN [2nd Name] IS NULL THEN (SELECT TOP 1 [splited_data] FROM [dbo].split_string_idx([Name], ' ') ORDER BY [Idx] DESC) ELSE [2nd Name] END)))
	END))) AS [2nd Name],
	[Email]
FROM
	[Sysprodb].[dbo].[AdmOperator]
LEFT JOIN
	[Employees]
ON
	[Sysprodb].[dbo].[AdmOperator].[Name] COLLATE DATABASE_DEFAULT = ([Employees].[1st Name] + ' ' + [Employees].[2nd Name]) COLLATE DATABASE_DEFAULT
WHERE
	[Email] IS NOT NULL AND LTRIM(RTRIM([Email])) != '' AND LEN(LTRIM(RTRIM([Email]))) > 3
;

SELECT * FROM @SRC

SELECT DISTINCT
	(CASE WHEN [Emp#] IS NULL THEN (CASE WHEN [T1].[Employee] IS NULL THEN RIGHT([T2].[Employee], 3) ELSE RIGHT([T1].[Employee], 3) END) ELSE [Emp#] END) AS [Emp#],
	[NameFromSyspro],
	[1st Name],
	[2nd Name],
	[@SRC].[1st Name] + ' ' + [@SRC].[2nd Name] AS [Name],
	[Email],
	
	(CASE WHEN LOWER([T1].[Name]) IS NULL THEN (CASE WHEN [T2].[Name] IS NULL THEN 'BWS' ELSE 'STARGATE' END) ELSE 'BWS' END) AS [Company],
	LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) AS [BWS Emp Name],
	LOWER([T1].[Name]) AS [CompanyA],
	LOWER([T2].[Name]) AS [CompanyS],
	(CASE WHEN (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) THEN 1 ELSE 0 END) AS [F]
FROM
	@SRC
LEFT JOIN (
	
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyA].[dbo].[BomEmployee]
	UNION 
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyA].[dbo].[ClkEmployee]
	) AS [T1]
ON
	LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
	-- Change 'glen' to 'glendon' for Glen Findlater 2021-11-18
	OR 1=(CASE 
			WHEN 
				LOWER([T1].[Name]) = 'findlater, glendon' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'glendon')) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'glendon')) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + 'glendon')) COLLATE DATABASE_DEFAULT)
					THEN
						1
					ELSE
						0
					END)
	-- Change 'jeff' to 'jeffrey' for Jeff Sherwood 2021-11-18
	OR 1=(CASE 
			WHEN
				LOWER([T1].[Name]) = 'sherwood, jeffrey' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'jeffrey')) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'jeffrey')) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + 'jeffrey')) COLLATE DATABASE_DEFAULT)
					THEN
						1
					ELSE
						0
					END)
	-- Change 'metherell' to 'mertherell' for Joanna Metherell 2021-11-18
	OR 1=(CASE 
			WHEN
				LOWER([T1].[Name]) = 'mertherell, joanna' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('mertherell' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('mertherell' + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('mertherell' + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) 
					THEN
						1
					ELSE
						0
					END)
	-- Change 'gillis' to 'gillas' for Matthew Gillis 2021-11-18
	OR 1=(CASE 
			WHEN 
				LOWER([T1].[Name]) = 'gillas, matthew' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('gillas' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('gillas' + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('gillas' + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) 
					THEN
						1
					ELSE
						0
					END)
	-- Change 'mike' to 'michael' for Mike Guest 2021-11-18
	OR 1=(CASE 
			WHEN 
				LOWER([T1].[Name]) = 'guest, michael' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'michael')) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'michael')) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + 'michael')) COLLATE DATABASE_DEFAULT)
					THEN
						1
					ELSE
						0
					END)
	-- Change 'nasser' to 'nassar' for Yassin Yassar 2021-11-18
	OR 1=(CASE 
			WHEN
				LOWER([T1].[Name]) = 'nassar, yassin' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('nassar' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT 
				OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('nassar' + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT 
				OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('nassar' + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT)
				THEN
						1
					ELSE
						0
					END)
	-- Change 'rocky' to 'Rockland' for Rocky Sears 2021-11-18
	OR 1=(CASE 
			WHEN
				LOWER([T1].[Name]) = 'sears, rockland' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'rockland')) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'rockland')) COLLATE DATABASE_DEFAULT 
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + 'rockland')) COLLATE DATABASE_DEFAULT)
					THEN
						1
					ELSE
						0
					END)
	-- Change 'hawlings' to 'hawling' for Roland Hawling 2021-11-18
	OR 1=(CASE 
			WHEN 
				LOWER([T1].[Name]) = 'hawlings, roland' 
				AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('hawling' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('hawling' + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
					OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('hawling' + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT)
					THEN
						1
					ELSE
						0
					END)
LEFT JOIN (
	
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyS].[dbo].[BomEmployee]
	UNION 
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyS].[dbo].[ClkEmployee]
	) AS [T2]
ON
	LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
WHERE
	1 = (CASE WHEN LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) IS NULL THEN 1 ELSE (CASE WHEN LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT = LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT THEN 1 ELSE 0 END) END)
ORDER BY
	[1st Name], [2nd Name]--[Email]

;



SELECT DISTINCT [Employee], LOWER([Name]) FROM [SysproCompanyA].[dbo].[BomEmployee]
UNION 
SELECT DISTINCT [Employee], LOWER([Name]) FROM [SysproCompanyA].[dbo].[ClkEmployee] ORDER BY LOWER([Name])


SELECT DISTINCT
	COUNT(*) AS [Total Null Employee #]
FROM
	@SRC
LEFT JOIN (
	
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyA].[dbo].[BomEmployee]
	UNION 
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyA].[dbo].[ClkEmployee]
	) AS [T1]
ON
	LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
	-- Change 'glen' to 'glendon' for Glen Findlater 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'findlater, glendon' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'glendon')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'glendon')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + 'glendon')) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'jeff' to 'jeffrey' for Jeff Sherwood 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'sherwood, jeffrey' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'jeffrey')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'jeffrey')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + 'jeffrey')) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'metherell' to 'mertherell' for Joanna Metherell 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'mertherell, joanna' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('mertherell' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('mertherell' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('mertherell' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'gillis' to 'gillas' for Matthew Gillis 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'gillas, matthew' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('gillas' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('gillas' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('gillas' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'mike' to 'michael' for Mike Guest 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'guest, michael' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'michael')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'michael')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'michael')) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'nasser' to 'nassar' for Yassin Yassar 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'nassar, yassin' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('nassar' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('nassar' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('nassar' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'rocky' to 'Rockland' for Rocky Sears 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'sears, rockland' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'rockland')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'rockland')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'rockland')) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
	-- Change 'hawlings' to 'hawling' for Roland Hawling 2021-11-18
	OR 1=(CASE 
			WHEN LOWER([T1].[Name]) LIKE 'hawlings, roland' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('hawling' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('hawling' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(('hawling' + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) THEN
						1
					ELSE
						0
					END)
LEFT JOIN (
	
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyS].[dbo].[BomEmployee]
	UNION 
	SELECT DISTINCT [Employee], [Name] FROM [SysproCompanyS].[dbo].[ClkEmployee]
	) AS [T2]
ON
	LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT OR LOWER([T2].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT
WHERE
	(CASE WHEN [Emp#] IS NULL THEN (CASE WHEN [T1].[Employee] IS NULL THEN RIGHT([T2].[Employee], 3) ELSE RIGHT([T1].[Employee], 3) END) ELSE [Emp#] END) IS NULL


	--(CASE WHEN [Emp#] IS NULL THEN (
	--	CASE WHEN CAST(right('000' + [T].[Employee], 3) AS INT) = 0 THEN CAST(right('000' + [T].[Employee], 3) AS INT) ELSE CAST(right('000' + [T].[Employee], 3) AS INT) END
	--) ELSE [Emp#] END) AS [EMP#],



	--OR 1=(CASE 
	--		WHEN LOWER([T1].[Name]) LIKE 'findlater, glendon' AND (LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ', ' + 'glen')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ' ' + 'glen')) COLLATE DATABASE_DEFAULT OR LOWER([T1].[Name]) COLLATE DATABASE_DEFAULT = LOWER(([@SRC].[2nd Name] + ',' + [@SRC].[1st Name])) COLLATE DATABASE_DEFAULT) THEN
	--					1
	--				ELSE
	--					0
	--				END)

	
--WHERE
--	LOWER(LTRIM(RTRIM([1st Name]))) <> 'test'
--	AND LOWER(LTRIM(RTRIM([2nd Name]))) <> 'test'