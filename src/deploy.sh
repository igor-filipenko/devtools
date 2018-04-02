#!/bin/bash

source $HOME/devtools/share/common.sh

SERVER=$1
SERVER_PATH=$MOUNT_PATH/$SERVER/deployments

echo "Deploy $SERVER"

rm -f $SERVER_PATH/Set10.ear.* && touch $SERVER_PATH/Set10.ear.dodeploy

while [ -f "$SERVER_PATH/Set10.ear.dodeploy" ]
do
    sleep 10
    echo "Waiting for deploy complete..."
done

if [ -f "$SERVER_PATH/Set10.ear.deployed" ]
then
    echo "SUCCESS"
else
    echo "FAILURE"
fi
