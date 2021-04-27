#!/bin/bash

if [ -z $1 ]; 
then
    echo "must pass argument: [PBJENGINE_SCRIPT]"
fi
PBJENGINE_SCRIPT=$1

cd /opt/pbjengine/bin
nohup $1 > $1.out 2>&1 &