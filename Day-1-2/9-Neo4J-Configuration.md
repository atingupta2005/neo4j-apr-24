# Configuration

## **The neo4j.conf file**
The main source of configuration settings
```
cat /etc/neo4j/neo4j.conf
```
## **JVM-specific configuration settings**
[**server.memory.heap.initial_size**](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings/)

Sets the initial heap size for the JVM. By default, the JVM heap size is calculated based on the available system resources.

[**server.memory.heap.max_size**](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings)

Sets the maximum size of the heap for the JVM. By default, the maximum JVM heap size is calculated based on the available system resources.

[**server.jvm.additional**](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings)

Sets additional options for the JVM. The options are set as a string and can vary depending on JVM implementation.
##
## **List currently active settings**
```
CALL dbms.listConfig()
YIELD name, value
WHERE name STARTS WITH 'server.default'
RETURN name, value
ORDER BY name;
```

# **File locations**
### **Default file locations**

|||
| :- | :- |
|/usr/bin|Running script & built-in tools, such as, cypher-shell & neo4j-admin.|
|/etc/neo4j/neo4j.conf|The Neo4j configuration settings|
|/var/lib/neo4j/data|All data-related content, such as, databases, transactions, cluster |
|/var/lib/neo4j/import|All CSV files that the command LOAD CSV uses as sources to import data|
|/usr/share/neo4j/lib|All Neo4j dependencies|
|/var/log/neo4j/|<p>The Neo4j log files</p><p>journalctl --unit=neo4j</p>|
|/var/lib/neo4j/metrics|The Neo4j built-in metrics for monitoring database|
|/var/lib/neo4j/plugins|Custom code that extends Neo4j|
|/var/lib/neo4j/run|The processes IDs.|


### List files
```
sudo tree /etc/neo4j
```

```
sudo tree /var/lib/neo4j
```

```
sudo tree /usr/share/neo4j
```

```
sudo tree /var/log/neo4j
```

### **Customize your file locations**
The file locations can also be customized by using environment variables and options.

The locations of <neo4j-home> and conf can be configured using environment variables:

|**Location**|**Environment variable**|
| :- | :- |
|\<neo4j-home\>|NEO4J\_HOME|
|conf|NEO4J\_CONF|


**Rest of the locations can be configured in the conf/neo4j.conf file**
```
cat /etc/neo4j/neo4j.conf | grep directories
```

# **Ports**
- Refer: 
https://neo4j.com/docs/operations-manual/current/configuration/configuration-settings/


# **Password and user recovery**
## Disable authentication
```
sudo systemctl stop neo4j
```

```
cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
cat /etc/neo4j/neo4j.conf | grep "#dbms.security.auth_enabled"
sudo sed -i 's/#dbms.security.auth_enabled=true/dbms.security.auth_enabled=false/g' /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep dbms.security.auth_enabled
```

**Restart**
```
sudo systemctl stop neo4j
sudo systemctl start neo4j
```

**Connect**
```
cypher-shell -d system
```

## Reset password
**Alter Password**
```
neo4j@system> ALTER USER neo4j SET PASSWORD 'secret1234';
```

**Exit**
```
neo4j@system> :exit
```

## Enable authentication
```
sudo systemctl stop neo4j
```

```
cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
cat /etc/neo4j/neo4j.conf | grep "#dbms.security.auth_enabled"
sudo sed -i 's/dbms.security.auth_enabled=false/#dbms.security.auth_enabled=true/g' /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep dbms.security.auth_enabled
```

**Restart**
```
sudo systemctl stop neo4j
sudo systemctl start neo4j
```

```
cypher-shell -d system
```


### Now open the browser and login.
- http://IP-ADDRESS:7474/browser/



# **Configure Neo4j connectors**
|***Default connectors and their ports***|||
| :- | :- | :- |
|**Connector name**|**Protocol**|**Default port number**|
|server.bolt.listen_address|Bolt|7687|
|server.http.listen_address|HTTP|7474|
|server.https.listen_address|HTTPS|7473|

### Configuration options

The connectors are configured by settings on the format server.\<connector-name\>.\<setting-suffix\>

**Example 1. Specify listen\_address for the Bolt connector**

To listen for Bolt connections on all network interfaces (0.0.0.0) and on port 7000, set the listen\_address for the Bolt connector:
```
server.bolt.listen_address=0.0.0.0:7000
```


# **Configure dynamic settings**
Neo4j Enterprise Edition supports changing some configuration settings at runtime, without restarting the service.

**Note:**

Changes to the configuration at runtime are not persisted

To avoid losing changes when restarting Neo4j make sure to update neo4j.conf as well.

**Example: Discover dynamic settings**
```
CALL dbms.listConfig()
YIELD name, dynamic, value
WHERE dynamic
RETURN name, dynamic, value
ORDER BY name
```

**Update dynamic settings**

An administrator is able to change some configuration settings at runtime, without restarting the service.

```
CALL dbms.setConfigValue('db.logs.query.enabled', 'info')
```

# **Transaction logs**
The transaction logs record all write operations in the database

Important configuration settings for transaction logging:

|**Transaction log configuration**|**Default value**|**Description**|
| :- | :- | :- |
|[**server.directories.transaction.logs.root**](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings/#config_server.directories.transaction.logs.root)|transactions|Root location where Neo4j will store transaction logs for configured databases.|
|[**db.tx_log.rotation.retention_policy**](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings/#config_db.tx_log.rotation.retention_policy)|7 days|Make Neo4j keep the logical transaction logs for being able to backup the database. Can be used for specifying the threshold to prune logical logs after.|
|[**db.tx_log.rotation.size**](https://neo4j.com/docs/operations-manual/current/reference/configuration-settings/#config_db.tx_log.rotation.size)|250M|Specifies at which file size the logical log will auto-rotate. Minimum accepted value is 128K (128 KiB).|
```
CALL dbms.listConfig()
YIELD name, value
WHERE name="server.directories.transaction.logs.root"
RETURN name, value
ORDER BY name
```

```
CALL dbms.listConfig()
YIELD name, value
WHERE name="db.tx_log.rotation.retention_policy"
RETURN name, value
ORDER BY name
```

```
CALL dbms.listConfig()
YIELD name, value
WHERE name="db.tx_log.rotation.size"
RETURN name, value
ORDER BY name
```