if [ -z "$1" ]
then
                echo "Quale ms ?"
                        return
                else
                                echo "restart deployment: $1"
fi

kubectl scale --replicas=0 deployment $1 -n NAMESPACE

echo "\n$1 scalato a 0\n"

kubectl scale --replicas=1 deployment $1 -n NAMESPACE

echo "\n$1 scalato a 1\n"

echo "ENVIROMENT: \n"
kubectl get deployment $1 -n NAMESPACE -o jsonpath='{range .spec.template.spec.containers[*].env[*]}{@.name}{"="}{@.value}{"\n"}{end}'
echo "restart $1  ok !!! \n"
kubectl get pods -n NAMESPACE | grep $1
timeout 5 bash -c 'sleep 5; kubectl get pods -n NAMESPACE | grep $1'

kubectl logs -f $(kubectl get pods -n NAMESPACE --no-headers -o custom-columns=":metadata.name" | grep $1) -n NAMESPACE
