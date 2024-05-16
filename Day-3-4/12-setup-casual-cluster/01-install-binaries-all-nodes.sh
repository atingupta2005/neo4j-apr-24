# Install Binaries on all VMS
#- Note: Below commands need to run on all the VMs

sudo add-apt-repository universe
sudo apt-get update
sudo apt-get -y install wget ca-certificates zip net-tools vim nano tar netcat tree

# Java Open JDK 11
sudo apt-get -y install openjdk-11-jdk
java -version


sudo wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -

echo 'deb https://debian.neo4j.com stable latest' | sudo tee /etc/apt/sources.list.d/neo4j.list

sudo apt update

apt list -a neo4j

sudo apt install -y neo4j-enterprise=1:5.19.0

echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf

cat /etc/security/limits.conf

sudo reboot

ulimit -n

sudo usermod -aG sudo neo4j

## Run alone
### Set password - neo4j
sudo passwd neo4j

logout

# Login again using the user - neo4j

echo "Make sure below ports are open:"
echo "7687,5000,6000,7000,7688,2003,2004,3637,5005,7474"

cp /etc/neo4j/neo4j.conf /etc/neo4j/neo4j.conf-$(date +"%Y_%m_%d_%I_%M_%p_UTC").bkp

sudo sed -i 's/#server.default_listen_address=0.0.0.0/server.default_listen_address=0.0.0.0/g' /etc/neo4j/neo4j.conf

cat /etc/neo4j/neo4j.conf | grep server.default_listen_address

sudo systemctl stop neo4j


