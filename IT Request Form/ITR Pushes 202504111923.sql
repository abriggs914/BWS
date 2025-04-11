/****** Object:  Table [dbo].[ITR Pushes]    Script Date: 2025-04-11 17:28:03 ******/
USE [BWSdb]
GO


/*

	Script to rewrite the [BWSdb].[dbo].[ITR Pushes] schema.
	The triggers sp_ITRSendEmailUpdateRepos and sp_ITRSendEmailUpdateDBs were
	mixing up values for column inserts, and was not accurately passing the user param.

	--202504111923

*/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DECLARE @st NVARCHAR(3) = '|||';

CREATE TABLE ##testTable202504111910 (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[Recipient] [nvarchar](1024) NULL,
	[Subject] [nvarchar](1024) NULL,
	[DBStr] [nvarchar](max) NULL,
	[CommentStr] [nvarchar](max) NULL,
	[Body] [nvarchar](max) NULL
)
INSERT INTO ##testTable202504111910 (
	[Active],
	[DateCreated],
	[DateActive],
	[Recipient],
	[Subject],
	[DBStr],
	[CommentStr]
)
SELECT
	1,
	[Date],
	[Date],
	[Subject],
	[Persons],
	LEFT([HTML], CHARINDEX(@st, [HTML]) - 1),
	SUBSTRING([HTML], CHARINDEX(@st, [HTML]) + LEN(@st), LEN([HTML]) - LEN(LEFT([HTML], CHARINDEX(@st, [HTML]) - 1)) - LEN(@st))
FROM 
	[BWSdb].[dbo].[ITR Pushes]
;

SELECT * FROM ##testTable202504111910

DROP TABLE [BWSdb].[dbo].[ITR Pushes];
GO

-- =============================================
-- Author:		<Avery Briggs>
-- Create date:	<2025-04-11 17:28:03>
-- Description:	<Create Table [BWSdb].[dbo].[ITR Pushes]>
-- =============================================
CREATE TABLE [dbo].[ITR Pushes] (
	[ID] [int] IDENTITY(0, 1) NOT NULL,
	[DateCreated] [datetime] NULL,
	[LastModified] [datetime] NULL,
	[Active] [bit] NULL,
	[DateActive] [datetime] NULL,
	[DateInActive] [datetime] NULL,
	[DBStr] [nvarchar](max) NULL,
	[CommentStr] [nvarchar](max) NULL,
	[User] [nvarchar](1024) NULL,
	[Recipient] [nvarchar](1024) NULL,
	[Subject] [nvarchar](1024) NULL,
	[Body] [nvarchar](max) NULL

	CONSTRAINT [PK_ITR Pushes] PRIMARY KEY CLUSTERED (
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
    AND (TABLE_NAME = 'ITR Pushes'))))
BEGIN
	ALTER TABLE [dbo].[ITR Pushes] ADD CONSTRAINT [DF_ITR Pushes_DateCreated] DEFAULT (GETDATE()) FOR [DateCreated];
END
GO

IF (EXISTS (SELECT * 
    FROM INFORMATION_SCHEMA.TABLES 
    WHERE (([TABLE_SCHEMA] = 'dbo') 
    AND (TABLE_NAME = 'ITR Pushes'))))
BEGIN
	ALTER TABLE [dbo].[ITR Pushes] ADD CONSTRAINT [DF_ITR Pushes_Active] DEFAULT ((1)) FOR [Active];
END
GO


INSERT INTO [BWSdb].[dbo].[ITR Pushes] (
	[Active],
	[DateCreated],
	[DateActive],
	[Recipient],
	[Subject],
	[CommentStr],
	[DBStr]
)
SELECT
	[Active],
	[DateCreated],
	[DateActive],
	[Recipient],
	[Subject],
	[CommentStr],
	[DBStr]
FROM
	##testTable202504111910
;
GO