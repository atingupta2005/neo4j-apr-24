cd

cat /etc/neo4j/neo4j.conf | grep server.http.advertised_address
! grep '^server.http.advertised_address' /etc/neo4j/neo4j.conf && echo "server.http.advertised_address=vm1:7474" >> /etc/neo4j/neo4j.conf

cat /etc/neo4j/neo4j.conf | grep server.bolt.advertised_address
! grep '^server.bolt.advertised_address' /etc/neo4j/neo4j.conf && echo "server.bolt.advertised_address=vm1:7687" >> /etc/neo4j/neo4j.conf


cat /etc/neo4j/neo4j.conf | grep server.cluster.advertised_address
! grep '^server.cluster.advertised_address' /etc/neo4j/neo4j.conf && echo "server.cluster.advertised_address=vm1:6000" >> /etc/neo4j/neo4j.conf

cat /etc/neo4j/neo4j.conf | grep server.cluster.raft.advertised_address
! grep '^server.cluster.raft.advertised_address' /etc/neo4j/neo4j.conf && echo "server.cluster.raft.advertised_address=vm1:7000" >> /etc/neo4j/neo4j.conf

cat /etc/neo4j/neo4j.conf | grep server.discovery.advertised_address
! grep '^server.discovery.advertised_address' /etc/neo4j/neo4j.conf && echo "server.discovery.advertised_address=vm1:5000" >> /etc/neo4j/neo4j.conf


cat /etc/neo4j/neo4j.conf | grep dbms.cluster.discovery.endpoints
! grep '^dbms.cluster.discovery.endpoints' /etc/neo4j/neo4j.conf && echo "dbms.cluster.discovery.endpoints=vm1:5000, vm2:5000, vm3:5000" >> /etc/neo4j/neo4j.conf


cat /etc/neo4j/neo4j.conf | grep initial.dbms.default_primaries_count
! grep '^initial.dbms.default_primaries_count' /etc/neo4j/neo4j.conf && echo "initial.dbms.default_primaries_count=2" >> /etc/neo4j/neo4j.conf

cat /etc/neo4j/neo4j.conf

sudo neo4j-admin dbms set-initial-password secret123

sudo journalctl -e -u neo4j

sudo systemctl stop neo4j

sleep 60

sudo systemctl start neo4j

sudo systemctl status neo4j

sleep 2

tail -f  /var/log/neo4j/debug.log

nc -vz vm1 5000
nc -vz vm2 5000
nc -vz vm3 5000

nc -vz vm1 7474
nc -vz vm2 7474
nc -vz vm3 7474

cypher-shell -u neo4j

SHOW SERVERS;