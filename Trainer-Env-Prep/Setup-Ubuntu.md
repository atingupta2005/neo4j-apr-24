sudo apt -y update
sudo apt -y install openssl tree zip unzip

sudo groupadd docker

for ((i=1;i<=9;i++)); do
	export username="u0$i"
	sudo useradd -m -p "p2" $username;sudo usermod -aG sudo $username;sudo usermod -aG docker $username;echo $username:p | sudo /usr/sbin/chpasswd;sudo chown -R  $username:root /home/$username
	sudo usermod -aG docker $username
done

for ((i=10;i<=50;i++)); do
	export username="u$i"
	sudo useradd -m -p "p2" $username;sudo usermod -aG sudo $username;sudo usermod -aG docker $username;echo $username:p | sudo /usr/sbin/chpasswd;sudo chown -R  $username:root /home/$username
	sudo usermod -aG docker $username
done
cat ~/.bashrc
echo 'export PS1="\e[0;31m\e[50m\u@\h\n\w \e[m\n$ "'   >> ~/.bashrc
cat ~/.bashrc
#########################################
sudo apt -y update;sudo apt-get -y install r-base;sudo apt -y update;sudo apt-get  -y install gdebi-core

# For ubuntu 20
wget https://download2.rstudio.org/server/focal/amd64/rstudio-server-2023.12.1-402-amd64.deb;sudo gdebi rstudio-server-2023.12.1-402-amd64.deb


free -h
curl http://localhost:8787


## Install Python
```
sudo apt install -y python3.8-venv python3-pip
sudo rm -rf /pyenv
sudo mkdir -p /pyenv
sudo chmod -R 777 /pyenv
python3 -m venv /pyenv
source /pyenv/bin/activate
sudo mkdir -p /workdir
sudo chmod -R 777 /workdir
pip install azure-cli
cd /workdir
pip install jupyter
nohup jupyter notebook --ip 0.0.0.0 --port 8888 &
curl localhost:8888
```

## Set password
```
New Jupyter password: jupyter123
```