USE BWSdb
GO

CREATE VIEW [v_Valid Sales People] AS 
SELECT
	UPPER([Sales Staff].[Sales Person]) AS [Sales Person]
FROM 
	[Sales Staff]
WHERE
	[Sales Staff].[Active] = 1
;
GO