#!/bin/bash
deployments=$(kubectl get deploy -o name -n $1 | awk -F "/" '{ print $2 }')
for d in $deployments
do
    image=$(kubectl get deploy $d -n $1 -o json | jq -r ".spec.template.spec.containers[0].image")
    #echo "$d,$image"
    echo $image | awk -F "/" '{ printf( "%s/%s\n", $2,$3 ) }'
done