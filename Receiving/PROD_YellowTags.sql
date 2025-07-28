/****** Object:  Table [dbo].[PROD_YellowTags]    Script Date: 2025-07-28 11:06:00 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-07-28 11:06:00>
-- Description:	<Create Table [BWSdb].[dbo].[PROD_YellowTags]>
-- =============================================
CREATE TABLE [dbo].[PROD_YellowTags] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[WO] [nvarchar](255) NULL,
	[StockCode] [nvarchar](255) NULL,
	[Description] [nvarchar](max) NULL,
	[QtyMissing] [int] NULL,
	[Supplier] [nvarchar](max) NULL,
	[PO] [nvarchar](255) NULL,
	[Notes] [nvarchar](max) NULL

	CONSTRAINT [PK_PROD_YellowTags] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'PROD_YellowTags'))))
BEGIN
	ALTER TABLE [dbo].[PROD_YellowTags] ADD CONSTRAINT [DF_PROD_YellowTags_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'PROD_YellowTags'))))
BEGIN
	ALTER TABLE [dbo].[PROD_YellowTags] ADD CONSTRAINT [DF_PROD_YellowTags_Active] DEFAULT ((1)) FOR [Active];
END
GO