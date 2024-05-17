cd

cat /etc/neo4j/neo4j.conf | grep server.http.advertised_address
! grep '^server.http.advertised_address' /etc/neo4j/neo4j.conf && sudo echo "server.http.advertised_address=vm2:7474" >> /etc/neo4j/neo4j.conf
cat /etc/neo4j/neo4j.conf | grep server.http.advertised_address

cat /etc/neo4j/neo4j.conf | grep server.bolt.advertised_address
sudo sh -c '! grep "^server.bolt.advertised_address" /etc/neo4j/neo4j.conf && echo "server.bolt.advertised_address=vm2:7687" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep server.bolt.advertised_address

cat /etc/neo4j/neo4j.conf | grep server.cluster.advertised_address
sudo sh -c '! grep "^server.cluster.advertised_address" /etc/neo4j/neo4j.conf && echo "server.cluster.advertised_address=vm2:6000" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep server.cluster.advertised_address

cat /etc/neo4j/neo4j.conf | grep server.cluster.raft.advertised_address
sudo sh -c '! grep "^server.cluster.raft.advertised_address" /etc/neo4j/neo4j.conf && echo "server.cluster.raft.advertised_address=vm2:7000" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep server.cluster.raft.advertised_address

cat /etc/neo4j/neo4j.conf | grep server.discovery.advertised_address
sudo sh -c '! grep "^server.discovery.advertised_address" /etc/neo4j/neo4j.conf && echo "server.discovery.advertised_address=vm2:5000" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep server.discovery.advertised_address

cat /etc/neo4j/neo4j.conf | grep dbms.cluster.discovery.endpoints
sudo sh -c '! grep "^dbms.cluster.discovery.endpoints" /etc/neo4j/neo4j.conf && echo "dbms.cluster.discovery.endpoints=vm1:5000,vm2:5000,vm3:5000,vm4:5000",vm5:5000"" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep dbms.cluster.discovery.endpoints

cat /etc/neo4j/neo4j.conf | grep initial.dbms.default_primaries_count
sudo sh -c '! grep "^initial.dbms.default_primaries_count" /etc/neo4j/neo4j.conf && echo "initial.dbms.default_primaries_count=2" >> /etc/neo4j/neo4j.conf'
cat /etc/neo4j/neo4j.conf | grep initial.dbms.default_primaries_count

cat /etc/neo4j/neo4j.conf

sudo journalctl -e -u neo4j

sudo systemctl stop neo4j

sleep 5

sudo systemctl start neo4j

sudo systemctl status neo4j

sleep 2

tail /var/log/neo4j/debug.log

nc -vz vm1 5000
nc -vz vm2 5000
nc -vz vm3 5000

nc -vz vm1 7474
nc -vz vm2 7474
nc -vz vm3 7474

tail -f /var/log/neo4j/debug.log

cypher-shell -u neo4j

SHOW SERVERS;