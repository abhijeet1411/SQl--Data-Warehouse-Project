/* ==============================================================================
   OVERALL PURPOSE: 
   Defines the Data Definition Language (DDL) for the Bronze layer (raw ingestion) 
   of the data warehouse. It initializes the foundational tables required to stage 
   untampered data originating from two distinct source systems: CRM and ERP. 
   This script is designed to be idempotent (can be run multiple times safely).
============================================================================== */

-- Idempotent drop-and-create pattern ensures a clean slate for full data reloads
if object_id('bronze.crm_cust_info', 'U') is not null
drop table bronze.crm_cust_info;
GO
create table bronze.crm_cust_info(
    cust_id INT ,
    cst_key NVARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gender VARCHAR(10),
    cst_create_date DATETIME
);

if object_id('bronze.crm_prd_info', 'U') is not null
drop table bronze.crm_prd_info;
GO  
create table bronze.crm_prd_info
(
    prdt_id INT ,
    prdt_key NVARCHAR(50),
    prdt_name VARCHAR(50),
    prdt_cost int,
    prdt_line NVARCHAR(50),
    prdt_start_date DATETIME,
    prdt_end_date DATETIME
);
GO

if object_id('bronze.crm_sales_info', 'U') is not null
drop table bronze.crm_sales_info;
GO
create table bronze.crm_sales_info
(
    sls_ord_num NVARCHAR(50) ,
    sls_prdt_key NVARCHAR(50),
    sls_cust_id INT ,
    -- Dates are stored as integers (likely YYYYMMDD format) reflecting source system extraction format
    sls_order_date INT,
    sls_ship_date INT,
    sls_due_date INT,
    sls_sales int,
    sls_quantity int,
    sls_price int
);
GO

if object_id ('bronze.erp_loc_a101', 'U') is not null
drop table bronze.erp_loc_a101;
GO
create table bronze.erp_loc_a101(
    -- cid (Customer ID) serves as the integration key to link ERP data back to CRM customer records
    cid NVARCHAR(50),
    cntry NVARCHAR(50)
)
GO

if object_id('bronze.erp_cust_az12', 'U') is not null
drop table bronze.erp_cust_az12;
GO
create table bronze.erp_cust_az12(
    cid NVARCHAR(50),
    bdate DATETIME,
    gen NVARCHAR(10)
)
GO

if object_id('bronze.erp_px_cat_g1v2', 'U') is not null
drop table bronze.erp_px_cat_g1v2;
GO
create table bronze.erp_px_cat_g1v2(
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintenance NVARCHAR(50)
)
GO
