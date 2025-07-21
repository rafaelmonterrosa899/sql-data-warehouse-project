
USE DataWaharehouse;
GO

INSERT INTO [silver].[erp_loc_a101] (
    [cid]
    ,[cntry]

)

    SELECT t.[cid],
        CASE 
            WHEN t.[cntry_cleaned] = 'US' THEN 'United States' 
            WHEN t.[cntry_cleaned] = 'USA' THEN 'United States' 
            WHEN t.[cntry_cleaned] = 'DE' THEN 'Germany' 
            WHEN t.[cntry_cleaned] = '' THEN 'm/a' ELSE t.[cntry_cleaned]
            END AS country_fixed
    FROM (

    SELECT  --[cid]
        REPLACE([cid], '-', '') AS cid
        --,[cntry]
        ,TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cntry,
        CHAR(9), ''),      -- Tabulador
        CHAR(10), ''),     -- Line Feed
        CHAR(13), ''),     -- Carriage Return
        NCHAR(8206), ''),  -- Left-to-Right Mark (LRM)
        NCHAR(8207), ''),  -- Right-to-Left Mark (RLM)
        NCHAR(8232), '')   -- Line Separator
    ) AS cntry_cleaned
    FROM [DataWaharehouse].[bronze].[erp_loc_a101] 

    ) AS t ;


