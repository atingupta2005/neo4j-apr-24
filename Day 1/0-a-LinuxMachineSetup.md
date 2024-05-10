# Machine Setup

## Download Mobaxterm
- https://download.mobatek.net/2032020060430358/MobaXterm_Portable_v20.3.zip

## SSH to the Cloud Machine
- Extract MobaXterm_Portable_v20.3.zip
- Run MobaXterm_Personal_20.3.exe
- Take your VM IP address and credentials
- Create SSH session to the cloud machine

## Update OS
```
sudo apt -y update
```

## Add User to Sudoers
```
sudo usermod -aG sudo $USER
```

## Install Ubuntu various utilities
```
sudo apt -y install tree zip unzip htop jq
```
