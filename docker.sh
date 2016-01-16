#!/bin/bash  
  
if [ -z $1 ]; then  
        echo "Usage: c run <image name>:<version>"  
        echo "       c stop <container name>"  
        exit 1  
fi  
  
if [ -z $ETCD_HOST ]; then  
  ETCD_HOST="localhost:4001"  
fi  
  
if [ -z $ETCD_PREFIX ]; then  
  ETCD_PREFIX="mosca"  
fi  
  
if [ -z $CPORT ]; then  
  CPORT="1883"  
fi  
  
if [ -z $FORREST_IP ]; then  
  FORREST_IP=`ifconfig eth0| grep "inet addr" | head -1 | cut -d : -f2 | awk '{print $1}'`  
fi  
  
function launch_container {  
        echo "Launching $1 on $FORREST_IP ..."  
  
        CONTAINER_ID=`sudo docker run -d --link mongodb $1`
	ADDR=`sudo docker inspect $CONTAINER_ID | grep "\"IPAddress\"" | cut -d '"' -f4| head -1`  
#        PORT=`sudo docker inspect $CONTAINER_ID|grep "\"Ports\"" |grep "\"$CPORT/tcp\""| #cut -d '"' -f4|head -1`  
        NAME=`sudo docker inspect $CONTAINER_ID | grep Name | cut -d '"' -f4| cut -d '/' -f2 |head -1`  
   
        echo "Announcing to $ETCD_HOST..."  
        curl -X PUT "http://$ETCD_HOST/v2/keys/$ETCD_PREFIX/$NAME" -d value="$ADDR:$CPORT"  
  
        echo "$1 running on IP $ADDR : $CPORT with name $NAME"  
}  
  
function stop_container {  
        echo "Stopping $1..."  
        CONTAINER_ID=`sudo docker ps| grep $1 | awk '{print $1}'`  
        echo "Found container $CONTAINER_ID"
        sudo docker stop $CONTAINER_ID 
        curl -XDELETE $ETCD_PREFIX/$1 &> /dev/null  
        echo "Stopped."  
}  
  
  
if [ $1 = "run" ]; then  
  launch_container $2  
else  
  stop_container $2  
fi 
