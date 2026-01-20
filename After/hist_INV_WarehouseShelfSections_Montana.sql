/****** Object:  Table [dbo].[hist_INV_WarehouseShelfSections_Montana]    Script Date: 2026-01-20 11:42:30 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2026-01-20 11:42:30>
-- Description:	<Create Table [BWSdb].[dbo].[hist_INV_WarehouseShelfSections_Montana]>
-- =============================================
CREATE TABLE [dbo].[hist_INV_WarehouseShelfSections_Montana] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
    [DateCreated] [datetime] NULL,
    [NestLevel] [int] NULL,
    [ModifiedID] [int] NULL,
    [ModifiedBy] [nvarchar](50) NULL,
    [ModifiedColumn] [nvarchar](512) NULL,
    [Modification] [nvarchar](50) NULL,
    [ValueBefore] [nvarchar](max) NULL, 
    [ValueAfter] [nvarchar](max) NULL

	CONSTRAINT [PK_hist_INV_WarehouseShelfSections_Montana] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'hist_INV_WarehouseShelfSections_Montana'))))
BEGIN
	ALTER TABLE [dbo].[hist_INV_WarehouseShelfSections_Montana] ADD CONSTRAINT [DF_hist_INV_WarehouseShelfSections_Montana_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO