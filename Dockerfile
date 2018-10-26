FROM alpine:3.8

RUN apk add -U curl bash

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
   && chmod +x ./kubectl \
   && mv ./kubectl /usr/local/bin/kubectl

RUN curl -L https://github.com/gliderlabs/sshfront/releases/download/v0.2.1/sshfront_0.2.1_Linux_x86_64.tgz| tar -xz -C /usr/local/bin

ADD kube-exec.sh ssh-auth.sh /

EXPOSE 22
CMD sshfront -e -a=/ssh-auth.sh  /kube-exec.sh