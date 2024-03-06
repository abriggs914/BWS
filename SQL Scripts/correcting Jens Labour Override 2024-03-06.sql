USE SysproCompanyA
GO

EXEC [dbo].[sp_ClkLabourTime] @sd='2024-03-04', @ed='2024-03-04 23:59:59'


SELECT
	*
FROM
	[ClkShiftEmpAssign] [C]
WHERE
	[C].[Emp#] = 200697
;
	
SELECT
	*
FROM
	[ClkShiftRoundRules V2] [C]
;
	
SELECT
	*
FROM
	[ClkFrmConfirm] [C]
WHERE
	[C].[EntryDate] BETWEEN '2024-03-04' AND '2024-03-04 23:59:59'
	AND [C].[EmployeeNumber] = 200697


BEGIN TRAN;

DELETE FROM
	[ClkFrmConfirm]
WHERE
	[ClkFrmConfirmID#] IN (

	SELECT
		--[EmployeeNumber]
		[ClkFrmConfirmID#]
	FROM (
		SELECT
			[EmployeeNumber]
			,[C].[ClkFrmConfirmID#]
			,[EntryDate]
			,[C].[HoursWorked]
			,ROW_NUMBER() OVER(
				PARTITION BY
					[EmployeeNumber]
					,[EntryDate]
					,[C].[HoursWorked]
				ORDER BY
					[C].[ClkFrmConfirmID#]
			) AS [RN]
		FROM
			[ClkFrmConfirm] [C]
		WHERE
			[C].[EntryDate] BETWEEN '2024-03-04' AND '2024-03-04 23:59:59'
		GROUP BY
			[EmployeeNumber]
			,[C].[ClkFrmConfirmID#]
			,[EntryDate]
			,[C].[HoursWorked]
		--HAVING
			--COUNT(*) > 1
		--ORDER BY
		--	[EmployeeNumber]
		--	,[C].[ClkFrmConfirmID#]
		--	,[EntryDate]
	) AS [Src]
	WHERE
		[RN] = 1
	GROUP BY
		[EmployeeNumber]
		,[ClkFrmConfirmID#]
		,[EntryDate]
		,[HoursWorked]
)

ROLLBACK;
COMMIT;