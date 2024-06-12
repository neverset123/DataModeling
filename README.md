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
one database for all: 

    - excellent for operation
    - no redundancy, high integrity
    - slow for analytics
    - hard to understand
#### OLAP
databases are optimized for reads;
optimized for complex analytical and ad hoc queries, including aggregations. 

#### OLTP
databases are optimized for read, insert, update, and delete;
optimized for less complex queries in large volume.

### Normalizaiton & Denormalization
1) Normalization: increase data integrity by reducing data redundancy
2) Denormalizaiton: increase performance by reducing number of joins 

#### normalization
redancency reduced from 1NF to 3NF.
- 1NF(Normal Form): atomicity of data
    - each cell contains unique and single value
    - each record (row) in a table is uniquely identifiable
    - all columns depend on the primary key
- 2NF: address partial dependencies
    - It is in 1NF
    - All non-key columns are **fully** functionally dependent on the entire primary key
- 3NF: ensure data integrity
    - It is in 2NF
    - There are no transitive dependencies. This means that non-key columns must not depend on other non-key columns. Each non-key column must be directly dependent on the primary key.

#### denormalization
Denormalization is a strategy used in database design to improve the read performance of a database. It involves adding redundant data to one or more tables, which can reduce the need for complex joins and other operations that can be expensive in terms of performance.

### Fact & Dimension Table

#### Fact Table(Numeric & Additive)
A fact table stores quantitative information for analysis and is often denormalized. It contains the measures, metrics or facts of a business process.

#### Dimension Table
A dimension table contains descriptive attributes (or fields) that are typically textual fields (or discrete numbers that behave like text). These attributes are used as search parameters to answer business questions(who, what, where, why etc.)

### Schema Struct
- Star Schema
 consists of one or more fact tables referencing any number of dimension tables. it is not normalized.
 advantages:
    - simplifies queries by relaxation of 3nf rules
    - fast aggregations (less joins)

 drawbacks:
    - data Integrity issue
    - not efficient for types of queries that involve complex joins across multiple dimension tables.
    - Complexity with Many-to-Many Relationships:These situations require a more complex design, such as a snowflake schema or a bridge table.

- Snowflake Schema
  the dimension tables are normalized, which means the data is organized to reduce redundancy, and this makes the schema more complex. This normalization     splits data into additional tables, hence the "snowflaked" appearance of the schema. Star Schema is a special, simplified case of the snowflake schema.
    - Allow for many to many relationships between dimension tables
    - More normalized than Star schema but only in 1NF or 2NF


### Postgres
1) autocommit
each action  is commited without having to add conn.commit() after each command
```
conn.set_session(autocommit=True)
```
2) psycopg2
python wrapper to operate on postgres
3) postgres does not support IF NOT EXISTS in CREATE DATABASE
4) string type in table: char(n), varchar(n), text

```
#connect to database
%sql postgresql://student:student@127.0.0.1:5432/pagila
``` 
## NoSQL database
advantages:
- Big Data: working with large amounts of data and particularly with unstructured data
- Horizonal Scalability: highly scalable and are designed to expand easily to handle more traffic and data by spreading out across more servers.
- Flexible Schema: store different types of data in each record, allowing for faster development.
- Low Latency for distributed users: faster data operations as they can handle large amounts of data and high load.

disadvantages:
- not ACID compliant
- JOINS is not allowed(as it results in full table scan)
- aggregations and analytics are not efficient or allowed
- Ad-hoc queries are possible but difficult(data model was done to fix particular queries)
- overhead for small dataset

### CAP 
a database can only guarantee two out of the three in CAP
- Consistency: every read from database gets the latest piece of data or an error(different from ACID consistency);all nodes in the system see the same data at the same time
- Availability: Every request to the database receives a response, without guarantee that it contains the most recent write.
- Partition Tolerance:  The system continues to function despite network partitions (breaks in the communication between nodes in the system).

### types of NoSQL
some NoSQL databases offer some form of ACID transaction, such as MongoDB.
- Apache Cassandra (Partition Row store)
- MongoDB (Document store)
- DynamoDB (Key-Value store)
- Apache HBase (Column-Oriented Store)
- Neo4J (Graph Database)

