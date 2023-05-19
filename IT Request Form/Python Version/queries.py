from pyodbc_connection import connect


V_ITR_DEPT = {
    "sql": """
SELECT
	[ID]
	,[DeptName]
	,[DeptRelations]
	,[DateAdded]
	,[DeptID]
	,[BWS Code]
	,[Class]
	,[Grouping]
	,[Dept]
	,[Position]
	,[Budget]
	,[Authorized]
	,[Pay Scale]
	,[Comments]
FROM 
	[v_ITR Depts]
;
    """,
    "database": "BWSdb",
    "server": "SERVER3",
    "uid": "user5",
    "pwd": "M@gic456"
}


V_ITR_HARDWARE = {
    "sql": """
SELECT 
	[HardwareID],
	[Hardware]
FROM
	[ITR Hardware]
;
    """,
    "database": "BWSdb",
    "server": "SERVER3",
    "uid": "user5",
    "pwd": "M@gic456"
}


V_ITR_SOFTWARE = {
    "sql": """
SELECT
	[SoftwareID],
	[Software]
FROM
	[ITR Software]
;
    """,
    "database": "BWSdb",
    "server": "SERVER3",
    "uid": "user5",
    "pwd": "M@gic456"
}


V_ITR_TRAINING = {
    "sql": """
SELECT
	[TrainingID],
	[Training]
FROM
	[ITR Training]
;
    """,
    "database": "BWSdb",
    "server": "SERVER3",
    "uid": "user5",
    "pwd": "M@gic456"
}


def exec_labour_prediction(company=None, department=None, request_type=None, request_sub_type=None):
    vals = [company, department, request_type, request_sub_type]
    for i, v in enumerate(vals):
        if v is None:
            vals[i] = "NULL"
        else:
            if not v.startswith("'"):
                vals[i] = f"'{v}"
            if not v.endswith("'"):
                vals[i] = f"{v}'"
    sql = "EXEC [sp_ITREstimateLabour] @company={0}, @department={1}, @requestType={2}, @requestSubType={3}".format(*vals)
    print(f"{sql=}")
    print(f"{connect(sql)=}")
    return connect(
        sql=sql
    )


if __name__ == '__main__':

    list_of_queries = [
        "V_ITR_DEPT",
        "V_ITR_HARDWARE",
        "V_ITR_SOFTWARE",
        "V_ITR_TRAINING"
    ]

    # for q in list_of_queries:
    #     print(f"{connect(**eval(q))}")

    print(f"{exec_labour_prediction()=}")
