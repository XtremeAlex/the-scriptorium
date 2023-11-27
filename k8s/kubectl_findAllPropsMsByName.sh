#!/bin/bash

if [ -z "$1" ]
then
          echo "Quale ms ?"
            return
    else
              echo "\n"
fi

echo "\n$1_deployment.yaml \n"
kubectl get deployment -o yaml $1 -n NAMESPACE

echo "\n$1_service.yaml \n"
kubectl get svc -o yaml $1 -n NAMESPACE

echo "\n$1_ingress.yaml \n"
kubectl get ingress -o yaml $1 -n NAMESPACE
