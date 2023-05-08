# Kubectl Commands with alias

 ```Linux
 
alias k='kubectl'
alias kg='kubectl get'
alias kgpod='kubectl get pod'
alias kgall='kubectl get --all-namespaces all'
alias kdp='kubectl describe pod'
alias kap='kubectl apply'
alias krm='kubectl delete'
alias krmf='kubectl delete -f'
alias kgsvc='kubectl get service'
alias kgdep='kubectl get deployments'
alias kl='kubectl logs'
alias kei='kubectl exec -it'

# short alias to set/show context/namespace (only works for bash and bash-compatible shells, current context to be set before using kn to set namespace) 
alias kx='f() { [ "$1" ] && kubectl config use-context $1 || kubectl config current-context ; } ; f'
alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace $1 || kubectl config view --minify | grep namespace | cut -d" " -f6 ; } ; f'

```
# Kubernetes Commands

List of general Kubernetes commands:

- [CONTEXT](#context)
- [PODS](#pods)
- [Create Deployments](#create-deployments)
- [Scaling PODs](#scaling-pods)
- [POD Upgrade / History](#pod-upgrade-and-history)
- [Services](#services)
- [Volumes](#volumes)
- [Secrets](#secrets)
- [ConfigMaps](#configmaps)
- [Ingress](#ingress)
- [Horizontal Pod Autoscalers](#horizontal-pod-autoscalers)
- [Scheduler](#scheduler)
- [Taints and Tolerations](#tains_and_tolerations)
- [Troubleshooting](#troubleshooting)
- [Role Based Access Control (RBAC)](#role_based_access_control)
- [Resources](#resources)


## CONTEXT

display list of contexts
```
$ kubectl config get-contexts    
```
display the current-context
```
$ kubectl config current-context
```

set the default context to my-cluster-name
```
$ kubectl config use-context <my-cluster-name>
```

to rename context name
$ kubectl config rename-context <old_name> <new_name>

delete the context
```
$ kubectl config delete-context <context_name>
```

## PODS

```
$ kubectl get pods
$ kubectl get pods --all-namespaces
$ kubectl get pod monkey -o wide
$ kubectl get pod monkey -o yaml
$ kubectl describe pod monkey
```
Create singe pod named nginx with image nginx:latest version
```
$ kubectl run nginx --image=nginx:latest
```

Exec into the pod
```
$ kubectl exec -it <pod_name> -- sh
```
## Create Deployments

Create single deployment

```
$ kubectl create deploy <deployment_name> --image=<image_name>:<version> 
```

## Scaling PODs

```bash
$ kubectl scale deployment/<deployment_name> --replicas=<count>
```

## POD Upgrade and history

#### List history of deployments

```
$ kubectl rollout history deployment/<deployment_name>
```

#### Rollout the deployment to pervious version

```
$ kubectl rollout undo deployment/<deployment_name> 
```

## Services

List services

```
$ kubectl get services
```

Expose PODs as services (creates endpoints)

```
$ kubectl expose deployment/<deployment_name> --name=<service_name> --port=<port> --type=<ClusterIP/NodePort>
```

If type is `NodePort` then you have to mention the nodePort in the yaml manually. Below command will give you the yaml in which you can add `nodePort` and then apply it.

```
$ kubectl expose deployment test --name=test-service --port=80 --type=NodePort --dry-run=client -o yaml
```

## Volumes

Lits Persistent Volumes and Persistent Volumes Claims:

```
$ kubectl get pv
$ kubectl get pvc
```

## Secrets

```
$ kubectl get secrets
$ kubectl create secret generic --help
$ kubectl create secret generic test --from-literal=password=root
$ kubectl get secrets test -o yaml
```

## ConfigMaps

```
$ kubectl create configmap <configmap_name> --from-file=<config.js>
$ kubectl get configmap test -o yaml
```

## DNS

List DNS-PODs:

```
$ kubectl get pods --all-namespaces | grep dns
```

## Ingress

### Create a single ingress called 'simple' that directs requests to foo.com/bar to svc
> #### svc1:8080 with a tls secret "my-cert"
```
$ kubectl create ingress simple --rule="foo.com/bar=svc1:8080,tls=my-cert"
$ kubectl get ingress
```
> Note: You can follow the documentation by -h flag `$ kubectl create ingress -h`

## Horizontal Pod Autoscaler

When heapster runs:

```
$ kubectl get hpa
$ kubectl autoscale --help
```

### Kubectl `HPA` patch commands 
It will patch the `HPA` count of all the deployment in mentioned namespace. You can use `minReplicas` and `maxReplicas` to change the min and max count under `spec` section.
```  
kubectl patch hpa $(kubectl get hpa -n <namespace> -o name | awk -F "/" '{ print $2 }') -p '{"spec":{"minReplicas": '<replica_count>'}}' -n <namespace>
```

To change the `HPA` replica count of particular deloyment 
```
kubectl patch hpa <deployment_name_of_scaler> -p '{"spec":{"maxReplicas": '<replica_count>'}}' -n <namespace>
```
To patch deployemt image
```
kubectl patch deploy <deployment_name> -p '{"image":"'<image_name>'"}' -n <namespace>
```

## DaemonSets

```
$ kubectl get daemonsets
$ kubectl get ds
```

## Scheduler

NodeSelector based policy:

```
$ kubectl label node test-node app=bar
```


## Tains and Tolerations

```
$ kubectl taint node test-node app=bar:NoSchedule
```
Docs: 
- https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/


## Troubleshooting

```
$ kubectl describe <pod_name or deployment_name>
$ kubectl logs <pod_name>
$ kubectl exec -it <pod_name> -- <command_to_run>
$ kubectl get nodes --show-labels
$ kubectl get events
```

## Role Based Access Control

- Role
- ClusterRule
- Binding
- ClusterRoleBinding

```
# Create a role named "pod-reader" that allows user to perform "get", "watch" and "list" on pods
$ kubectl create role pod-reader --verb=get --verb=list --verb=watch --resource=pods
```

```
# Create a role binding for user1, user2, and group1 using the admin cluster role
$ kubectl create rolebinding admin --clusterrole=admin --user=user1 --user=user2 --group=group1
```
```
# Create a cluster role named "pod-reader" that allows user to perform "get", "watch" and "list" on pods
$ kubectl create clusterrole pod-reader --verb=get,list,watch --resource=pods
```

```
# Create a cluster role binding for user1, user2, and group1 using the cluster-admin cluster role
$ kubectl create clusterrolebinding cluster-admin --clusterrole=cluster-admin --user=user1 --user=user2 --group=group1
```

# Resources
This command will display the `CPU-LIMIT`   `CPU-REQUESTS`   `MEMORY-LIMIT`   `MEMORY-REQUESTS` of deploymemts in mentioned namespace
```
kubectl get deploy -n <namespace> -o custom-columns='Name:metadata.name,CPU-LIMIT:spec.template.spec.containers[].resources.limits.cpu,CPU-REQUESTS:spec.template.spec.containers[].resources.requests.cpu,MEMORY-LIMIT:spec.template.spec.containers[].resources.limits.memory,MEMORY-REQUESTS:spec.template.spec.containers[].resources.requests.memory'
```