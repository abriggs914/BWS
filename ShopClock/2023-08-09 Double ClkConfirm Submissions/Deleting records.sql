

BEGIN TRAN;

DECLARE @t AS TABLE ([ID] INT IDENTITY(0, 1), [V] INT)
INSERT INTO @t VALUES
(26270),
(26295),
(26271),
(26296),
(26272),
(26297),
(26273),
(26298),
(26274),
(26299),
(26275),
(26300),
(26276),
(26301),
(26277),
(26302),
(26278),
(26303),
(26279),
(26304),
(26280),
(26305),
(26281),
(26306),
(26282),
(26307),
(26283),
(26308),
(26284),
(26309),
(26285),
(26310),
(26286),
(26311),
(26287),
(26312),
(26288),
(26313),
(26289),
(26314),
(26290),
(26315),
(26291),
(26316),
(26292),
(26317),
(26293),
(26318),
(26294),
(26319)
;


SELECT
	*
FROM
	[ClkFrmConfirm]
INNER JOIN
	@t
ON
	[ClkFrmConfirm].[ClkFrmConfirmID#] = [@t].[V]
;

DELETE [C]
FROM
	[ClkFrmConfirm] AS [C]
INNER JOIN
	@t
ON
	[C].[ClkFrmConfirmID#] = [@t].[V]
WHERE
	([@t].[ID] % 2) = 1
;

SELECT
	*
FROM
	[ClkFrmConfirm]
INNER JOIN
	@t
ON
	[ClkFrmConfirm].[ClkFrmConfirmID#] = [@t].[V]


ROLLBACK;
COMMIT;