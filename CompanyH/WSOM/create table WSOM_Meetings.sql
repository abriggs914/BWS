/****** Object:  Table [dbo].[WSOM_Meetings]    Script Date: 2025-01-28 16:21:08 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-01-28 16:21:08>
-- Description:	<Create Table [BWSdb].[dbo].[WSOM_Meetings]>
-- =============================================
CREATE TABLE [dbo].[WSOM_Meetings] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[DateMeeting] [datetime] NULL,
	[Attendance] [nvarchar](max) NULL

	CONSTRAINT [PK_WSOM_Meetings] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'WSOM_Meetings'))))
BEGIN
	ALTER TABLE [dbo].[WSOM_Meetings] ADD CONSTRAINT [DF_WSOM_Meetings_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'WSOM_Meetings'))))
BEGIN
	ALTER TABLE [dbo].[WSOM_Meetings] ADD CONSTRAINT [DF_WSOM_Meetings_Active] DEFAULT ((1)) FOR [Active];
END
GO