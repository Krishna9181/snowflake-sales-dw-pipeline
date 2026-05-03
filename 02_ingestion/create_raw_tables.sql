-- ============================================================
-- Phase 2: Data Ingestion — Raw Tables, Stages, File Formats
-- ============================================================

-- File Formats
CREATE OR REPLACE FILE FORMAT SALES_DW.RAW.CSV_FORMAT
  TYPE = CSV SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"' NULL_IF = ('NULL', 'null', '');

CREATE OR REPLACE FILE FORMAT SALES_DW.RAW.JSON_FORMAT
  TYPE = JSON STRIP_OUTER_ARRAY = TRUE NULL_IF = ('NULL', 'null', '');

-- Internal Stage
CREATE OR REPLACE STAGE SALES_DW.RAW.RAW_DATA_STAGE
  FILE_FORMAT = SALES_DW.RAW.CSV_FORMAT
  COMMENT = 'Landing zone for raw data files';

-- Raw Tables
CREATE OR REPLACE TABLE SALES_DW.RAW.RAW_CUSTOMERS (
    CUSTOMER_ID NUMBER,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    SEGMENT VARCHAR,
    COUNTRY VARCHAR,
    CREATED_AT DATE,
    _LOADED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SALES_DW.RAW.RAW_PRODUCTS (
    PRODUCT_ID NUMBER,
    PRODUCT_NAME VARCHAR,
    CATEGORY VARCHAR,
    BRAND VARCHAR,
    PRICE NUMBER(10,2),
    CREATED_AT DATE,
    _LOADED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SALES_DW.RAW.RAW_ORDERS (
    ORDER_ID NUMBER,
    CUSTOMER_ID NUMBER,
    ORDER_DATE DATE,
    STATUS VARCHAR,
    TOTAL_AMOUNT NUMBER(12,2),
    _LOADED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SALES_DW.RAW.RAW_ORDER_ITEMS (
    ITEM_ID NUMBER,
    ORDER_ID NUMBER,
    PRODUCT_ID NUMBER,
    QUANTITY NUMBER,
    UNIT_PRICE NUMBER(10,2),
    _LOADED_AT TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- Sample Data: Customers
INSERT INTO SALES_DW.RAW.RAW_CUSTOMERS (CUSTOMER_ID, CUSTOMER_NAME, EMAIL, SEGMENT, COUNTRY, CREATED_AT) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'Premium', 'USA', '2024-01-10'),
(2, 'Bob Smith', 'bob@example.com', 'Standard', 'Canada', '2024-01-12'),
(3, 'Carlos Rivera', 'carlos@example.com', 'Premium', 'Mexico', '2024-01-15'),
(4, 'Diana Chen', 'diana@example.com', 'Enterprise', 'USA', '2024-01-20'),
(5, 'Emma Wilson', 'emma@example.com', 'Standard', 'UK', '2024-02-01'),
(6, 'Frank Mueller', 'frank@example.com', 'Premium', 'Germany', '2024-02-05'),
(7, 'Grace Kim', 'grace@example.com', 'Enterprise', 'South Korea', '2024-02-10'),
(8, 'Hassan Ali', 'hassan@example.com', 'Standard', 'UAE', '2024-02-15'),
(9, 'Isabella Rossi', 'isabella@example.com', 'Premium', 'Italy', '2024-03-01'),
(10, 'James Brown', 'james@example.com', 'Standard', 'Australia', '2024-03-05'),
(11, 'Keiko Tanaka', 'keiko@example.com', 'Enterprise', 'Japan', '2024-03-10'),
(12, 'Liam O''Brien', 'liam@example.com', 'Premium', 'Ireland', '2024-03-15'),
(13, 'Maria Santos', 'maria@example.com', 'Standard', 'Brazil', '2024-04-01'),
(14, 'Nathan Park', 'nathan@example.com', 'Premium', 'USA', '2024-04-10'),
(15, 'Olivia Laurent', 'olivia@example.com', 'Enterprise', 'France', '2024-04-15'),
(16, 'Priya Sharma', 'priya@example.com', 'Standard', 'India', '2024-04-20'),
(17, 'Quinn Davis', 'quinn@example.com', 'Premium', 'USA', '2024-05-01'),
(18, 'Raj Patel', 'raj@example.com', 'Enterprise', 'India', '2024-05-05'),
(19, 'Sofia Martinez', 'sofia@example.com', 'Standard', 'Spain', '2024-05-10'),
(20, 'Tom Anderson', 'tom@example.com', 'Premium', 'Canada', '2024-05-15');

-- Sample Data: Products
INSERT INTO SALES_DW.RAW.RAW_PRODUCTS (PRODUCT_ID, PRODUCT_NAME, CATEGORY, BRAND, PRICE, CREATED_AT) VALUES
(1, 'Wireless Headphones', 'Electronics', 'SoundMax', 79.99, '2024-01-15'),
(2, 'Running Shoes', 'Footwear', 'SpeedFit', 129.99, '2024-01-20'),
(3, 'Coffee Maker', 'Kitchen', 'BrewPro', 49.99, '2024-02-01'),
(4, 'Yoga Mat', 'Fitness', 'FlexForm', 29.99, '2024-02-10'),
(5, 'Laptop Stand', 'Office', 'ErgoDesk', 45.99, '2024-02-15'),
(6, 'Bluetooth Speaker', 'Electronics', 'SoundMax', 59.99, '2024-03-01'),
(7, 'Trail Boots', 'Footwear', 'SpeedFit', 159.99, '2024-03-05'),
(8, 'Blender', 'Kitchen', 'BrewPro', 39.99, '2024-03-10'),
(9, 'Dumbbells Set', 'Fitness', 'FlexForm', 89.99, '2024-03-15'),
(10, 'Monitor Arm', 'Office', 'ErgoDesk', 69.99, '2024-03-20'),
(11, 'Noise Cancelling Earbuds', 'Electronics', 'SoundMax', 119.99, '2024-04-01'),
(12, 'Hiking Sandals', 'Footwear', 'SpeedFit', 74.99, '2024-04-10'),
(13, 'Electric Kettle', 'Kitchen', 'BrewPro', 34.99, '2024-04-15'),
(14, 'Resistance Bands', 'Fitness', 'FlexForm', 19.99, '2024-04-20'),
(15, 'Webcam HD', 'Office', 'ErgoDesk', 54.99, '2024-05-01');

-- Sample Data: Orders
INSERT INTO SALES_DW.RAW.RAW_ORDERS (ORDER_ID, CUSTOMER_ID, ORDER_DATE, STATUS, TOTAL_AMOUNT) VALUES
(1001, 1, '2024-02-01', 'COMPLETED', 209.97),
(1002, 2, '2024-02-03', 'COMPLETED', 129.99),
(1003, 3, '2024-02-05', 'COMPLETED', 79.99),
(1004, 4, '2024-02-10', 'COMPLETED', 315.96),
(1005, 5, '2024-02-15', 'COMPLETED', 49.99),
(1006, 1, '2024-03-01', 'COMPLETED', 159.98),
(1007, 6, '2024-03-05', 'COMPLETED', 89.99),
(1008, 7, '2024-03-10', 'COMPLETED', 249.97),
(1009, 3, '2024-03-15', 'COMPLETED', 69.99),
(1010, 8, '2024-03-20', 'SHIPPED', 174.98),
(1011, 9, '2024-04-01', 'COMPLETED', 119.99),
(1012, 10, '2024-04-05', 'COMPLETED', 54.99),
(1013, 2, '2024-04-10', 'COMPLETED', 234.97),
(1014, 11, '2024-04-15', 'SHIPPED', 189.98),
(1015, 4, '2024-04-20', 'COMPLETED', 79.99),
(1016, 12, '2024-05-01', 'PENDING', 159.99),
(1017, 13, '2024-05-05', 'COMPLETED', 49.98),
(1018, 14, '2024-05-10', 'SHIPPED', 199.98),
(1019, 5, '2024-05-15', 'PENDING', 89.99),
(1020, 15, '2024-05-20', 'COMPLETED', 124.98),
(1021, 16, '2024-06-01', 'COMPLETED', 79.99),
(1022, 1, '2024-06-05', 'SHIPPED', 259.97),
(1023, 17, '2024-06-10', 'PENDING', 149.98),
(1024, 18, '2024-06-15', 'COMPLETED', 339.96),
(1025, 19, '2024-06-20', 'COMPLETED', 34.99);

-- Sample Data: Order Items
INSERT INTO SALES_DW.RAW.RAW_ORDER_ITEMS (ITEM_ID, ORDER_ID, PRODUCT_ID, QUANTITY, UNIT_PRICE) VALUES
(1, 1001, 1, 1, 79.99), (2, 1001, 2, 1, 129.99), (3, 1002, 2, 1, 129.99),
(4, 1003, 1, 1, 79.99), (5, 1004, 2, 2, 129.99), (6, 1004, 5, 1, 45.99),
(7, 1005, 3, 1, 49.99), (8, 1006, 6, 1, 59.99), (9, 1006, 4, 1, 29.99),
(10, 1006, 14, 1, 19.99), (11, 1007, 9, 1, 89.99), (12, 1008, 7, 1, 159.99),
(13, 1008, 9, 1, 89.99), (14, 1009, 10, 1, 69.99), (15, 1010, 11, 1, 119.99),
(16, 1010, 15, 1, 54.99), (17, 1011, 11, 1, 119.99), (18, 1012, 15, 1, 54.99),
(19, 1013, 7, 1, 159.99), (20, 1013, 12, 1, 74.99), (21, 1014, 9, 1, 89.99),
(22, 1014, 4, 2, 29.99), (23, 1014, 14, 1, 19.99), (24, 1015, 1, 1, 79.99),
(25, 1016, 7, 1, 159.99), (26, 1017, 4, 1, 29.99), (27, 1017, 14, 1, 19.99),
(28, 1018, 2, 1, 129.99), (29, 1018, 10, 1, 69.99), (30, 1019, 9, 1, 89.99),
(31, 1020, 5, 1, 45.99), (32, 1020, 1, 1, 79.99), (33, 1021, 1, 1, 79.99),
(34, 1022, 11, 1, 119.99), (35, 1022, 2, 1, 129.99), (36, 1023, 6, 1, 59.99),
(37, 1023, 9, 1, 89.99), (38, 1024, 7, 2, 159.99), (39, 1024, 14, 1, 19.99),
(40, 1025, 13, 1, 34.99);
