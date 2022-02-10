USE [Stargatedb]
GO

/****** Object:  Table [dbo].[Payment Terms]    Script Date: 2022-02-10 12:19:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Payment Terms](
	[PayID] [int] IDENTITY(1,1) NOT NULL,
	[Payment Terms] [nvarchar](255) NULL,
 CONSTRAINT [aaaaaPayment Terms_PK] PRIMARY KEY NONCLUSTERED 
(
	[PayID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'17' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'PayID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'PayID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Payment Terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'4' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'PayID'
GO

EXEC sys.sp_addextendedproperty @name=N'AggregateType', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'AllowZeroLength', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'AppendOnly', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'CollatingOrder', @value=N'1033' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'ColumnHidden', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'ColumnOrder', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'ColumnWidth', @value=N'6990' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'DataUpdatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_IMESentMode', @value=N'3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Payment Terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'OrdinalPosition', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Required', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Size', @value=N'255' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'SourceField', @value=N'Payment Terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'SourceTable', @value=N'Payment Terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'TextAlign', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Type', @value=N'10' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'UnicodeCompression', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms', @level2type=N'COLUMN',@level2name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Attributes', @value=N'1073741824' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Connect', @value=N';DATABASE=J:\Access\BWSdb.mdb' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'DateCreated', @value=N'10/30/2012 12:06:21 PM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'DisplayViewsOnSharePointSite', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'FilterOnLoad', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'HideNewField', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'LastUpdated', @value=N'10/30/2012 12:06:21 PM' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DefaultView', @value=N'2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_OrderByOn', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Orientation', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Name', @value=N'Payment Terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'OrderByOnLoad', @value=N'True' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'RecordCount', @value=N'-1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'SourceTableName', @value=N'Payment Terms' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'TotalsRow', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO

EXEC sys.sp_addextendedproperty @name=N'Updatable', @value=N'False' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Payment Terms'
GO


