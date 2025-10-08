-- 2025-09-25 17:39

;WITH Buckets AS (
    SELECT
        [O].[Model No],
        SortG,
        SortSe,
        Description,
        MIN([O].Quote#) AS MinQuote,
        MAX([O].Quote#) AS MaxQuote,
        COUNT(*) AS Cnt
    FROM [BWSdb].[dbo].[Order Standards] OS
    INNER JOIN [BWSdb].[dbo].[Orders] O
        ON OS.Quote# = O.Quote#
	WHERE
		[Quote Date] > '2023-12-31'
    GROUP BY [O].[Model No], SortG, SortSe, Description
    HAVING COUNT(*) > 1
)
SELECT B1.[Model No], B1.SortG, B1.SortSe, B1.Description,
       A.Quote# AS Quote_A, B.Quote# AS Quote_B
FROM Buckets B1
JOIN [BWSdb].[dbo].[Order Standards] A
  ON A.[Model No] = B1.[Model No]
 AND A.SortG = B1.SortG
 AND A.SortSe = B1.SortSe
 AND A.Description = B1.Description
JOIN [BWSdb].[dbo].[Order Standards] B
  ON B.[Model No] = B1.[Model No]
 AND B.SortG = B1.SortG
 AND B.SortSe = B1.SortSe
 AND B.Description = B1.Description
 AND A.Quote# < B.Quote#;
