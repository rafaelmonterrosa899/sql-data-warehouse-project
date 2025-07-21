
--This query is to clean up the data of the sales table
--This will go into the silver table.
--Businews Rules for the last 3 columns: 
    --Summatory of Sales must be Quantitiy * price. 
    --Negative, Zeros, Nulls are not allowed. 

USE DataWaharehouse; 
GO 



INSERT INTO [silver].[crm_sales_details]  (
    [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,[sls_order_dt]
      ,[sls_ship_dt]
      ,[sls_due_dt]
      ,[sls_sales]
      ,[sls_quantity]
      ,[sls_price]
)


SELECT 
    sl.[sls_ord_num]
      ,sl.[sls_prd_key]
      ,sl.[sls_cust_id]
      --,sl.[sls_order_dt]
      --This query is to avoid cero values and wrong data values and replece those with NULL
      ,CASE WHEN sl.[sls_order_dt] <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
            ELSE CAST(CAST(sl.[sls_order_dt] AS VARCHAR) AS DATE)
            END AS sls_order_dt
      ,CASE WHEN sl.[sls_ship_dt] <= 0 OR LEN([sls_ship_dt]) != 8 THEN NULL
            ELSE CAST(CAST(sl.[sls_ship_dt] AS VARCHAR) AS DATE)
            END AS sls_ship_dt
      ,CASE WHEN sl.[sls_due_dt] <= 0 OR LEN([sls_due_dt]) != 8 THEN NULL
            ELSE CAST(CAST(sl.[sls_due_dt] AS VARCHAR) AS DATE)
            END AS sls_due_dt
      --,sl.[sls_ship_dt]
      --,sl.[sls_due_dt]
      --,sl.[sls_sales]
,CASE WHEN sl.sls_sales IS NULL OR sl.sls_sales <= 0 OR sl.sls_sales != sl.sls_quantity * ABS(sl.sls_price)
    THEN sl.sls_quantity * ABS(sl.sls_price)
    ELSE sl.sls_sales 
END AS sls_sales
      ,sl.[sls_quantity]
      --,sl.[sls_price]
,CASE WHEN sl.sls_price IS NULL OR sl.sls_price <= 0 
    THEN sl.sls_sales / NULLIF(sl.sls_quantity, 0)
    ELSE sl.sls_price
END AS sls_price
FROM [bronze].[crm_sales_details] AS sl; 











--Order Date should be always earlier thatn Shipping date and due date 
--TEST 

-- USE DataWaharehouse; 
-- GO

-- SELECT
--  CASE WHEN sl.[sls_order_dt] <= 0 OR LEN(sls_order_dt) != 8 THEN NULL
--             ELSE CAST(CAST(sl.[sls_order_dt] AS VARCHAR) AS DATE)
--             END AS sls_order_dt
--       ,CASE WHEN sl.[sls_ship_dt] <= 0 OR LEN([sls_ship_dt]) != 8 THEN NULL
--             ELSE CAST(CAST(sl.[sls_ship_dt] AS VARCHAR) AS DATE)
--             END AS sls_ship_dt
--       ,CASE WHEN sl.[sls_due_dt] <= 0 OR LEN([sls_due_dt]) != 8 THEN NULL
--             ELSE CAST(CAST(sl.[sls_due_dt] AS VARCHAR) AS DATE)
--             END AS sls_due_dt
-- FROM [bronze].[crm_sales_details] AS sl
-- --WHERE t.[sls_order_dt] > t.[sls_ship_dt]


--Check last 3 columns

-- SELECT
--     sl.sls_sales AS old_sls_sales
--   ,sl.sls_quantity
--   ,sl.sls_price AS old_sls_price

-- ,CASE WHEN sl.sls_sales IS NULL OR sl.sls_sales <= 0 OR sl.sls_sales != sl.sls_quantity * ABS(sl.sls_price)
--     THEN sl.sls_quantity * ABS(sl.sls_price)
--     ELSE sl.sls_sales 
-- END AS sls_sales

-- ,CASE WHEN sl.sls_price IS NULL OR sl.sls_price <= 0 
--     THEN sl.sls_sales / NULLIF(sl.sls_quantity, 0)
--     ELSE sl.sls_price
-- END AS sls_price

-- FROM [bronze].[crm_sales_details] AS sl
-- WHERE sl.sls_sales != sl.sls_quantity * sl.sls_price
-- OR sl.sls_sales IS NULL OR sl.sls_quantity IS NULL OR sl.sls_price IS NULL
-- OR sl.sls_sales <= 0 OR sl.sls_quantity <= 0 OR sl.sls_price <= 0
-- ORDER BY sl.sls_sales, sl.sls_quantity, sl.sls_price;

