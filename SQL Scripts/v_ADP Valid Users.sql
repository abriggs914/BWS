USE BWSdb
GO

CREATE VIEW [v_ADP Valid Users] AS
SELECT
	*
FROM
	[ADP Valid Users]
WHERE
	[Active] = 1
;
GO