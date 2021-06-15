-- SELECT * FROM `PizzaCompany`

-- SELECT DISTINCT [CompanyCity] FROM [PizzaCompany]
SELECT DISTINCT
  [PizzaCompany].[CompanyName], [PizzaCompany].[CompanyCity]
FROM
  [PizzaCompany]
INNER JOIN (
  SELECT
    ROW_NUMBER() OVER (
      PARTITION BY [CompanyCity]
      ORDER BY [CompanyID]
    ) row_num, *
  FROM 
      [PizzaCompany]
)
AS A
ON
  [PizzaCompany].[CompanyName] = A.[CompanyName]
-- ORDER BY [CompanyCity], [row_num]

/*
SELECT
  ROW_NUMBER() OVER (
    PARTITION BY [CompanyCity]
    ORDER BY [CompanyID]
  ) row_num, *
FROM 
	[PizzaCompany]
ORDER BY [CompanyCity], [row_num]
*/



-- based on answer https://stackoverflow.com/a/7745635/808921

-- SELECT a.id, a.rev, a.content
-- FROM `docs` a
-- INNER JOIN (
--     SELECT id, MAX(rev) rev
--     FROM `docs`
--     GROUP BY id
-- ) b ON a.id = b.id AND a.rev = b.rev;


-- SELECT a.*
-- FROM `docs` a
-- LEFT OUTER JOIN `docs` b
--     ON a.id = b.id AND a.rev < b.rev
-- WHERE b.id IS NULL;