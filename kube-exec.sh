#!/bin/bash

kubectl exec -it $(kubectl get po -l run=${USER} -o jsonpath='{.items[0].metadata.name}') -- bash