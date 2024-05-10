# Managing a Neo4j Database

# **Neo4j instance files**
Default folders to frequently use for managing the Neo4j instance.

|**Purpose**|**Description**|
| :- | :- |
|Tools|The /usr/bin folder contains the tooling scripts you will typically run to manage the Neo4j instance.|
|Configuration|Neo4j.conf is the primary configuration file for the Neo4j instance and resides in the /etc/neo4j folder.|
|Logging|The /var/log/neo4j folder contains log files that you can monitor.|
|Database(s)|The /var/lib/neo4j/data folder contains the database(s).|

# **Post-installation preparation**

### **Managing the Neo4j instance**
You can start and stop the instance regardless of whether the neo4j service is enabled.

```
sudo systemctl start neo4j
```

```
sudo systemctl stop neo4j
```

```
sudo systemctl restart neo4j
```

```
sudo systemctl status neo4j
```

### **Viewing the neo4j log**
```
sudo journalctl -u neo4j   # To view the entire neo4j log file.
```

```
sudo journalctl -e -u neo4j   # To view the end of the neo4j log file.
```


### **Exercise #1: Managing the Neo4j instance**
#### Exercise steps:

- Open a terminal on your system.
- View the status of the Neo4j instance.

#### Stop the Neo4j instance.
```
sudo systemctl stop neo4j
```


#### View the status of the Neo4j instance.
```
sudo systemctl status neo4j
```

#### Examine the Neo4j log file.
```
sudo journalctl -e -u neo4j
```

#### Examine the files and folders created for this Neo4j instance.
```
cd /etc/neo4j
ls -al
```

#### Using cypher-shell
```
cypher-shell -u neo4j
```

#### Changing the default password
```
ALTER CURRENT USER
SET PASSWORD FROM 'secret1234' TO 'secret123';
```

### **Exercise: Copying a Neo4j database**

- Never copy database from one location in the filesystem to another location.
- Copy a Neo4j database by creating an offline backup.
- To create offline backup:

#### Stop the Neo4j instance
```
# Put this command in Cypher in browser
stop database neo4j
```


#### Ensure that the folder where you will dump the database exists.
```
sudo mkdir -p /usr/local/dumps
```

```
sudo chown -R neo4j:neo4j /usr/local/dumps
```

```
ls -al /usr/local/dumps
```

```
sudo rm -rf /usr/local/dumps/*
```


#### Use the dump command of the neo4j-admin tool to create the dump file.
```
neo4j-admin database dump neo4j --to-path=/usr/local/dumps/
ls /usr/local/dumps/
```

```
# Put this command in Cypher in browser
start database neo4j
```

#### You can now copy the dump file between systems.
```
# Put this command in Cypher in browser
stop database neo4j
```

#### Use the load command of the neo4j-admin tool to create database from dump file.
```
ls /usr/local/dumps/
neo4j-admin database load neo4j --from-path=/usr/local/dumps/ --overwrite-destination=true
```

```
ls -la /var/lib/neo4j/data/databases
```


**Note:** Dumping and loading a database is done when the Neo4j database instance is stopped.

- Offline backup is typically done for initial setup and development purposes
- Online backup and restore is done in a production environment.

### **Exercise: Deleting a Neo4j database**
#### Stop the Neo4j instance or Database
```
:USE SYSTEM
```

```
STOP Database neo4j2
```


#### Remove the folder for the active database
```
sudo rm -rf /var/lib/neo4j/data/databases/neo4j
ls -la /var/lib/neo4j/data/databases/
```

#### Also need to remove database from Cypher
```
:USE SYSTEM
```

```
DROP DATABASE neo4j
```

### **Modifying the location of the database**
```
sudo systemctl stop neo4j
```

#### Modify location
```
cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
cat /etc/neo4j/neo4j.conf | grep server.directories.data
sudo sed -i 's|server.directories.data=/var/lib/neo4j/data|server.directories.data=/usr/local/db|g' /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep server.directories.data
```

```
sudo mkdir -p /usr/local/db
sudo chown -R neo4j:neo4j /usr/local/db
ls -al /usr/local/
ls -al /usr/local/db/
```

### **Starting Neo4j instance with a new location**
```
sudo systemctl start neo4j
sudo journalctl -e -u neo4j
```

#### Ensure new location exist
- A new database named <active\_database> will be created
```
ls -al /usr/local/db/databases
```
- To move existing database must dump and load the database to safely copy it to the new location


### Modify the Neo4j configuration to use a database named neo4j2, rather than neo4j

```
sudo systemctl stop neo4j
```

```
cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
cat /etc/neo4j/neo4j.conf | grep initial.dbms.default_database
sudo sed -i 's|#initial.dbms.default_database=neo4j|initial.dbms.default_database=neo4j2|g' /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep initial.dbms.default_database
cat /etc/neo4j/neo4j.conf | grep server.directories.data
```

```
ls -al /usr/local/db/databases/
```

```
sudo systemctl stop neo4j
sudo systemctl start neo4j
sudo journalctl -e -u neo4j
ls -al /usr/local/db/databases/
```

#### Note: The initial.dbms.default_database setting is meant to set the default database before the creation of the DBMS. Once it is created, the setting is not valid anymore.



### **Checking the consistency of a database**
- If a specific database has been corrupted, you can perform a consistency check on it.

```
sudo systemctl stop neo4j
```


```
cd /usr/local/db/databases/
ls -al
sudo neo4j-admin database check neo4j2 --report-path=/usr/local/reports
ls /usr/local/reports
```

**Note:** No report will be written to the reports folder if the consistency check passed.

```
sudo systemctl start neo4j
```


### **Examples: Scripting with cypher-shell: Adding constraints**
- Create file:

