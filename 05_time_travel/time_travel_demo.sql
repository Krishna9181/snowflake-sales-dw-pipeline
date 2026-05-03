-- ============================================================
-- Phase 5: Time Travel & Zero-Copy Cloning
-- ============================================================

-- Time Travel: Query data at a specific point in time
-- SELECT * FROM table AT(TIMESTAMP => 'YYYY-MM-DD HH:MI:SS'::TIMESTAMP_NTZ);
-- SELECT * FROM table AT(OFFSET => -300);  -- 300 seconds ago
-- SELECT * FROM table BEFORE(STATEMENT => '<query_id>');

-- Example: Recover accidentally deleted data
-- Step 1: Note the timestamp before delete
SELECT CURRENT_TIMESTAMP() AS BEFORE_DELETE;

-- Step 2: Delete some data (simulating accident)
-- DELETE FROM SALES_DW.RAW.RAW_CUSTOMERS WHERE SEGMENT = 'Premium';

-- Step 3: Query data before the delete
-- SELECT * FROM SALES_DW.RAW.RAW_CUSTOMERS AT(TIMESTAMP => '<timestamp>'::TIMESTAMP_NTZ);

-- Step 4: Restore the table to the pre-delete state
-- CREATE OR REPLACE TABLE SALES_DW.RAW.RAW_CUSTOMERS AS
-- SELECT * FROM SALES_DW.RAW.RAW_CUSTOMERS AT(TIMESTAMP => '<timestamp>'::TIMESTAMP_NTZ);

-- UNDROP: Restore dropped objects
-- DROP TABLE SALES_DW.DEV.TEST_TABLE;
-- UNDROP TABLE SALES_DW.DEV.TEST_TABLE;
-- Also works: UNDROP SCHEMA, UNDROP DATABASE

-- Zero-Copy Cloning: Instant copy with no extra storage
CREATE DATABASE SALES_DW_DEV CLONE SALES_DW
  COMMENT = 'Dev clone of SALES_DW - zero copy, instant';

-- Clone a single table
-- CREATE TABLE SALES_DW.DEV.CUSTOMERS_COPY CLONE SALES_DW.RAW.RAW_CUSTOMERS;

-- Clone at a point in time (Time Travel + Clone)
-- CREATE TABLE SALES_DW.DEV.CUSTOMERS_YESTERDAY
--   CLONE SALES_DW.RAW.RAW_CUSTOMERS AT(OFFSET => -86400);

-- Set data retention for Time Travel (Enterprise edition)
-- ALTER TABLE SALES_DW.RAW.RAW_CUSTOMERS SET DATA_RETENTION_TIME_IN_DAYS = 7;
