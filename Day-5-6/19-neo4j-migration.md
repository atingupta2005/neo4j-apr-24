# Migrating from Neo4J 4.x to Neo4J 5.x
## Setup Neo4J 4.4
```
sudo apt update
sudo apt-get install openjdk-11-jre -y
```

```
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
sudo rm -rf /etc/apt/sources.list.d/neo4j.list
```

```
echo 'deb https://debian.neo4j.com stable 4.4' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
sudo apt-get update
```

```
apt list -a neo4j
```

```
sudo apt-get install neo4j-enterprise=1:4.4.34
```

```
cat /etc/neo4j/neo4j.conf | grep dbms.default_listen_address
```

```
sudo sed -i 's/#dbms.default_listen_address=0.0.0.0/dbms.default_listen_address=0.0.0.0/g' /etc/neo4j/neo4j.conf
```

```
cat /etc/neo4j/neo4j.conf | grep dbms.default_listen_address
```

```
sudo systemctl enable  neo4j
sudo systemctl stop neo4j
sudo systemctl start neo4j
sudo systemctl status neo4j
```

```
journalctl -e -u neo4j
curl localhost:7474
```


## Set password
```
sudo usermod -aG sudo neo4j
```

```
sudo passwd neo4j
```

```
logout
```


- Delete the previous connection from Mobaxterm

- Now login again using neo4j user name



## Prepare for your migration
- Start by reviewing the new features, fixes, and breaking changes
- As you do, make a list of your external systems that connect to Neo4j that will need updating

## Downtime
- Migrating databases between versions of Neo4j always requires downtime. Although it is possible to leave the old versions online in read-only mode.

- Since every case is different, it is recommended that you prepare an environment in which you can test the migration process. This will give you more accurate timings than you can estimate and an idea of what to expect in terms of duration for the process.

## Disk space considerations
- To migrate a database you must create a backup


## Backup your databases
```
:use system
ALTER DATABASE atindb SET ACCESS READ ONLY
```

```
sudo mkdir /mnt/fsneo4j
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/savmneo4j6121980.cred" ]; then
    sudo bash -c 'echo "username=savmneo4j6121980" >> /etc/smbcredentials/savmneo4j6121980.cred'
    sudo bash -c 'echo "password=p/JlF/p4QS4QjUlVrkOmqp/3ZwckttEnvoyq+2nuv2A4EwBwqhSIl3U3FmspRMVNjztdAUGIT4m6+AStlYy+SQ==" >> /etc/smbcredentials/savmneo4j6121980.cred'
fi
sudo chmod 600 /etc/smbcredentials/savmneo4j6121980.cred

sudo bash -c 'echo "//savmneo4j6121980.file.core.windows.net/fsneo4j /mnt/fsneo4j cifs nofail,credentials=/etc/smbcredentials/savmneo4j6121980.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //savmneo4j6121980.file.core.windows.net/fsneo4j /mnt/fsneo4j -o credentials=/etc/smbcredentials/savmneo4j6121980.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
```


```
sudo rm -rf /mnt/fsneo4j/migration-backups
ls -alhR /mnt/fsneo4j/
mkdir /mnt/fsneo4j/migration-backups
neo4j-admin backup --database=atindb  --backup-dir=/mnt/fsneo4j/migration-backups --include-metadata=all
```

```
cp /etc/neo4j/neo4j.conf /mnt/fsneo4j/migration-backups/neo4j.conf
ls -alh /mnt/fsneo4j/migration-backups
```

## Install and configure Neo4j 5
- Migrating configuration files
- Copy the Neo4j 4.4 configuration file(s) to the new Neo4j 5 configuration directory if you want to migrate an existing configuration
- Command in Neo4J 5

### Note: Connect using the user - neo4j
```
sudo passwd neo4j
su neo4j
```

```
cp /mnt/fsneo4j/migration-backups/neo4j.conf /etc/neo4j/neo4j.conf
neo4j-admin server migrate-configuration
ls -alh /etc/neo4j/neo4j*
```


## Restore the database on Neo4j 5
```
ls -alh /mnt/fsneo4j/migration-backups/atindb
```


```
cp -R /mnt/fsneo4j/migration-backups/atindb /tmp/atindb
```

```
ls -alhR /tmp/atindb
```

```
neo4j-admin database restore --from-path=/tmp/atindb
```

```
ls -alh /var/lib/neo4j/data/databases/atindb/
```

```
cat  /var/lib/neo4j/data/scripts/atindb/restore_metadata.cypher | cypher-shell -u neo4j -p secret123 --format verbose --param 'database => "atindb"'
```


```
neo4j-admin database migrate atindb
```


- Start Neo4j 5 and recreate each of your databases using the following Cypher®:
```
show databases
START DATABASE atindb
show databases
MATCH (n) RETURN n LIMIT 25
```

## Upgrade checklist
- Complete all prerequisites for the upgrade
- Back up your current deployment to avoid losing data in case of failure
- Download the new version of Neo4j. Make sure the upgrade path is supported
- Prepare a new neo4j.conf file to be used by the new installation
- Perform a test upgrade as per your Neo4j version and deployment type (Single instance or Causal Cluster)
- Monitor the logs
- Perform the upgrade