### Cassandra
open source, linear scalable, distributed, marsterless architecture, can't do ad-hoc queries(requires data modeling based on the query). support AP out of CAP.
It organizes data by rows and columns, but unlike a relational database, not all rows have to have the same columns. This makes it highly flexible and efficient for reading and writing data. It supports query without specifying all the primary keys, but it is not recommended 
1) Keyspace
same as database
2) PRIMARY KEY
primary key consists of two parts: partition key(determines which node stores the data) and clustering columns(determine the order of the data inside the partition).
Primary key has to be unique, otherwise data will be overwritten!!
   - PARTITION KEY
   - CLUSTERING COLUMNS
    - clustering columns sort data in ascending order
    - none or more than one clusering columns can be used
    - using CLUSTERING COLUMNS in same order in SELECT as they were in WHERE clause
6) Placeholder should be %s when using session.execute(even if the data type is int)
7) no JOINs in Cassandra(denormalizaiton is a must)
8) one table per query

#### CQL(Cassandra Query Language)
JOIN, GROUP BY, Subquery are not supported.

## Data Warehouse
data warehouse is OLAP system, a copy of transaction data specifically structured for query and analysis.
dimensional model could be different from traditional dimension table. Star schema is a good option for OLAP, not OLTP(too many joins).
Data warehouse can deal with specific data structures for highly performant analytics but they do not perform well with unstructured data.

```
tips for ipython-sql in jupyter
-%load-ext sql
- %sql
one line sql query, can access python var using $
- %%sql
multi-line sql query, can not access python var using $
```
### Architecture
#### Kimball's Bus Architecture
bottom-up approach where data marts are created first and then combined together to form a complete data warehouse.
two different levels of data granularity(atomic and summary data) stored in the data warehouse.
![](docs/Kimball_bus.png)
+ performance and flexibility: each data mart is alighed with a specific business process; the architecture allows for the development of one data mart at a time.
- Integration challenges adn complexity: Managing conformed dimensions across multiple data marts can be complex.

#### Independent data marts
small-scale, focused data warehouses that are developed independently for a specific business unit or team within an organization.
![](docs/Data_marts.png)
+ speed of development: independent ETL processes and dimensional model; seperate and small dimensional models
+ business alignment:  closely aligned with the needs of a specific business unit or team
- data consistency: different fact tables for same events; inconsistent views
- data redundency and scalability: generally discouraged

#### Inmon's Cooperative Information Factory(CIF)
top-down approach or the Inmon methodology: the first step is to build a central data warehouse that contains all of the organization's data; data marts are created for specific business functions or departments.
![](docs/CIF.PNG)
+ data consistency and comprehensive view: The central data warehouse provides a comprehensive view of the entire organization's data
+ scalability: new data marts can be added without affecting the existing structure.
- complexity: Building a central data warehouse can be a complex and time-consuming; ETL Process for the Data Warehouse, ETL Process for the Data Marts;
- flexibility: changes impact all the data marts.

#### Hybrid Kimball Bus & Inmon CIF
combines the strengths of both Kimball's Bus Architecture and Inmon's Cooperative Information Factory (CIF) to create a data warehousing solution that is both flexible and consistent.It exposes data warehouse to the enterprise. 
![](docs/Hybrid.png)
+ Data Consistency and Integration:: Central Data Warehouse
+ Conformed Dimensions: ensure that data is consistent and integrated across different data marts.
- Complex to implement and manage 

### OLAP Cubes
an aggregation of fact metrics on a number of dimensions. the OLAP cubes should store the finest grain of data.
using **grouping sets ()** or **cube()** could optimize query with only one pass through fact tables.

1) Multidimensional Online Analytical Processing(MOLAP):
indexes data through a multidimensional model, very strong for providing summarized and complex analysis.
MOLAP allows for faster data retrieval through optimized indexing and data storage, and pre-computation of summarized data and storing them on a special purpose **non-relational** database.

3) Relational Online Analytical Processing(ROLAP):
compute the OLAP cubes on the fly from existing **relational** databases where dimensional model resides, provide up-to-the-minute data analysis.
ROLAP tools tend to scale much better than MOLAP tools, and more flexible than MOLAP in handling changing data models.

#### Operations
1) Rollup
This operation performs aggregation on a data cube, either by climbing up a concept hierarchy for a dimension or by dimension reduction (less columns in branch dimension)

2) Drill-down
the reverse of the roll-up operation. It navigates from less detailed data to more detailed data (more columns in branch dimension)

