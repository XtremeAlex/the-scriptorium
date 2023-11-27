
#!/bin/bash

for line in $(kubectl get pods -n NAMESPACE --no-headers -o custom-columns=":metadata.name");
do
          if kubectl logs $line -n NAMESPACE | grep 'ERROR'; then
                      kubectl logs $line -n NAMESPACE | grep 'ERROR';
                        else
                                    echo ""
                                      fi
                              done
