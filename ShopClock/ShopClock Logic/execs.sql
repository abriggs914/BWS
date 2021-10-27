USE SysproCompanyA
GO

DECLARE @test_range AS BIT, @test_select AS BIT;
SET @test_range = 1;
SET @test_select = 1;

--EXEC [dbo].[sp_RoundTime] @time='2021-10-27 10:28:00', @interval=15, @threshold=2
--EXEC [dbo].[sp_RoundTime] @time='2021-10-27 11:41:00', @interval=15, @threshold=2


IF @test_range = 1 BEGIN
	DECLARE @sd AS DATETIME;
	DECLARE @ed AS DATETIME;
	DECLARE @interval AS INT;
	DECLARE @threshold AS INT;
	DECLARE @i AS INT;

	SET @sd = '2021-10-27';
	SET @ed = '2021-10-28';
	SET @interval = 15;
	SET @threshold = 2;
	SET @i = 0;

	WHILE @i < ((60*24) / 15) BEGIN
		DECLARE @t AS DATETIME;
		SET @t = DATEADD(MINUTE, @i, @sd)
		EXEC [dbo].[sp_RoundTime] @time=@t, @interval=@interval, @up_down=1, @threshold=@threshold
		SET @i = @i + 1
	END
END

IF @test_select = 1 BEGIN

	DECLARE @shift_1_start_time AS DATETIME;
	DECLARE @shift_1_end_time AS DATETIME;
	DECLARE @shift_1_interval AS INT;
	DECLARE @shift_1_threshold AS INT;

	SET @shift_1_start_time = '2021-10-27 8:00:00';
	SET @shift_1_end_time = '2021-10-27 16:30:00';
	SET @shift_1_interval = 15;
	SET @shift_1_threshold = 2;

	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 7:47:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 7:48:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 7:53:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 8:02:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 8:03:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 8:47:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 8:51:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 9:02:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 9:03:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=1, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time

	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:00:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:14:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:18:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:27:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:28:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:29:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:31:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time
	EXEC [dbo].[sp_RoundTime] @time='2021-10-27 16:35:00', @interval=@shift_1_interval, @threshold=@shift_1_threshold, @up_down=0, @start_date=@shift_1_start_time, @end_date=@shift_1_end_time

END