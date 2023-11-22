USE BWSdb
GO


DECLARE @q0 NVARCHAR(MAX) = '27654';
DECLARE @q1 NVARCHAR(MAX) = '27655';
DECLARE @q2 NVARCHAR(MAX) = '27656';
DECLARE @q3 NVARCHAR(MAX) = '27657';


SELECT
	[Orders_Quote]
	,[Products_ModelNo]
	,[Orders_USSale]
	,[CW].[US Price]
	,[Orders_Price]
	,[Products_Price]
	,[Orders_Discount1]
	,[Orders_Discount1_Type]
	,[Orders_Discount2]
	,[Orders_Discount2_Type]
	,[Orders_Discount3]
	,[Orders_Discount3_Type]
	,[O].*
	,[OO].*
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
;