USE SysproCompanyA
GO

--Please support an employee signing in up to 4 hours early or working up to 4 hours late.

--SELECT * FROM [ClkShiftEmpAssign];
--SELECT * FROM [ClkShiftDetail];
--SELECT * FROM [ClkShiftRoundRules V2];

--SELECT 
--  emp.Employee, 
--  emp.Name,
--  CONVERT(date, trx.LoggedOn) AS WorkDay,
--  MIN(trx.LoggedOn) AS FirstLogOn, 
--  MAX(trx.LoggedOff) AS LastLogOff
--FROM 
--  ClkTransaction AS trx
--  INNER JOIN [ClkShiftEmpAssign] AS sea 
--    ON [trx].[EmployeeNumber] = [sea].[Emp#] 
--  INNER JOIN [ClkEmployee] AS emp 
--    ON [trx].[EmployeeNumber] = [emp].[Employee] 
--INNER JOIN
--	[ClkShiftRoundRules V2] AS [srr]
--ON
--	[sea].[ShiftID] = [srr].[ShiftID]
--WHERE 
--	LEFT([EmployeeNumber], 1) = '2'
--  AND trx.LoggedOn IS NOT NULL 
--  AND trx.LoggedOff IS NOT NULL 
--  AND (
--    (trx.LoggedOn BETWEEN 
--		DATEADD(DAY, DAY(GETDATE()) - 1, DATEADD(MONTH, MONTH(GETDATE()) - 1, (DATEADD(YEAR, YEAR(GETDATE()) - 1900, CAST([srr].[StartTime] AS DATETIME)))))
--		AND 
--		DATEADD(DAY, DAY(GETDATE()) - 1, DATEADD(MONTH, MONTH(GETDATE()) - 1, (DATEADD(YEAR, YEAR(GETDATE()) - 1900, CAST([srr].[EndTime] AS DATETIME)))))
--	)
--    OR (trx.LoggedOff BETWEEN DATEADD(DAY, DAY(GETDATE()) - 1, DATEADD(MONTH, MONTH(GETDATE()) - 1, (DATEADD(YEAR, YEAR(GETDATE()) - 1900, CAST([srr].[StartTime] AS DATETIME)))))
--		AND 
--		DATEADD(DAY, DAY(GETDATE()) - 1, DATEADD(MONTH, MONTH(GETDATE()) - 1, (DATEADD(YEAR, YEAR(GETDATE()) - 1900, CAST([srr].[EndTime] AS DATETIME)))))
--	) 
--    OR (trx.LoggedOn <= 
--		DATEADD(DAY, DAY(GETDATE()) - 1, DATEADD(MONTH, MONTH(GETDATE()) - 1, (DATEADD(YEAR, YEAR(GETDATE()) - 1900, CAST([srr].[StartTime] AS DATETIME)))))
--		AND trx.LoggedOff >= 
--		DATEADD(DAY, DAY(GETDATE()) - 1, DATEADD(MONTH, MONTH(GETDATE()) - 1, (DATEADD(YEAR, YEAR(GETDATE()) - 1900, CAST([srr].[EndTime] AS DATETIME)))))
--	)
--  )
--GROUP BY 
--  emp.Employee, 
--  emp.Name, 
--  CONVERT(date, trx.LoggedOn)
--ORDER BY
--	[Name]

-- PART C

--DECLARE @sd AS DATETIME = '2023-03-23';
--DECLARE @ed AS DATETIME = '2023-03-23 23:59:59';
DECLARE @sd AS DATETIME = '2023-03-24';
DECLARE @ed AS DATETIME = '2023-03-24 23:59:59';
DECLARE @w AS INT = 3;

SELECT
	[A_EmpName]
	, [A_EmpNum]
	, SUM([A_Len]) AS [Hours]
	, CAST([ST] AS DATE) AS [EntryDate]
	, MIN([A_LoggedOn]) AS [FirstLogOn]
	, MAX([A_LoggedOff]) AS [LastLogOff]
FROM (
	SELECT 
		[A_EmpName]
		, [A_EmpNum]
		, [A_LoggedOn]
		, [A_LoggedOff]
		, [A_Len]
		, [ST]
		, [ET]
		, DATEDIFF(SECOND,
			(CASE WHEN [A_LoggedOn] <= [ST] THEN [ST] ELSE [A_LoggedOn] END),
			(CASE WHEN [A_LoggedOff] >= [ET] THEN [ET] ELSE [A_LoggedOff] END)
		) AS [ToS]
	FROM (
		SELECT
			[ClkTransaction].[EmployeeName] AS [A_EmpName]
			, [ClkTransaction].[EmployeeNumber] AS [A_EmpNum]
			, [ClkTransaction].[LoggedOn] AS [A_LoggedOn]
			, [ClkTransaction].[LoggedOff] AS [A_LoggedOff]
			, DATEDIFF(SECOND, [ClkTransaction].[LoggedOn], [ClkTransaction].[LoggedOff]) / (60.0 * 60) AS [A_Len]
			, DATEADD(HOUR, @w, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([StartTime] AS DATETIME)))))) AS [ST]
			, DATEADD(HOUR, @w, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([EndTime] AS DATETIME)))))) AS [ET]
		FROM
			[ClkTransaction]
		INNER JOIN
			[ClkShiftEmpAssign]
		ON
			[ClkTransaction].[EmployeeNumber] = [ClkShiftEmpAssign].[Emp#]
		INNER JOIN
			[ClkShiftRoundRules V2]
		ON
			[ClkShiftRoundRules V2].[ShiftID] = [ClkShiftEmpAssign].[ShiftID]
		WHERE
			LEFT([EmployeeNumber], 1) = '2'
			AND
			([LoggedOn] BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([StartTime] AS DATETIME)))))) AND DATEADD(HOUR, 6, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([EndTime] AS DATETIME))))))
			OR [LoggedOff] BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([StartTime] AS DATETIME)))))) AND DATEADD(HOUR, 6, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([EndTime] AS DATETIME)))))))
	) AS [SrcA]
) AS [SrcB]
WHERE
	[ToS] > 0
