USE BWSdb
GO

BEGIN TRAN;

SELECT * FROM [IT Requests]

DECLARE @T TABLE (
	[ITRequestID#] [int] NULL,
	[RequestDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[Request] [nvarchar](max) NULL,
	[Priority] [int] NULL,
	[SubPriority] [int] NULL,
	[RequestedBy] [nvarchar](255) NULL,
	[Department] [int] NULL,
	[RequestFollowUpPersonnel] [nvarchar](max) NULL,
	[RequestType] [nvarchar](255) NULL,
	[RequestSubType] [nvarchar](255) NULL,
	[Comments] [nvarchar](max) NULL,
	[Company] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Directory] [nvarchar](max) NULL,
	[ITPersonAssigned] [nvarchar](255) NULL
)
;

INSERT INTO @T
SELECT 
[ITRequestID#],
[RequestDate],
[StartDate],
[DueDate],
[Request],
[Priority],
[SubPriority],
[RequestedBy],
[Department],
[RequestFollowUpPersonnel],
[RequestType],
[RequestSubType],
[Comments],
[Company],
[Status],
[Directory],
[ITPersonAssigned]
 FROM [IT Requests]
;

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IT Requests]') AND type in (N'U'))
DROP TABLE [dbo].[IT Requests]
--GO

SET ANSI_NULLS ON
--GO

SET QUOTED_IDENTIFIER ON
--GO

CREATE TABLE [dbo].[IT Requests](
	[ITRequestID#] [int] IDENTITY(1,1) NOT NULL,
	[RequestDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[Request] [nvarchar](max) NULL,
	[Priority] [int] NULL,
	[SubPriority] [int] NULL,
	[RequestedBy] [nvarchar](255) NULL,
	[Department] [int] NULL,
	[RequestFollowUpPersonnel] [nvarchar](max) NULL,
	[RequestType] [nvarchar](255) NULL,
	[RequestSubType] [nvarchar](255) NULL,
	[Comments] [nvarchar](max) NULL,
	[ITRequestts] [timestamp] NULL,
	[Company] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Directory] [nvarchar](max) NULL,
	[ITPersonAssignedID] [int] NULL,
 CONSTRAINT [PK_IT Requests] PRIMARY KEY CLUSTERED 
(
	[ITRequestID#] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO

ALTER TABLE [dbo].[IT Requests] ADD  CONSTRAINT [DF_IT Requests_RequestDate]  DEFAULT (CONVERT([date],getdate(),(0))) FOR [RequestDate]
--GO

INSERT INTO [IT Requests] ([RequestDate],
[StartDate],
[DueDate],
[Request],
[Priority],
[SubPriority],
[RequestedBy],
[Department],
[RequestFollowUpPersonnel],
[RequestType],
[RequestSubType],
[Comments],
[Company],
[Status],
[Directory])
SELECT [RequestDate],
[StartDate],
[DueDate],
[Request],
[Priority],
[SubPriority],
[RequestedBy],
[Department],
[RequestFollowUpPersonnel],
[RequestType],
[RequestSubType],
[Comments],
[Company],
[Status],
[Directory]
FROM @T

SELECT * FROM [IT Requests]

ROLLBACK;
COMMIT;