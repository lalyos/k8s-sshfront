#!/bin/bash

[[ "$DEBUG" ]] && set -x
: ${NS:=$(kubectl  get deployment -l user -A -o jsonpath='{.items[0].metadata.namespace}')}
kubectl exec -n ${NS} -it $(kubectl get po -n ${NS} -l run=${USER} -o jsonpath='{.items[0].metadata.name}') -- bash

set +x