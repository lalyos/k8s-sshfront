#!/bin/bash

[[ "$DEBUG" ]] && set -x
: ${NS:=$(kubectl  get deployment -l user -A -o jsonpath='{.items[0].metadata.namespace}')}

[[ "$SSH_ORIGINAL_COMMAND" ]] || OPTS='-it'
kubectl exec -n ${NS} ${OPTS} $(kubectl get po -n ${NS} -l run=${USER} -o jsonpath='{.items[0].metadata.name}') -- ${SSH_ORIGINAL_COMMAND:=bash}

set +x