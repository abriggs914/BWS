
-- 2025-09-25 - Avery Briggs - Adding to support List Similar Quotes function.


-- one-time: a unique, non-null key is required
CREATE UNIQUE INDEX UX_OrderStandards_Key
ON [BWSdb].[dbo].[Order Standards](IDOS);  -- your surrogate key

-- catalog (or use an existing one)
CREATE FULLTEXT CATALOG ftc AS DEFAULT;

-- full-text index on the MAX column
CREATE FULLTEXT INDEX ON [BWSdb].[dbo].[Order Standards]
(
  [Description] LANGUAGE 1033  -- en-US; adjust if needed
)
KEY INDEX UX_OrderStandards_Key
WITH CHANGE_TRACKING AUTO;
