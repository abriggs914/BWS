USE BWSdb
GO

DECLARE @t AS TABLE ([99] NVARCHAR(MAX), [NP] FLOAT)
INSERT INTO @t ([99], [NP]) VALUES
('99000265', 4574.54),
('99000266', 4049.94),
('99000055', 658.17),
('99000320', 929.75),
('99000283', 2106.00)
;

SELECT * FROM [Budget Options];
SELECT
	[99]
	, [Option No]
	, [Model No]
	, [US Price] AS [US Price (old)]
	, [NP] AS [US Price (new)]
FROM
	[Options]
INNER JOIN
	@t
ON
	[Draw/Part#] = [99]
ORDER BY
	[99]


BEGIN TRAN;

SELECT
	[99]
	, [Option No]
	, [Model No]
	, [US Price] AS [US Price (old)]
	, [NP] AS [US Price (new)]
FROM
	[Options]
INNER JOIN
	@t
ON
	[Draw/Part#] = [99]
ORDER BY
	[99]
;

UPDATE
	[Options]
SET
	[US Price] = [NP]
FROM
	[Options]
INNER JOIN
	@t
ON 
	[Draw/Part#] = [99]

;

SELECT
	[99]
	, [Option No]
	, [Model No]
	, [US Price] AS [US Price (old)]
	, [NP] AS [US Price (new)]
FROM
	[Options]
INNER JOIN
	@t
ON
	[Draw/Part#] = [99]
ORDER BY
	[99]
;

ROLLBACK;
COMMIT;