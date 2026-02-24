USE [msdb]
GO

/****** Object:  Job [j_INV_Pop_InvDescWord]    Script Date: 2026-02-24 11:20:38 AM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'e18e4d1d-dc89-43dd-a470-a579057f085d', @delete_unused_schedule=1
GO

/****** Object:  Job [j_INV_Pop_InvDescWord]    Script Date: 2026-02-24 11:20:38 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 2026-02-24 11:20:38 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'j_INV_Pop_InvDescWord', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Ensure all descriptions for stockcodes have their words stored and tracked in an indexing table.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'user5', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [1]    Script Date: 2026-02-24 11:20:38 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'1', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE BWSdb.dbo.INV_InvDescWord;

;WITH Words AS (
    SELECT
        IM.StockCode,
        Word = UPPER(LTRIM(RTRIM(T.C.value(''.'', ''varchar(100)''))))
    FROM SysproCompanyA.dbo.InvMaster IM WITH (NOLOCK)
    CROSS APPLY (
        SELECT CAST(
            ''<x>'' +
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(ISNULL(IM.Description,''''), ''&'', ''&amp;''),
                        ''<'', ''&lt;''),
                    ''>'', ''&gt;''),
                '' '', ''</x><x>''),
            CHAR(9), '' '') +
            ''</x>'' AS xml
        ) AS X
    ) AS A
    CROSS APPLY A.X.nodes(''/x'') AS T(C)
),
Clean AS (
    SELECT
        StockCode,
        Word = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(Word, ''.'', ''''), '','', ''''), '';'',''''), '':'',''''), ''"'','''')
    FROM Words
    WHERE Word <> ''''
      AND LEN(Word) >= 3
)
INSERT INTO BWSdb.dbo.INV_InvDescWord (StockCode, Word)
SELECT DISTINCT StockCode, Word
FROM Clean;', 
		@database_name=N'BWSdb', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Sched 1', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=30, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20260224, 
		@active_end_date=99991231, 
		@active_start_time=0, 
		@active_end_time=235959, 
		@schedule_uid=N'c3ad2c4f-d07e-490a-b149-73199f7172ce'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO


