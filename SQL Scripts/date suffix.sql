
	DECLARE @ws AS NVARCHAR(MAX) = '                                           ';
	DECLARE @persons AS NVARCHAR(MAX);
	DECLARE @subject AS NVARCHAR(255);
	DECLARE @body AS NVARCHAR(MAX);
	DECLARE @fmtDate AS NVARCHAR(MAX);
	DECLARE @fmtTime AS NVARCHAR(MAX);

	DECLARE @today AS DATETIME
	SET @today = GETDATE()
	SET @today = '2022-01-15 12:01 AM'

	SET @fmtDate = LEFT(DATENAME(WEEKDAY, @today), 3) + (CASE WHEN LEN(LEFT(DATENAME(WEEKDAY, @today), 3)) = LEN(DATENAME(WEEKDAY, @today)) THEN '' ELSE '.' END) + ' ' + DATENAME(MONTH, @today) + ' ' + DATENAME(DAY, @today) + (
		CASE WHEN
			RIGHT(DATENAME(DAY, @today), 1) = '1' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @today), 2), 1) = '1' THEN
						'th' 
					ELSE
						'st'
				END)
			WHEN 
				RIGHT(DATENAME(DAY, @today), 1) = '2' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @today), 2), 1) = '1' THEN
						'th' 
					ELSE
						'nd'
				END)
			WHEN 
				RIGHT(DATENAME(DAY, @today), 1) = '3' THEN
				(CASE WHEN
					LEFT(RIGHT('00' + DATENAME(DAY, @today), 2), 1) = '1' THEN
						'th' 
					ELSE
						'rd'
				END)
			ELSE 'th' 
		END) + ' ' + DATENAME(YEAR, @today);
	SET @fmtTime = (CASE WHEN DATENAME(HOUR, @today) = '0' THEN '12' ELSE DATENAME(HOUR, @today) END) + ':' + RIGHT('00' + DATENAME(MINUTE, @today), 2) + ' ' + CASE WHEN DATEPART(HOUR, @today) > 11 THEN 'PM' ELSE 'AM' END

	SELECT @fmtDate, @fmtTime