
DECLARE @WO NVARCHAR(MAX);
SELECT @WO = '10015962';

SELECT 
	*
FROM
	[v_LabourAnalysis_SortByOperation] WITH (NOLOCK)
WHERE 
	[Job] = @WO