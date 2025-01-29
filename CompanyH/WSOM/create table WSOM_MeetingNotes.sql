/****** Object:  Table [dbo].[WSOM_MeetingNotes]    Script Date: 2025-01-28 16:14:49 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-01-28 16:14:49>
-- Description:	<Create Table [BWSdb].[dbo].[WSOM_MeetingNotes]>
-- =============================================
CREATE TABLE [dbo].[WSOM_MeetingNotes] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[MeetingID] [int] NULL,
	[Quote] [nvarchar](255) NULL,
	[IssueDescription] [nvarchar](max) NULL,
	[DateResolved] [datetime] NULL,
	[ResolutionDetails] [nvarchar](max) NULL,
	[ResolvedBy] [nvarchar](255) NULL

	CONSTRAINT [PK_WSOM_MeetingNotes] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'WSOM_MeetingNotes'))))
BEGIN
	ALTER TABLE [dbo].[WSOM_MeetingNotes] ADD CONSTRAINT [DF_WSOM_MeetingNotes_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'WSOM_MeetingNotes'))))
BEGIN
	ALTER TABLE [dbo].[WSOM_MeetingNotes] ADD CONSTRAINT [DF_WSOM_MeetingNotes_Active] DEFAULT ((1)) FOR [Active];
END
GO