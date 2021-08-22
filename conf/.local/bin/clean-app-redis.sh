#!/bin/bash

if [ "$1" == "" ]; then
    echo "This command requiere a pattern to clean..."
    exit 1
fi
pattern=$1;

kubectl exec -ti `kubectl get po | awk '{print $1}' | grep app-redis -m1` -- bash -c "redis-cli --raw sscan resque:workers 0 MATCH *${pattern}* COUNT 100000000 | xargs redis-cli srem resque:workers"

kubectl exec -ti `kubectl get po | awk '{print $1}' | grep app-redis -m1` -- bash -c "redis-cli --scan --pattern *${pattern}* | xargs redis-cli del"
