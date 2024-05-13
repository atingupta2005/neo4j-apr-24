# Neo4J Linux Installation
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
sudo wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
```

```
echo 'deb https://debian.neo4j.com stable latest' | sudo tee /etc/apt/sources.list.d/neo4j.list
```

```
sudo apt update
```


**verify which Neo4j versions are available**
```
apt list -a neo4j
```

**Install Neo4j Enterprise Edition**
```
sudo apt install -y neo4j-enterprise=1:5.19.0
```

- Accept evaluation license

```
ulimit -n 60000
```

**Neo4J Configuration**
- Stored in /etc/neo4j/neo4j.conf

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


Delete the previous connection from Mobaxterm

Now login again using neo4j user name


### **Starting the service automatically on system start**
```
sudo systemctl enable neo4j
```

### **Controlling the service**
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


###
### **Log**
```
sudo journalctl -e -u neo4j
```

### **Enable below Ports on Firewall/ Inbound Port Rules**
7687,5000,6000,7000,7688,2003,2004,3637,5005,7474

### **Allow All IP Addresses to access Neo4J**
```
cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp
sudo sed -i 's/#server.default_listen_address=0.0.0.0/server.default_listen_address=0.0.0.0/g' /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep server.default_listen_address
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
sudo apt-get -y purge neo4j
```

```
sudo apt-get  -y purge neo4j-enterprise
```

```
sudo rm -rf  /etc/neo4j
```

```
sudo rm -rf  /var/lib/neo4j
```

```
sudo rm -rf  /usr/share/neo4j
```

```
sudo rm -rf  /var/log/neo4j
```

```
sudo systemctl status neo4j
```

