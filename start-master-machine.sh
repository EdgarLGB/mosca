docker-machine create \
 -d virtualbox \
--virtualbox-memory "512" \
--virtualbox-disk-size "5000" \
 --swarm \
 --swarm-master \
 --swarm-discovery="consul://$(docker-machine ip kv):8500" \
 --engine-opt="cluster-store=consul://$(docker-machine ip kv):8500" \
 --engine-opt="cluster-advertise=eth1:3376" \
 master