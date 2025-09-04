/****** Object:  Table [dbo].[hist_SorStatusCodes]    Script Date: 2025-09-02 09:49:54 ******/
USE [SysproCompanyA]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-09-02 09:49:54>
-- Description:	<Create Table [SysproCompanyA].[dbo].[hist_SorStatusCodes]>
-- =============================================
CREATE TABLE [dbo].[hist_SorStatusCodes] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
    [DateCreated] [datetime] NULL,
    [NestLevel] [int] NULL,
    [ModifiedID] [int] NULL,
    [ModifiedBy] [nvarchar](50) NULL,
    [ModifiedColumn] [nvarchar](512) NULL,
    [Modification] [nvarchar](50) NULL,
    [ValueBefore] [nvarchar](max) NULL, 
    [ValueAfter] [nvarchar](max) NULL

	CONSTRAINT [PK_hist_SorStatusCodes] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'hist_SorStatusCodes'))))
BEGIN
	ALTER TABLE [dbo].[hist_SorStatusCodes] ADD CONSTRAINT [DF_hist_SorStatusCodes_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO