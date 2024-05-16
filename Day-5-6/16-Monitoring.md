# Monitoring Neo4J

## Monitoring in Neo4J
- Authentication events are written to the security.log file

## Collecting metrics
- Can configure to collect metrics that are related to events
- Can be viewed in tools - such as Grafana
- Can configure a tool such as Nagios to provide alerts when certain metrics are detected in Neo4j

## Monitoring queries
- Write information about queries to the query.log file
- Log information about queries that took a long time to complete
- Can also monitor currently running queries and if need be, kill them if they are taking too long.


## Configuring query logging
- Should enable logging for queries
- Set a threshold for the length of time queries take
- Regularly inspect the query.log file
- Determine if queries are taking longer duration

### Examples:
```
dbms.logs.query.enabled=VERBOSE
#Options:  [OFF, INFO, VERBOSE]
```

#### If the execution of query takes more time than this threshold, the query is logged once completed
```
dbms.logs.query.threshold=1000ms
```


#### Log parameters for the executed queries being logged
```
dbms.logs.query.parameter_logging_enabled=true
```

#### Log detailed time information for the executed queries being logged
```
dbms.logs.query.time_logging_enabled=true
```

#### Log amount of total allocated bytes for the executed queries being logged. The logged number is cumulative over the duration of the query
```
dbms.logs.query.allocation_logging_enabled=true
```

#### Log page hits and page faults for the executed queries being logged.
```
dbms.logs.query.page_logging_enabled=true
```

#### Enables or disables tracking of how much time a query spends actively executing on the CPU
```
dbms.track_query_cpu_time=true
```

#### Enables or disables tracking of how many bytes are allocated by the execution of a query.
- If enabled, calling dbms.listQueries will display the allocated bytes
```
dbms.track_query_allocation=true
```


## Dynamic settings
- All the above listed settings are dynamic.
- To view the list of settings which can be set dynamically:
```
CALL dbms.listConfig()
YIELD name, dynamic
WHERE dynamic
RETURN name
ORDER BY name
```

- To configure dynamic setting:
```
CALL dbms.setConfigValue('dbms.logs.query.enabled', 'info')
```

## Read the logs
```
tail -f -n 50 /logs/query.log
```

## Create some nodes
```
cypher-shell -u neo4j -p secret -d neo4j --format plain
```

```
:use neo4j;
```

```
MATCH (n) DETACH DELETE n;
```

#### Create some records
```
FOREACH (i IN RANGE(1,200) | CREATE (:Person {name:'Person' + i}));
```

## Exercise: Monitoring queries
```
cypher-shell -u neo4j -p secret -d neo4j --format plain
```

### Execute a query that runs for longer than 1000 ms:
```
MATCH (a), (b), (c), (d) RETURN count(id(a));
```

## Viewing currently running queries
```
CALL dbms.listQueries
:queries
```

## Killing a long-running query
```
:queries
```

- Click on cross button

## Exercise #1: Monitoring queries
- Modify the neo4j.conf file to create a log record if a query exceeds 1000 ms


```
vim /var/lib/neo4j/conf/neo4j.conf
```

```
dbms.logs.query.enabled=VERBOSE
dbms.logs.query.threshold=1000ms
dbms.logs.query.parameter_logging_enabled=true
dbms.logs.query.time_logging_enabled=true
dbms.logs.query.allocation_logging_enabled=true
dbms.logs.query.page_logging_enabled=true
dbms.track_query_cpu_time=true
dbms.track_query_allocation=true
```

```
neo4j restart
```


## Exercise: Monitoring queries
```
cypher-shell -u neo4j -p secret -d neo4j --format plain
```


### Execute a query that runs for longer than 1000 ms:
```
MATCH (a), (b), (c), (d) RETURN count(id(a));
```

### Exercise: Monitoring queries

- Wait about a minute, it should complete.
- View the query.log. Is there a record for this query?

```
tail -f query.log
```



## Exercise #1: Monitoring queries
- In cypher-shell session, enter query that will execute for an even longer time
```
MATCH (a), (b), (c), (d), (e) RETURN count(id(a));
```

- Open a new terminal window and log in to cypher-shell
- Execute the Cypher statement to list transactions
```
CALL dbms.listTransactions() yield username, currentQueryId, currentQuery, elapsedTimeMillis;
```
- Do you see the query?

- Execute the Cypher statement to kill the long-running query.
```
CALL dbms.listTransactions() yield username, currentQueryId, currentQuery, elapsedTimeMillis;
```

```
CALL dbms.killQuery('query-id');
```

- Observe in other session that the query has been killed.

## Automating monitoring of queries
- Automate the killing of long-running queries:
```
CALL dbms.listQueries() YIELD query, elapsedTimeMillis, queryId, username
WHERE  NOT query CONTAINS toLower('LOAD')
AND elapsedTimeMillis > 1000
WITH query, collect(queryId) AS q
CALL dbms.killQueries(q) YIELD queryId
RETURN query, queryId;
```

## Configuring transaction guard
- Example of lock acquisition timeout and transaction guard
```
vim /var/lib/neo4j/conf/neo4j.conf
```

### transaction guard: max duration of any transaction
```
dbms.transaction.timeout=1s
```

### max time to acquire write lock
```
dbms.lock.acquisition.timeout=10ms
```

```
neo4j restart
```

### Enter this statement to create multiple Person nodes:
```
FOREACH (i IN RANGE(1,1000000) | CREATE (:Person {name:'Person' + i}));
```

- Do you receive an error?
- A record is written to the debug.log file
- View the record written to debug.log
```
tail -n 2 debug.log
```

## Monitoring connections
- Can view the current connections to a Neo4j instance from cypher-shell

```
Call dbms.listConnections();
```

- Terminate the connection
```
dbms.killConnection()
```

## Logging HTTP requests
- You can set this property in neo4j.conf to log HTTP requests:
```
vim /var/lib/neo4j/conf/neo4j.conf
```

```
dbms.logs.http.enabled=true
```

```
neo4j restart
```


- View the records in the http.log file
```
tail -f -n 10 /logs/http.log
```

## Initial memory settings for database
- Obtain recommendation for settings related to memory:
```
neo4j-admin memrec
```

- Provides recommended memory settings


## Recommendation for log files
- Each type of log file should  have 
	- Its maximum size defined
	- Number of log files to keep
- Number of HTTP logs to keep.
```
dbms.logs.http.rotation.keep_number=5
```
- Size of each HTTP log that is kept. (k,m,g)
```
dbms.logs.http.rotation.size=20m
```
- Number of query logs to keep.
```
dbms.logs.query.rotation.keep_number=5
```
- Size of each query log that is kept.
```
dbms.logs.query.rotation.size=20m
```

## Collecting metrics
- Automatically collects metrics
- Can disable them by setting 
```
metrics.enabled=false
```

- Metrics are collected in CSV format
```
cd /var/lib/neo4j/metrics
```

```
ls -al
```
