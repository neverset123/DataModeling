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

CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
    LOCATION     = 'dim_rider',
    DATA_SOURCE = [udacity_udacity1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [rider_id], [first]+[last] AS name, [is_member], DATEDIFF(YEAR, birthday,  TRY_CONVERT(DATETIME, SUBSTRING(account_start_date, 1, LEN(account_start_date)-4), 120)) AS age
FROM [dbo].[staging_rider];
GO


SELECT TOP 100 * FROM dbo.dim_rider
GO