DECLARE @sd DATETIME ='2022-02-11';
DECLARE @ed DATETIME ='2022-02-11 23:59:59';

EXEC [sp_ClkLabourOverride] @sd=@sd, @ed=@ed;

SET @sd ='2022-03-11';
SET @ed = '2022-03-11 23:59:59';
EXEC [sp_ClkLabourOverride] @sd=@sd, @ed=@ed;

SET @sd ='2022-02-11';
SET @ed = '2022-03-11 23:59:59';

EXEC [sp_ClkTallyHours] @sd=@sd, @ed=@ed, @by_transaction=0;

SELECT
		*
	FROM
		[ClkFrmConfirm]
	WHERE
		[EntryDate] BETWEEN @sd AND @ed