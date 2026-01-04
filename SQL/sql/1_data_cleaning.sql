-- Data Load
SELECT *
FROM data

-- Preprocessing

-- 결측치 처리


DELETE FROM data
WHERE CustomerID IS NULL OR Description IS NULL


-- 중복값 처리

CREATE OR REPLACE TABLE data AS
SELECT DISTINCT *
FROM data 

-- 오류값 처리
S

