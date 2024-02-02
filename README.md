## sql database
database is a collection of tables, each talbe represents one entity type.

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
- not able to store different data type formats
- ACID reduces throughtput (fast read is not possible)
- flexible schema is not supported (columns added do not have to be used by every row)
- availability is limited (as it is not distributed)
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


### types of implementation
some NoSQL databases that offer some form of ACID transaction, such as MongoDB
- Apache Cassandra (Partition Row store)
- MongoDB (Document store)
- DynamoDB (Key-Value store)
- Apache HBase (Wide Column Store)
- Neo4J (Graph Database)

### Cassandra
Since Apache Cassandra requires data modeling based on the query you want, you can't do ad-hoc queries.
1) Keyspace
same as database
2) all placeholder should be %s when using session.execute(even if the data type is int)