GROUP BY
	[A_EmpName]
	, [A_EmpNum]
	, [ST]
ORDER BY
	[A_EmpName]



--SELECT 
--	[EmpNum],
--	[EmpName],
--	[WorkDay],
--	MIN([FirstLogOn]) AS [FirstLogOn],
--	MAX([LastLogOff]) AS [LastLogOff],
--	DATEDIFF(SECOND, MIN([FirstLogOn]), MAX([LastLogOff])) / (60.0 * 60) AS [Hours]

-- FROM (
	SELECT 
	  emp.Employee AS [EmpNum], 
	  emp.Name AS [EmpName],
	  CONVERT(date, (
		CASE WHEN DATEPART(DAY, MIN(trx.LoggedOn)) = DATEPART(DAY, MIN(trx.LoggedOff)) THEN MIN(trx.LoggedOn) ELSE (
			CASE WHEN DATEDIFF(SECOND, MIN(trx.LoggedOn), CAST(CAST(YEAR(MIN(trx.LoggedOn)) AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST(MONTH(MIN(trx.LoggedOn)) AS NVARCHAR(2)), 2) + '-' + RIGHT(CAST(DAY(MIN(trx.LoggedOn)) AS NVARCHAR(2)), 2) AS DATETIME)) 
			>=
			DATEDIFF(SECOND, CAST(CAST(YEAR(MIN(trx.LoggedOff)) AS NVARCHAR(4)) + '-' + RIGHT('00' + CAST(MONTH(MIN(trx.LoggedOff)) AS NVARCHAR(2)), 2) + '-' + RIGHT(CAST(DAY(MIN(trx.LoggedOff)) AS NVARCHAR(2)), 2) AS DATETIME), MIN(trx.LoggedOff))
			THEN MIN(trx.LoggedOn) ELSE MIN(trx.LoggedOff) END
		) END
	  )) AS WorkDay,
	  MIN(trx.LoggedOn) AS FirstLogOn, 
	  MAX(trx.LoggedOff) AS LastLogOff,

	  (CASE WHEN
		(MIN(trx.LoggedOn) BETWEEN 
			DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST(MIN([srr].[StartTime]) AS DATETIME)))))) 
			AND 
			DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST(MAX([srr].[EndTime]) AS DATETIME)))))
		) THEN 'A'
		WHEN (MAX(trx.LoggedOff) BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST(MIN([srr].[StartTime]) AS DATETIME))))))
			AND 
			DATEADD(HOUR, 6, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST(MAX([srr].[EndTime]) AS DATETIME))))))
		) THEN 'B'
		WHEN (MIN(trx.LoggedOn) <= 
			DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST(MIN([srr].[StartTime]) AS DATETIME)))))) 
			AND MAX(trx.LoggedOff) >= 
			DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST(MAX([srr].[EndTime]) AS DATETIME)))))
		) THEN 'C' ELSE 'D' END
		--AND DATEDIFF(SECOND, trx.LoggedOn, trx.LoggedOff) <= 57600 -- 16 hours in seconds
	  ) AS [Qid]

	FROM 
	  ClkTransaction AS trx
	  INNER JOIN [ClkShiftEmpAssign] AS sea 
		ON [trx].[EmployeeNumber] = [sea].[Emp#] 
	  INNER JOIN [ClkEmployee] AS emp 
		ON [trx].[EmployeeNumber] = [emp].[Employee] 
	INNER JOIN
		[ClkShiftRoundRules V2] AS [srr]
	ON
		[sea].[ShiftID] = [srr].[ShiftID]
	WHERE 
		LEFT([EmployeeNumber], 1) = '2'
	  AND trx.LoggedOn IS NOT NULL 
	  AND trx.LoggedOff IS NOT NULL 
	  AND (
		(trx.LoggedOn BETWEEN 
			DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([srr].[StartTime] AS DATETIME)))))) 
			AND 
			DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([srr].[EndTime] AS DATETIME)))))
		)
		OR (trx.LoggedOff BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([srr].[StartTime] AS DATETIME))))))
			AND 
			DATEADD(HOUR, 6, DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([srr].[EndTime] AS DATETIME))))))
		) 
		OR (trx.LoggedOn <= 
			DATEADD(HOUR, -6, DATEADD(DAY, DAY(@sd) - 1, DATEADD(MONTH, MONTH(@sd) - 1, (DATEADD(YEAR, YEAR(@sd) - 1900, CAST([srr].[StartTime] AS DATETIME)))))) 
			AND trx.LoggedOff >= 
			DATEADD(DAY, DAY(@ed) - 1, DATEADD(MONTH, MONTH(@ed) - 1, (DATEADD(YEAR, YEAR(@ed) - 1900, CAST([srr].[EndTime] AS DATETIME)))))
		)
		--AND DATEDIFF(SECOND, trx.LoggedOn, trx.LoggedOff) <= 57600 -- 16 hours in seconds
	  )
GROUP BY 
  [emp].[Employee], 
  [emp].[Name]
--) AS [SubA]
--GROUP BY 
--  [EmpNum], 
--  [EmpName], 
--  [WorkDay]
ORDER BY
	[EmpName]
