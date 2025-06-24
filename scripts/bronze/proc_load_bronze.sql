/*
 
=============================================================================================
Stored Procedure: Load Bronze Layer (Source = Bronze)
=============================================================================================

Script Purpose:

      This stored procedure loads data into the 'bronze' schema from external CSV files.
        It performs the following actions: 

        - Truncates the bronze tables before loading data. 
        - Uses the 'BULK INSER' comand to load data from csv files to bronze tables.

Parameters:

      None
    This stored procedure does not accept any parameters or return any values.

    Usage Example: 
    EXEC bronze.load_bronze;


*/


--Use this script to send the file to the docker container... 
--docker cp "FOLDER PATH" sqlserver:/var/opt/mssql/data/



CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    --Declaring the variables to get the duration of each step. 
    DECLARE @start_time DATETIME, @end_time DATETIME; 
    BEGIN TRY
        SET @start_time = GETDATE();
        PRINT '======================================================';
        PRINT 'Loading Bronze Layer...';
        PRINT '======================================================';

        PRINT '-------------------------------------------------------';
        PRINT 'Loading CRM Tables...';
        PRINT '-------------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info'; 
        
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info'; 

        BULK INSERT bronze.crm_cust_info 

        FROM '/var/opt/mssql/data/cust_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT( '-------------------------------------------------------');

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info 

        FROM '/var/opt/mssql/data/prd_info.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT( '-------------------------------------------------------');


        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';

        BULK INSERT bronze.crm_sales_details

        FROM '/var/opt/mssql/data/sales_details.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT( '-------------------------------------------------------');


        PRINT '-------------------------------------------------------';
        PRINT 'Loading ERP Tables...';
        PRINT '-------------------------------------------------------';
        PRINT '>> Truncating Table: bronze.erp_cust_az12';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

        BULK INSERT bronze.erp_cust_az12

        FROM '/var/opt/mssql/data/cust_az12.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az13';

        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/data/loc_a101.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/data/px_cat_g1v2.csv'
        WITH (
            FIELDTERMINATOR = ',',
            FIRSTROW = 2,
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>>Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '--------------------------------------------------------';

        SET @end_time = GETDATE();
        PRINT '======================================================';
        PRINT 'Bronze Layer Load Completed Successfully';
        PRINT 'Total Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '======================================================';

    END TRY
    BEGIN CATCH
        PRINT '======================================================';
        PRINT 'Error Occurred During Bronze Layer Load';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '======================================================';

    END CATCH
END
