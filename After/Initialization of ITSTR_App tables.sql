
-- 2026-02-09 0901
-- Initialization of [ITSTR_App... tables [Users, UserSettings, UserAccessLog]

-- Optional: keep auth objects separated
-- CREATE SCHEMA auth;
-- GO


CREATE TABLE [dbo].[ITSTR_AppUsers] (
    [ID]            INT IDENTITY(1,1) PRIMARY KEY,
    [UserName]           NVARCHAR(128) NOT NULL,
    [PasswordHashHex]  CHAR(64)      NOT NULL, -- sha256 pbkdf2 output (32 bytes -> 64 hex chars)
    [SaltHex]           CHAR(32)      NOT NULL, -- 16 bytes -> 32 hex chars
    [pbkdf2Iterations]  INT           NOT NULL CONSTRAINT [DF_ITSTR_AppUsers_iters] DEFAULT (100000),

    [FirstAccessUTC]   DATETIME2(3)  NOT NULL,
    [LastAccessUTC]    DATETIME2(3)  NOT NULL,
    [TimesAccessed]     INT           NOT NULL CONSTRAINT [DF_ITSTR_AppUsers_times] DEFAULT (0),

    [Active]          BIT           NOT NULL CONSTRAINT [DF_ITSTR_AppUsers_active] DEFAULT (1),

    CONSTRAINT [UQ_ITSTR_AppUsers_username] UNIQUE ([username])
);
GO

CREATE TABLE [dbo].[ITSTR_AppUserSettings] (
    [ID]        INT          NOT NULL PRIMARY KEY,
    [SettingsJSON]  NVARCHAR(MAX) NOT NULL,   -- store dict as JSON text
    [updatedUTC]    DATETIME2(3) NOT NULL,
    CONSTRAINT [FK_ITSTR_AppUserSettings_user]
        FOREIGN KEY (ID) REFERENCES [dbo].[ITSTR_AppUsers](ID)
        ON DELETE CASCADE
);
GO

-- Optional but useful for audits / troubleshooting
CREATE TABLE [dbo].[ITSTR_AppUserAccessLog] (
    [AccessID]      BIGINT IDENTITY(1,1) PRIMARY KEY,
    [ID]			INT NULL,
    [UserName]       NVARCHAR(128) NULL,
    [Success]        BIT NOT NULL,
    [EventType]     NVARCHAR(32) NOT NULL,     -- 'login', 'register', 'pw_change'
    [EventUTC]      DATETIME2(3) NOT NULL,
    [RemoteIP]      NVARCHAR(64) NULL,
    [UserAgent]     NVARCHAR(256) NULL
);
GO