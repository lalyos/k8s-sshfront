
[![](https://images.microbadger.com/badges/image/lalyos/k8s-sshfront.svg)](https://microbadger.com/images/lalyos/k8s-sshfront "Get your own image badge on microbadger.com")
[![Docker Automated build](https://img.shields.io/docker/automated/lalyos/k8s-sshfront.svg)](https://hub.docker.com/r/lalyos/k8s-sshfront/)

For k8s workshops I prefer to create a dedicated pod for each participant, with all the tools preinstalled.

I wanted to provide an ssh access directly into the pod, without creating real ssh users on the cluster nodes. A containerised version of [gliderlabs/sshfront](https://github.com/gliderlabs/sshfront) is used.

## Deployment

The manifest file will create:
- ServiceAccount - will be assigned to the sshfront pod
- ClusterRole - gives access to read ConfigMaps, and exec into Pods.
- ClusterRoleBinding - bindes the 2 previous resources
- Deployment - runs the main process: sshfront
- Service - exposes the deployment as a NodePort

```
kubectl apply -f https://raw.githubusercontent.com/lalyos/k8s-sshfront/master/sshfront.yaml
```
## External ssh access

After successfull deployment, you can use the NodePort on any node's externalIP.
This command will print the ssh command:
```
$ echo ssh $(kubectl get no -o jsonpath='{.items[0].status.addresses[?(.type=="ExternalIP")].address}') \
  -p $(kubectl get svc sshfront -o jsonpath='{.spec.ports[0].nodePort}') \
  -l PODNAME

ssh 35.199.111.25 -p 30174 -l PODNAME
```

## Authentication

Authentication is using public keys. The public key should be stored in
a **ConfigMap** named `ssh` under the key named `key`.

## helper function

This function can be used by the user to "self service":
- get public key by github user id: `ssh-pubkey <GITHUB_USERNAME>` 
- get public key from stdin: `<SOME_COMMAND> | ssh-pubkey`

It expects that the user can jump into the pod already, probably via browser (see: todo)

```
ssh-pubkey() {
  declare githubUser=${1}

  if [ -t 0 ]; then
    if [[ $githubUser ]]; then 
      curl -sL https://github.com/${githubUser}.keys|kubectl create configmap ssh --from-literal="key=$(cat)"  --dry-run -o yaml | kubectl apply -f -
    else
      cat << USAGE
Configures ssh public key from stdin or github
usage:
  ${FUNCNAME[0]} <GITHUB_USERNAME>
  <SOME_COMMAND> | ${FUNCNAME[0]}
USAGE
    fi
  else
    kubectl create configmap ssh --from-literal="key=$(cat)"  --dry-run -o yaml | kubectl apply -f -  
  fi
}
```


