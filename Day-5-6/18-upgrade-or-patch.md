# Upgrade or patch Neo4j 5

## Standalone
- The steps to upgrade a standalone Neo4j server (one that’s not part of a cluster) are:

 - Stop the old Neo4j server.
 - Install the new version of Neo4j.
 - Start the new Neo4j server.


### Note: 
 - When you restart the Neo4j server, it is a good idea to monitor the logs for any errors or warnings caused by the upgrade. 
   - The neo4j.log file contains information on the upgrade.

```
sudo systemctl stop neo4j
sudo apt upgrade neo4j-enterprise
sudo systemctl start neo4j
```

## In-place rolling upgrade of a cluster
- This is an example of how to do a rolling upgrade, by upgrading individual servers one at a time
- This approach keeps the cluster available throughout the upgrade. However, it does reduce fault tolerance while each server is offline.

### Upgrade steps (to be repeated for each server)
- Use the following query to check servers are hosting all their assigned databases. The query should return no results:
```
SHOW SERVERS YIELD name, hosting, requestedHosting, serverId WHERE requestedHosting <> hosting
```

- Use the following query to check all databases are in their expected state. The query should return no results:
```
SHOW DATABASES YIELD name, address, currentStatus, requestedStatus, statusMessage WHERE currentStatus <> requestedStatus RETURN name, address, currentStatus, requestedStatus, statusMessage
```

```
sudo systemctl stop neo4j
sudo apt upgrade neo4j-enterprise
sudo systemctl start neo4j
```

