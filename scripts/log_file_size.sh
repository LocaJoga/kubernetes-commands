d=$(date --iso-8601=seconds)
ns=payment
for deployment in $(kubectl -n $ns get deploy --no-headers | awk '{ print $1 }');
 do echo $deployment
  for pod in $(kubectl -n $ns get po --no-headers | grep $deployment | awk '{ print $1 }');
    do echo $pod;
    node=$(kubectl -n $ns get po $pod -o json | jq -r .spec.nodeName)
    size=$(kubectl -n $ns exec -it $pod -- du -sh /var/tmp/microservices/Payments 2>/dev/null | awk '{ print $1 }';)
    echo "$deployment,$node,$pod,$size" >> report-$d.csv
  done
done
