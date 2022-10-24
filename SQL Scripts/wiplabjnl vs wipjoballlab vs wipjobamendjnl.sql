
DECLARE @WO AS NVARCHAR(MAX) = '10015456';

SELECT
			*
		FROM
			[WipLabJnl]
		WHERE
			[Job] LIKE @WO
			AND [Operation] = 4
;

SELECT
			[Job]
            , EntryDate
            , Operation
            , Employee
            , RunTime
		FROM
			[WipLabJnl]
		WHERE
			[Job] LIKE @WO
			AND [Operation] = 4
;

SELECT
			sum(RunTime) AS [SumHours]
		FROM
			[WipLabJnl]
		WHERE
			[Job] LIKE @WO
			AND [Operation] = 4
;