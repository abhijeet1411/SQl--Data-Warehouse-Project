/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

USE DataWareHouse;
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    DECLARE @startTime DATETIME = GETDATE(), @endTime DATETIME;

    BEGIN TRY
        PRINT '===============================';
        PRINT 'Loading Bronze Layer Tables';
        PRINT '===============================';
        PRINT '';

        PRINT'-------------------------------';
        PRINT 'loading CRM tables';
        PRINT'-------------------------------';

        SET @startTime = GETDATE();
        PRINT '>>Truncating Table : bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>>Loading Table : bronze.crm_cust_info';
        
        BULK INSERT bronze.crm_cust_info
        FROM '/var/opt/mssql/data/cust_info.csv'
        WITH (
            firstrow = 2,           -- Skips the header row in the CSV file
            FIELDTERMINATOR = ',',
            tablock                 -- Acquires a table-level lock to optimize bulk load performance and minimize transaction logging
        );
        SET @endTime = GETDATE();
        PRINT '>>Time taken to load bronze.crm_cust_info is ' 
        + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';

        SET @startTime = GETDATE();
        PRINT '';
        PRINT 'Truncating Table : bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '>>Loading Table : bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/var/opt/mssql/data/prd_info.csv'
        WITH (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @endTime = GETDATE();
        PRINT '>>Time taken to load bronze.crm_prd_info is ' 
        + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';

        SET @startTime = GETDATE();
        PRINT '';
        PRINT 'Truncating Table : bronze.crm_sales_info';
        TRUNCATE TABLE bronze.crm_sales_info;
        PRINT '>>Loading Table : bronze.crm_sales_info';
        BULK INSERT bronze.crm_sales_info
        FROM '/var/opt/mssql/data/sales_details.csv'
        WITH (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @endTime = GETDATE();
        PRINT '>>Time taken to load bronze.crm_sales_info is ' 
        + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';

        PRINT '';
        PRINT '-------------------------------';
        PRINT 'loading ERP tables';
        PRINT '-------------------------------';

        SET @startTime = GETDATE();
        PRINT '>>Truncating Table : bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '>>Loading Table : bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM '/var/opt/mssql/data/LOC_A101.csv'
        WITH (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @endTime = GETDATE();
        PRINT '>>Time taken to load bronze.erp_loc_a101 is ' 
        + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';

        SET @startTime = GETDATE();
        PRINT '';
        PRINT '>>Truncating Table : bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '>>Loading Table : bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM '/var/opt/mssql/data/CUST_AZ12.csv'
        WITH (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @endTime = GETDATE();
        PRINT '>>Time taken to load bronze.erp_cust_az12 is ' 
        + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';

        SET @startTime = GETDATE();
        PRINT '';
        PRINT '>>Truncating Table : bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '>>Loading Table : bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/var/opt/mssql/data/PX_CAT_G1V2.csv'
        WITH (
            firstrow = 2,
            FIELDTERMINATOR = ',',
            tablock
        );
        SET @endTime = GETDATE();
        PRINT '>>Time taken to load bronze.erp_px_cat_g1v2 is ' 
        + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';

    END TRY
    BEGIN CATCH
        -- Captures and outputs standardized system error details before halting execution
        PRINT '===============================';
        PRINT 'Error occurred while loading Bronze Layer Tables';
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Procedure: ' + ISNULL(ERROR_PROCEDURE(), 'N/A');
        PRINT '===============================';
        THROW; -- Rethrows the error to the calling application ensuring the job reports a failure status
    END CATCH
END
