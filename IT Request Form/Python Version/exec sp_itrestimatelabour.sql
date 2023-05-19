USE [BWSdb]
GO

DECLARE @t AS TABLE (
	[qid] NVARCHAR(1)
	, [ID] INT
	, [Company] NVARCHAR(MAX)
	, [Dept] NVARCHAR(MAX)
	, [RequestType] NVARCHAR(MAX)
	, [RequestSubType] NVARCHAR(MAX)
	, [# Reqs] INT
	, [Tot Reqs] INT
	, [Tot Act] DECIMAL(14,7)
	, [Tot Bud] DECIMAL(14,7) 
	, [% Ttl Reqs] DECIMAL(16,2)
	, [Act] DECIMAL(14,7)
	, [Bud] DECIMAL(14,7)
	, [Act / Bud] DECIMAL(14,2)
	, [Act / Req] DECIMAL(14,2)
	, [Bud / Req] DECIMAL(14,2)
	, [% Total Act] DECIMAL(14,2)
	, [% Total Bud] DECIMAL(14,2)
)
;

INSERT INTO @t

EXEC	[dbo].[sp_ITREstimateLabour]
		@company = NULL,
		@department = NULL,
		@requestType = NULL,
		@requestSubType = NULL
;

SELECT * FROM @t