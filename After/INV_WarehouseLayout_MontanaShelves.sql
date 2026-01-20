/****** Object:  Table [dbo].[INV_WarehouseLayout_MontanaShelves]    Script Date: 2026-01-20 12:16:56 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-20 12:16:56>
-- Description:	<Create Table [BWSdb].[dbo].[INV_WarehouseLayout_MontanaShelves]>
-- =============================================
CREATE TABLE [dbo].[INV_WarehouseLayout_MontanaShelves] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[Section] [nvarchar](50) NULL,
	[ShelfSectionID] [int] NULL,
	[Shelf] [nvarchar](255) NULL,
	[ShelfRow] [int] NULL

	CONSTRAINT [PK_INV_WarehouseLayout_MontanaShelves] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'INV_WarehouseLayout_MontanaShelves'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseLayout_MontanaShelves] ADD CONSTRAINT [DF_INV_WarehouseLayout_MontanaShelves_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_WarehouseLayout_MontanaShelves'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseLayout_MontanaShelves] ADD CONSTRAINT [DF_INV_WarehouseLayout_MontanaShelves_Active] DEFAULT ((1)) FOR [Active];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_WarehouseLayout_MontanaShelves'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseLayout_MontanaShelves] ADD CONSTRAINT [DF_INV_WarehouseLayout_MontanaShelves_Shelf] DEFAULT ((0)) FOR [Shelf];
END
GO