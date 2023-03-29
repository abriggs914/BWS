USE SysproCompanyA
GO

DECLARE @sd AS DATETIME;
DECLARE @ed AS DATETIME;
SELECT 
	@sd='2023-03-28',
	@ed='2023-03-28 23:59:59'
;


DECLARE @interested AS TABLE([ID] INT IDENTITY(0, 1), [EmpNum] BIGINT, [ListID] INT);
INSERT INTO @interested ([EmpNum], [ListID]) VALUES
(200141, 0),
(200528, 0),
(200447, 0),
(200634, 0),

(200477, 1),
(200651, 1),

(200495, 2)
;


SELECT
	[TransactionID]
	, [EmployeeName]
	, [EmployeeNumber]
	, [LoggedOn]
	, [InTimeFromShopClk]
	, [LoggedOff]
	, [OutTimeFromShopClk]
FROM
	[ClkTransaction]
INNER JOIN
	@interested
ON
	CAST([EmployeeNumber] AS BIGINT) = [@interested].[EmpNum]
WHERE	
	(
		(
			[LoggedOn] BETWEEN @sd AND @ed
			OR [LoggedOff] BETWEEN @sd AND @ed
		) 
		OR (
			[InTimeFromShopClk] BETWEEN @sd AND @ed
			OR [OutTimeFromShopClk] BETWEEN @sd AND @ed
		)
	)
	AND [ListID] = 0
ORDER BY
	[EmployeeName]
	, [LoggedOn]


--BEGIN TRAN;

--DECLARE @to_uptdate AS TABLE ([ID] INT IDENTITY(0, 1), [TranID] BIGINT, [NewTime] DATETIME)
--INSERT INTO @to_uptdate ([TranID], [NewTime]) VALUES
--(1549509, '2023-03-28 00:00'),
--(1549753, '2023-03-28 12:45'),
--(1549786, '2023-03-28 16:00'),
--(1549866, '2023-03-28 16:30'),
--(1549883, '2023-03-28 18:30'),
--(1549895, '2023-03-28 19:00'),
--(1549898, '2023-03-28 21:30'),
--(1549911, '2023-03-29 00:00'),

--(1549311, '2023-03-28 00:00'),
--(1549717, '2023-03-29 00:00'),

--(1549296, '2023-03-28 00:00'),
--(1549682, '2023-03-29 00:00'),

--(1549513, '2023-03-28 00:00'),
--(1549750, '2023-03-28 12:00'),
--(1549755, '2023-03-28 13:00'),
--(1549788, '2023-03-28 13:00'),
--(1549789, '2023-03-28 14:45'),
--(1549834, '2023-03-28 16:00'),
--(1549862, '2023-03-28 18:00'),
--(1549892, '2023-03-28 18:30'),
--(1549894, '2023-03-28 20:00'),
--(1549904, '2023-03-28 22:45'),
--(1549916, '2023-03-29 00:00')

--UPDATE
--	[ClkTransaction]
--SET
--	[OutTimeFromShopClk] = [NewTime]
--FROM 
--	[ClkTransaction]
--INNER JOIN
--	@to_uptdate
--ON
--	[ClkTransaction].[TransactionID] = [@to_uptdate].[TranID]

--ROLLBACK;
--COMMIT;