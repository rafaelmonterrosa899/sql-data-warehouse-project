
USE DataWaharehouse;
GO

INSERT INTO [silver].[erp_px_cat_g1v2] (
    [id]
    ,[cat]
    ,[subcat]
    ,[maintanance]
)

SELECT *
FROM (


SELECT [id]
      ,[cat]
      ,[subcat]
      --,[maintanance]
      ,TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(maintanance,
        CHAR(9), ''),      -- Tabulador
        CHAR(10), ''),     -- Line Feed
        CHAR(13), ''),     -- Carriage Return
        NCHAR(8206), ''),  -- Left-to-Right Mark (LRM)
        NCHAR(8207), ''),  -- Right-to-Left Mark (RLM)
        NCHAR(8232), '')   -- Line Separator
    ) AS maintanance
  FROM [DataWaharehouse].[bronze].[erp_px_cat_g1v2]

) AS t 

--GROUP BY t.[cat]
