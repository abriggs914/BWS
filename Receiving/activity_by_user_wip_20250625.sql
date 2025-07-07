
DECLARE @sd DATETIME = '2025-05-23';
DECLARE @ed DATETIME = GETDATE();
DECLARE @oC TABLE ([ID] INT IDENTITY(0, 1), [OperatorCode] NVARCHAR(MAX))
INSERT INTO @oC ([OperatorCode]) VALUES
('ABRIGGS2')

-- Bin Relocations
SELECT TOP 250000
	*
FROM
	--[SysproCompanyA].[dbo].[InvMastAmendJnl] [IM]
	[SysproCompanyA].[dbo].[InvWhAmendJnl] [IM]
WHERE
	([JnlDate] BETWEEN @sd AND DATEADD(DAY, 1, @ed))
	
	AND (
		(LOWER([OperatorCode]) LIKE '%abriggs%')
		OR (LOWER([OperatorCode]) LIKE '%chamilton%')
		OR (LOWER([OperatorCode]) LIKE '%rec%')
		OR (LOWER([OperatorCode]) LIKE '%parts%')
	)

;


-- Bin Relocations
SELECT TOP 2500
	*
FROM
	--[SysproCompanyA].[dbo].[InvMastAmendJnl] [IM]
	--[SysproCompanyA].[dbo].[InvWhAmendJnl] [IM]
	--[SysproCompanyA].[dbo].[WipLabJnl] [IM]
	--[SysproCompanyA].[dbo].[InvJournalCtl] [IM]
	--[SysproCompanyA].[dbo].[WipJobAmendJnl] [IM]
	[SysproCompanyA].[dbo].[WipJobPost] [IM]
WHERE
	([IM].[] BETWEEN @sd AND DATEADD(DAY, 1, @ed))
	/*
	AND (
		(LOWER([OperatorCode]) LIKE '%abriggs%')
		OR (LOWER([OperatorCode]) LIKE '%chamilton%')
		OR (LOWER([OperatorCode]) LIKE '%rec%')
		OR (LOWER([OperatorCode]) LIKE '%parts%')
	)*/