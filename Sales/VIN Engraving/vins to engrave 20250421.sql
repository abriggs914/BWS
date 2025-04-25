
-- Shelleys list of units that need VINs engraved 2025-04-21

DECLARE @t TABLE ([ID] INT IDENTITY, [Q] NVARCHAR(12), [SN] NVARCHAR(17))
INSERT INTO @t ([Q], [SN]) VALUES
('SG101653', NULL),
('SG100576', NULL),
('SG100581', NULL),
('SG100585', NULL),
('SG100586', NULL),
('SG100584', NULL),
('SG100587', NULL),

(NULL, '2S9DA64634M115319'),
(NULL, '2S9DA2144YM115038'),
(NULL, '2S9DA6468HM117329')
;


SELECT
	[SGQuote]
	,[Model No]
	,[Serial Number]
	,[GVWR]
	--,[Date In Service]
	--,[Date Registered]
	--,[Date Requested]
	,[Delivery Date]
	--,[Finish Date]
	/*,[UnitQtyReqd]
	,[M].**/
FROM
	[BWSdb].[dbo].[OrdersV2] [O]
INNER JOIN
	@t [T]
ON
	(CASE WHEN [T].[SN] IS NULL THEN (CASE WHEN [T].[Q] = [O].[SGQuote] THEN 1 ELSE 0 END) ELSE (CASE WHEN [T].[SN] = [O].[Serial Number] THEN 1 ELSE 0 END) END) = 1