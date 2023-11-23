USE BWSdb
GO


DECLARE @q0 NVARCHAR(MAX) = '27654';
--DECLARE @q1 NVARCHAR(MAX) = '27655';
--DECLARE @q2 NVARCHAR(MAX) = '27656';
--DECLARE @q3 NVARCHAR(MAX) = '27657';

--DECLARE @q0 NVARCHAR(MAX) = '27654';
DECLARE @q1 NVARCHAR(MAX) = '';
DECLARE @q2 NVARCHAR(MAX) = '';
DECLARE @q3 NVARCHAR(MAX) = '';

SELECT
	[Orders_Quote]
	,[Products_ModelNo]
	,[Orders_USSale]
	,[SumOfNPOUSPrice]
	,[SumOfOptionsPrice]
	,[CountOfNPOs]
	,[CountOfOptions]
	,[Orders_Price]
	,[Products_Price]
	,[Orders_Discount1]
	,[Orders_Discount1_Type]
	,[Orders_Discount2]
	,[Orders_Discount2_Type]
	,[Orders_Discount3]
	,[Orders_Discount3_Type]
	,[TotalFixed]
	,[PctgCoefficient]
	,(([Orders_Price] + [SumOfNPOUSPrice] + [SumOfOptionsPrice]) + [TotalFixed]) * [PctgCoefficient] AS [CalcPrice]