3) Slice & Dice
Slice: Reducing N dimensions to N-1 dimensions by restricting **one** dimension to a single value
Dice: computing a sub-cube by restricting **multi** dimensions

4) Pivot (or rotate):
This operation is a visualization operation that rotates the data axes in view to provide a multi-dimensional view of data.

### Cloud Data Warehouse
#### Database
1. SQL
managed databases: the user doesn't have to manage the hardware resources to gain optimal performance.
1) Microsoft Azure
Azure SQL Database (MS SQL Server), Azure Database for MySQL, Azure Database for MariaDB, Azure Database for PostgreSQL
2) GCP
Cloud SQL (MySQL, PostgreSQL, and MS SQL Server)
3) AWS
Amazon RDS (MySQL, PostgreSQL, MariaDB, Oracle, MS SQL Server)

2. NoSQL
1) Azure - CosmosDB
Gremlin - graph database
MongoDB - document
Cassandra - column oriented
3) GCP
Big Table - column oriented
Firestore - document
MongoDB Atlas - document
4) AWS
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
- Allowing you to scale compute and storage independently
- Ingest data from a wide variety of sources

#### Architecture

1) based on azure synapse for comprehensive integrated data warehousing and analytics
![](docs/Azure_data_warehouse.PNG)
this architecture design can be  automated with Azure Data Factory, creating data integrations and data flows for multiple services.
2) Azure databricks for analytics built on Apache Spark
![](docs/Azure_data_warehouse_databricks.PNG)
databricks utilizes Spark to create ETL pipelines, is more suitable for lake house architecture.

