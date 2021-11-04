USE Stargatedb
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

BEGIN TRAN;
SELECT * FROM [Payroll]
DECLARE @Temp TABLE (
	[RaiseID] [int],
	[Emp#] [real],
	[Date] [datetime],
	[STS] [varchar](8),
	[Salary] [float],
	[Annual] [money],
	[Bonus%] [float],
	[Dep Life] [float],
	[Health] [float],
	[Dental] [float],
	[Vacation%] [float],
	[RRSP%] [float],
	[Absent] [float],
	[Late] [float],
	[Leave Early] [float],
	[NQ] [bit],
	[Reason] [nvarchar](255),
	[2nd Name] [nvarchar](50),
	[1st Name] [nvarchar](50),
	[Hourly/Salary] [nvarchar](50),
	[Comments] [nvarchar](255),
	[RRSP ER%] [float],
	[RRSP VOL%] [float]
)

INSERT INTO @Temp
SELECT * FROM [Payroll]

DROP TABLE [dbo].[Payroll]

CREATE TABLE [dbo].[Payroll](
	[RaiseID] [int] IDENTITY(1,1) NOT NULL,
	[Emp#] [int] NULL,
	[Date] [datetime] NULL,
	[STS] [varchar](8) NULL,
	[Salary] [float] NULL,
	[Annual] [money] NULL,
	[Bonus%] [float] NULL,
	[Dep Life] [float] NULL,
	[Health] [float] NULL,
	[Dental] [float] NULL,
	[Vacation%] [float] NULL,
	[RRSP%] [float] NULL,
	[Absent] [float] NULL,
	[Late] [float] NULL,
	[Leave Early] [float] NULL,
	[NQ] [bit] NULL,
	[Reason] [nvarchar](255) NULL,
	[2nd Name] [nvarchar](50) NULL,
	[1st Name] [nvarchar](50) NULL,
	[Hourly/Salary] [nvarchar](50) NULL,
	[Comments] [nvarchar](255) NULL,
	[RRSP ER%] [float] NULL,
	[RRSP VOL%] [float] NULL,
 CONSTRAINT [PK_Payroll] PRIMARY KEY CLUSTERED 
(
	[RaiseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
--GO

INSERT INTO [dbo].[Payroll] (
	[Emp#],
	[Date],
	[STS],
	[Salary],
	[Annual],
	[Bonus%],
	[Dep Life],
	[Health],
	[Dental],
	[Vacation%],
	[RRSP%],
	[Absent],
	[Late],
	[Leave Early],
	[NQ],
	[Reason],
	[2nd Name],
	[1st Name],
	[Hourly/Salary],
	[Comments],
	[RRSP ER%],
	[RRSP VOL%])
SELECT 
	[Emp#],
	[Date],
	[STS],
	[Salary],
	[Annual],
	[Bonus%],
	[Dep Life],
	[Health],
	[Dental],
	[Vacation%],
	[RRSP%],
	[Absent],
	[Late],
	[Leave Early],
	[NQ],
	[Reason],
	[2nd Name],
	[1st Name],
	[Hourly/Salary],
	[Comments],
	[RRSP ER%],
	[RRSP VOL%]
FROM @Temp

SELECT * FROM [Payroll]

ROLLBACK;
COMMIT;