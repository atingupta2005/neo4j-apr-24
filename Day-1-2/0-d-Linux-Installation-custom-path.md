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
wget https://neo4j.com/artifact.php?name=neo4j-community-5.19.0-unix.tar.gz
```

```
tar zxf neo4j-community-5.19.0-unix.tar.gz
```

```
ulimit -n 60000 
```

```
mv neo4j-enterprise-5.19.0 /opt/
```

```
ln -s /opt/neo4j-enterprise-5.19.0 /opt/neo4j
```

```
groupadd neo4j
useradd -g neo4j neo4j -s /bin/bash
```


```
chown -R neo4j:adm /opt/neo4j-enterprise-5.19.0
```

```
export NEO4J_ACCEPT_LICENSE_AGREEMENT=eval
```

```
/opt/neo4j/bin/neo4j-admin server license --accept-evaluation
```

```
/opt/neo4j/bin/neo4j console
```

### Configure Neo4j to start automatically on system boot
```
cp neo4j.service /lib/systemd/system/neo4j.service
```


###
### **Log**
```
sudo journalctl -e -u neo4j
```

### **Enable below Ports on Firewall/ Inbound Port Rules**
7687,5000,6000,7000,7688,2003,2004,3637,5005,7474

### **Allow All IP Addresses to access Neo4J**
```
cp /opt/neo4j/conf/neo4j.conf /opt/neo4j/conf/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
sudo sed -i 's/#server.default_listen_address=0.0.0.0/server.default_listen_address=0.0.0.0/g' /opt/neo4j/conf/neo4j.conf
cat /opt/neo4j/conf/neo4j.conf | grep server.default_listen_address
```

**Restart**
```
sudo systemctl stop neo4j
```

```
sudo systemctl start neo4j
```


### **Set Default Password (Optional)**

```
sudo neo4j-admin dbms set-initial-password secret123
```


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

