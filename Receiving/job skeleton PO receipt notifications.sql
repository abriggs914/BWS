
-- 2025-07-23 - Abriggs - Notify individuals when a PO is received, even partially.
--	They must subscribe first, and must have an entry for [ITR Customers].[WindowsUser].

DECLARE @testMode BIT = 1;

SET NOCOUNT ON;

IF @testMode = 1 BEGIN
	SELECT
		*
	FROM
		[BWSdb].[dbo].[REC_POReceivedSubs] [S]
	;
END

DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [R_PO_ID] INT, [PO] NVARCHAR(255), [AllQtyMet] INT, [RB] NVARCHAR(255), [LastDate] DATETIME, [NewDate] DATETIME);

--DECLARE @poIsGood TABLE ([ID] INT IDENTITY(0, 1), [PO] NVARCHAR(255), [AllQtyMet] INT);

INSERT INTO @t ([R_PO_ID], [PO], [AllQtyMet], [RB], [LastDate], [NewDate])
SELECT
	[S].[ID],
	[S].[PurchaseOrder],
	[Src].[AllQtyMet],
	[S].[RequestedBy],
	ISNULL([S].[LastSent], DATEADD(DAY, -1, GETDATE())),
	[Src].[MaxLastReceiptDate]
FROM (
	SELECT
		[P].[PurchaseOrder],
		MAX([MLastReceiptDat]) AS [MaxLastReceiptDate],
		CASE 
			WHEN MIN(CASE WHEN [P].[MReceivedQty] < [P].[MOrderQty] THEN 0 ELSE 1 END) = 1 
			THEN 1
			ELSE 0
		END AS [AllQtyMet]
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
	--AND ([AllQtyMet] = 1)
;

IF @testMode = 1 BEGIN
	SELECT '@t' AS [T], * FROM @t;
END

-- 2025-07-23
-- Receiving
-- Avery Briggs
-- Lori Piper
-- Jason Somerville
-- Lance Lunn
-- Jamie Merrithew
-- Yassin Nasser
DECLARE @defaultEmails AS NVARCHAR(MAX) = 'rec@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';avery.briggs@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';lori.piper@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';jason.somerville@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';lance.lunn@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';jamie.merrithew@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';yassin.nasser@bwstrailers.com';
	
DECLARE @rb NVARCHAR(255);
DECLARE @poS NVARCHAR(255);
DECLARE @complete INT = 0;
DECLARE @newDate DATETIME;
DECLARE @lastDate DATETIME;
DECLARE @lastReceived DATETIME;
DECLARE @firstReceived DATETIME;
DECLARE @timesReceived INT;
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
		@iR = NULL,
		@complete = NULL,
		@newDate = NULL,
		@lastDate = NULL,
		@firstReceived = NULL,
		@lastReceived = NULL,
		@timesReceived = NULL
	;

	SELECT
		@iR = [R_PO_ID],
		@rb = [RB],
		@poS = [PO],
		@po = CAST([PO] AS INT),
		@complete = ISNULL([AllQtyMet], 0),
		@lastDate = [T].[LastDate],
		@newDate = [T].[NewDate]
	FROM
		@t [T]
	WHERE
		[T].[ID] = @i
	;
	SELECT
		@timesReceived = COUNT([JnlDate]),
		@firstReceived = MIN([JnlDate]),
		@lastReceived = MAX([JnlDate])
	FROM
		[SysproCompanyA].[dbo].[PorHistReceipt] [P]
	WHERE
		[PurchaseOrder] = @poS
	GROUP BY
		[PurchaseOrder],
		[JnlDate]
	;
	
	IF @testMode = 1 BEGIN
		SELECT
			'TEST_0' AS [T],
			@LastDate AS [LastDate],
			@newDate AS [NewDate],
			@rb AS [RB],
			@po AS [PO],
			@poS AS [POs]
		;
	END

	IF ((LEN(@rb) * LEN(@poS)) > 0) AND (ISNULL(@newDate, @lastDate) > @lastDate) BEGIN
		
		SET @body = '<!DOCTYPE html><html><head><title>PO Receipt Alert</title></head><body><p>'

		SELECT
			@subject = 'PO ' + CAST(@po AS NVARCHAR(255)) + ' Received',
			@body = @body + 'PO ' + CAST(@po AS NVARCHAR(255)) + ' has been received, please check Syspro for futher details.'
		;

		IF @complete = 0 BEGIN
			SELECT @body = @body + '</p><h4 style="color:RGB(200, 34, 34)">BACKORDERED PARTS YET TO BE DELIVERED</h4><p>PO ' + CAST(@po AS NVARCHAR(255)) + ' has been received ' + CAST(@timesReceived AS NVARCHAR(12)) + ' time(s), between ' + CAST(CAST(@firstReceived AS DATE) AS NVARCHAR(255)) + ' and ' + CAST(CAST(@lastReceived AS DATE) AS NVARCHAR(255))
		END

		SELECT
			@body = @body + '</p></body></html>'

		SELECT
			@email = [Email]
		FROM
			[BWSdb].[dbo].[ITR Customers]
		WHERE
			([WindowsUser] = @rb)
			AND ([Active] = 1)
		;

		IF @email IS NULL BEGIN
			SELECT @email = @defaultEmails
		END
		ELSE BEGIN
			SELECT @email = @email + ';' + @defaultEmails
		END
		
		IF @testMode = 1 BEGIN
			SELECT
				'TEST_1' AS [T],
				@subject AS [@subject], 
				@email AS [@email], 
				@body AS [@body],
				@po AS[@po]
			;
		END
		ELSE BEGIN		
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
				[Active] = (CASE WHEN @complete = 1 THEN 0 ELSE 1 END),
				[TimesSent] = [TimesSent] + 1,
				[LastSent] = GETDATE()
			WHERE
				[ID] = @iR
			;
		END
	END

	SELECT @i = @i + 1;
END