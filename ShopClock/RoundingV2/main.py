import pandas
from datetime_utility import first_of_week, end_of_day
from pyodbc_connection import *

window = 3

sql = """
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
			, DATEADD(HOUR, {w}, DATEADD(DAY, DAY('{sd}') - 1, DATEADD(MONTH, MONTH('{sd}') - 1, (DATEADD(YEAR, YEAR('{sd}') - 1900, CAST([StartTime] AS DATETIME)))))) AS [ST]
			, DATEADD(HOUR, {w}, DATEADD(DAY, DAY('{ed}') - 1, DATEADD(MONTH, MONTH('{ed}') - 1, (DATEADD(YEAR, YEAR('{ed}') - 1900, CAST([EndTime] AS DATETIME)))))) AS [ET]
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
			([LoggedOn] BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY('{sd}') - 1, DATEADD(MONTH, MONTH('{sd}') - 1, (DATEADD(YEAR, YEAR('{sd}') - 1900, CAST([StartTime] AS DATETIME)))))) AND DATEADD(HOUR, 6, DATEADD(DAY, DAY('{ed}') - 1, DATEADD(MONTH, MONTH('{ed}') - 1, (DATEADD(YEAR, YEAR('{ed}') - 1900, CAST([EndTime] AS DATETIME))))))
			OR [LoggedOff] BETWEEN DATEADD(HOUR, -6, DATEADD(DAY, DAY('{sd}') - 1, DATEADD(MONTH, MONTH('{sd}') - 1, (DATEADD(YEAR, YEAR('{sd}') - 1900, CAST([StartTime] AS DATETIME)))))) AND DATEADD(HOUR, 6, DATEADD(DAY, DAY('{ed}') - 1, DATEADD(MONTH, MONTH('{ed}') - 1, (DATEADD(YEAR, YEAR('{ed}') - 1900, CAST([EndTime] AS DATETIME)))))))
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
"""

if __name__ == '__main__':

    d1 = first_of_week(datetime.datetime(2023, 3, 24))
    df_res = pandas.DataFrame(columns=["A_EmpName", "A_EmpNum", "Hours", "EntryDate", "FirstLogOn", "LastLogOff"])
    for i in range(7):
        tsd = d1 + datetime.timedelta(days=i)
        ted = end_of_day(tsd)
        df_i = connect(sql.format(sd=tsd, ed=ted, w=window), database="SysproCompanyA")
        print(f"\n\n{tsd:%Y-%m-%d}\n{df_i}")
        df_res = df_res.append(df_i)

    print(f"\n\n\tRES")
    # print(df_res)

    damien = 200528
    masen = 200447
    chad = 200141
    alex = 200634
    # print(df_res[df_res["A_EmpNum"] == str(chad)])
    # print(df_res[df_res["A_EmpNum"] == str(alex)])
    # print(df_res[df_res["A_EmpNum"] == str(damien)])
    # print(df_res[df_res["A_EmpNum"] == str(masen)])
    print(df_res[df_res["A_EmpNum"].isin(map(str, [damien, masen, chad, alex]))])
