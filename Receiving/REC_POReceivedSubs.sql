/****** Object:  Table [dbo].[REC_POReceivedSubs]    Script Date: 2025-07-08 22:20:26 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-07-08 22:20:26>
-- Description:	<Create Table [BWSdb].[dbo].[REC_POReceivedSubs]>
-- =============================================
CREATE TABLE [dbo].[REC_POReceivedSubs] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[PurchaseOrder] [nvarchar](255) NULL,
	[RequestedBy] [nvarchar](255) NULL

	CONSTRAINT [PK_REC_POReceivedSubs] PRIMARY KEY CLUSTERED (
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
)
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_POReceivedSubs'))))
BEGIN
	ALTER TABLE [dbo].[REC_POReceivedSubs] ADD CONSTRAINT [DF_REC_POReceivedSubs_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_POReceivedSubs'))))
BEGIN
	ALTER TABLE [dbo].[REC_POReceivedSubs] ADD CONSTRAINT [DF_REC_POReceivedSubs_Active] DEFAULT ((1)) FOR [Active];
END
GO