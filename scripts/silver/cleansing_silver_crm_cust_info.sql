--Check for Nulls or Duplicates in Primary Key 
--Expectation: No result 

-- -- SELECT crm.[cst_id], COUNT(*) AS count

-- -- FROM [DataWaharehouse].[bronze].[crm_cust_info] AS crm
-- -- GROUP BY crm.[cst_id] 
-- -- HAVING COUNT(*) > 1 OR crm.[cst_id] IS NULL;

--Check for unwanted Spaces 
--Expectation: No results 

USE DataWaharehouse;
GO


INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_first_name,
    cst_last_name,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)

SELECT 
t.[cst_id],
t.[cst_key],
TRIM(t.[cst_first_name]) AS cst_first_name,
TRIM(t.[cst_last_name]) AS  cst_last_name,
--t.[cst_marital_status],
--t.[cst_gndr],
    CASE WHEN UPPER(TRIM(t.[cst_gndr])) = 'M' THEN 'Male' 
         WHEN UPPER(TRIM(t.[cst_gndr])) = 'F' THEN 'Female'
         ELSE 'n/a' END AS cst_gndr, -- Normalize marital values into readable format

    CASE WHEN UPPER(TRIM(t.[cst_marital_status])) = 'S' THEN 'Single' 
         WHEN UPPER(TRIM(t.[cst_marital_status])) = 'M' THEN 'Married'
         ELSE 'n/a' END AS cst_marital_status, -- Normalize gender values to readable format 
         
                 
t.[cst_create_date]

FROM (

SELECT *, 
ROW_NUMBER() OVER (PARTITION BY crm.[cst_id] ORDER BY crm.[cst_create_date] DESC) AS flag_last

FROM [DataWaharehouse].[bronze].[crm_cust_info] AS crm

) t 
WHERE t.flag_last = 1
