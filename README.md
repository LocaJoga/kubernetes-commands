# kubernetes-commands
## Kubectl Commands with alias

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
### kubectl config commands 

display list of contexts
```
kubectl config get-contexts    
```
display the current-context
```
kubectl config current-context
```

set the default context to my-cluster-name
```
kubectl config use-context <my-cluster-name>
```

to rename context name
kubectl config rename-context <old_name> <new_name>

delete the context
```
kubectl config delete-context <context_name>
```

### some useful Kubectl patch commands
It will patch the hpa count of existing deployment file
```  
kubectl patch hpa $(kubectl get hpa -n <namespace> -o name | awk -F "/" '{ print $2 }') -p '{"spec":{"minReplicas": '<replica_count>'}}' -n <namespace>
```
