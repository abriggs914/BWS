/****** Object:  Table [dbo].[PROD_JobOpIssue]    Script Date: 2025-09-22 12:04:01 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-09-22 12:04:01>
-- Description:	<Create Table [BWSdb].[dbo].[PROD_JobOpIssue]>
-- =============================================
CREATE TABLE [dbo].[PROD_JobOpIssue] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[Job] [nvarchar](511) NULL,
	[Operation] [int] NULL,
	[FirstIssued] [datetime] NULL,
	[LastIssued] [date] NULL

	CONSTRAINT [PK_PROD_JobOpIssue] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'PROD_JobOpIssue'))))
BEGIN
	ALTER TABLE [dbo].[PROD_JobOpIssue] ADD CONSTRAINT [DF_PROD_JobOpIssue_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'PROD_JobOpIssue'))))
BEGIN
	ALTER TABLE [dbo].[PROD_JobOpIssue] ADD CONSTRAINT [DF_PROD_JobOpIssue_Active] DEFAULT ((1)) FOR [Active];
END
GO