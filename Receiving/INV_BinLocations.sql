/****** Object:  Table [dbo].[INV_BinLocations]    Script Date: 2025-07-30 14:16:21 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-07-30 14:16:21>
-- Description:	<Create Table [BWSdb].[dbo].[INV_BinLocations]>
-- =============================================
CREATE TABLE [dbo].[INV_BinLocations] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[Bin] [nvarchar](255) NULL

	CONSTRAINT [PK_INV_BinLocations] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'INV_BinLocations'))))
BEGIN
	ALTER TABLE [dbo].[INV_BinLocations] ADD CONSTRAINT [DF_INV_BinLocations_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'INV_BinLocations'))))
BEGIN
	ALTER TABLE [dbo].[INV_BinLocations] ADD CONSTRAINT [DF_INV_BinLocations_Active] DEFAULT ((1)) FOR [Active];
END
GO