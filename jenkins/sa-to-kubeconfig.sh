#!/bin/bash

# K8s 集群名称
clusterName=kubernetes

# 集群 API Server 地址，使用 `kubectl cluster-info` 命令获取
server=https://apiserver.cluster.local:6443

# SA 命名空间名称
namespace=jenkins

# SA 名称
serviceAccount=jenkins

# ==========生成kubeconfig文件===============

secretName=$serviceAccount
ca=$(kubectl -n $namespace get secret/$secretName -o jsonpath='{.data.ca\.crt}')
token=$(kubectl -n $namespace get secret/$secretName -o jsonpath='{.data.token}' | base64 --decode)

echo "
---
apiVersion: v1
kind: Config
clusters:
  - name: ${clusterName}
    cluster:
      certificate-authority-data: ${ca}
      server: ${server}
contexts:
  - name: ${serviceAccount}@${clusterName}
    context:
      cluster: ${clusterName}
      namespace: ${namespace}
      user: ${serviceAccount}
users:
  - name: ${serviceAccount}
    user:
      token: ${token}
current-context: ${serviceAccount}@${clusterName}
"