#!/bin/bash

if [ -z "$1" ]
then
          echo "Quale ms ?"
            return
    else
              echo "\n"
fi

kubectl get deployment $1 -n NAMESPACE -o jsonpath='{range .spec.template.spec.containers[*].env[*]}{@.name}{"="}{@.value}{"\n"}{end}'
