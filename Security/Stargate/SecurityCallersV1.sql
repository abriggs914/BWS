USE [BWSdb]
GO

/****** Object:  Table [dbo].[SecurityCallersV1]    Script Date: 2022-04-12 3:10:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SecurityCallersV1](
	[CallerID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[Main1] [int] NULL,
	[Main2] [int] NULL,
	[Main3] [int] NULL,
	[Main4] [int] NULL,
	[Main5] [int] NULL,
	[Main6] [int] NULL,
	[Finish1] [int] NULL,
	[Finish2] [int] NULL,
	[Finish3] [int] NULL,
	[Finish4] [int] NULL,
	[Finish5] [int] NULL,
	[Finish6] [int] NULL,
	[Dome1] [int] NULL,
	[Dome2] [int] NULL,
	[Dome3] [int] NULL,
	[Dome4] [int] NULL,
	[Dome5] [int] NULL,
	[Dome6] [int] NULL,
	[Tire1] [int] NULL,
	[Tire2] [int] NULL,
	[Tire3] [int] NULL,
	[Tire4] [int] NULL,
	[Tire5] [int] NULL,
	[Tire6] [int] NULL,
 CONSTRAINT [PK_SecurityCallersV1] PRIMARY KEY CLUSTERED 
(
	[CallerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


