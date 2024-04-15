USE BWSdb
GO




SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Function to get a formatted string indicating how long ago date1 is from date2
-- Abriggs 2024-04-15 1848

ALTER FUNCTION [dbo].[HowLongAgoComment](
	@date1 DATETIME,
	@date2 DATETIME = NULL,
	@mode NVARCHAR(MAX) = 'HOUR'
) RETURNS NVARCHAR(MAX)
AS
BEGIN

	
	DECLARE @diffH INT, @diffM INT;

	/*
	DECLARE @date1 DATETIME, @date2 DATETIME;
	DECLARE @mode NVARCHAR(MAX) = 'HOUR'
	--SELECT @date1 = '2024-04-15 11:30';
	--SELECT @date1 = '2024-04-15 08:30';
	SELECT @date1 = '2024-04-15 04:30';
	--SELECT @date2 = GETDATE();
	SELECT @date2 = '2024-04-15 11:30';
	SELECT @date2 = '2024-04-15 18:30';
	SELECT @mode = 'MINUTE'
	SELECT
		@date1 = '2024-04-01',
		@date2 = GETDATE()
	--SELECT @mode = 'DAY'
	*/
	

	IF @date2 IS NULL BEGIN
		SELECT @date2 = GETDATE();
	END
		
	SELECT 
		@date1 = MIN([Date]),
		@date2 = MAX([Date])
	FROM (
		SELECT
			@date1 AS [Date]
		UNION
		SELECT
			@date2
	) AS [Src]
	;

	SELECT
		@diffH = DATEDIFF(HOUR, @date1, @date2),
		@diffM = DATEDIFF(MINUTE, @date1, @date2)
	;

	/*
	SELECT
		@date1 AS [1]
		,@date2 AS [2]
		,@diffM AS [DM]
		,@diffH AS [DH]
	*/
	
	RETURN
	--SELECT
		(CASE 
			WHEN UPPER(@mode) = 'AM/PM' THEN
				(CASE
					WHEN @date1 >= DATEADD(HOUR, -13, @date2) THEN
						(CASE WHEN DATEPART(HOUR, @date1) > 11 THEN 
							-- date1 PM
							(CASE WHEN DATEPART(HOUR, @date2) < 12 
								-- date2 AM
								THEN 'Last Night 2' ELSE 'This Morning' END) 
							ELSE (CASE WHEN DATEPART(HOUR, @date2) < 12 THEN 'This Morning' ELSE 'Last Night 1' END) 
						END)
				END)
			WHEN UPPER(@mode) = 'MINUTE' THEN
				(CASE 
					WHEN @date1 >= DATEADD(MINUTE, -1, @date2) THEN
						'Within Last Minute'
					ELSE 
						CAST(@diffM AS NVARCHAR(MAX)) + ' Minute' + (CASE WHEN @diffM = 1 THEN '' ELSE 's' END) + ' Ago' 
				END)
			WHEN UPPER(@mode) = 'HOUR' THEN
				(CASE 
					WHEN @date1 >= DATEADD(HOUR, -1, @date2) THEN
						'Within Last Hour'
					ELSE 
						CAST(@diffH AS NVARCHAR(MAX)) + ' Hour' + (CASE WHEN @diffH = 1 THEN '' ELSE 's' END) + ' Ago' 
				END)
					
			WHEN UPPER(@mode) = 'DAY' THEN
				(CASE 
					WHEN @date1 >= DATEADD(HOUR, -12, @date2) THEN
						'Today'
					WHEN @date1 >= DATEADD(HOUR, -24, @date2) THEN
						'Yesterday'
					WHEN @date1 >= DATEADD(HOUR, -168, @date2) THEN
						'This Week'
					WHEN @date1 >= DATEADD(HOUR, -336, @date2) THEN
						'Last Week'
					WHEN @date1 >= DATEADD(HOUR, -672, @date2) THEN
						'This Month'
					WHEN @date1 >= DATEADD(HOUR, -1512, @date2) THEN
						'Last Month'
					WHEN @date1 >= DATEADD(HOUR, -4380, @date2) THEN
						'Within Last 6 Months'
					WHEN @date1 >= DATEADD(HOUR, -8760, @date2) THEN
						'This Year'
					WHEN @date1 >= DATEADD(HOUR, -17520, @date2) THEN
						'Within Last 2 Years'
					WHEN @date1 >= DATEADD(HOUR, -43824, @date2) THEN
						'Within last 5 Years'
					ELSE
						'More Than 5 Years'
					END)
			ELSE
				NULL
			END)

END