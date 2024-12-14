/*
SELECT
	*
FROM
	[uniPoint_Live].[dbo].[v_Tools&Equip]
WHERE
	[Current_location] LIKE '%emma%'
*/

DECLARE @machines TABLE ([ID] INT IDENTITY(0, 1), [Name] NVARCHAR(255));
INSERT INTO @machines ([Name]) VALUES
	('HORIZONTAL SAW'),
	('HYDRAULIC IRON WORKER'),
	('PRESS BRAKE 1'),
	('PRESS BRAKE 2'),
	('PRESS BRAKE 3'),
	('DRILL 1'),
	('DRILL 2'),
	('DRILL 4'),
	('MANUAL SAW'),
	('MECHANICAL IRON WORKER'),
	('VERTICAL SAW'),
	('SHEAR'),
	('BUFF'),
	('LATHE'),
	('FLAME CUTTER')
;

DECLARE @empsYear00 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear01 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear02 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear03 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear04 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear05 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear06 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear07 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear08 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear09 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear10 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear11 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear12 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear13 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear14 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear15 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear16 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear17 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear18 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear19 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear20 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear21 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear22 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear23 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear24 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear25 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear26 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear27 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear28 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear29 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYear30 TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));
DECLARE @empsYearCurr TABLE ([ID] INT IDENTITY(0, 1), [Year] NVARCHAR(255), [Name] NVARCHAR(255));

INSERT INTO @empsYear00 ([Year], [Name])
SELECT '2000' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2000-01-01' AND '2000-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear01 ([Year], [Name])
SELECT '2001' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2001-01-01' AND '2001-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear02 ([Year], [Name])
SELECT '2002' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2002-01-01' AND '2002-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear03 ([Year], [Name])
SELECT '2003' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2003-01-01' AND '2003-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear04 ([Year], [Name])
SELECT '2004' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2004-01-01' AND '2004-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear05 ([Year], [Name])
SELECT '2005' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2005-01-01' AND '2005-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear06 ([Year], [Name])
SELECT '2006' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2006-01-01' AND '2006-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear07 ([Year], [Name])
SELECT '2007' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2007-01-01' AND '2007-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear08 ([Year], [Name])
SELECT '2008' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2008-01-01' AND '2008-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear09 ([Year], [Name])
SELECT '2009' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2009-01-01' AND '2009-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear10 ([Year], [Name])
SELECT '2010' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2010-01-01' AND '2010-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear11 ([Year], [Name])
SELECT '2011' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2011-01-01' AND '2011-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear12 ([Year], [Name])
SELECT '2012' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2012-01-01' AND '2012-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear13 ([Year], [Name])
SELECT '2013' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2013-01-01' AND '2013-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear14 ([Year], [Name])
SELECT '2014' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2014-01-01' AND '2014-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear15 ([Year], [Name])
SELECT '2015' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2015-01-01' AND '2015-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear16 ([Year], [Name])
SELECT '2016' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2016-01-01' AND '2016-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear17 ([Year], [Name])
SELECT '2017' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2017-01-01' AND '2017-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear18 ([Year], [Name])
SELECT '2018' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2018-01-01' AND '2018-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear19 ([Year], [Name])
SELECT '2019' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2019-01-01' AND '2019-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear20 ([Year], [Name])
SELECT '2020' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2020-01-01' AND '2020-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear21 ([Year], [Name])
SELECT '2021' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2021-01-01' AND '2021-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear22 ([Year], [Name])
SELECT '2022' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2022-01-01' AND '2022-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear23 ([Year], [Name])
SELECT '2023' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2023-01-01' AND '2023-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear24 ([Year], [Name])
SELECT '2024' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2024-01-01' AND '2024-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear25 ([Year], [Name])
SELECT '2025' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2025-01-01' AND '2025-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear26 ([Year], [Name])
SELECT '2026' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2026-01-01' AND '2026-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear27 ([Year], [Name])
SELECT '2027' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2027-01-01' AND '2027-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear28 ([Year], [Name])
SELECT '2028' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2028-01-01' AND '2028-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear29 ([Year], [Name])
SELECT '2029' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2029-01-01' AND '2029-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYear30 ([Year], [Name])
SELECT '2030' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN '2030-01-01' AND '2030-12-31 23:59:59') AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

