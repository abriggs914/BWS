/****** Object:  Table [dbo].[hist_PROD_YellowTagsAdmins]    Script Date: 2025-09-08 11:19:17 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-09-08 11:19:17>
-- Description:	<Create Table [BWSdb].[dbo].[hist_PROD_YellowTagsAdmins]>
-- =============================================
CREATE TABLE [dbo].[hist_PROD_YellowTagsAdmins] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
    [DateCreated] [datetime] NULL,
    [NestLevel] [int] NULL,
    [ModifiedID] [int] NULL,
    [ModifiedBy] [nvarchar](50) NULL,
    [ModifiedColumn] [nvarchar](512) NULL,
    [Modification] [nvarchar](50) NULL,
    [ValueBefore] [nvarchar](max) NULL, 
    [ValueAfter] [nvarchar](max) NULL

	CONSTRAINT [PK_hist_PROD_YellowTagsAdmins] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'hist_PROD_YellowTagsAdmins'))))
BEGIN
	ALTER TABLE [dbo].[hist_PROD_YellowTagsAdmins] ADD CONSTRAINT [DF_hist_PROD_YellowTagsAdmins_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO