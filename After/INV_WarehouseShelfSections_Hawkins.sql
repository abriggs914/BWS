/****** Object:  Table [dbo].[INV_WarehouseShelfSections_Hawkins]    Script Date: 2026-01-07 14:16:33 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-07 14:16:33>
-- Description:	<Create Table [BWSdb].[dbo].[INV_WarehouseShelfSections_Hawkins]>
-- =============================================
CREATE TABLE [dbo].[INV_WarehouseShelfSections_Hawkins] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[ParentShelf] [nvarchar](255) NULL,
	[Section] [nvarchar](50) NULL,
	[Group] [nvarchar](255) NULL,
	[X0] [int] NULL,
	[X1] [int] NULL,
	[Y0] [int] NULL,
	[Y1] [int] NULL

	CONSTRAINT [PK_INV_WarehouseShelfSections_Hawkins] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'INV_WarehouseShelfSections_Hawkins'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseShelfSections_Hawkins] ADD CONSTRAINT [DF_INV_WarehouseShelfSections_Hawkins_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_WarehouseShelfSections_Hawkins'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseShelfSections_Hawkins] ADD CONSTRAINT [DF_INV_WarehouseShelfSections_Hawkins_Active] DEFAULT ((1)) FOR [Active];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_WarehouseShelfSections_Hawkins'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseShelfSections_Hawkins] ADD CONSTRAINT [DF_INV_WarehouseShelfSections_Hawkins_Group] DEFAULT ((0)) FOR [Group];
END
GO