#!/bin/bash

if [ -z $1 ]; 
then
    echo "must pass argument: [PBJENGINE_SCRIPT]"
fi
PBJENGINE_SCRIPT=$1

cd /opt/pbjengine/bin
echo "running command: bash $PBJENGINE_SCRIPT > $PBJENGINE_SCRIPT.out 2>&1 &"
bash "$PBJENGINE_SCRIPT" > "$PBJENGINE_SCRIPT.out" 2>&1 &