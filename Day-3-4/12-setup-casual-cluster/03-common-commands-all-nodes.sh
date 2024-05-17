# Install Binaries on all VMS
#- Note: Below commands need to run on all the VMs

# Add hosts entries (mocking DNS) - put relevant IPs here
cat /etc/hosts
sudo perl -pi -e "s,^10.0.0...*vm.\n$,," /etc/hosts
ip addr

sudo bash -c 'echo "10.0.0.4 vm1" >> /etc/hosts'
sudo bash -c 'echo "10.0.0.5 vm2" >> /etc/hosts'
sudo bash -c 'echo "10.0.0.6 vm3" >> /etc/hosts'
sudo bash -c 'echo "10.0.0.7 vm4" >> /etc/hosts'
sudo bash -c 'echo "10.0.0.8 vm5" >> /etc/hosts'

cat /etc/hosts
