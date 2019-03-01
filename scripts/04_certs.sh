#!/bin/sh

# CA
cfssl gencert -initca certs/ca-csr.json | cfssljson -bare ca

# Admin
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=certs/ca-config.json -profile=kubernetes certs/admin-csr.json | cfssljson -bare admin

# Workers
for instance in worker-0 worker-1 worker-2; do
EXTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

INTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].networkIP)')

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done

# Kube Controller Manager
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=certs/ca-config.json -profile=kubernetes certs/kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

# Kube Proxy
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=certs/ca-config.json -profile=kubernetes certs/kube-proxy-csr.json | cfssljson -bare kube-proxy

# Kube Scheduler
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=certs/ca-config.json -profile=kubernetes certs/kube-scheduler-csr.json | cfssljson -bare kube-scheduler

# Kubernetes API Server
K8S_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way --region $(gcloud config get-value compute/region) --format 'value(address)')
cfssl gencert \
    -ca=ca.pem \
    -ca-key=ca-key.pem \
    -config=certs/ca-config.json \
    -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${K8S_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
    -profile=kubernetes \
    certs/kube-scheduler-csr.json | cfssljson -bare kube-scheduler

# Service Accounts
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=certs/ca-config.json -profile=kubernetes certs/service-account-csr.json | cfssljson -bare service-account

# What did we do?
ls