-- Data Load
SELECT *
FROM data

SELECT COUNT(*)
FROM data

SELECT COUNT(InvoiceNO) AS COUNT_InvoiceNO,
       COUNT(StockCode) AS COUNT_StockCode,
       COUNT(Description) AS COUNT_Description,
       COUNT(Quantity) AS COUNT_Quantity,
       COUNT(InvoiceDate) AS COUNT_InvoiceDate,
       COUNT(UnitPrice) AS COUNT_UnitPrice,
       COUNT(CustomerID) AS COUNT_CustomerID,
       COUNT(Country) AS COUNT_Country
FROM data

SELECT column_name, ROUND((total - column_value) / total * 100, 2)
FROM
(
    SELECT 'InvoiceNo' AS column_name, COUNT(InvoiceNo) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'StockCode' AS column_name, COUNT(StockCode) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'Description' AS column_name, COUNT(Description) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'Quantity' AS column_name, COUNT(Quantity) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'InvoiceDate' AS column_name, COUNT(InvoiceDate) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'UnitPrice' AS column_name, COUNT(UnitPrice) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'CustomerID' AS column_name, COUNT(CustomerID) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data UNION ALL
    SELECT 'Country' AS column_name, COUNT(Country) AS column_value, COUNT(*) AS total FROM continual-nomad-479202-p8.test.data
) AS column_data;


-- Preprocessing

-- 결측치 처리
SELECT Description
FROM data
WHERE StockCode = '85123A'
GROUP BY Description

DELETE FROM data
WHERE CustomerID IS NULL OR Description IS NULL


-- 중복값 처리

-- 중복개수 확인
WITH temp AS(
SELECT *, COUNT(*) AS cnt_row
FROM data
GROUP BY InvoiceNO, StockCode, Description, QUantity, InvoiceDate, UnitPrice, CustomerID, Country
HAVING cnt_row > 1
)

SELECT COUNT(*) FROM temp

CREATE OR REPLACE TABLE data AS
SELECT DISTINCT *
FROM data 

-- 오류값 처리
SELECT COUNT(DISTINCT InvoiceNO) 
FROM data

SELECT DISTINCT InvoiceNO 
FROM data
LIMIT 100

SELECT *  
FROM data
WHERE InvoiceNO LIKE "C%"
LIMIT 100

SELECT ROUND(SUM(CASE WHEN InvoiceNO LIKE "C%" THEN 1 ELSE 0 END) / COUNT(*) * 100, 1) AS canceled_ratio
FROM data

SELECT COUNT(DISTINCT StockCode) 
FROM data

SELECT StockCode, COUNT(*) AS sell_cnt
FROM data
GROUP BY StockCode
ORDER BY sell_cnt DESC
LIMIT 10

SELECT DISTINCT StockCode, number_count
FROM (
  SELECT StockCode,
    LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
  FROM data
) 
WHERE number_count = 1 OR number_count = 0

SELECT StockCode, ROUND (COUNT(*) / (SELECT COUNT(*) FROM continual-nomad-479202-p8.test.data) * 100, 2) AS ratio
FROM data
GROUP BY StockCode
HAVING StockCode IN ('POST','D','C2','M','BANK CHARGES','PADS','DOT','CRUK')

DELETE FROM data
WHERE StockCode IN (
  SELECT DISTINCT StockCode
  FROM data
  WHERE StockCode IN ('POST', 'D', 'C2', 'M', 'BANK CHARGES', 'PADS', 'DOT', 'CRUK')
);

SELECT Description, COUNT(*) AS description_cnt
FROM data
GROUP BY Description
ORDER BY description_cnt DESC
LIMIT 30

DELETE FROM data
WHERE Description IN ('Next Day Carriage','High Resolution Image');

CREATE OR REPLACE TABLE data AS
SELECT 
  * EXCEPT (Description),
  UPPER(Description) AS Description
FROM data

SELECT MIN(UnitPrice) AS min_price, 
       MAX(UnitPrice) AS max_price,
       AVG(UnitPrice) AS avg_price
FROM data

SELECT COUNT(*) AS cnt_quantity,  
       MIN(Quantity) AS min_quantity, 
       MAX(Quantity) AS max_quantity, 
       AVG(Quantity) AS avg_quantity
FROM data
WHERE UnitPrice = 0

DELETE FROM data
WHERE UnitPrice = 0