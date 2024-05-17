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
cat /etc/neo4j/neo4j.conf | grep db.logs.query.enabled

```
db.logs.query.enabled=VERBOSE
#Options:  [OFF, INFO, VERBOSE]
```

#### If the execution of query takes more time than this threshold, the query is logged once completed
```
db.logs.query.threshold=1000ms
```


#### Log parameters for the executed queries being logged
```
db.logs.query.parameter_logging_enabled=true
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
CALL dbms.setConfigValue('db.logs.query.enabled', 'info')
```

## Read the logs
```
tail -f -n 50  /var/log/neo4j/query.log
```

## Create some nodes
```
cypher-shell -u neo4j -p secret -d secret1234
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
SHOW TRANSACTIONS
```

## Killing a long-running query
```
SHOW TRANSACTIONS
```

```
TERMINATE TRANSACTIONS "neo4j-transaction-121"
YIELD username, message
RETURN *
```

## Exercise #1: Monitoring queries
- Modify the neo4j.conf file to create a log record if a query exceeds 1000 ms


```
sudo vim /etc/neo4j/neo4j.conf
```

```
db.logs.query.enabled=VERBOSE
db.logs.query.threshold=1000ms
db.logs.query.parameter_logging_enabled=true
```

```
neo4j restart
```


## Exercise: Monitoring queries
```
cypher-shell -u neo4j -p secret -d neo4j
```


### Execute a query that runs for longer than 1000 ms:
```
MATCH (a), (b), (c), (d) RETURN count(id(a));
```

### Exercise: Monitoring queries

- Wait about a minute, it should complete.
- View the query.log. Is there a record for this query?

```
tail -f  /var/log/neo4j/query.log
```


## Configuring transaction guard
- Example of lock acquisition timeout and transaction guard

### transaction guard: max duration of any transaction
```
cat /etc/neo4j/neo4j.conf | grep db.transaction.timeout
sudo sh -c '! grep "^db.transaction.timeout" /etc/neo4j/neo4j.conf && echo "db.transaction.timeout=2s" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep db.transaction.timeout
```

### max time to acquire write lock
```
cat /etc/neo4j/neo4j.conf | grep db.lock.acquisition.timeout
sudo sh -c '! grep "^db.lock.acquisition.timeout" /etc/neo4j/neo4j.conf && echo "db.lock.acquisition.timeout=10ms" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep db.lock.acquisition.timeout
```

```
neo4j restart
```

### Enter this statement to create multiple Person nodes:
```
cypher-shell -u neo4j -p secret -d secret1234
```

```
FOREACH (i IN RANGE(1,1000000) | CREATE (:Person {name:'Person' + i}));
```

- Do you receive an error?
- A record is written to the debug.log file
- View the record written to debug.log
```
tail -n 2 /var/log/neo4j/debug.log
```

## Monitoring connections
- Can view the current connections to a Neo4j instance from cypher-shell

```
SHOW TRANSACTIONS;
```

- Terminate the connection
```
cypher-shell -u neo4j -p secret -d secret1234
```


```
TERMINATE TRANSACTIONS "neo4j-transaction-121"
YIELD username, message
RETURN *
```

## Logging HTTP requests
- You can set this property in neo4j.conf to log HTTP requests:
```
cat /etc/neo4j/neo4j.conf | grep dbms.logs.http.enabled
sudo sh -c '! grep "^dbms.logs.http.enabled" /etc/neo4j/neo4j.conf && echo "dbms.logs.http.enabled=true" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep dbms.logs.http.enabled
```

```
neo4j restart
```


- View the records in the http.log file
```
tail -f -n 10 /var/log/neo4j/http.log
```

## Initial memory settings for database
- Obtain recommendation for settings related to memory:
```
neo4j-admin server  memory-recommendation
```

- Provides recommended memory settings


## Recommendation for log files
```
server.logs.gc.rotation.keep_number=5
```
- Size of each HTTP log that is kept. (k,m,g)
```
server.logs.gc.rotation.size=20m
```

## Collecting metrics
- Automatically collects metrics

- Metrics are collected in CSV format
```
cd /var/lib/neo4j/metrics
```

```
ls -al
```