```
cat <<EOT >> AddNodes.cypher
CREATE  (m:Movie:Action {title: 'Batman Begins'})
RETURN m.title;
EOT
```

```
cat ./AddNodes.cypher | /usr/bin/cypher-shell -u neo4j -p secret12345 --format verbose
```

### **Managing plugins**
Some applications can use Neo4j out-of-the-box

But many applications require additional functionality that could be:

1. A library supported by Neo4j such as GraphQL or GRAPH ALGORITHMS.
1. A community-supported library, such as APOC.
1. Custom functionality that has been written by the developers of your application.

### **Example: Installing the APOC plugin**
APOC contains over 450 user-defined procedures that make accessing a graph incredibly efficient and much easier than writing your own Cypher statements to do the same thing.

Open - http://IPAddress:7474/browser/

```
CALL dbms.procedures()
```

#### Note that APOC procedures not available

Install APOC

```
cp  /var/lib/neo4j/labs/apoc-5.19.0-core.jar /var/lib/neo4j/plugins/
cd /var/lib/neo4j/plugins
ls -al
```

```
sudo chmod +x *.jar
```

```
ls -al
```

```
sudo systemctl restart neo4j
sudo journalctl -e -u neo4j
```


Open - http://IPAddress:7474/browser/

```
SHOW PROCEDURES
```

```
CALL apoc.help("apoc")
```

```
CALL apoc.load.json('https://api.stackexchange.com/2.2/questions?pagesize=100&order=desc&sort=creation&tagged=neo4j&site=stackoverflow&filter=!5-i6Zw8Y)4W7vpy91PMYsKM-k9yzEsSC1_Uxlf') YIELD value
UNWIND value.items AS item
RETURN item.title, item.owner, item.creation_date, keys(item)
```


### **Performing online backup and restore**
Online backup is used in production where the application cannot tolerate the database being unavailable.

To enable a Neo4j instance to be backed up online, you must add these two properties to your neo4j.conf file:

```
cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
cat /etc/neo4j/neo4j.conf | grep server.backup.enabled
cat /etc/neo4j/neo4j.conf | grep server.backup.listen_address
sudo sed -i 's/#server.backup.enabled=true/server.backup.enabled=true/g' /etc/neo4j/neo4j.conf
sudo sed -i 's/#server.backup.listen_address=0.0.0.0:6362/server.backup.listen_address=0.0.0.0:6362/g' /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep server.backup.enabled
cat /etc/neo4j/neo4j.conf | grep server.backup.listen_address
```

```
sudo systemctl restart neo4j
```


### Create a folder
```
sudo mkdir -p /usr/local/backup
```

```
sudo mkdir -p /usr/local/work/reports
```

```
sudo chown -R neo4j:neo4j /usr/local/backup
```

```
sudo chown -R neo4j:neo4j  /usr/local/work/reports
```


### Perform an online backup of the active database
```
export HEAP_SIZE=2G
```

```
 neo4j-admin database  backup neo4j2  --from=localhost:6362 --to-path=/usr/local/backup
 ls /usr/local/backup
```


#### **Restore the database from the backup**
```
neo4j-admin database restore neo4j5db --from-path=/usr/local/backup/neo4j2-2024-05-09T03-01-01.backup
```

```
neo4j-admin database  check neo4j5db
```

```
ls -al /usr/local/db/databases/
```


#### Create database in Cypher-Shell or Cypher Browser
```
:use system
```


#### Create database neo4j5db
```
CREATE DATABASE neo4j5db
:use neo4j5db
match(n) return count(n);
```


### **Using the import tool to create a database**
- For large datasets, a best practice is to import the data using the import command of the neo4j-admin tool
- This tool creates the database from a set of .csv files.
- The data import creates a database
- You must run the import tool with the Neo4j instance stopped.

```
sudo mkdir -p /usr/local/import
```

```
sudo chown -R neo4j:neo4j /usr/local/import
```

```
cd /usr/local/import
```

```
cat <<EOT >> movies.csv
movieId:ID,title,year:int,:LABEL
tt0133093,"The Matrix",1999,Movie
tt0234215,"The Matrix Reloaded",2003,Movie;Sequel
tt0242653,"The Matrix Revolutions",2003,Movie;Sequel
EOT
```


```
cat <<EOT >> actors.csv
personId:ID,name,:LABEL
keanu,"Keanu Reeves",Actor
laurence,"Laurence Fishburne",Actor
carrieanne,"Carrie-Anne Moss",Actor
EOT
```

```
cat <<EOT >> roles.csv
:START_ID,role,:END_ID,:TYPE
keanu,"Neo",tt0133093,ACTED_IN
keanu,"Neo",tt0234215,ACTED_IN
keanu,"Neo",tt0242653,ACTED_IN
laurence,"Morpheus",tt0133093,ACTED_IN
laurence,"Morpheus",tt0234215,ACTED_IN
laurence,"Morpheus",tt0242653,ACTED_IN
carrieanne,"Trinity",tt0133093,ACTED_IN
carrieanne,"Trinity",tt0234215,ACTED_IN
carrieanne,"Trinity",tt0242653,ACTED_IN
EOT
```



```
neo4j-admin database import full --nodes=movies.csv --nodes=actors.csv --relationships=roles.csv
```

```
:USE neo4j
```

```
MATCH (n) RETURN n
```


### **Copy a database to another**
The copy command of neo4j-admin is used to copy data from an existing database to a new database.

### Use the copy command to take a copy of the database neo4j

```
STOP DATABASE neo4j
```

```
neo4j-admin database copy neo4j neo4jcop
```


### A new database with the name copy now exists on the server, but it is not automatically picked up by Neo4j
#### To start the new database you have to insert it into Neo4j with the following Cypher query:

```
CREATE DATABASE neo4jcopy
```

```
START DATABASE neo4j
```