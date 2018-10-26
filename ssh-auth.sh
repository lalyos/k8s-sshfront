#!/bin/bash
user=$1
key=$2
kubectl get configmaps ssh -n $user -o jsonpath='{.data.key}' | grep "${key}" &> /dev/null