#### Compute
- Azure Dedicated SQL Pools:
designed for large-scale, enterprise-level data warehousing workloads. It uses a provisioned resources model(allocate a certain amount of resources and pay for those resources whether you're using them or not; uses Massively Parallel Processing (MPP) architecture to quickly run complex queries across large amounts of data).
- Azure Synapse Analytics Serverless SQL Pools:
designed for on-demand and exploratory analysis, more cost-effective if workload is intermittent or low-volume. It uses a shared resources model(only pay based on the amount of data processed).

#### Azure Synapse Pipeline
Azure Synapse cannot convert string to datetime!!
1. Ingestion
![](docs/Ingestion.PNG)
- linked services
  a linked service contains connection information to other services
- pipeline
  A pipeline contains the logical flow for an execution of a set of activities
- trigger or a one-time data ingestion
  trigger could be manually startet or automatically scheduled

2. ETL/ELT (utilizing SQL)
**Azure Polybase**: using TSQL to query blob storage in support of ELT scenarios
![](docs/ELT_pipeline.PNG)
steps: 
- Extract: Data ingestion into Blob Storage or Azure Data Lake Gen 2
- Load: Create EXTERNAL staging tables in the Data Warehouse
- Transform: Transform data from staging tables to data warehouse tables

## Data Lake
+ Flexibility: Data lakes are capable of storing all types of data, regardless of whether that data is structured, semi-structured, and unstructured data;
+ Low Cost: use inexpensive hardware and open-source software(Hadoop and Spark), making them less costly to operate than traditional relational databases when storing large amounts of data; provide schema-on-read rather than schema-on-write which lowers the cost and work of ingesting large amounts of data.
- Data lakes are unable to support transactions and perform poorly with changing datasets;
- Data governance became difficult due to the unstructured nature of these systems.

Modern lakehouse architectures provide a metadata and data governance layer on top of the data lake, which combines the strengths of data warehouses and data lakes into a single powerful architecture, offer the ability to quickly ingest large amounts of data and then incrementally improve the quality of the data.

![](docs/datalake.PNG)

Personally Identifiable Information (PII) refers to any data that could potentially identify a specific individual. This can be any information that can be used on its own or with other information to identify, contact, or locate a single person, or to identify an individual in context. 

### storage
Azure Data Lake Gen 2 ( has been integrated into blob storage with hierarchical namespace): combines the power of a Hadoop compatible file system(including APIs) with integrated hierarchical namespace with the massive scale and economy of Azure Blob Storage. It enhances the capabilities of Azure Data Lake Storage Gen1 by enabling a high-performance file system layer on top of blob storage.

Delta Lake:
![](docs/delta_lake.PNG)
Delta Lake is an open-source storage layer that brings ACID transactions to Apache Spark and big data workloads. It's designed to provide reliability to both batch and streaming data processing, handling scenarios such as schema enforcement and evolution, and data consistency.
- ACID Transactions: Data reliability is ensured with ACID transactions
- Scalable Metadata Handling: Handles metadata of petabyte-scale tables with billions of files at ease, making it faster to query table data.
- Time Travel (Data Versioning): Stores a history of all the operations that happened in the table, allowing developers to access older versions of data for audits, rollbacks or to reproduce experiments.
- Unified Batch and Streaming Source and Sink: A table in Delta Lake is both a batch table, as well as a streaming source and sink. Streaming data ingest, batch historic backfill, and interactive queries all just work out of the box.

Caching of delta lake
- Delta Cache
   a high-performance caching layer that automatically caches frequently accessed data in the memory of your cluster's worker nodes.
- Result Cache
  a feature provided by some database systems and data processing frameworks to improve the performance of repeated queries. When a query is executed, the system stores the result of the query in a cache. If the same query is executed       again, the system can retrieve the result from the cache instead of executing the query again, which can save time and resources

data processing stages:
- Bronze Stage: ingesting raw into ingestion table
- Silver Stage: data are refined and combined
- Gold Stage: creation of features and aggregates such as star schema's fact and dimension tables.
### hadoop system
![](docs/data_lake.PNG)
hadoop is an ecosystem of tools for big data storage and data analysis, consists of Hadoop Distributed File System(HDFS, splits files into 64 or 128 megabyte blocks and replicates these blocks across the cluster) and MapReduce. 
- The major difference between Spark and Hadoop: Hadoop writes intermediate results to disk; Spark keeps data in memory whenever possible. This makes Spark faster(10-100x).
- The Hadoop ecosystem includes a distributed file storage system called HDFS (Hadoop Distributed File System). Spark does not include a file storage system(Spark on top of HDFS is not a must). 

Apache Pig: a SQL-like language that runs on top of Hadoop MapReduce
Apache Hive: another SQL-like interface that runs on top of Hadoop MapReduce

#### MapReduce
MapReduce is a programming technique for manipulating large data sets. "Hadoop MapReduce" is a specific implementation of this programming technique.

- Dividing up a large dataset and distributing the data across a cluster. 
- In the map step, each data is analyzed and converted into a (key, value) pair. Then these key-value pairs are shuffled across the cluster so that all keys are on the same machine. 
- In the reduce step, the values with the same keys are combined together.

#### Spark
 an open-source, distributed computing system used for big data processing and analytics. It provides an interface for programming entire clusters with implicit data parallelism and fault tolerance.
- Master: orchestrating the tasks across the cluster
- Workers: performing the actual computations

weakness:
- Memory Consumption: Spark uses in-memory computation for speed, which can be a problem for large datasets that don't fit into memory
- Latency: Spark Streaming’s latency is at least 500 milliseconds(operates on micro-batches).
- Spark only supports ML algorithms that scale linearly with the input data size

1. pure function
functions that are deterministic and No Side Effects are called pure functions.
Spark function never changes the original parent data by making a copy of input data.

2 lazy evaluation
calculations are delayed until the result is required by building Directed Acyclic Graph (DAG) of what functions and data it will need.
Apache Spark supports two types of operations: transformations(lazy) and actions(not lazy).
Transformation:
    - Narrow transformations: These transformations do not require the data to be shuffled across the partitions. Examples include map(), filter(), and union().
    - Wide transformations: These transformations require the data to be shuffled. Examples include groupByKey(), reduceByKey(), and join().
Action: return a value to the driver program or write data to an external storage system. Actions trigger the computation for transformations. Examples of actions include count(), first(), take(), collect(), and saveAsTextFile().

3. map
Maps simply make a copy of the original input data, and transform that copy according to function inside the map.

4. programming style
- Imperative programming(how): provide a sequence of commands or statements to change a program's state.
- Declarative programming(what): tell the computer what you want to do, and let the computer figure out how to do it.

5. shuffle (different from ML shuffle)
Shuffling is the process of redistributing data across partitions that may cause data to be moved across the network and between executors. This is often a costly operation and can have a significant impact on performance. Shuffling can occur during operations like join, groupByKey, reduceByKey, repartition.

spark debugging
Spark makes copy of the input data during calling a function, each worker has their own copy of these variables, and only these copies get modified. 
1) Accumulator can be used to help tracking errors.
2) Broadcast variable is a read-only variable to all worker nodes for use in one or more operations, saving the cost of shipping a large read-only lookup table to every node. 

