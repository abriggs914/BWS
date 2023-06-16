
USE BWSdb
GO

BEGIN TRAN;

DECLARE @uname AS NVARCHAR(255);
DECLARE @fname AS NVARCHAR(255);

SELECT
	@uname = 'LAO'
	,@fname = 'Lloyd Orser'

SELECT
	'Aft' AS [T]
	, *
FROM
	[ITR Customers] AS [A]
CROSS JOIN
	[v_ADG Latest Accessors] AS [B]
WHERE
	[B].[Latest Accessor(s)] = @uname
	AND [A].[Name] = @fname
;

UPDATE
	[A]
SET
	[WindowsUser] = [B].[Latest Accessor(s)]
FROM
	[ITR Customers] AS [A]
CROSS JOIN
	[v_ADG Latest Accessors] AS [B]
WHERE
	[B].[Latest Accessor(s)] = @uname
	AND [A].[Name] = @fname
;

SELECT
	'Aft' AS [T]
	, *
FROM
	[ITR Customers] AS [A]
CROSS JOIN
	[v_ADG Latest Accessors] AS [B]
WHERE
	[B].[Latest Accessor(s)] = @uname
	AND [A].[Name] = @fname
;

ROLLBACK;
COMMIT;