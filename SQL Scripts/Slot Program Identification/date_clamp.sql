USE BWSdb
GO

--DECLARE @sd DATETIME = '2021-07-06';
--DECLARE @sd DATETIME = '2020-08-06';
DECLARE @sd DATETIME = '2023-07-10';
DECLARE @MinDate DATETIME = DATEADD(MONTH, -12, GETDATE());
DECLARE @MaxDate DATETIME = DATEADD(MONTH, 12, GETDATE());
	

IF @sd < @MinDate BEGIN
	SET @sd = @MinDate
	SET @MaxDate = DATEADD(MONTH, 11, @sd)
END
IF @sd > @MaxDate BEGIN
	SET @sd = @MaxDate
	SET @MinDate = DATEADD(MONTH, -11, @sd)
END

SET @MinDate = @sd
SET @MaxDate = DATEADD(MONTH, 11, @sd)


SELECT @sd AS [Start Date], @MinDate AS [MinDate], @MaxDate AS [MaxDate]