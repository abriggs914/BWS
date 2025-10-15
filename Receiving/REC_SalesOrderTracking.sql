/****** Object:  Table [dbo].[REC_SalesOrderTracking]    Script Date: 2025-10-15 11:55:49 ******/
USE [BWSdb]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create today:	<2025-10-15 11:55:49>
-- Description:	<Create Table [BWSdb].[dbo].[REC_SalesOrderTracking]>
-- =============================================
CREATE TABLE [dbo].[REC_SalesOrderTracking] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[SalesOrder] [nvarchar](255) NULL,
	[RequestDate] [datetime] NULL,
	[StartDate] [datetime] NULL,
	[CompleteDate] [datetime] NULL,
	[ShipDate] [datetime] NULL,
	[Printed] [int] NULL

	CONSTRAINT [PK_REC_SalesOrderTracking] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'REC_SalesOrderTracking'))))
BEGIN
	ALTER TABLE [dbo].[REC_SalesOrderTracking] ADD CONSTRAINT [DF_REC_SalesOrderTracking_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_SalesOrderTracking'))))
BEGIN
	ALTER TABLE [dbo].[REC_SalesOrderTracking] ADD CONSTRAINT [DF_REC_SalesOrderTracking_Active] DEFAULT ((1)) FOR [Active];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_SalesOrderTracking'))))
BEGIN
	ALTER TABLE [dbo].[REC_SalesOrderTracking] ADD CONSTRAINT [DF_REC_SalesOrderTracking_RequestDate] DEFAULT (GETDATE()) FOR [RequestDate];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'REC_SalesOrderTracking'))))
BEGIN
	ALTER TABLE [dbo].[REC_SalesOrderTracking] ADD CONSTRAINT [DF_REC_SalesOrderTracking_Printed] DEFAULT ((0)) FOR [Printed];
END
GO