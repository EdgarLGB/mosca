#!/bin/bash


echo "How many slave machine do you want to make? "
read -p  "Input the start index: " i
read -p "and the number of slave: " n

for (( ; i <= n; i++ )); do
	docker-machine create \
	 -d virtualbox \
	--virtualbox-memory "512" \
	--virtualbox-disk-size "5000" \
	 --swarm \
	 --swarm-discovery="consul://$(docker-machine ip kv):8500" \
	 --engine-opt="cluster-store=consul://$(docker-machine ip kv):8500" \
	 --engine-opt="cluster-advertise=eth1:2376" \
	 node$i
done