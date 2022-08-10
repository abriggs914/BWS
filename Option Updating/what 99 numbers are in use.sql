DECLARE @Src AS TABLE ([ID] INT IDENTITY(1, 1), [Draw/Part] NVARCHAR(MAX), [Model No] NVARCHAR(MAX));
INSERT INTO @Src
SELECT 
	[Src2].[Draw/Part]
	,[Model No]
FROM (
	SELECT
		[Draw/Part]
	FROM (
		SELECT
			[Option No]
			,[Draw/Part#] AS [Draw/Part]
			--,*
			--,[DrawPArt#]
		FROM
			[Options]
		WHERE
			[Obsolete] = 0
		GROUP BY
			[Option No]
			,[Draw/Part#]
	) AS [Src1]
	GROUP BY
		[Draw/Part]
	HAVING COUNT(*) > 1
) AS [Src2]
LEFT JOIN
	[Options]
ON
	[Src2].[Draw/Part] = [Options].[Draw/Part#]
;

SELECT * FROM @Src

SELECT t2.[Draw/Part], STUFF((SELECT ';' + [Model No] FROM @Src t1  where t1.[Draw/Part] = t2.[Draw/Part] FOR XML PATH('')), 1 ,1, '') AS ValueList
FROM @Src t2
GROUP BY t2.[Draw/Part]

--SELECT DISTINCT
--	t1.[Draw/Part],
--    STUFF((SELECT ',' + [Model No]
--           FROM @Src t2
--           WHERE t2.Id = t1.Id
--           FOR XML PATH('')), 1 ,1, '') AS ValueList
--FROM 
--	@Src AS t1
----FOR XML PATH('') --AS [Vals]


--SELECT
--	--[Option No]
--	--,*
--	[Draw/Part#]
--FROM
--	[Options]
--GROUP BY
--	[Draw/Part#]
--HAVING COUNT(*) > 2