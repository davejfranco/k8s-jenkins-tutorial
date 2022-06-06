# Jenkins on Kubernetes 

This repo is a tutorial on how to deploy jenkins on a kubernetes cluster. 

## Requirements

You will need an AWS account with credentials and needed permissions to deploy a EKS cluster. Setting awscli is scope out of this tutorial.

- eksctl
- awscli
- Helm 3

## Create EKS cluster using EKSCTL

Create an EKS cluster. Feel free to update cluster.yaml if you want to.

```sh
eksctl create cluster -f cluster.yaml
```

Once the cluster is ready, we are going to need to get the kubeconfig of our cluster.

```sh
aws eks update-kubeconfig --name eksctl-cluster --alias EKStutorial
```

### Installing nginx ingress on AWS EKS

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml
```

### Get Jenkins Helm Chart

```sh
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

### Get Chart default values (optional)

```sh
helm show values jenkins/jenkins > values.yaml
```

 ### Custom Jenkins Image on AWS ECR

Login to AWS ECR registry. Make sure you get the same region of your eks cluster and your account id number

```sh
aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
```

Lets create our Jenkins repository.
```
aws ecr create-repository --repository-name jenkins
```

We are going to build our custom jenkins image with our required plugins
```sh
docker build -t <aws_account_id>.dkr.ecr.<region>.amazonaws.com/jenkins .
docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/jenkins
```

### Helm install Jenkins

Make sure your custom image gets updated in the value file

```sh
kubectl create namespace jenkins
helm install jenkins jenkins/jenkins -n jenkins -f jenkins-values.yaml
```

### Accesing Jenkins
You can access Jenkins by port forwarding the jenkins service

```sh
kubectl port-forward svc/jenkins 8080:8080
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
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/chart-admin-password && echo
```





