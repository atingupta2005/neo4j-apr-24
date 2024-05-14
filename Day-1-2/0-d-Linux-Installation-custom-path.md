# Neo4J Linux Installation with Custom Path
## **Ubuntu Installation Instructions**

```
sudo add-apt-repository universe
```

```
sudo apt -y update
```

```
sudo add-apt-repository -y ppa:openjdk-r/ppa
```

```
sudo apt -y update
```

```
sudo apt install openjdk-17-jdk -y
```

```
wget https://neo4j.com/artifact.php?name=neo4j-community-5.19.0-unix.tar.gz -O neo4j-community-5.19.0-unix.tar.gz
```

```
tar zxvf neo4j-community-5.19.0-unix.tar.gz
```

```
ulimit -n 60000 
```

```community
sudo mv neo4j-community-5.19.0 /opt/
```

```
sudo ln -s /opt/neo4j-community-5.19.0 /opt/neo4j
```

```
sudo groupadd neo4j
sudo useradd -g neo4j neo4j -s /bin/bash
```


```
sudo chown -R neo4j:neo4j /opt/neo4j-community-5.19.0
```

```
export NEO4J_ACCEPT_LICENSE_AGREEMENT=eval
```

```
sudo /opt/neo4j/bin/neo4j-admin server stop
sudo /opt/neo4j/bin/neo4j-admin server start
sudo /opt/neo4j/bin/neo4j-admin server status
```

###
### **Log**
```
 tail -f /opt/neo4j/logs/debug.log
```

### **Enable below Ports on Firewall/ Inbound Port Rules**
7687,5000,6000,7000,7688,2003,2004,3637,5005,7474

### **Allow All IP Addresses to access Neo4J**
```
sudo cp /opt/neo4j/conf/neo4j.conf /opt/neo4j/conf/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
sudo sed -i 's/#server.default_listen_address=0.0.0.0/server.default_listen_address=0.0.0.0/g' /opt/neo4j/conf/neo4j.conf
cat /opt/neo4j/conf/neo4j.conf | grep server.default_listen_address
```

**Restart**
```
sudo /opt/neo4j/bin/neo4j-admin server stop
sudo /opt/neo4j/bin/neo4j-admin server start
sudo /opt/neo4j/bin/neo4j-admin server status
``


**Login Details:**

**URL**
```
[http://<ip-address>:7474/browser/]()
```

**Note:** If the password is not set explicitly using this method, it will be set to the default password neo4j. In that case, you will be prompted to change the default password at first login.


**Username/Password**

neo4j/secret123

Or

neo4j/neo4j


### **Uninstall (Optional)**
```
sudo systemctl stop neo4j
```

```
sudo rm -rf  /opt/neo4j
```

```
sudo systemctl status neo4j
```

