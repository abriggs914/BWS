/****** Object:  Table [dbo].[INV_WarehouseLayout_Legend]    Script Date: 2026-01-07 08:41:55 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-07 08:41:55>
-- Description:	<Create Table [BWSdb].[dbo].[INV_WarehouseLayout_Legend]>
-- =============================================
CREATE TABLE [dbo].[INV_WarehouseLayout_Legend] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[Key] [nvarchar](1023) NULL,
	[Value] [nvarchar](max) NULL,
	[IsPath] [bit] NULL,
	[BG] [nvarchar](50) NULL,
	[FG] [nvarchar](50) NULL

	CONSTRAINT [PK_INV_WarehouseLayout_Legend] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'INV_WarehouseLayout_Legend'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseLayout_Legend] ADD CONSTRAINT [DF_INV_WarehouseLayout_Legend_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_WarehouseLayout_Legend'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseLayout_Legend] ADD CONSTRAINT [DF_INV_WarehouseLayout_Legend_Active] DEFAULT ((1)) FOR [Active];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_WarehouseLayout_Legend'))))
BEGIN
	ALTER TABLE [dbo].[INV_WarehouseLayout_Legend] ADD CONSTRAINT [DF_INV_WarehouseLayout_Legend_IsPath] DEFAULT ((0)) FOR [IsPath];
END
GO