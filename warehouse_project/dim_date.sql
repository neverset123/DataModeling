IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 FIRST_ROW = 2,
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'udacity_udacity1_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [udacity_udacity1_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://udacity@udacity1.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE dbo.dim_date
WITH (
    LOCATION     = 'dim_date',
    DATA_SOURCE = [udacity_udacity1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT REPLACE(SUBSTRING(date, 0, CHARINDEX(' ',date,0)), '-', '') AS date_id,  YEAR(TRY_CONVERT(DATETIME, SUBSTRING(date, 1, LEN(date)-4), 120)) AS year, DATEPART(QUARTER, TRY_CONVERT(DATETIME, SUBSTRING(date, 1, LEN(date)-4), 120)) AS quarter, MONTH(TRY_CONVERT(DATETIME, SUBSTRING(date, 1, LEN(date)-4), 120)) AS month, DAY(TRY_CONVERT(DATETIME, SUBSTRING(date, 1, LEN(date)-4), 120)) AS day, DATEPART(dw, TRY_CONVERT(DATETIME, SUBSTRING(date, 1, LEN(date)-4), 120)) AS weekday
FROM [dbo].[staging_payment]
UNION
SELECT REPLACE(SUBSTRING(start_at, 0, CHARINDEX(' ',start_at,0)), '-', '') AS date_id, YEAR(TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120)) AS year, DATEPART(QUARTER, TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120)) AS quarter, MONTH(TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120)) AS month, DAY(TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120)) AS day, DATEPART(dw, TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120)) AS weekday
FROM [dbo].[staging_trip]
UNION
SELECT REPLACE(SUBSTRING(ended_at, 0, CHARINDEX(' ',ended_at,0)), '-', '') AS date_id, YEAR(TRY_CONVERT(DATETIME, SUBSTRING(ended_at, 1, LEN(ended_at)-4), 120)) AS year, DATEPART(QUARTER, TRY_CONVERT(DATETIME, SUBSTRING(ended_at, 1, LEN(ended_at)-4), 120)) AS quarter, MONTH(TRY_CONVERT(DATETIME, SUBSTRING(ended_at, 1, LEN(ended_at)-4), 120)) AS month, DAY(TRY_CONVERT(DATETIME, SUBSTRING(ended_at, 1, LEN(ended_at)-4), 120)) AS day, DATEPART(dw, TRY_CONVERT(DATETIME, SUBSTRING(ended_at, 1, LEN(ended_at)-4), 120)) AS weekday
FROM [dbo].[staging_trip];
GO

SELECT TOP 100 * FROM dbo.dim_date
GO