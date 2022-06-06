# Jenkins on Kubernetes 

This repo is a tutorial on how to deploy jenkins on a kubernetes cluster. 

## Requirements
- minikube
- Helm 3

## Install Jenkins 

### Get Jenkins Helm Chart

```sh
$helm repo add jenkins https://charts.jenkins.io
$helm repo update
```

### Get Chart default values (optional)

```sh
helm show values jenkins/jenkins > values.yaml
```

### Helm install Jenkins 

We are going to build our custom jenkins image with our required plugins
```sh
$docker build -t <docker url>/jenkins .
$docker push <docker url>/jenkins
```
Create secret
```sh
$kubectl create secret docker-registry registry --docker-server='<Docker registry URL here>' --docker-username='<docker registry username>' --docker-password='<password here>' --docker-email='<docker registry email>'
```

Make user minikube has nginx ingress controller enable, if not
```sh
$minikube addons enable ingress
```

Make sure your custom image gets updated in the value file

```sh
$kubectl create namespace jenkins
$helm install jenkins jenkins/jenkins -n jenkins -f jenkins-values.yaml
```

### Accesing Jenkins
You can access Jenkins by port forwarding the jenkins service

```sh
$kubectl port-forward svc/jenkins 8080:8080
```
>http://localhost:8080/jenkins

or you can create a minikube tunnel and access through the nginx ingress, you'll need sudo
```sh
➜  ~ minikube tunnel
✅  Tunnel successfully started

📌  NOTE: Please do not close this terminal as this process must stay alive for the tunnel to be accessible ...

❗  The service/ingress jenkins requires privileged ports to be exposed: [80 443]
🔑  sudo permission will be asked for it.
🏃  Starting tunnel for service jenkins.
[sudo] password for dave:
```
>http://localhost/jenkins

Once in the login page, get the admin password with the following command
![login](img/login.PNG)
```sh
$kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
```



