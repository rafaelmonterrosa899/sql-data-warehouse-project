
USE DataWaharehouse; 
GO

INSERT INTO silver.erp_cust_az12 (cid, bdate,gen)


SELECT t. cid 
    ,t.bdate
    --,t.gen_cleaned
,CASE WHEN UPPER(TRIM(t.gen_cleaned)) IN ('F', 'FEMALE') THEN 'Female'
      WHEN UPPER(TRIM(t.gen_cleaned)) IN ('M', 'Male') THEN 'Male'
      ELSE 'n/a'
END AS gen 
FROM (

SELECT --[cid]
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) 
    ELSE cid 
END cid 
      --,[bdate]
,CASE WHEN bdate > GETDATE() THEN NULL
    ELSE bdate 
END AS bdate
      --,[gen]
,TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(gen,
       CHAR(9), ''),      -- Tabulador
       CHAR(10), ''),     -- Line Feed
       CHAR(13), ''),     -- Carriage Return
       NCHAR(8206), ''),  -- Left-to-Right Mark (LRM)
       NCHAR(8207), ''),  -- Right-to-Left Mark (RLM)
       NCHAR(8232), '')   -- Line Separator
  ) AS gen_cleaned


  FROM [DataWaharehouse].[bronze].[erp_cust_az12]

) AS t 
--WHERE t.gen_cleaned = 'F'




  