INSERT INTO @empsYearCurr ([Year], [Name])
SELECT 'Curr' AS [T], [CT].[EmployeeName]
FROM [SysproCompanyA].[dbo].[ClkTransaction] [CT]
LEFT JOIN @machines [MC]
ON [CT].[EmployeeName] COLLATE DATABASE_DEFAULT = [MC].[Name] COLLATE DATABASE_DEFAULT
WHERE ([LoggedOn] BETWEEN DATEADD(DAY, -15, GETDATE()) AND GETDATE()) AND ([MC].[Name] IS NULL)
GROUP BY [CT].[EmployeeName]
ORDER BY [CT].[EmployeeName]
;

SELECT * FROM @empsYear00
UNION SELECT * FROM @empsYear01
UNION SELECT * FROM @empsYear02
UNION SELECT * FROM @empsYear03
UNION SELECT * FROM @empsYear04
UNION SELECT * FROM @empsYear05
UNION SELECT * FROM @empsYear06
UNION SELECT * FROM @empsYear07
UNION SELECT * FROM @empsYear08
UNION SELECT * FROM @empsYear09
UNION SELECT * FROM @empsYear10
UNION SELECT * FROM @empsYear11
UNION SELECT * FROM @empsYear12
UNION SELECT * FROM @empsYear13
UNION SELECT * FROM @empsYear14
UNION SELECT * FROM @empsYear15
UNION SELECT * FROM @empsYear16
UNION SELECT * FROM @empsYear17
UNION SELECT * FROM @empsYear18
UNION SELECT * FROM @empsYear19
UNION SELECT * FROM @empsYear20
UNION SELECT * FROM @empsYear21
UNION SELECT * FROM @empsYear22
UNION SELECT * FROM @empsYear23
UNION SELECT * FROM @empsYear24
UNION SELECT * FROM @empsYear25
UNION SELECT * FROM @empsYear26
UNION SELECT * FROM @empsYear27
UNION SELECT * FROM @empsYear28
UNION SELECT * FROM @empsYear29
UNION SELECT * FROM @empsYear30
UNION SELECT * FROM @empsYearCurr
ORDER BY
	[Year]
	

SELECT
	[Name]
	,[2000]
	,[2001]
	,[2002]
	,[2003]
	,[2004]
	,[2005]
	,[2006]
	,[2007]
	,[2008]
	,[2009]
	,[2010]
	,[2011]
	,[2012]
	,[2013]
	,[2014]
	,[2015]
	,[2016]
	,[2017]
	,[2018]
	,[2019]
	,[2020]
	,[2021]
	,[2022]
	,[2023]
	,[2024]
	,[2025]
	,[2026]
	,[2027]
	,[2028]
	,[2029]
	,[2030]
	,[Curr]
	,MAX([CT].[LoggedOff]) AS [LastLogOff]
