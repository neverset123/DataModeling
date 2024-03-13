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

CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION     = 'fact_trip',
    DATA_SOURCE = [udacity_udacity1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [trip_id], DATEDIFF(MINUTE, TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120),  TRY_CONVERT(DATETIME, SUBSTRING(ended_at, 1, LEN(start_at)-4), 120)) AS trip_duration_min,  [dbo].[staging_trip].[rider_id], [start_station_id], [end_station_id], REPLACE(SUBSTRING(start_at, 0, CHARINDEX(' ',start_at,0)), '-', '') AS date_id, DATEDIFF(YEAR, birthday, TRY_CONVERT(DATETIME, SUBSTRING(start_at, 1, LEN(start_at)-4), 120)) AS age_at_trip
FROM [dbo].[staging_trip] LEFT JOIN [dbo].[staging_rider]  on [dbo].[staging_trip].rider_id = [dbo].[staging_rider].rider_id;
GO

SELECT TOP 100 * FROM dbo.fact_trip
GO