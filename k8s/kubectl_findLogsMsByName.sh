#!/bin/bash

if [ -z "$1" ]
then
          echo "Quale ms ?"
            return
    else
              echo "\n"
fi

kubectl logs -f $(kubectl get pods -n NAMESPACE --no-headers -o custom-columns=":metadata.name" | grep $1) -n NAMESPACE
