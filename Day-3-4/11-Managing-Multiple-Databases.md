# Managing Multiple databases

## Reviewing initial databases
```
:USE SYSTEM
```

```
SHOW DATABASES
```


## Creating a new database
```
CREATE DATABASE movieGraph
```


## Use new database
```
:USE movieGraph
```

## Loading data
```
:PLAY movies
```

```
CALL db.schema.visualization()
```

## Cleaning out database within same instance
```
CREATE OR REPLACE DATABASE neo4j
```