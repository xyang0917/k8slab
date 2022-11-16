1. 创建namespace
`kubectl create namespace jenkins`

2. 创建sa
`kubectl create -f sa.yaml`

3. 创建pvc
```shell
$ mkdir /mnt/data && chmod 777 /mnt/data
$ kubectl create -f pvc.yaml
```
4. 创建pod与service
`kubectl create -f jenkins.yaml`

5. 创建cert-manager
```
$ helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
	--set controller.service.type=LoadBalancer \
  --namespace ingress-nginx --create-namespace

# 配置LB IP（注意修改节点IP）
$ kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec":{"externalIPs":["172.16.203.28"]}}'
```

6. 创建issuer
`kubectl create -f letsencrypt-issuer.yaml`

7. 创建nginx ingress
```shell
# 安装
$ helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
	--set controller.service.type=LoadBalancer \
  --namespace ingress-nginx --create-namespace

# 配置LB IP
$ kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec":{"externalIPs":["172.16.203.28"]}}'
```

8. 创建ingress
`kubectl create -f ingress.yaml`