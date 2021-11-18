DECLARE @a NVARCHAR(250);
DECLARE @b NVARCHAR(250);
DECLARE @c NVARCHAR(250);
DECLARE @d NVARCHAR(250);
DECLARE @e NVARCHAR(250);

SET @a = 'guest, michael';
SET @b = 'guest, charlie';
SET @c = 'guest,';
SET @d = '';
SET @e = '';

SELECT (CASE WHEN @a = @b THEN '<' + @a + '> = <' + @b + '>' ELSE 'NOT' END) AS [@a = @b]
SELECT (CASE WHEN @a LIKE @b THEN '<' + @a + '> = <' + @b + '>' ELSE 'NOT' END) AS [@a LIKE @b]

SELECT (CASE WHEN @a = @c THEN '<' + @a + '> = <' + @c + '>' ELSE 'NOT' END) AS [@a = @c]
SELECT (CASE WHEN @a LIKE @c THEN '<' + @a + '> = <' + @c + '>' ELSE 'NOT' END) AS [@a LIKE @c]

SELECT (CASE WHEN @b = @c THEN '<' + @b + '> = <' + @c + '>' ELSE 'NOT' END) AS [@b = @c]
SELECT (CASE WHEN @b LIKE @c THEN '<' + @b + '> = <' + @c + '>' ELSE 'NOT' END) AS [@b LIKE @c]