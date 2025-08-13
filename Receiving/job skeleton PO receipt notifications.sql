
-- 2025-07-23 - Abriggs - Notify individuals when a PO is received, even partially.
--	They must subscribe first, and must have an entry for [ITR Customers].[WindowsUser].
-- 2025-07-29 - Abriggs - Added consideration for Yellow Tagged items via [BWSdb].[dbo].[PROD_YellowTags]

DECLARE @testMode BIT = 0;

SET NOCOUNT ON;

IF @testMode = 1 BEGIN
	SELECT
		*
	FROM
		[BWSdb].[dbo].[REC_POReceivedSubs] [S]
	;
	SELECT
		*
	FROM
		[BWSdb].[dbo].[PROD_YellowTags] [P]
	;
END

DECLARE @t TABLE ([ID] INT IDENTITY(0, 1), [R_PO_ID] INT, [PO] NVARCHAR(255), [AllQtyMet] INT, [RB] NVARCHAR(255), [LastDate] DATETIME, [NewDate] DATETIME, [YTID] INT, [YT] INT);

--DECLARE @poIsGood TABLE ([ID] INT IDENTITY(0, 1), [PO] NVARCHAR(255), [AllQtyMet] INT);

INSERT INTO @t ([R_PO_ID], [PO], [AllQtyMet], [RB], [LastDate], [NewDate], [YTID], [YT])
SELECT
	[Src2].[ID],
	[Src2].[PurchaseOrder],
	[Src1].[AllQtyMet],
	[Src2].[RequestedBy],
	ISNULL([Src2].[LastSent], DATEADD(DAY, -1, GETDATE())),
	[Src1].[MaxLastReceiptDate],
	[YTID],
	[YT]
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
) AS [Src1]
INNER JOIN (
	SELECT
		[S].[ID],
		[S].[RequestedBy],
		[S].[LastSent],
		ISNULL([S].[PurchaseOrder], [YT].[PO]) AS [PurchaseOrder],
		[S].[Active],
		[YT].[ID] AS [YTID],
		(CASE WHEN [YT].[ID] IS NULL THEN 0 ELSE 1 END) AS [YT]
	FROM
		[BWSdb].[dbo].[REC_POReceivedSubs] [S]
	FULL JOIN
		[BWSdb].[dbo].[PROD_YellowTags] [YT]
	ON
		[S].[PurchaseOrder] = [YT].[PO]
	WHERE
		(ISNULL([YT].[PO], [S].[PurchaseOrder]) IS NOT NULL)
		AND (([S].[Active] = 1) OR ([YT].[Active] = 1))
) AS [Src2]
	ON
	[Src2].[PurchaseOrder] = [Src1].[PurchaseOrder] COLLATE DATABASE_DEFAULT 
;

IF @testMode = 1 BEGIN
	/* -- From testing on 20250729
	INSERT INTO @t ([R_PO_ID], [PO], [AllQtyMet], [RB], [LastDate], [NewDate], [YT]) VALUES
	(NULL, '000000000147350', 0, NULL, DATEADD(DAY, -1, GETDATE()),	GETDATE(), 1),
	(NULL, '000000000149158', 0, NULL, DATEADD(DAY, -1, GETDATE()),	GETDATE(), 0)
	;
	*/

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
--SELECT @defaultEmails = @defaultEmails + ';lori.piper@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';jason.somerville@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';lance.lunn@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';rick.howard@bwstrailers.com';
SELECT @defaultEmails = @defaultEmails + ';tony.underhill@bwstrailers.com';
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
DECLARE @yt INT;
DECLARE @iR INT = 0;
DECLARE @iY INT = 0;
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
		@yt = NULL,
		@iY = NULL,
		@complete = NULL,
		@newDate = NULL,
		@lastDate = NULL,
		@firstReceived = NULL,
		@lastReceived = NULL,
		@timesReceived = NULL
	;

	SELECT
		@iR = [R_PO_ID],
		@iY = [YTID],
		@rb = [RB],
		@yt = [YT],
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
		@timesReceived = ISNULL(COUNT([JnlDate]), 0),
		@firstReceived = ISNULL(MIN([JnlDate]), 0),
		@lastReceived = ISNULL(MAX([JnlDate]), 0)
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

	IF (LEN(ISNULL(@poS, '')) > 0) AND (ISNULL(@newDate, @lastDate) > @lastDate) BEGIN
		
		SET @body = '<!DOCTYPE html><html><head><title>PO Receipt Alert</title></head><body><p>'

		SELECT
			@subject = 'PO ' + CAST(ISNULL(@po, 0) AS NVARCHAR(255)) + ' Received'
			--,
			--@body = @body + 'PO ' + CAST(ISNULL(@po, 0) AS NVARCHAR(255)) + ' has been received'
		;

		IF @complete = 0 BEGIN
			SELECT @body = @body + '</p><h4 style="color:RGB(200, 34, 34)">BACKORDERED PARTS YET TO BE DELIVERED</h4><p>PO ' + CAST(ISNULL(@po, 0) AS NVARCHAR(255)) + ' has been received ' + ISNULL(CAST(@timesReceived AS NVARCHAR(12)), '?') + ' time(s), between ' + ISNULL(CAST(CAST(@firstReceived AS DATE) AS NVARCHAR(255)), '?') + ' and ' + ISNULL(CAST(CAST(@lastReceived AS DATE) AS NVARCHAR(255)), '?')
		END

		IF @yt = 1 BEGIN
			SELECT @body = @body + '</p><h4 style="color:RGB(200, 34, 34)">THIS PO IS LISTED AS URGENT DUE TO EXPECTED PARTS INDICATED IN THE YELLOW TAG PROCESS.</h4><p>'
		END

		SELECT
			@body = @body + 'please check Syspro for futher details.'
		SELECT
			@body = @body + '</p></body></html>'
		;

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
		
			UPDATE
				[BWSdb].[dbo].[PROD_YellowTags]
			SET
				[Active] = (CASE WHEN @complete = 1 THEN 0 ELSE 1 END)
			WHERE
				[ID] = @iY
			;
		END
	END

	SELECT @i = @i + 1;
--END