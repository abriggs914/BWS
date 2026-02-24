USE BWSdb

-- 2026-02-24 - Avery Briggs - Used to track words used to describe stockcodes.

DROP TABLE [dbo].[INV_InvDescWord]

CREATE TABLE dbo.[INV_InvDescWord] (
    StockCode varchar(50) NOT NULL,
    Word      varchar(100) NOT NULL,
    CONSTRAINT PK_InvDescWord PRIMARY KEY (StockCode, Word)
);

CREATE INDEX IX_INV_InvDescWord_Word ON dbo.[INV_InvDescWord](Word);