FROM (
	SELECT
		[Orders_Quote]
		,[Products_ModelNo]
		,[Orders_USSale]
		,SUM([CW].[US Price]) AS [SumOfNPOUSPrice]
		,SUM([OO].[Price]) AS [SumOfOptionsPrice]
		,COUNT([CW].[ID]) AS [CountOfNPOs]
		,COUNT([OO].[Option No]) AS [CountOfOptions]
		,[Orders_Price]
		,[Products_Price]
		,[Orders_Discount1]
		,[Orders_Discount1_Type]
		,[Orders_Discount2]
		,[Orders_Discount2_Type]
		,[Orders_Discount3]
		,[Orders_Discount3_Type]
		,(CASE WHEN ISNULL([Orders_Discount1_Type], '') = 'Percent' THEN 0 ELSE ISNULL([Orders_Discount1], 0) END)
			+ (CASE WHEN ISNULL([Orders_Discount2_Type], '') = 'Percent' THEN 0 ELSE ISNULL([Orders_Discount2], 0) END)
			+ (CASE WHEN ISNULL([Orders_Discount3_Type], '') = 'Percent' THEN 0 ELSE ISNULL([Orders_Discount3], 0) END)
		AS [TotalFixed]
		,(CASE 
			WHEN (ISNULL([Orders_Discount1], 0) = 0) AND (ISNULL([Orders_Discount2], 0) = 0) AND (ISNULL([Orders_Discount3], 0) = 0) THEN 0
			ELSE (1 - ISNULL([Orders_Discount1], 0)) * (1 - ISNULL([Orders_Discount2], 0)) * (1 - ISNULL([Orders_Discount3], 0))
		END) AS [PctgCoefficient]
		--,[O].*
		--,[OO].*
	FROM
		[v_SFC_BWSUnionSTGOrders] AS [O]
	INNER JOIN
		[Order Options] AS [OO]
	ON
		[O].[Orders_Quote] = CAST([OO].[Quote#] AS NVARCHAR(MAX))
	INNER JOIN
		[Custom Work] AS [CW]
	ON
		[O].[Orders_Quote] = CAST([CW].[Quote#] AS NVARCHAR(MAX))
	WHERE
		[Orders_Quote] IN (@q0, @q1, @q2, @q3)
	GROUP BY
		[Orders_Quote]
		,[Products_ModelNo]
		,[Orders_USSale]
		,[Orders_Price]
		,[Products_Price]
		,[Orders_Discount1]
		,[Orders_Discount1_Type]
		,[Orders_Discount2]
		,[Orders_Discount2_Type]
		,[Orders_Discount3]
		,[Orders_Discount3_Type]
		,[Orders_Price]
) AS [SrcA]
;


SELECT
	*
FROM
	[Order Options]
WHERE
	[Quote#] IN (@q0, @q1, @q2, @q3)
;
SELECT
	*
FROM
	[Custom Work]
WHERE
	[Quote#] IN (@q0, @q1, @q2, @q3)
;
SELECT
	'HERE',
	*
FROM
	[Order Options]
INNER JOIN
	[Custom Work]
ON
	[Order Options].[Quote#] = [Custom Work].[Quote#]
WHERE
	[Order Options].[Quote#] IN (@q0, @q1, @q2, @q3)


--SELECT
--	[Orders_Quote]
--	,[Products_ModelNo]
--	,[Orders_USSale]
--	--,[SumOfNPOUSPrice]
--	--,[SumOfOptionsPrice]
--	--,[CountOfNPOs]
--	--,[CountOfOptions]
--	,[Orders_Price]
--	,[Products_Price]
--	,[Orders_Discount1]
--	,[Orders_Discount1_Type]
--	,[Orders_Discount2]
--	,[Orders_Discount2_Type]
--	,[Orders_Discount3]
--	,[Orders_Discount3_Type]
--	,[TotalFixed]
--	,[PctgCoefficient]
--	--,(([Orders_Price] + [SumOfNPOUSPrice] + [SumOfOptionsPrice]) + [TotalFixed]) * [PctgCoefficient] AS [CalcPrice]
--FROM (
	SELECT
		[Orders_Quote]
		,[Products_ModelNo]
		,[Orders_USSale]
		--,SUM([CW].[US Price]) AS [SumOfNPOUSPrice]
		--,SUM([OO].[Price]) AS [SumOfOptionsPrice]
		--,COUNT([CW].[ID]) AS [CountOfNPOs]
		--,COUNT([OO].[Option No]) AS [CountOfOptions]
		,[Orders_Price]
		,[Products_Price]
		,[Orders_Discount1]
		,[Orders_Discount1_Type]
		,[Orders_Discount2]
		,[Orders_Discount2_Type]
		,[Orders_Discount3]
		,[Orders_Discount3_Type]
		,(CASE WHEN ISNULL([Orders_Discount1_Type], '') = 'Percent' THEN 0 ELSE ISNULL([Orders_Discount1], 0) END)
			+ (CASE WHEN ISNULL([Orders_Discount2_Type], '') = 'Percent' THEN 0 ELSE ISNULL([Orders_Discount2], 0) END)
			+ (CASE WHEN ISNULL([Orders_Discount3_Type], '') = 'Percent' THEN 0 ELSE ISNULL([Orders_Discount3], 0) END)
		AS [TotalFixed]
		,(CASE 
			WHEN (ISNULL([Orders_Discount1], 0) = 0) AND (ISNULL([Orders_Discount2], 0) = 0) AND (ISNULL([Orders_Discount3], 0) = 0) THEN 0
			ELSE (1 - ISNULL([Orders_Discount1], 0)) * (1 - ISNULL([Orders_Discount2], 0)) * (1 - ISNULL([Orders_Discount3], 0))
		END) AS [PctgCoefficient]
		,[O].*
		,[OO].*
		,[CW].*
	FROM
		[v_SFC_BWSUnionSTGOrders] AS [O]
	INNER JOIN
		[Order Options] AS [OO]
	ON
		[O].[Orders_Quote] = CAST([OO].[Quote#] AS NVARCHAR(MAX))
	INNER JOIN
		[Custom Work] AS [CW]
	ON
		[O].[Orders_Quote] = CAST([CW].[Quote#] AS NVARCHAR(MAX))
	WHERE
		([Orders_Quote] IN (@q0, @q1, @q2, @q3))
	--GROUP BY
	--	[Orders_Quote]
	--	,[Products_ModelNo]
	--	,[Orders_USSale]
	--	,[Orders_Price]
	--	,[Products_Price]
	--	,[Orders_Discount1]
	--	,[Orders_Discount1_Type]
	--	,[Orders_Discount2]
	--	,[Orders_Discount2_Type]
	--	,[Orders_Discount3]
	--	,[Orders_Discount3_Type]
	--	,[Orders_Price]
--) AS [SrcA]
;