FROM (
	SELECT
		ISNULL([YC].[Name],
			ISNULL([Y30].[Name], ISNULL([Y29].[Name], ISNULL([Y28].[Name], ISNULL([Y27].[Name], ISNULL([Y26].[Name],
			ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
			)))))
			)))))
		) AS [Name]
		,[Y00].[Year] AS [2000]
		,[Y01].[Year] AS [2001]
		,[Y02].[Year] AS [2002]
		,[Y03].[Year] AS [2003]
		,[Y04].[Year] AS [2004]
		,[Y05].[Year] AS [2005]
		,[Y06].[Year] AS [2006]
		,[Y07].[Year] AS [2007]
		,[Y08].[Year] AS [2008]
		,[Y09].[Year] AS [2009]
		,[Y10].[Year] AS [2010]
		,[Y11].[Year] AS [2011]
		,[Y12].[Year] AS [2012]
		,[Y13].[Year] AS [2013]
		,[Y14].[Year] AS [2014]
		,[Y15].[Year] AS [2015]
		,[Y16].[Year] AS [2016]
		,[Y17].[Year] AS [2017]
		,[Y18].[Year] AS [2018]
		,[Y19].[Year] AS [2019]
		,[Y20].[Year] AS [2020]
		,[Y21].[Year] AS [2021]
		,[Y22].[Year] AS [2022]
		,[Y23].[Year] AS [2023]
		,[Y24].[Year] AS [2024]
		,[Y25].[Year] AS [2025]
		,[Y26].[Year] AS [2026]
		,[Y27].[Year] AS [2027]
		,[Y28].[Year] AS [2028]
		,[Y29].[Year] AS [2029]
		,[Y30].[Year] AS [2030]
		,[YC].[Year] AS [Curr]
	FROM
		@empsYear00 [Y00]
	FULL JOIN
		@empsYear01 [Y01]
	ON
		[Y00].[Name] = [Y01].[Name]
	FULL JOIN
		@empsYear02 [Y02]
	ON
		ISNULL([Y01].[Name], [Y00].[Name]) = [Y02].[Name]
	FULL JOIN
		@empsYear03 [Y03]
	ON
		ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])) = [Y03].[Name]
	FULL JOIN
		@empsYear04 [Y04]
	ON
		ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name]))) = [Y04].[Name]
	FULL JOIN
		@empsYear05 [Y05]
	ON
		ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))) = [Y05].[Name]
	FULL JOIN
		@empsYear06 [Y06]
	ON
		ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name]))))) = [Y06].[Name]
	FULL JOIN
		@empsYear07 [Y07]
	ON
		ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
		) = [Y07].[Name]
	FULL JOIN
		@empsYear08 [Y08]
	ON
		ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
		)) = [Y08].[Name]
	FULL JOIN
		@empsYear09 [Y09]
	ON
		ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
		))) = [Y09].[Name]
	FULL JOIN
		@empsYear10 [Y10]
	ON
		ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
		)))) = [Y10].[Name]
	FULL JOIN
		@empsYear11 [Y11]
	ON
		ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
		))))) = [Y11].[Name]
	FULL JOIN
		@empsYear12 [Y12]
	ON
		ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
		) = [Y12].[Name]
	FULL JOIN
		@empsYear13 [Y13]
	ON
		ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
		)) = [Y13].[Name]
	FULL JOIN
		@empsYear14 [Y14]
	ON
		ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
		))) = [Y14].[Name]
	FULL JOIN
		@empsYear15 [Y15]
	ON
		ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
		)))) = [Y15].[Name]
	FULL JOIN
		@empsYear16 [Y16]
	ON
		ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
		))))) = [Y16].[Name]
	FULL JOIN
		@empsYear17 [Y17]
	ON
		ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
		) = [Y17].[Name]
	FULL JOIN
		@empsYear18 [Y18]
	ON
		ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
		)) = [Y18].[Name]
	FULL JOIN
		@empsYear19 [Y19]
	ON
		ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
		))) = [Y19].[Name]
	FULL JOIN
		@empsYear20 [Y20]
	ON
		ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
		)))) = [Y20].[Name]
	FULL JOIN
		@empsYear21 [Y21]
	ON
		ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
		))))) = [Y21].[Name]
	FULL JOIN
		@empsYear22 [Y22]
	ON
		ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
		) = [Y22].[Name]
	FULL JOIN
		@empsYear23 [Y23]
	ON
		ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
		)) = [Y23].[Name]
	FULL JOIN
		@empsYear24 [Y24]
	ON
		ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
		))) = [Y24].[Name]
	FULL JOIN
		@empsYear25 [Y25]
	ON
		ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
		)))) = [Y25].[Name]
	FULL JOIN
		@empsYear26 [Y26]
	ON
		ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
		))))) = [Y26].[Name]
	FULL JOIN
		@empsYear27 [Y27]
	ON
		ISNULL([Y26].[Name],
			ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
			)))))
		) = [Y27].[Name]
	FULL JOIN
		@empsYear28 [Y28]
	ON
		ISNULL([Y27].[Name], ISNULL([Y26].[Name],
			ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
			)))))
		)) = [Y28].[Name]
	FULL JOIN
		@empsYear29 [Y29]
	ON
		ISNULL([Y28].[Name], ISNULL([Y27].[Name], ISNULL([Y26].[Name],
			ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
			)))))
		))) = [Y29].[Name]
	FULL JOIN
		@empsYear30 [Y30]
	ON
		ISNULL([Y29].[Name], ISNULL([Y28].[Name], ISNULL([Y27].[Name], ISNULL([Y26].[Name],
			ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
			)))))
		)))) = [Y30].[Name]
	FULL JOIN
		@empsYearCurr [YC]
	ON
		ISNULL([Y30].[Name],
			ISNULL([Y29].[Name], ISNULL([Y28].[Name], ISNULL([Y27].[Name], ISNULL([Y26].[Name],
			ISNULL([Y25].[Name], ISNULL([Y24].[Name], ISNULL([Y23].[Name], ISNULL([Y22].[Name], ISNULL([Y21].[Name],
			ISNULL([Y20].[Name], ISNULL([Y19].[Name], ISNULL([Y18].[Name], ISNULL([Y17].[Name], ISNULL([Y16].[Name],
			ISNULL([Y15].[Name], ISNULL([Y14].[Name], ISNULL([Y13].[Name], ISNULL([Y12].[Name], ISNULL([Y11].[Name],
			ISNULL([Y10].[Name], ISNULL([Y09].[Name], ISNULL([Y08].[Name], ISNULL([Y07].[Name], ISNULL([Y06].[Name],
			ISNULL([Y05].[Name], ISNULL([Y04].[Name], ISNULL([Y03].[Name], ISNULL([Y02].[Name], ISNULL([Y01].[Name], [Y00].[Name])))))
			)))))
			)))))
			)))))
			)))))
			))))
		) = [YC].[Name]

) AS [Src]
/*FULL JOIN
	@empsYear23 [Y23]
ON
	[Y00].[Name] = [Y23].[Name]
FULL JOIN
	@empsYear24 [Y24]
ON
	ISNULL([Y00].[Name], [Y23].[Name]) = [Y24].[Name]
*/
LEFT JOIN
	[SysproCompanyA].[dbo].[ClkTransaction] [CT]
ON
	[Src].[Name] COLLATE DATABASE_DEFAULT = [CT].[EmployeeName] COLLATE DATABASE_DEFAULT
GROUP BY
	[Name]
	,[2000]
	,[2001]
	,[2002]
	,[2003]
	,[2004]
	,[2005]
	,[2006]
	,[2007]
	,[2008]
	,[2009]
	,[2010]
	,[2011]
	,[2012]
	,[2013]
	,[2014]
	,[2015]
	,[2016]
	,[2017]
	,[2018]
	,[2019]
	,[2020]
	,[2021]
	,[2022]
	,[2023]
	,[2024]
	,[2025]
	,[2026]
	,[2027]
	,[2028]
	,[2029]
	,[2030]
	,[Curr]
ORDER BY
	[LastLogOff]
	--[Src].[Name]


/*
SELECT
	*
FROM
	@empsYear1
ORDER BY
	[Name]

SELECT
	*
FROM
	@empsYear2
ORDER BY
	[Name]

SELECT
	*
FROM
	@empsYear3
ORDER BY
	[Name]
*/