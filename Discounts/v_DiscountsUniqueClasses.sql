
USE BWSdb
GO

CREATE VIEW [dbo].[v_DiscountsUniqueClasses] AS

SELECT
	[Class]
FROM (
	SELECT DISTINCT
		[Class]
	FROM
		v_DiscountDataProductsDealers
	UNION
	SELECT
		'NONE' AS [Class]
	FROM
		v_DiscountDataProductsDealers
) AS [Src]
--ORDER BY
	--(CASE WHEN [Class] = 'NONE' THEN 0 ELSE 1 END),
	--[Class]
;
GO