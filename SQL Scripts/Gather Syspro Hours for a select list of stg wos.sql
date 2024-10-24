
-- Charlie's list of WOs that he needs hours for.
-- 2024-10-23 1559


DECLARE @tWOs TABLE ([ID] INT IDENTITY(0, 1), [WO] INT)

INSERT INTO @tWOs ([WO]) VALUES
(10001426),
(10001383),
(10001381),
(10001452),
(10001455),
(10001454),
(10001460),
(10001484),
(10001485),
(10001482),
(10001462),
(10001514),
(10001535),
(10001537),
(10001509),
(10001510),
(10001576),
(10001577),
(10001572),
(10001573),
(10001588);


SELECT
	[Lab].[Job]
	,[Lab].[Operation]
	,(CASE WHEN [Master].[ActCompleteDate] IS NOT NULL THEN 'Y' ELSE 'N' END) AS [JobComplete]
	,[Lab].[IExpUnitRunTim]
	,[Lab].[RunTimeIssued]
	,[Lab].[IExpUnitRunTim] - [Lab].[RunTimeIssued] AS [RunTimeOverUnder]
	,[Lab].[UnitValueReqd]
	,[Lab].[ValueIssued]
	,[Lab].[UnitValueReqd] - [Lab].[ValueIssued] AS [ValueIssuedOverUnder]
FROM
	@tWOs [WOs]
INNER JOIN
	[SysproCompanyS].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
ON
	[Lab].[Job] = CAST([WO] AS NVARCHAR(MAX))
INNER JOIN
	[SysproCompanyS].[dbo].[WipMaster] [Master] WITH (NOLOCK)
ON
	[Lab].[Job] = [Master].[Job]
--WHERE
--	[Master].[ActCompleteDate] IS NOT NULL
--GROUP BY
--	[Lab].[Job]
--	,[Lab].[Operation]
ORDER BY
	[Lab].[Job]
	,[Lab].[Operation]

SELECT COUNT(*) FROM @tWOs
SELECT COUNT(*) FROM (
SELECT
	[Lab].[Job]
FROM
	@tWOs [WOs]
INNER JOIN
	[SysproCompanyS].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
ON
	[Lab].[Job] = CAST([WO] AS NVARCHAR(MAX))
INNER JOIN
	[SysproCompanyS].[dbo].[WipMaster] [Master] WITH (NOLOCK)
ON
	[Lab].[Job] = [Master].[Job]
--WHERE
--	[Master].[ActCompleteDate] IS NOT NULL
GROUP BY
	[Lab].[Job]
) AS [Src]


SELECT
	[Lab].[Job]
	,[Lab].[Operation]
	,[Lab].[IExpUnitRunTim]
	,[Lab].[RunTimeIssued]
	,[Lab].[IExpUnitRunTim] - [Lab].[RunTimeIssued] AS [RunTimeOverUnder]
	,[Lab].[UnitValueReqd]
	,[Lab].[ValueIssued]
	,[Lab].[UnitValueReqd] - [Lab].[ValueIssued] AS [ValueIssuedOverUnder]
FROM
	@tWOs [WOs]
LEFT JOIN
	[SysproCompanyS].[dbo].[WipJobAllLab] [Lab] WITH (NOLOCK)
ON
	[Lab].[Job] = CAST([WO] AS NVARCHAR(MAX))
WHERE
	[Lab].[Job] IS NULL
--GROUP BY
--	[Lab].[Job]
--	,[Lab].[Operation]
ORDER BY
	[Lab].[Job]
	,[Lab].[Operation]