
# 🚀 AI-Powered Kubernetes Application Deployment Pipeline

## 📌 Project Overview

This project demonstrates an end-to-end **Kubernetes application deployment pipeline on Amazon EKS** using Infrastructure as Code, containerization, CI/CD automation, and AI-powered Kubernetes assessment.

The solution automates application deployment from container image creation to Kubernetes rollout and uses AI analysis to validate cluster health, identify operational risks, and provide production readiness recommendations.

---

# 🏗️ Architecture

```
Developer
    |
    | Git Push
    |
GitHub Repository
    |
    |
CI/CD Pipeline
(GitHub Actions / Jenkins)
    |
    |
Docker Build
    |
    |
Amazon ECR
(Container Registry)
    |
    |
Amazon EKS Cluster
    |
    |
Kubernetes Deployment
    |
    |
Kubernetes Service
(AWS LoadBalancer)
    |
    |
Application Access


Post Deployment:
        |
        |
AI Kubernetes Assessment
        |
        |
Health Validation
Risk Identification
Best Practice Recommendations
```

---

# 🛠️ Technologies Used

### Cloud
- AWS EKS
- AWS ECR
- AWS VPC
- AWS IAM
- AWS LoadBalancer

### Infrastructure as Code
- Terraform
- Terraform Modules

### Containerization
- Docker
- Nginx Container Image

### Kubernetes
- Deployments
- ReplicaSets
- Pods
- Services
- Namespaces
- kubectl

### CI/CD
- GitHub Actions
- Jenkins

### AI Operations
- Kubernetes cluster health assessment
- Deployment validation
- Risk analysis
- Production readiness recommendations

---

# 🔄 Deployment Workflow

## 1. Infrastructure Provisioning

Terraform provisions:

- AWS VPC networking
- EKS Cluster
- Managed Node Groups
- IAM Roles and Policies


```
terraform init
terraform plan
terraform apply
```

---

## 2. Container Image Deployment

Application image is built and pushed to Amazon ECR.

```
docker build -t html-app .
docker push <ECR-IMAGE-URI>
```

---

## 3. Kubernetes Application Deployment

Application deployment:

```
kubectl apply -f deployment.yml -n qa
```

Service exposure:

```
kubectl apply -f service.yml -n qa
```

Deployment validation:

```
kubectl rollout status deployment/html-app -n qa
```

---

# ✅ Kubernetes Environment Validation

AI assessment validates:

### Cluster Health
✔ EKS worker nodes status  
✔ Kubernetes system components  
✔ CoreDNS availability  
✔ AWS CNI networking  
✔ kube-proxy health  

### Application Health
✔ Pod status  
✔ Container readiness  
✔ Restart count  
✔ Service availability  
✔ LoadBalancer provisioning  

---

# 🤖 AI Kubernetes Assessment Example

## Health Status

✅ Cluster nodes are healthy  
✅ Application pods are running  
✅ Kubernetes networking is functional  
✅ LoadBalancer provisioning successful  


## Identified Risks

⚠ Single replica deployment creates availability risk  
⚠ Public LoadBalancer exposure requires security review  
⚠ Missing autoscaling configuration  
⚠ Missing resource requests and limits  


## Recommended Improvements

- Increase application replicas
- Add readiness and liveness probes
- Configure resource requests and limits
- Implement PodDisruptionBudget
- Enable Horizontal Pod Autoscaler
- Add monitoring using Prometheus and Grafana

---

## AI Kubernetes Assessment

Below is the AI-generated Kubernetes health assessment performed after application deployment.

![AI Kubernetes Assessment](images/app_deploy_assessment.png)

# 🔧 Troubleshooting Example

### Issue

```
deployment "html-app" exceeded its progress deadline
```

### Investigation

```
kubectl get pods -n qa
```

Found:

```
ErrImagePull
```

### Root Cause

Deployment referenced an incorrect ECR repository image.

Before:

```
qa-nginx-repo:latest
```

After:

```
dev-nginx-repo:latest
```

### Resolution

```
kubectl apply -f deployment.yml -n qa

kubectl rollout status deployment/html-app -n qa
```

Result:

```
deployment "html-app" successfully rolled out
```

---

# 🔐 Security Practices

Implemented:

✔ Private ECR repository  
✔ IAM-based AWS access  
✔ Terraform-managed infrastructure  
✔ Kubernetes namespace isolation  
✔ Infrastructure version control  


Future Improvements:

- IRSA implementation
- Kubernetes RBAC hardening
- Network Policies
- Secrets Manager integration
- Container image scanning

---

# 📈 Future Enhancements

- Helm-based deployment
- GitOps with ArgoCD
- Prometheus/Grafana monitoring
- Kubernetes autoscaling
- AWS ALB Ingress Controller
- Automated security scanning

---

# 👨‍💻 Author

**Abhishek Rahel**

DevOps Engineer | Cloud Engineer | Linux Administrator

Skills:
AWS | Terraform | Kubernetes | Docker | Jenkins | GitHub Actions | Linux
