USE [BWSdb]
GO

BEGIN TRAN;


SELECT * FROM [IT Personnel]

DECLARE @T TABLE ([ITPersonID#] [int] NULL,
	[Name] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[Emp#] [real] NULL)

INSERT INTO @T ([ITPersonID#], [Name], [Company], [Emp#]) (SELECT 1 AS [ITPersonID#],'Unassigned' AS [Name], NULL AS [Company], NULL AS [Emp#])

INSERT INTO @T
SELECT * FROM [IT Personnel]

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IT Personnel]') AND type in (N'U'))
DROP TABLE [dbo].[IT Personnel]

CREATE TABLE [dbo].[IT Personnel](
	[ITPersonID#] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[Company] [nvarchar](255) NULL,
	[Emp#] [real] NULL,
 CONSTRAINT [PK_IT Personnel] PRIMARY KEY CLUSTERED 
(
	[ITPersonID#] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


INSERT INTO [IT Personnel] ([Name], [Company], [Emp#])
SELECT [Name], [Company], [Emp#] FROM @T


SELECT * FROM [IT Personnel]

ROLLBACK;
COMMIT;