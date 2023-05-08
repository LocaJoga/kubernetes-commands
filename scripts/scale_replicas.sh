#!/bin/bash

deploys=`kubectl -n $1 get deployments | tail -n +2 | cut -d ' ' -f 1`
for deploy in $deploys; do
	kubectl scale --replicas=$2 deployment $deploy -n $1
done