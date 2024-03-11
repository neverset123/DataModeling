-- Use the same file format as used for creating the External Tables during the LOAD step.
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
    WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
           FORMAT_OPTIONS (
             FIELD_TERMINATOR = ',',
             USE_TYPE_DEFAULT = FALSE
            ))
GO

-- Use the same data source as used for creating the External Tables during the LOAD step.
-- Storage path where the result set will persist
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'mydlsfs20230413_mydls20230413_dfs_core_windows_net') 
    CREATE EXTERNAL DATA SOURCE [mydlsfs20230413_mydls20230413_dfs_core_windows_net] 
    WITH (
        LOCATION = 'abfss://mydlsfs20230413@mydls20230413.dfs.core.windows.net' 
    )
GO

CREATE EXTERNAL TABLE bike.fact_trip
WITH (
    LOCATION     = 'fact_trip',
    DATA_SOURCE = [mydlsfs20230413_mydls20230413_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [trip_id], [DATEDIFF(MINUTE, started_at, ended_at)], [rider_id], [start_station_id], [end_station_id], [date_id]
FROM [bike].[staging_trip];
GO

CREATE EXTERNAL TABLE bike.fact_payment
WITH (
    LOCATION     = 'fact_payment',
    DATA_SOURCE = [mydlsfs20230413_mydls20230413_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [payment_id], [amount], [rider_id], [rider_id], [date_id]
FROM [bike].[staging_payment];
GO

CREATE EXTERNAL TABLE bike.dim_rider
WITH (
    LOCATION     = 'dim_rider',
    DATA_SOURCE = [mydlsfs20230413_mydls20230413_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [rider_id], [first+last], [member], [DATEDIFF(YEAR, birthday, start_date)]
FROM [bike].[staging_rider];
GO

CREATE EXTERNAL TABLE bike.dim_station
WITH (
    LOCATION     = 'dim_station',
    DATA_SOURCE = [mydlsfs20230413_mydls20230413_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [station_id], [name]
FROM [bike].[staging_station];
GO

CREATE EXTERNAL TABLE bike.dim_date
WITH (
    LOCATION     = 'dim_date',
    DATA_SOURCE = [mydlsfs20230413_mydls20230413_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [date_id], [EXTRACT(YEAR FROM date)], [EXTRACT(QUARTER FROM date)], [EXTRACT(MONTH FROM date)], [EXTRACT(DAY FROM date)], [EXTRACT(WEEK FROM date)], [EXTRACT(HOUR FROM date)]
FROM [bike].[staging_payment];
GO

SELECT TOP 100 * FROM bike.fact_trip
GO
