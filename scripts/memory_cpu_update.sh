#!/bin/bash
deployments=$(kubectl get deploy -o name -n $1 | awk -F "/" '{ print $2 }')
for d in $deployments
do
	cpu_limit=$(kubectl get deploy $d -n $1 -o json | jq -r '.spec.template.spec.containers[0].resources.limits.cpu')
	mem_limit=$(kubectl get deploy $d -n $1 -o json | jq -r '.spec.template.spec.containers[0].resources.limits.memory')
	kubectl patch deployment $d --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/resources/requests/memory", "value": "'$limit'"}]' -n $1
done


#you can update cup/memory limit and request values using jsonpath
#spec.template.spec.containers[].resources.limits.cpu