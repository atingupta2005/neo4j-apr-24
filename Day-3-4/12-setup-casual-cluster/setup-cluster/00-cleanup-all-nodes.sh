# To clean neo4j from the VMs
#- Note: Below commands need to run on all the nodes

#- Need to run on all the VMs

sudo systemctl stop neo4j


sudo apt-get -y purge neo4j



sudo apt-get  -y purge neo4j-enterprise



sudo rm -rf  /etc/neo4j



sudo rm -rf  /var/lib/neo4j



sudo rm -rf  /usr/share/neo4j



sudo rm -rf  /var/log/neo4j



sudo systemctl status neo4j


