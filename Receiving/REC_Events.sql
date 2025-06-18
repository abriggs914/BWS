/****** Object:  Table [dbo].[REC_Events]    Script Date: 2025-06-18 15:33:46 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-06-18 15:33:46>
-- Description:	<Create Table [BWSdb].[dbo].[REC_Events]>
-- =============================================
CREATE TABLE [dbo].[REC_Events] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[LastModified] [datetime] NULL,
	[DateCreated] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[DateEvent] [datetime] NULL,
	[TimeEvent] [nvarchar](255) NULL,
	[Contact] [nvarchar](1023) NULL,
	[Job] [nvarchar](255) NULL,
	[Qty] [decimal](18, 5) NULL,
	[UOM] [nvarchar](255) NULL,
	[StockCode] [nvarchar](1023) NULL,
	[DateIssued] [datetime] NULL,
	[TimeIssued] [nvarchar](1023) NULL,
	[IssueComplete] [int] NULL,
	[Notes] [nvarchar](max) NULL

	CONSTRAINT [PK_REC_Events] PRIMARY KEY CLUSTERED (
        [ID] ASC
    )
    WITH (
        PAD_INDEX = OFF,
        STATISTICS_NORECOMPUTE = OFF,
        IGNORE_DUP_KEY = OFF,
        ALLOW_ROW_LOCKS = ON,
        ALLOW_PAGE_LOCKS = ON
        --, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
    ) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_Events'))))
BEGIN
	ALTER TABLE [dbo].[REC_Events] ADD CONSTRAINT [DF_REC_Events_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_Events'))))
BEGIN
	ALTER TABLE [dbo].[REC_Events] ADD CONSTRAINT [DF_REC_Events_Active] DEFAULT ((1)) FOR [Active];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_Events'))))
BEGIN
	ALTER TABLE [dbo].[REC_Events] ADD CONSTRAINT [DF_REC_Events_DateEvent] DEFAULT (getdate()) FOR [DateEvent];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_Events'))))
BEGIN
	ALTER TABLE [dbo].[REC_Events] ADD CONSTRAINT [DF_REC_Events_IssueComplete] DEFAULT ((0)) FOR [IssueComplete];
END
GO