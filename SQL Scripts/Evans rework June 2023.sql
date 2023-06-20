
DECLARE @sd AS DATETIME = '2022-06-01';
DECLARE @ed AS DATETIME = '2023-06-01 23:59:59';

DECLARE @m AS TABLE ([ID] INT IDENTITY(0, 1), [M] NVARCHAR(200))
INSERT INTO @m ([M]) VALUES
('12'), ('13'), ('17'), ('19'), ('26'), ('27'), ('28'), ('44'), ('45'), ('46'), ('51');


SELECT
	*
FROM (
	SELECT
		[Job]
		, [IMachine] AS [Machine]
		, CASE
			WHEN ISNULL([PlannedQueueDate], '9999-12-31') <= ISNULL([PlannedStartDate], '9999-12-31')
				AND ISNULL([PlannedQueueDate], '9999-12-31') <= ISNULL([PlannedEndDate], '9999-12-31')
				AND ISNULL([PlannedQueueDate], '9999-12-31') <= ISNULL([ActualQueueDate], '9999-12-31')
				AND ISNULL([PlannedQueueDate], '9999-12-31') <= ISNULL([ActualStartDate], '9999-12-31')
				AND ISNULL([PlannedQueueDate], '9999-12-31') <= ISNULL([ActualFinishDate], '9999-12-31')
				THEN [PlannedQueueDate]
			WHEN ISNULL([PlannedStartDate], '9999-12-31') <= ISNULL([PlannedQueueDate], '9999-12-31')
				AND ISNULL([PlannedStartDate], '9999-12-31') <= ISNULL([PlannedEndDate], '9999-12-31')
				AND ISNULL([PlannedStartDate], '9999-12-31') <= ISNULL([ActualQueueDate], '9999-12-31')
				AND ISNULL([PlannedStartDate], '9999-12-31') <= ISNULL([ActualStartDate], '9999-12-31')
				AND ISNULL([PlannedStartDate], '9999-12-31') <= ISNULL([ActualFinishDate], '9999-12-31')
				THEN [PlannedStartDate]
			WHEN ISNULL([PlannedEndDate], '9999-12-31') <= ISNULL([PlannedQueueDate], '9999-12-31')
				AND ISNULL([PlannedEndDate], '9999-12-31') <= ISNULL([PlannedStartDate], '9999-12-31')
				AND ISNULL([PlannedEndDate], '9999-12-31') <= ISNULL([ActualQueueDate], '9999-12-31')
				AND ISNULL([PlannedEndDate], '9999-12-31') <= ISNULL([ActualStartDate], '9999-12-31')
				AND ISNULL([PlannedEndDate], '9999-12-31') <= ISNULL([ActualFinishDate], '9999-12-31')
				THEN [PlannedEndDate]
			WHEN ISNULL([ActualQueueDate], '9999-12-31') <= ISNULL([PlannedQueueDate], '9999-12-31')
				AND ISNULL([ActualQueueDate], '9999-12-31') <= ISNULL([PlannedStartDate], '9999-12-31')
				AND ISNULL([ActualQueueDate], '9999-12-31') <= ISNULL([PlannedEndDate], '9999-12-31')
				AND ISNULL([ActualQueueDate], '9999-12-31') <= ISNULL([ActualStartDate], '9999-12-31')
				AND ISNULL([ActualQueueDate], '9999-12-31') <= ISNULL([ActualFinishDate], '9999-12-31')
				THEN [ActualQueueDate]
			WHEN ISNULL([ActualStartDate], '9999-12-31') <= ISNULL([PlannedQueueDate], '9999-12-31')
				AND ISNULL([ActualStartDate], '9999-12-31') <= ISNULL([PlannedStartDate], '9999-12-31')
				AND ISNULL([ActualStartDate], '9999-12-31') <= ISNULL([PlannedEndDate], '9999-12-31')
				AND ISNULL([ActualStartDate], '9999-12-31') <= ISNULL([ActualQueueDate], '9999-12-31')
				AND ISNULL([ActualStartDate], '9999-12-31') <= ISNULL([ActualFinishDate], '9999-12-31')
				THEN [ActualStartDate]
			ELSE [ActualFinishDate]
		END AS min_value
	  , CASE
			WHEN ISNULL([PlannedQueueDate], '1900-01-01') >= ISNULL([PlannedStartDate], '1900-01-01')
				AND ISNULL([PlannedQueueDate], '1900-01-01') >= ISNULL([PlannedEndDate], '1900-01-01')
				AND ISNULL([PlannedQueueDate], '1900-01-01') >= ISNULL([ActualQueueDate], '1900-01-01')
				AND ISNULL([PlannedQueueDate], '1900-01-01') >= ISNULL([ActualStartDate], '1900-01-01')
				AND ISNULL([PlannedQueueDate], '1900-01-01') >= ISNULL([ActualFinishDate], '1900-01-01')
				THEN [PlannedQueueDate]
			WHEN ISNULL([PlannedStartDate], '1900-01-01') >= ISNULL([PlannedQueueDate], '1900-01-01')
				AND ISNULL([PlannedStartDate], '1900-01-01') >= ISNULL([PlannedEndDate], '1900-01-01')
				AND ISNULL([PlannedStartDate], '1900-01-01') >= ISNULL([ActualQueueDate], '1900-01-01')
				AND ISNULL([PlannedStartDate], '1900-01-01') >= ISNULL([ActualStartDate], '1900-01-01')
				AND ISNULL([PlannedStartDate], '1900-01-01') >= ISNULL([ActualFinishDate], '1900-01-01')
				THEN [PlannedStartDate]
			WHEN ISNULL([PlannedEndDate], '1900-01-01') >= ISNULL([PlannedQueueDate], '1900-01-01')
				AND ISNULL([PlannedEndDate], '1900-01-01') >= ISNULL([PlannedStartDate], '1900-01-01')
				AND ISNULL([PlannedEndDate], '1900-01-01') >= ISNULL([ActualQueueDate], '1900-01-01')
				AND ISNULL([PlannedEndDate], '1900-01-01') >= ISNULL([ActualStartDate], '1900-01-01')
				AND ISNULL([PlannedEndDate], '1900-01-01') >= ISNULL([ActualFinishDate], '1900-01-01')
				THEN [PlannedEndDate]
			WHEN ISNULL([ActualQueueDate], '1900-01-01') >= ISNULL([PlannedQueueDate], '1900-01-01')
				AND ISNULL([ActualQueueDate], '1900-01-01') >= ISNULL([PlannedStartDate], '1900-01-01')
				AND ISNULL([ActualQueueDate], '1900-01-01') >= ISNULL([PlannedEndDate], '1900-01-01')
				AND ISNULL([ActualQueueDate], '1900-01-01') >= ISNULL([ActualStartDate], '1900-01-01')
				AND ISNULL([ActualQueueDate], '1900-01-01') >= ISNULL([ActualFinishDate], '1900-01-01')
				THEN [ActualQueueDate]
			WHEN ISNULL([ActualStartDate], '1900-01-01') >= ISNULL([PlannedQueueDate], '1900-01-01')
				AND ISNULL([ActualStartDate], '1900-01-01') >= ISNULL([PlannedStartDate], '1900-01-01')
				AND ISNULL([ActualStartDate], '1900-01-01') >= ISNULL([PlannedEndDate], '1900-01-01')
				AND ISNULL([ActualStartDate], '1900-01-01') >= ISNULL([ActualQueueDate], '1900-01-01')
				AND ISNULL([ActualStartDate], '1900-01-01') >= ISNULL([ActualFinishDate], '1900-01-01')
				THEN [ActualStartDate]
			ELSE [ActualFinishDate]
		END AS max_value
	FROM
		[WipJobAllLab]
	INNER JOIN
		@m
	ON
		[WipJobAllLab].[IMachine] = [@m].[M]
) AS [A]
WHERE
	[min_value] BETWEEN @sd AND @ed
	OR [max_value] BETWEEN @sd AND @ed