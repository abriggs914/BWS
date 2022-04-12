USE [Stargatedb]
GO

/****** Object:  Table [dbo].[SecurityV1]    Script Date: 2022-04-12 3:10:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SecurityV1](
	[SecurityID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[Code] [nvarchar](4) NULL,
	[A] [int] NULL,
	[A1] [int] NULL,
	[A2] [int] NULL,
	[A3] [int] NULL,
	[Main] [bit] NULL,
	[Finish] [bit] NULL,
	[Tire] [bit] NULL,
	[Dome] [bit] NULL,
	[Active] [bit] NULL,
	[TimeStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO


