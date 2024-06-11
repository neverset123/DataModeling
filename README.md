## SQL database
database is a collection of tables, each table represents one entity type.

advantages:
- ease of use SQL
- ability to do joins
- ability to do aggregations and analytics
- smaller data volumes
- easier to change business requirements
- flexibility for query
- modeling the data not modeling queries
- secondary indexes available
- ACID Transactions(data integrity)

disadvantages:
- not able to handle large amount of data: only scale vertically by adding more storage
- not able to store different data type after schema definition
- ACID reduces throughtput due to check operations
- flexible schema is not supported (schemaless design not supported)
- availability is limited (not distributed)
- no horizontal scaling 


### ACID
Properties of database transactions intended to guarantee validity even in the event of errors or power failures.
- Atomicity
The whole transaction is processed or nothing is processed
- Consistency
Only transactions that abide by constraints and rules are written into the database, otherwise the database keeps the previous state.
- Isolation
Transactions are processed independently and securely, order does not matter.
- Durability
Completed transactions are saved to database even in cases of system failure


### OLAP(Online Analytical Processing) & OLTP(Online Transactional Processing)
one database for all would lead to 

    - excellent for operation
    - no redundancy, high integrity
    - slow for analytics
    - hard to understand
#### OLAP
optimized for these workloads allow for complex analytical and ad hoc queries, including aggregations. These type of databases are optimized for reads.

#### OLTP
optimized for these workloads allow for less complex queries in large volume. The types of queries for these databases are read, insert, update, and delete.

### Normalizaiton & Denormalization
1) Normalization: increase data integrity by reducing data redundancy
2) Denormalizaiton: increase performance by reducing number of joins 

#### normalization
- 1NF
    - Atomic values: each cell contains unique and single values
    - Be able to add data without altering tables(adding or removing columns)
    - Separate different relations into different tables
    - Keep relationships between tables together with foreign keys
- 2NF
    - Have reached 1NF
    - All columns in the table must rely on the Primary Key(so that data can be joined)
- 3NF
    - Must be in 2nd Normal Form
    - No transitive dependencies(non-key column does not depend on another non-key column)
    - Remember, transitive dependencies you are trying to maintain is that to get from A-> C, you want to avoid going through B.

#### denormalization
denormalization comes after normalization.

### Fact & Dimension Table

#### Fact Table(Numeric & Additive)
Fact table records business events in quantifiable metrics.

#### Dimension Table
records context of business events (who, what, where, why etc.), it contains descriptive attributes.

### Schema Struct
- Star Schema
 consists of one or more fact tables referencing any number of dimension tables.
 advantages:
    - denormalized
    - simplifies queries by relaxation of 3nf rules
    - fast aggregations (less joins)
drawbacks:
    - data Integrity issue
    - decrease query flexibility(no ad-hoc query)
    - many to many relationship is a simplification

- snowflake Schema
    - Star Schema is a special, simplified case of the snowflake schema.
    - Star schema does not allow for many to many relationships between dimension tables while the snowflake schema does.
    - Snowflake schema is more normalized than Star schema but only in 1NF or 2NF


### Postgres
1) autocommit
each action  is commited without having to cann conn.commit() after each command
```
conn.set_session(autocommit=True)
```
2) psycopg2
python wrapper to operate on postgres
3) postgres does not support IF NOT EXISTS in CREATE DATABASE
4) string type in table: char(n), varchar(n), text

## NoSQL database
advantages:
- support large amounts of data
- horizonal scalability
- high throughput
- flexible schema
- high availability
- able to store different data type formats
- low latency for distributed users

disadvantages:
- not ACID compliance
- JOINS is not allowed(as it results in full table scan)
- aggregations and analytics are not efficient or allowed
- Ad-hoc queries are possible but difficult(as data model was done to fix particular queries)
- flexible queries are not supported
- overhead for small dataset

### CAP theorem 
a database can actually only guarantee two out of the three in CAP
- Consistency: every read from database gets the latest piece of data or an error(differt from ACID consistency)
- Availability
- partition Tolerance


### types of implementation
some NoSQL databases that offer some form of ACID transaction, such as MongoDB
- Apache Cassandra (Partition Row store)
- MongoDB (Document store)
- DynamoDB (Key-Value store)
- Apache HBase (Wide Column Store)
- Neo4J (Graph Database)

### Cassandra
open source NoSQL DB, marsterless architecture, linear scalable. it support AP of CAP.
Since Apache Cassandra requires data modeling based on the query you want, you can't do ad-hoc queries.
1) Keyspace
same as database
2) PRIMARY KEY
primary key in Cassandra consists of two parts: the partition key and the clustering columns. The partition key determines which node stores the data. The clustering columns determine the order of the data inside the partition.
Primary key has to be unique, otherwise data will be overwritten!!
3) PARTITION KEY

4) CLUSTERING COLUMNS
- clustering columns sort data in ascending order
- none or more than one clusering columns can be used
- using CLUSTERING COLUMNS in same order in SELECT as they were in WHERE clause
5) ALLOW FILTERING
support query without specifying all the primary keys, but it is not recommended 
6) all placeholder should be %s when using session.execute(even if the data type is int)
7) denormalizaiton is a must in Cassandra, as there is no JOINs in Cassandra
8) one table per query

#### CQL
JOIN, GROUP BY, Subquery are not supported.

## data warehouse
data warehouse is OLAP system, a copy of transaction data specifically structured for query and analysis.
data struct for data warehouse
    - dimensional model
    could be different from traditional dimension table. Star schema is a good option for OLAP, not OLTP(too many joins), it is easier to understand than 3NF Schema.

tips for ipython-sql in jupyter
-%load-ext sql
- %sql
one line sql query, can access python var using $
- %%sql
multi-line sql query, can not access python var using $

```
#connect to database
%sql postgresql://student:student@127.0.0.1:5432/pagila
``` 

### Architecture

#### Kimball's Bus Architecture
![](docs/Kimball_bus.png)
- conformed dimensions
- atomic and summary data
- dimensional

#### Independent data marts
![](docs/Data_marts.png)
- independent ETL processes and dimensional models
- seperate and small dimensional models
- different fact tables for same events
- inconsistent views
- generally discouraged

#### Inmon's Cooperative Information Factory(CIF)
![](docs/CIF.PNG)
- two ETL Processes: ETL Process for the Data Warehouse, ETL Process for the Data Marts
- 3NF Database accessable by end-user
- data marts are dimnesionally modeled and mostly aggregated

#### Hybrid Kimball Bus & Inmon CIF
![](docs/Hybrid.png)
- Removes Data Marts
- Exposes the enterprise data warehouse


### OLAP Cubes
an aggregation of a fact metric on a number of dimensions. the OLAP cubes should store the finest grain of data.
using **grouping sets ()** or **cube()** could optimize query with only one pass through facts tables instead of multi.

1) MOLAP
Pre-aggregate the OLAP cubes and saves them on a special purpose non-relational database.

2) ROLAP
compute the OLAP cubes on the fly from existing relational databases where dimensional model resides. 

#### Operations
1) Rollup
Roll-up: Sum up the sales of each city by Country: e.g. US, France (less columns in branch dimension)

2) Drill-down
Drill-Down: Decompose the sales of each city into smaller districts (more columns in branch dimension)

3) Slice
Slice: Reducing N dimensions to N-1 dimensions by restricting **one** dimension to a single value

4) Dice
Dice: computing a sub-cube by restricting **multi** dimensions


### Cloud Data Warehouse
#### Database
1. SQL
managed databases: the user doesn't have to manage the hardware resources to gain optimal performance.
1) Microsoft Azure
Azure SQL Database (MS SQL Server)
Azure Database for MySQL
Azure Database for MariaDB
Azure Database for PostgreSQL
2) GCP
Cloud SQL (MySQL, PostgreSQL, and MS SQL Server)
3) AWS
Amazon RDS (MySQL, PostgreSQL, MariaDB, Oracle, MS SQL Server)

2. NoSQL
1) Azure - CosmosDB
Gremlin - graph database
MongoDB - document
Cassandra - column oriented
2) GCP
Big Table - column oriented
Firestore - document
MongoDB Atlas - document
3) AWS
DynamoDB - Key value
DocumentDB - document
Keyspaces = column oriented
Neptune - graph
Time stream - time series

#### ETL & ELT

ETL: happens on an intermediate server
ELT: load large amounts of data quickly, especially for streaming data. happens on the destination server

Available ETL/ELT tools:

- Azure Data Factory
- AWS Glue
- GCP Dataflow

Data ingestion tools:

- Azure - Streaming Analytics
- AWS - Kinesis
- GCP - Dataflow

data warehouse tools
- Azure Synapse
- Amazon Redshift
- GCP Big Query

### Azure Data Warehouse
advantages over other cloud providers:
- Integration with Azure Ecosystem
- On-Demand scaling of compute power
- Ingest data from a wide variety of sources

Architecture

1) based on azure synapse for comprehensive integrated data warehousing and analytics
![](docs/Azure_data_warehouse.PNG)
this architecture design can be  automated with Azure Data Factory, creating data integrations and data flows for multiple services.
2) Azure databricks for analytics built on Apache Spark
![](docs/Azure_data_warehouse_databricks.PNG)
databricks utilizes Spark to create ETL pipelines, is more suitable for lake house architecture.

SQL Pool

- Azure Dedicated SQL Pools
designed for large-scale, enterprise-level data warehousing workloads. It uses a provisioned resources model, where you allocate a certain amount of resources to your SQL pool and pay for those resources whether you're using them or not. It uses Massively Parallel Processing (MPP) architecture to quickly run complex queries across large amounts of data.
- Azure Synapse Analytics Serverless SQL Pools
This is designed for on-demand and exploratory analysis. You only pay for the queries that you run based on the amount of data processed. It's ideal for scenarios where you have unpredictable or bursty workloads, or when you're exploring data before deciding to move it to a dedicated SQL pool. It uses a shared resources model, which can be more cost-effective if your workload is intermittent or low-volume.

Ingesting Data into Azure Synapse:
![](docs/Ingestion.PNG)

- Creating linked services
    - a linked service contains connection information to other services
- Creating a pipeline
    - A pipeline contains the logical flow for an execution of a set of activities
- Using a trigger or a one-time data ingestion
    -  manually start a data ingestion or schedule a trigger

#### ETL / ELT Pipelines (utilizing SQL)
**Azure Polybase**: using TSQL to query blob storage in support of ELT scenarios
![](docs/ELT_pipeline.PNG)
steps: 
- Extract: Data ingestion into Blob Storage or Azure Data Lake Gen 2
- Load: Create EXTERNAL staging tables in the Data Warehouse
    - Azure Synapse cannot convert string to datetime!!
- Transform: Transform data from staging tables to DW tables

## Data Lake
- Data warehouses are based on specific and explicit data structures that allow for highly performant business intelligence and analytics but they do not perform well with unstructured data.

- Data lakes are capable of ingesting massive amounts of both structured and unstructured data with Hadoop and Spark providing processing on top of these datasets. Data lakes are unable to support transactions and perform poorly with changing datasets. Data governance became difficult due to the unstructured nature of these systems.
    - Lower costs associated with using big data tools for ETL / ELT operations.
    - Data lakes provide schema-on-read rather than schema-on-write which lowers the cost and work of ingesting large amounts of data.
    - Data lakes provide support for structured, semi-structured, and unstructured data.
- Modern lakehouse architectures combine the strengths of data warehouses and data lakes into a single, powerful architecture, which provide the ability to quickly ingest large amounts of data and then incrementally improve the quality of the data.
    - a metadata and data governance layer on top of the data lake

![](docs/datalake.PNG)

Personally Identifiable Information (PII) refers to any data that could potentially identify a specific individual. This can be any information that can be used on its own or with other information to identify, contact, or locate a single person, or to identify an individual in context. 

### storage
Azure Data Lake Gen 2 ( has been integrated into blob storage with hierarchical namespace)
- Incorporates and extends Azure Blob Storage.
- Hierarchical namespaces to enable the better organization of information
- The entire structure is accessible using Hadoop compatible APIs.

Delta Lake
![](docs/delta_lake.PNG)
Delta Lake is an open-source storage layer that brings ACID (Atomicity, Consistency, Isolation, Durability) transactions to Apache Spark and big data workloads. It's designed to provide reliability to both batch and streaming data processing, handling scenarios such as schema enforcement and evolution, and data consistency.
- Parquet data files as partitions
- Json files as transaction log (provide ACID transactions and isolation to spark)
- Checkpoint file
Caching features of delta
- Delta Cache
- Result Cache

stages for data processing:
- Bronze Stage: ingesting raw into ingestion table
- Silver Stage: data are refined and combined
- Gold Stage: creation of features and aggregates such as star schema's fact and dimension tables.
### hadoop
![](docs/data_lake.PNG)

hadoop is an ecosystem of tools for big data storage and data analysis, consists of Hadoop Distributed File System(HDFS) and MapReduce (in general means of hadoop). 
- The major difference between Spark and Hadoop is how they use memory. Hadoop writes intermediate results to disk whereas Spark tries to keep data in memory whenever possible. This makes Spark faster for many use cases.
- The Hadoop ecosystem includes a distributed file storage system called HDFS (Hadoop Distributed File System). Spark does not include a file storage system. You can use Spark on top of HDFS but you do not have to. Spark can read in data from other sources as well.

Apache Pig: a SQL-like language that runs on top of Hadoop MapReduce
Apache Hive: another SQL-like interface that runs on top of Hadoop MapReduce

HDFS splits files into 64 or 128 megabyte blocks and replicates these blocks across the cluster.

#### MapReduce
MapReduce is a programming technique for manipulating large data sets. "Hadoop MapReduce" is a specific implementation of this programming technique.

- first dividing up a large dataset and distributing the data across a cluster. 
- In the map step, each data is analyzed and converted into a (key, value) pair. Then these key-value pairs are shuffled across the cluster so that all keys are on the same machine. 
- In the reduce step, the values with the same keys are combined together.

#### Spark
- The master node is responsible for orchestrating the tasks across the cluster
- Workers are performing the actual computations

weakness:
- Spark Streaming’s latency is at least 500 milliseconds since it operates on micro-batches of records.
- Spark only supports ML algorithms that scale linearly with the input data size

1) pure function
functions that preserve their inputs and avoid side effects, these are called pure functions.
Spark function makes a copy of its input data and never changes the original parent data.

2) lazy evaluation
Before Spark does anything with the data in your program, it first built Directed Acyclic Graph (DAG) of what functions and data it will need.

3) map
Maps simply make a copy of the original input data, and transform that copy according to whatever function you put inside the map.

4) programming
- Imperative programming-->how
- Ceclarative programming-->what

5) shuffle (different from ML shuffle)
Shuffling is the process of redistributing data across partitions that may cause data to be moved across the network and between executors. This is often a costly operation and can have a significant impact on performance. Shuffling can occur during operations like join, groupByKey, reduceByKey, repartition.

##### spark debugging and optimization
Spark makes a copy of the input data every time you call a function. So, the original debugging variables that you created won't actually get loaded into the worker nodes. Instead, each worker has their own copy of these variables, and only these copies get modified.
1) Accumulator can be used to help tracking errors.
2) Broadcast variable is a read-only variable to all worker nodes for use in one or more operations,  used to save the cost of shipping a large read-only lookup table to every node. 

##### Transformations and Actions

##### Data Skew
solution: partition the data to change workload on worker node.
- Assign a new, temporary partition key(new column or composite key)
- Repartition by number of Spark workers
df.repartition(number_of_workers)

#### Databricks
1) Azure Databricks is used to prepare, train, process, and transform data for use in Azure Synapse Analytics or Microsoft Power BI.
![](docs/databricks.PNG)

2) Databricks provides data flows and processing, and preparing data for machine learning solutions.
![](docs/databricks1.PNG)

## Data Pipeline
data-driven workflow that orchestrates activities(data movement, data transformation and control flow).

### Components
1) linked service
used to connect to external resources

2) Datasets
Representations of data structures within the data stores, which simply point to or reference the data you want to use in your activities as inputs or outputs.

3) Integration Runtimes(IR): It provides the bridge between the public network and private network on-premises. It's the compute infrastructure used by Azure Data Factory to provide data integration capabilities across different network environments
- Azure IR: Perform data flows, data movement between cloud data stores. can also be used to dispatch activities to external compute such as Databricks, .NET activity, SQL Server Stored Procedure etc. that are in public network or using private network link. Azure IR is fully managed, serverless compute.
- Self-hosted IR (SHIR): used to perform data movement between a cloud data stores and a data store in private network. can also be used to dispatch activities to external computes on-premises or Azure Virtual Network. These computes include HDInsight Hive, SQL Server Stored Procedure activity etc.
- Azure-SSIS IR: used to lift and shift the existing SSIS packages to execute in Azure.
4) Triggers: Events that determine when a pipeline execution needs to happen
5) Parameters
- Pipeline Parameters: Define parameters inside the Pipelines and Data Flows and use inside the expressions activities from data extraction to sink
- Global parameters: can be utilized by all pipelines and can be passed to data flows. 
- System Variables: Azure Data Factory and Synapse Workspace provide System Variables, such as @pipeline().DataFactory, @pipeline().RunId, @trigger().startTime.
6) Control Flow: Control flow elements allow you to sequence activities in a pipeline and specify conditions for whether or not to execute certain activities
7) Data Flow: A graphical interface for data transformation activities. It allows you to develop graphical data transformation logic without writing scripts

### Tools
Azure Data Factory/Synapse Analytics
while both services can create pipelines for data movement and transformation, Azure Synapse Analytics also includes features for data warehousing and analytics.
Azure Data Factory supports cross-region Integration Runtimes but Synapse Analytics does not.

#### Mapping Data Flows
Mapping Data Flows in Azure Data Factory are visually-designed data transformations that allow you to build data transformation logic without writing code. They are part of the Data Flow feature in Azure Data Factory.
Expression Builder:a key tool within Mapping Data Flows to perform transformation logic.
activities: 
- Schema modifiers: manipulate the data to create new derived columns, aggregate data, pivoting the data.
- Row modifiers: filtering rows, sorting rows, altering row based on insert/update/delete/upsert policies.
- Multiple inputs/outputs: joins, unions, or splitting the data#

#### Power Query
Power Query is more user-friendly and designed for smaller scale transformations by business analysts. Power Query engine uses a scripting language called M.


### Data Management
#### Data Governance
the overall management of the availability, usability, integrity, and security of the data employed in an enterprise. It's a set of processes, roles, policies, standards, and metrics that ensure the effective and efficient use of information in enabling an organization to achieve its goals.
Azure Purview is a data governance service on Azure to discovery data quickly, classify data and as well as see the data lineage from source to destination. 
Optimize Dataflows
- Tuning Integration Runtime Live time to avoid spin off the cluster during concurrent jobs
- Partition data during transformation
- Enable Schema Drift in the Data Flows

Slowly Changing Dimensions types:

Type 0: Ignore any changes and keep only the original values
Type 1: Overwrite the existing values with new values
Type 2: Add a new row with the new values and add a new version column that identifies current and prior version.
Type 3: Add new columns for the new values. Like Current_Phone_Number and Original_Phone Number
Type 4: Maintain all the historical values in a new History table.
Type 5: This an extension of Type 4 where a mini-dimension table is created by maintaining the keys.
Type 6: This is a combination of Type 1, Type 2 and Type 3. This adds a new record for new values and also maintains a new column.

#### Data Quality
is about the state of your data(complete, timely and consistent)



