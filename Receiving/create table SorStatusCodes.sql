/****** Object:  Table [dbo].[SorStatusCodes]    Script Date: 2025-09-02 09:49:54 ******/
USE [SysproCompanyA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-09-02 09:49:54>
-- Description:	<Create Table [SysproCompanyA].[dbo].[SorStatusCodes]>
-- =============================================
CREATE TABLE [dbo].[SorStatusCodes] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[StatusCode] [nvarchar](1) NULL,
	[Description] [nvarchar](max) NULL

	CONSTRAINT [PK_SorStatusCodes] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'SorStatusCodes'))))
BEGIN
	ALTER TABLE [dbo].[SorStatusCodes] ADD CONSTRAINT [DF_SorStatusCodes_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'SorStatusCodes'))))
BEGIN
	ALTER TABLE [dbo].[SorStatusCodes] ADD CONSTRAINT [DF_SorStatusCodes_Active] DEFAULT ((1)) FOR [Active];
END
GO