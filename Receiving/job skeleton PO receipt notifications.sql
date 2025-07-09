DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [R_PO_ID] INT, [PO] NVARCHAR(255), [RB] NVARCHAR(255));

INSERT INTO @t ([R_PO_ID], [PO], [RB])
SELECT
	[S].[ID],
	[S].[PurchaseOrder],
	[S].[RequestedBy]
FROM (
	SELECT
		[P].[PurchaseOrder],
		MAX([MLastReceiptDat]) AS [MaxLastReceiptDate]
	FROM
		[SysproCompanyA].[dbo].[PorMasterDetail] [P]
	GROUP BY
		[P].[PurchaseOrder]
) AS [Src]
INNER JOIN
	[BWSdb].[dbo].[REC_POReceivedSubs] [S]
ON
	[S].[PurchaseOrder] = [Src].[PurchaseOrder] COLLATE DATABASE_DEFAULT 
WHERE
	([S].[Active] = 1)
	AND ([MaxLastReceiptDate] IS NOT NULL)

	
DECLARE @rb NVARCHAR(255);
DECLARE @poS NVARCHAR(255);
DECLARE @po INT;
DECLARE @iR INT = 0;
DECLARE @i INT = 0;
DECLARE @j INT = 0;
SELECT @j = COUNT(*) FROM @t;
DECLARE @email AS NVARCHAR(1024);
DECLARE @subject AS NVARCHAR(1024);
DECLARE @body AS NVARCHAR(1024);

WHILE @i < @j BEGIN

	SELECT
		@body = NULL,
		@subject = NULL,
		@email = NULL,
		@iR = NULL

	SELECT
		@iR = [R_PO_ID],
		@rb = [RB],
		@poS = [PO],
		@po = CAST([PO] AS INT)
	FROM
		@t [T]
	WHERE
		[T].[ID] = @i
	;

	IF (LEN(@rb) * LEN(@poS)) > 0 BEGIN
		SELECT
			@subject = 'PO ' + CAST(@po AS NVARCHAR(255)) + ' Received',
			@body = 'PO ' + CAST(@po AS NVARCHAR(255)) + ' has been received, please check Syspro for futher details.'
		SELECT
			@email = [Email]
		FROM
			[BWSdb].[dbo].[ITR Customers]
		WHERE
			([WindowsUser] = @rb)
			AND ([Active] = 1)
		;

		IF @email IS NULL BEGIN
			SELECT @email = 'avery.briggs@bwstrailers.com'
		END
		ELSE BEGIN
			SELECT @email = @email + ';avery.briggs@bwstrailers.com'
		END

		EXEC msdb.dbo.sp_send_dbmail 
			@recipients = @email,
			@profile_name = 'SQL Agent',
			@subject = @subject, 
			@body = @body,
			--@body_format='TEXT'
			@body_format='HTML'
			;

		UPDATE
			[BWSdb].[dbo].[REC_POReceivedSubs]
		SET
			[Active] = 0
		WHERE
			[ID] = @iR
		;
	END

	SELECT @i = @i + 1;
END