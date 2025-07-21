
USE DataWaharehouse;
GO

INSERT INTO [silver].[crm_prd_info]
(
   [prd_id]
      ,[cat_id]
      ,[prd_key]
      ,[prd_nm]
      ,[prd_cost]
      ,[prd_line]
      ,[prd_start_dt]
      ,[prd_end_dt]
      
)

--Mountain Bottle Cag

SELECT 
    pr.[prd_id]
      --,pr.[prd_key]
      ,REPLACE(SUBSTRING(pr.[prd_key], 1, 5),'-', '_') AS [cat_id]
      ,SUBSTRING(pr.[prd_key], 7, LEN(pr.prd_key)) AS [prd_key]
      ,pr.[prd_nm]
      ,ISNULL(pr.[prd_cost], 0) AS [prd_cost]
      --,pr.[prd_line]
      ,CASE UPPER(TRIM(pr.[prd_line])) -- Quick case for simple value mapping
          WHEN 'M' THEN 'Montain'
          WHEN 'R' THEN 'Road'
          WHEN 'S' THEN 'Other Sales'
          WHEN 'T' THEN 'Touring'
          ELSE 'n/a'
      END AS [prd_line]
      ,CAST(pr.[prd_start_dt] AS DATE) AS [prd_start_dt]
      --,pr.[prd_end_dt]
      --This code help us to get the next record into a column this will replace the original end data timestamp
      ,CAST(LEAD(pr.prd_start_dt) OVER (PARTITION BY pr.[prd_key] ORDER BY pr.[prd_start_dt]) - 1 AS DATE) AS next_prd_start_dt
  FROM [DataWaharehouse].[bronze].[crm_prd_info] AS pr
  --WHERE pr.[prd_key] = 'CO-RF-FR-R92R-48'
