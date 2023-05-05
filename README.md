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

```
### kubectl command to rename context name
'
```
kubectl config rename-context <old_name> <new_name>
```