Data Skew
solution: partition the data to change workload on worker node.
- Assign a new, temporary partition key(new column or composite key)
- Repartition by number of Spark workers

#### Databricks
1) used to prepare, train, process, and transform data for use in Azure Synapse Analytics or Microsoft Power BI.
![](docs/databricks.PNG)

2) providing data flows and processing, and preparing data for machine learning solutions.
![](docs/databricks1.PNG)

## Data Pipeline
a set of processes that move data from one system to another, which could be for various purposes like data integration, data migration, data transformation, or data analytics.

### Components
1) linked service: 
used to connect to external resources

2) Datasets: 
Representations of data structures within the data stores, which point to or reference the data used as inputs or outputs.

3) Integration Runtimes(IR):
compute infrastructure used to provide data integration capabilities across different network environments. It serves as the bridge between public network data stores and data stores within private networks.
- Azure IR: a multi-tenant, managed cloud data integration service used for data movement activities in public network and dispatching activities to external computes. 
- Self-hosted IR (SHIR): used to perform data movement between a cloud data stores and a data store in private network, or dispatch activities to external computes on-premises or Azure Virtual Network. 
- Azure-SSIS IR: a fully managed cluster of virtual machines dedicated to running SQL Server Integration Services (SSIS) packages.

4) Triggers:
Events that determine when execution needs to happen

5) Parameters
- Pipeline Parameters: parameters inside the Pipelines and Data Flows
- Global parameters: utilized by all pipelines and can be passed to data flows. 
- System Variables: Azure Data Factory and Synapse Workspace provide System Variables, such as @pipeline().DataFactory, @pipeline().RunId, @trigger().startTime.

6) Control Flow:
Control activities in a pipeline and specify conditions for whether or not to execute certain activities
7) Data Flow:
graphical data transformation logic interface without writing scripts for data transformation activities.

### Components
Azure Data Factory/Synapse Analytics
- while both services can create pipelines for data movement and transformation, Azure Synapse Analytics also includes features for data warehousing and analytics.
- Azure Data Factory supports cross-region Integration Runtimes but Synapse Analytics does not.

#### Mapping Data Flows
Mapping Data Flows in Azure Data Factory are visually-designed data transformations without writing code. 
Expression Builder: key tool within Mapping Data Flows to perform transformation logic.
functions: 
- Schema modifiers:create new columns, aggregate data, pivot data.
- Row modifiers: filtering sorting altering rows based on insert/update/delete/upsert policies.
- Multiple inputs/outputs: joins, unions, or split the data

#### Power Query
more user-friendly and designed for smaller scale transformations. 
Power Query engine uses a scripting language called M.


### Data Management
#### Data Governance
the overall management of the availability, usability, integrity, and security of the data employed in an enterprise. It's a set of processes, roles, policies, standards, and metrics that ensure the effective and efficient use of information in enabling an organization to achieve its goals.
Azure Purview is a data governance service to discovery data, classify data and see the data lineage from source to destination. 

Optimizing data flow in data governance involves ensuring that data moves through your systems efficiently and accurately, while also maintaining compliance with data governance policies:
- Monitor and Tune Performance: Use Spark's built-in tools to monitor the performance of your data processing tasks and tune your configurations accordingly.
- Partition Data: Partitioning data can significantly improve the efficiency of data processing tasks by reducing the amount of data that needs to be processed at once. 
- Monitoring and Alerts: Set up monitoring and alerts to notify you of potential schema shifts or other data quality issues.

Dimensions Changing:
changes in the structure or type of data fields (dimensions) in dataset due to schema evolution, where new fields are added, existing fields are removed, or the type of fields is changed.

Type 0: Ignore any changes and keep only the original values
Type 1: Overwrite the existing values with new values
Type 2: Add a new row with the new values and add a new version column that identifies current and prior version.
Type 3: Add new columns for the new values.
Type 4: Maintain all the historical values in a new History table.
Type 5: This an extension of Type 4 where a mini-dimension table is created by maintaining the keys.
Type 6: This is a combination of Type 1, Type 2 and Type 3. This adds a new record for new values and also maintains a new column.

#### Data Quality
state of data(complete, timely and consistent)



